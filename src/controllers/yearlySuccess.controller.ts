import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/auth.middleware';

const prisma = new PrismaClient();

export const getAllYearlySuccesses = async (req: any, res: Response) => {
    try {
        const { branchId } = req.query;
        const where: any = {};
        
        // If branchId is provided, filter by it
        if (branchId) {
            where.branchId = branchId as string;
        }
        
        const successes = await prisma.yearlySuccess.findMany({
            where,
            include: {
                banner: true,
                students: {
                    orderBy: { order: 'asc' }
                }
            },
            orderBy: { year: 'desc' }
        });
        
        // If user is authenticated and is a branch admin, add pending flags
        if (req.user?.role === 'BRANCH_ADMIN' && req.user.branchId) {
            // Get pending change requests for this branch
            const pendingRequests = await prisma.changeRequest.findMany({
                where: {
                    branchId: req.user.branchId,
                    entityType: 'YearlySuccess',
                    status: 'PENDING',
                    changeType: { in: ['SUCCESS_CREATE', 'SUCCESS_UPDATE', 'SUCCESS_DELETE'] }
                }
            });
            
            // Map pending requests to successes
            const successesWithPending = successes.map(success => {
                const pendingRequest = pendingRequests.find(req => req.entityId === success.id);
                if (pendingRequest) {
                    return {
                        ...success,
                        isPending: true,
                        pendingType: pendingRequest.changeType === 'SUCCESS_CREATE' ? 'CREATE' : 'UPDATE'
                    };
                }
                return success;
            });
            
            // Add pending CREATE requests as virtual items
            const createRequests = pendingRequests.filter(req => req.changeType === 'SUCCESS_CREATE');
            for (const createReq of createRequests) {
                const newData = createReq.newData as any;
                successesWithPending.push({
                    id: createReq.id,
                    year: newData.year,
                    banner: newData.banner || null,
                    students: [],
                    totalDegrees: newData.totalDegrees || 0,
                    placementCount: newData.placementCount || 0,
                    successRate: newData.successRate || 0,
                    cityCount: newData.cityCount || 0,
                    top100Count: newData.top100Count || 0,
                    top1000Count: newData.top1000Count || 0,
                    yksAverage: newData.yksAverage || 0,
                    lgsAverage: newData.lgsAverage || 0,
                    isActive: true,
                    branchId: newData.branchId,
                    createdAt: createReq.createdAt,
                    updatedAt: createReq.updatedAt,
                    isPending: true,
                    pendingType: 'CREATE'
                });
            }
            
            return res.json({ success: true, data: successesWithPending });
        }
        
        res.json({ success: true, data: successes });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Başarılar getirilemedi' });
    }
};

export const getByYear = async (req: Request, res: Response) => {
    try {
        const success = await prisma.yearlySuccess.findFirst({
            where: { year: req.params.year },
            include: {
                banner: true,
                students: {
                    orderBy: { order: 'asc' }
                }
            }
        });
        if (!success) return res.status(404).json({ success: false, error: 'Yıl bulunamadı' });
        res.json({ success: true, data: success });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Veri getirilemedi' });
    }
};

