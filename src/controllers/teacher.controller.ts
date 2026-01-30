import { Response, NextFunction } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/auth.middleware';

const prisma = new PrismaClient();

export const getAll = async (req: AuthRequest, res: Response) => {
    try {
        const { branchId } = req.query;
        const where: any = {};
        
        // If branchId is provided, filter by it
        if (branchId) {
            where.branchId = branchId as string;
        }
        
        // If user is BRANCH_ADMIN, only show their branch's teachers
        if (req.user?.role === 'BRANCH_ADMIN' && req.user.branchId) {
            where.branchId = req.user.branchId;
        }
        
        const teachers = await prisma.teacher.findMany({
            where,
            include: { branch: true },
            orderBy: { order: 'asc' },
        });
        
        // If BRANCH_ADMIN, add pending status and filter out deleted ones
        if (req.user?.role === 'BRANCH_ADMIN') {
            const pendingRequests = await prisma.changeRequest.findMany({
                where: {
                    changeType: { in: ['TEACHER_CREATE', 'TEACHER_UPDATE', 'TEACHER_DELETE'] },
                    status: 'PENDING',
                    branchId: req.user.branchId
                },
                select: { 
                    id: true,
                    entityId: true, 
                    changeType: true,
                    newData: true
                }
            });
            
            // Create a map of pending requests
            const pendingMap = new Map();
            const pendingDeleteIds = new Set();
            const pendingCreates: any[] = [];
            
            pendingRequests.forEach(req => {
                if (req.changeType === 'TEACHER_DELETE') {
                    pendingDeleteIds.add(req.entityId);
                } else if (req.changeType === 'TEACHER_CREATE') {
                    pendingCreates.push({
                        ...(req.newData as any),
                        id: req.id, // Use change request ID as temporary ID
                        isPending: true,
                        pendingType: 'CREATE'
                    });
                } else if (req.changeType === 'TEACHER_UPDATE') {
                    pendingMap.set(req.entityId, {
                        isPending: true,
                        pendingType: 'UPDATE'
                    });
                }
            });
            
            // Filter out deleted teachers and add pending status
            const filteredTeachers = teachers
                .filter(t => !pendingDeleteIds.has(t.id))
                .map(t => ({
                    ...t,
                    ...(pendingMap.get(t.id) || {})
                }));
            
            // Add pending creates
            const allTeachers = [...filteredTeachers, ...pendingCreates];
            
            return res.json({ data: allTeachers });
        }
        
        res.json({ data: teachers });
    } catch (error) {
        res.status(500).json({ message: 'Error fetching teachers', error });
    }
};

export const create = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const data = req.body;
        
        // If user is BRANCH_ADMIN, force branchId to their branch
        if (req.user?.role === 'BRANCH_ADMIN') {
            if (!req.user.branchId) {
                return res.status(403).json({ message: 'Branch admin must have a branch assigned' });
            }
            data.branchId = req.user.branchId;
            
            // Create change request instead of direct creation
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'TEACHER_CREATE',
                    branchId: req.user.branchId,
                    entityType: 'Teacher',
                    newData: data,
                    requestedBy: req.user.id,
                    status: 'PENDING'
                },
                include: {
                    requester: { select: { id: true, name: true, email: true } },
                    branch: { select: { id: true, name: true } }
                }
            });

            // Create notification for admins
            const admins = await prisma.user.findMany({
                where: { role: { in: ['SUPER_ADMIN', 'CENTER_ADMIN'] } }
            });
            
            for (const admin of admins) {
                await prisma.notification.create({
                    data: {
                        type: 'CHANGE_PENDING',
                        title: '🔔 Yeni Öğretmen Ekleme Talebi',
                        message: `${req.user.name} yeni öğretmen ekleme talebi oluşturdu (${data.name || 'İsimsiz'}).`,
                        userId: admin.id,
                        changeRequestId: changeRequest.id
                    }
                });
            }
            
            return res.status(201).json({ 
                message: 'Öğretmen ekleme talebi oluşturuldu. Admin onayı bekleniyor.',
                data: changeRequest,
                isPending: true
            });
        }
        
        // Admin can create directly
        const teacher = await prisma.teacher.create({
            data,
            include: { branch: true }
        });
        res.status(201).json({ data: teacher });
    } catch (error) {
        res.status(500).json({ message: 'Error creating teacher', error });
    }
};