export const createYearlySuccess = async (req: AuthRequest, res: Response) => {
    try {
        const { year, banner, totalDegrees, placementCount, successRate, cityCount, top100Count, top1000Count, yksAverage, lgsAverage, branchId } = req.body;
        
        // Branch admin can only create for their branch
        if (req.user?.role === 'BRANCH_ADMIN') {
            if (!req.user.branchId) {
                return res.status(403).json({ success: false, error: 'Branch admin must have a branch assigned' });
            }
            if (branchId && branchId !== req.user.branchId) {
                return res.status(403).json({ success: false, error: 'You can only create successes for your branch' });
            }
            
            // Check for duplicate pending request
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    changeType: 'SUCCESS_CREATE',
                    branchId: req.user.branchId,
                    status: 'PENDING',
                    newData: {
                        path: ['year'],
                        equals: String(year)
                    }
                }
            });
            
            if (existingRequest) {
                return res.status(400).json({ success: false, error: 'DUPLICATE_REQUEST' });
            }
            
            // Check if year already exists for this branch
            const existingYearSuccess = await prisma.yearlySuccess.findFirst({
                where: {
                    year: String(year),
                    branchId: req.user.branchId
                }
            });
            
            if (existingYearSuccess) {
                return res.status(400).json({ 
                    success: false, 
                    error: 'YEAR_EXISTS',
                    message: `${year} yılı için zaten bir başarı kaydınız var. Lütfen mevcut kaydı düzenleyin.`
                });
            }
            
            // Create change request for branch admin
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'SUCCESS_CREATE',
                    branchId: req.user.branchId,
                    entityType: 'YearlySuccess',
                    requestedBy: req.user.id,
                    newData: {
                        year: String(year), // Ensure year is string
                        totalDegrees: totalDegrees || 0,
                        placementCount: placementCount || 0,
                        successRate: successRate || 0,
                        cityCount: cityCount || 0,
                        top100Count: top100Count || 0,
                        top1000Count: top1000Count || 0,
                        yksAverage: yksAverage || 0,
                        lgsAverage: lgsAverage || 0,
                        banner: banner ? {
                            title: banner.title || '',
                            subtitle: banner.subtitle || '',
                            description: banner.description || '',
                            image: banner.image || ''
                        } : null,
                        branchId: req.user.branchId
                    }
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
                        title: '🔔 Yeni Başarı Ekleme Talebi',
                        message: `${req.user.name} yeni bir başarı ekleme talebi oluşturdu (${year}).`,
                        userId: admin.id,
                        changeRequestId: changeRequest.id
                    }
                });
            }
            
            return res.status(201).json({ 
                success: true, 
                data: changeRequest,
                message: 'Başarı ekleme talebiniz oluşturuldu. Onay bekliyor.' 
            });
        }
        
        // Admin can create directly
        const success = await prisma.yearlySuccess.create({
            data: {
                year: String(year), // Ensure year is string
                totalDegrees: totalDegrees || 0,
                placementCount: placementCount || 0,
                successRate: successRate || 0,
                cityCount: cityCount || 0,
                top100Count: top100Count || 0,
                top1000Count: top1000Count || 0,
                yksAverage: yksAverage || 0,
                lgsAverage: lgsAverage || 0,
                branchId: branchId || null,
                banner: banner ? {
                    create: {
                        title: banner.title || '',
                        subtitle: banner.subtitle || '',
                        description: banner.description || '',
                        image: banner.image || '',
                        highlightText: banner.highlightText || null,
                        gradientFrom: banner.gradientFrom || '#2563eb',
                        gradientTo: banner.gradientTo || '#1e40af'
                    }
                } : undefined
            },
            include: { 
                banner: true,
                students: {
                    orderBy: { order: 'asc' }
                }
            }
        });
        res.status(201).json({ success: true, data: success });
    } catch (error: any) {
        console.error('Create yearly success error:', error);
        res.status(500).json({ success: false, error: error.message || 'Oluşturulamadı' });
    }
};