export const update = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        
        // If user is BRANCH_ADMIN, verify teacher belongs to their branch
        if (req.user?.role === 'BRANCH_ADMIN') {
            const existingTeacher = await prisma.teacher.findUnique({
                where: { id }
            });
            
            if (!existingTeacher || existingTeacher.branchId !== req.user.branchId) {
                return res.status(403).json({ message: 'You can only update teachers from your branch' });
            }
            
            // Check if there's already a pending update request for this teacher
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    entityId: id,
                    changeType: 'TEACHER_UPDATE',
                    status: 'PENDING'
                }
            });
            
            if (existingRequest) {
                return res.status(400).json({ 
                    message: 'Bu öğretmen için zaten bekleyen bir güncelleme talebi var',
                    error: 'DUPLICATE_REQUEST'
                });
            }
            
            // Create change request instead of direct update
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'TEACHER_UPDATE',
                    branchId: req.user.branchId!,
                    entityId: id,
                    entityType: 'Teacher',
                    oldData: existingTeacher,
                    newData: req.body,
                    requestedBy: req.user.id,
                    status: 'PENDING'
                },
                include: {
                    requester: { select: { id: true, name: true, email: true } },
                    branch: { select: { id: true, name: true } }
                }
            });

            // Create notification for admins
            const admins = await prisma.user.findMany({
                where: { role: { in: ['SUPER_ADMIN', 'CENTER_ADMIN'] } }
            });
            
            for (const admin of admins) {
                await prisma.notification.create({
                    data: {
                        type: 'CHANGE_PENDING',
                        title: '🔔 Öğretmen Güncelleme Talebi',
                        message: `${req.user.name} öğretmen güncelleme talebi oluşturdu (${existingTeacher.name}).`,
                        userId: admin.id,
                        changeRequestId: changeRequest.id
                    }
                });
            }
            
            return res.json({ 
                message: 'Öğretmen güncelleme talebi oluşturuldu. Admin onayı bekleniyor.',
                data: changeRequest,
                isPending: true
            });
        }
        
        // Admin can update directly
        const teacher = await prisma.teacher.update({
            where: { id },
            data: req.body,
            include: { branch: true }
        });
        res.json({ data: teacher });
    } catch (error) {
        res.status(500).json({ message: 'Error updating teacher', error });
    }
};

export const deleteTeacher = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        
        // If user is BRANCH_ADMIN, verify teacher belongs to their branch
        if (req.user?.role === 'BRANCH_ADMIN') {
            const existingTeacher = await prisma.teacher.findUnique({
                where: { id }
            });
            
            if (!existingTeacher || existingTeacher.branchId !== req.user.branchId) {
                return res.status(403).json({ message: 'You can only delete teachers from your branch' });
            }
            
            // Check if there's already a pending delete request for this teacher
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    entityId: id,
                    changeType: 'TEACHER_DELETE',
                    status: 'PENDING'
                }
            });
            
            if (existingRequest) {
                return res.status(400).json({ 
                    message: 'Bu öğretmen için zaten bekleyen bir silme talebi var',
                    error: 'DUPLICATE_REQUEST'
                });
            }
            
            // Create change request instead of direct deletion
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'TEACHER_DELETE',
                    branchId: req.user.branchId!,
                    entityId: id,
                    entityType: 'Teacher',
                    oldData: existingTeacher,
                    newData: { deleted: true },
                    requestedBy: req.user.id,
                    status: 'PENDING'
                },
                include: {
                    requester: { select: { id: true, name: true, email: true } },
                    branch: { select: { id: true, name: true } }
                }
            });

            // Create notification for admins
            const admins = await prisma.user.findMany({
                where: { role: { in: ['SUPER_ADMIN', 'CENTER_ADMIN'] } }
            });
            
            for (const admin of admins) {
                await prisma.notification.create({
                    data: {
                        type: 'CHANGE_PENDING',
                        title: '🔔 Öğretmen Silme Talebi',
                        message: `${req.user.name} öğretmen silme talebi oluşturdu (${existingTeacher.name}).`,
                        userId: admin.id,
                        changeRequestId: changeRequest.id
                    }
                });
            }
            
            return res.json({ 
                message: 'Öğretmen silme talebi oluşturuldu. Admin onayı bekleniyor.',
                data: changeRequest,
                isPending: true
            });
        }
        
        // Admin can delete directly
        await prisma.teacher.delete({
            where: { id },
        });
        res.json({ message: 'Teacher deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting teacher', error });
    }
};