export const updateYearlySuccess = async (req: AuthRequest, res: Response) => {
    try {
        const { banner, totalDegrees, placementCount, successRate, cityCount, top100Count, top1000Count, yksAverage, lgsAverage } = req.body;
        
        // Get existing success
        const existingSuccess = await prisma.yearlySuccess.findUnique({
            where: { id: req.params.id },
            include: { banner: true }
        });
        
        if (!existingSuccess) {
            return res.status(404).json({ success: false, error: 'Başarı bulunamadı' });
        }
        
        // Branch admin can only update their branch's successes
        if (req.user?.role === 'BRANCH_ADMIN') {
            if (!req.user.branchId || existingSuccess.branchId !== req.user.branchId) {
                return res.status(403).json({ success: false, error: 'You can only update your branch successes' });
            }
            
            // Check for duplicate pending request
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    changeType: 'SUCCESS_UPDATE',
                    entityId: req.params.id,
                    branchId: req.user.branchId,
                    status: 'PENDING'
                }
            });
            
            if (existingRequest) {
                return res.status(400).json({ success: false, error: 'DUPLICATE_REQUEST' });
            }
            
            // Create change request
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'SUCCESS_UPDATE',
                    entityId: req.params.id,
                    entityType: 'YearlySuccess',
                    branchId: req.user.branchId,
                    requestedBy: req.user.id,
                    oldData: existingSuccess,
                    newData: {
                        totalDegrees: totalDegrees !== undefined ? totalDegrees : existingSuccess.totalDegrees,
                        placementCount: placementCount !== undefined ? placementCount : existingSuccess.placementCount,
                        successRate: successRate !== undefined ? successRate : existingSuccess.successRate,
                        cityCount: cityCount !== undefined ? cityCount : existingSuccess.cityCount,
                        top100Count: top100Count !== undefined ? top100Count : existingSuccess.top100Count,
                        top1000Count: top1000Count !== undefined ? top1000Count : existingSuccess.top1000Count,
                        yksAverage: yksAverage !== undefined ? yksAverage : existingSuccess.yksAverage,
                        lgsAverage: lgsAverage !== undefined ? lgsAverage : existingSuccess.lgsAverage,
                        banner: banner || existingSuccess.banner,
                        branchId: existingSuccess.branchId
                    }
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
                        title: '🔔 Başarı Güncelleme Talebi',
                        message: `${req.user.name} bir başarı güncelleme talebi oluşturdu (${existingSuccess.year}).`,
                        userId: admin.id,
                        changeRequestId: changeRequest.id
                    }
                });
            }
            
            return res.json({ 
                success: true, 
                data: changeRequest,
                message: 'Başarı güncelleme talebiniz oluşturuldu. Onay bekliyor.' 
            });
        }
        
        // Admin can update directly
        const success = await prisma.yearlySuccess.update({
            where: { id: req.params.id },
            data: {
                totalDegrees: totalDegrees !== undefined ? totalDegrees : undefined,
                placementCount: placementCount !== undefined ? placementCount : undefined,
                successRate: successRate !== undefined ? successRate : undefined,
                cityCount: cityCount !== undefined ? cityCount : undefined,
                top100Count: top100Count !== undefined ? top100Count : undefined,
                top1000Count: top1000Count !== undefined ? top1000Count : undefined,
                yksAverage: yksAverage !== undefined ? yksAverage : undefined,
                lgsAverage: lgsAverage !== undefined ? lgsAverage : undefined,
                banner: banner ? {
                    upsert: {
                        create: {
                            title: banner.title || '',
                            subtitle: banner.subtitle || '',
                            description: banner.description || '',
                            image: banner.image || '',
                            highlightText: banner.highlightText || null,
                            gradientFrom: banner.gradientFrom || '#2563eb',
                            gradientTo: banner.gradientTo || '#1e40af'
                        },
                        update: {
                            title: banner.title || '',
                            subtitle: banner.subtitle || '',
                            description: banner.description || '',
                            image: banner.image || '',
                            highlightText: banner.highlightText || null,
                            gradientFrom: banner.gradientFrom || '#2563eb',
                            gradientTo: banner.gradientTo || '#1e40af'
                        }
                    }
                } : undefined
            },
            include: { 
                banner: true,
                students: {
                    orderBy: { order: 'asc' }
                }
            }
        });
        res.json({ success: true, data: success });
    } catch (error: any) {
        console.error('Update yearly success error:', error);
        res.status(500).json({ success: false, error: error.message || 'Güncellenemedi' });
    }
};

export const deleteYearlySuccess = async (req: AuthRequest, res: Response) => {
    try {
        // Get existing success
        const existingSuccess = await prisma.yearlySuccess.findUnique({
            where: { id: req.params.id },
            include: { banner: true, students: true }
        });
        
        if (!existingSuccess) {
            return res.status(404).json({ success: false, error: 'Başarı bulunamadı' });
        }
        
        // Branch admin can only delete their branch's successes
        if (req.user?.role === 'BRANCH_ADMIN') {
            if (!req.user.branchId || existingSuccess.branchId !== req.user.branchId) {
                return res.status(403).json({ success: false, error: 'You can only delete your branch successes' });
            }
            
            // Check for duplicate pending request
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    changeType: 'SUCCESS_DELETE',
                    entityId: req.params.id,
                    branchId: req.user.branchId,
                    status: 'PENDING'
                }
            });
            
            if (existingRequest) {
                return res.status(400).json({ success: false, error: 'DUPLICATE_REQUEST' });
            }
            
            // Create change request
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'SUCCESS_DELETE',
                    entityId: req.params.id,
                    entityType: 'YearlySuccess',
                    branchId: req.user.branchId,
                    requestedBy: req.user.id,
                    oldData: existingSuccess,
                    newData: { deleted: true }
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
                        title: '🔔 Başarı Silme Talebi',
                        message: `${req.user.name} bir başarı silme talebi oluşturdu (${existingSuccess.year}).`,
                        userId: admin.id,
                        changeRequestId: changeRequest.id
                    }
                });
            }
            
            return res.json({ 
                success: true, 
                data: changeRequest,
                message: 'Başarı silme talebiniz oluşturuldu. Onay bekliyor.' 
            });
        }
        
        // Admin can delete directly
        await prisma.yearlySuccess.delete({
            where: { id: req.params.id }
        });
        res.json({ success: true, message: 'Silindi' });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Silinemedi' });
    }
};

// Top Student Handlers
export const addStudent = async (req: AuthRequest, res: Response) => {
    try {
        const { name, exam, rank, image, branch, university, score, order } = req.body;
        
        // Get the yearly success to check branch ownership
        const yearlySuccess = await prisma.yearlySuccess.findUnique({
            where: { id: req.params.id }
        });
        
        if (!yearlySuccess) {
            return res.status(404).json({ success: false, error: 'Başarı bulunamadı' });
        }
        
        // Branch admin creates change request
        if (req.user?.role === 'BRANCH_ADMIN') {
            if (!req.user.branchId || yearlySuccess.branchId !== req.user.branchId) {
                return res.status(403).json({ success: false, error: 'Bu başarıya öğrenci ekleyemezsiniz' });
            }
            
            // Check for duplicate pending request
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    changeType: 'STUDENT_CREATE',
                    entityId: req.params.id,
                    branchId: req.user.branchId,
                    status: 'PENDING',
                    newData: {
                        path: ['name'],
                        equals: name
                    }
                }
            });
            
            if (existingRequest) {
                return res.status(400).json({ success: false, error: 'DUPLICATE_REQUEST' });
            }
            
            // Create change request
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'STUDENT_CREATE',
                    entityId: req.params.id,
                    entityType: 'TopStudent',
                    branchId: req.user.branchId,
                    requestedBy: req.user.id,
                    newData: {
                        name,
                        exam,
                        rank,
                        image: image || null,
                        branch: branch || null,
                        university: university || null,
                        score: score ? parseFloat(score) : null,
                        order: order || 0,
                        yearlySuccessId: req.params.id
                    }
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
                        title: '🔔 Yeni Öğrenci Ekleme Talebi',
                        message: `${req.user.name} bir öğrenci ekleme talebi oluşturdu (${name}).`,
                        userId: admin.id,
                        changeRequestId: changeRequest.id
                    }
                });
            }
            
            return res.status(201).json({ 
                success: true, 
                data: changeRequest,
                message: 'Öğrenci ekleme talebiniz oluşturuldu. Onay bekliyor.' 
            });
        }
        
        // Admin can add directly
        const student = await prisma.topStudent.create({
            data: {
                yearlySuccessId: req.params.id,
                name,
                exam,
                rank,
                image: image || null,
                branch: branch || null,
                university: university || null,
                score: score ? parseFloat(score) : null,
                order: order || 0
            }
        });
        res.status(201).json({ success: true, data: student });
    } catch (error: any) {
        console.error('Add student error:', error);
        res.status(500).json({ success: false, error: error.message || 'Öğrenci eklenemedi' });
    }
};

export const deleteStudent = async (req: AuthRequest, res: Response) => {
    try {
        // Get the student to check branch ownership
        const student = await prisma.topStudent.findUnique({
            where: { id: req.params.studentId },
            include: { yearlySuccess: true }
        });
        
        if (!student) {
            return res.status(404).json({ success: false, error: 'Öğrenci bulunamadı' });
        }
        
        // Branch admin creates change request
        if (req.user?.role === 'BRANCH_ADMIN') {
            if (!req.user.branchId || student.yearlySuccess.branchId !== req.user.branchId) {
                return res.status(403).json({ success: false, error: 'Bu öğrenciyi silemezsiniz' });
            }
            
            // Check for duplicate pending request
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    changeType: 'STUDENT_DELETE',
                    entityId: req.params.studentId,
                    branchId: req.user.branchId,
                    status: 'PENDING'
                }
            });
            
            if (existingRequest) {
                return res.status(400).json({ success: false, error: 'DUPLICATE_REQUEST' });
            }
            
            // Create change request
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'STUDENT_DELETE',
                    entityId: req.params.studentId,
                    entityType: 'TopStudent',
                    branchId: req.user.branchId,
                    requestedBy: req.user.id,
                    oldData: student,
                    newData: { deleted: true }
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
                        title: '🔔 Öğrenci Silme Talebi',
                        message: `${req.user.name} bir öğrenci silme talebi oluşturdu (${student.name}).`,
                        userId: admin.id,
                        changeRequestId: changeRequest.id
                    }
                });
            }
            
            return res.json({ 
                success: true, 
                data: changeRequest,
                message: 'Öğrenci silme talebiniz oluşturuldu. Onay bekliyor.' 
            });
        }
        
        // Admin can delete directly
        await prisma.topStudent.delete({
            where: { id: req.params.studentId }
        });
        res.json({ success: true, message: 'Öğrenci silindi' });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Öğrenci silinemedi' });
    }
};
