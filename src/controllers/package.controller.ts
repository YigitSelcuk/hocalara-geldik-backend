import { Response, NextFunction } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/auth.middleware';
import { AppError } from '../middleware/error.middleware';

const prisma = new PrismaClient();

export const getAllPackages = async (req: AuthRequest, res: Response) => {
    try {
        const { branchId } = req.query;
        const where: any = {};
        
        // If branchId is provided, filter by it
        if (branchId) {
            where.branchId = branchId as string;
        }
        
        // If user is BRANCH_ADMIN, only show their branch's packages
        if (req.user?.role === 'BRANCH_ADMIN' && req.user.branchId) {
            where.branchId = req.user.branchId;
        }
        
        const packages = await prisma.educationPackage.findMany({
            where,
            include: { branch: true },
            orderBy: { order: 'asc' }
        });
        
        // If BRANCH_ADMIN, add pending status and filter out deleted ones
        if (req.user?.role === 'BRANCH_ADMIN') {
            const pendingRequests = await prisma.changeRequest.findMany({
                where: {
                    changeType: { in: ['PACKAGE_CREATE', 'PACKAGE_UPDATE', 'PACKAGE_DELETE'] },
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
                if (req.changeType === 'PACKAGE_DELETE') {
                    pendingDeleteIds.add(req.entityId);
                } else if (req.changeType === 'PACKAGE_CREATE') {
                    pendingCreates.push({
                        ...(req.newData as any),
                        id: req.id,
                        isPending: true,
                        pendingType: 'CREATE'
                    });
                } else if (req.changeType === 'PACKAGE_UPDATE') {
                    pendingMap.set(req.entityId, {
                        isPending: true,
                        pendingType: 'UPDATE'
                    });
                }
            });
            
            // Filter out deleted packages and add pending status
            const filteredPackages = packages
                .filter(p => !pendingDeleteIds.has(p.id))
                .map(p => ({
                    ...p,
                    ...(pendingMap.get(p.id) || {})
                }));
            
            // Add pending creates
            const allPackages = [...filteredPackages, ...pendingCreates];
            
            return res.json({ success: true, data: allPackages });
        }
        
        res.json({ success: true, data: packages });
    } catch (error) {
        res.status(500).json({ message: 'Error fetching packages', error });
    }
};

export const getPackageById = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const pkg = await prisma.educationPackage.findUnique({
            where: { id },
            include: { branch: true }
        });

        if (!pkg) {
            throw new AppError('Package not found', 404);
        }

        res.json({ success: true, data: pkg });
    } catch (error) {
        next(error);
    }
};

export const createPackage = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { name, ...rest } = req.body;
        
        // Generate slug from name
        const slug = name
            .toLowerCase()
            .replace(/ğ/g, 'g')
            .replace(/ü/g, 'u')
            .replace(/ş/g, 's')
            .replace(/ı/g, 'i')
            .replace(/ö/g, 'o')
            .replace(/ç/g, 'c')
            .replace(/[^a-z0-9]+/g, '-')
            .replace(/^-+|-+$/g, '');
        
        const data = {
            name,
            slug,
            type: rest.type || 'STANDARD',
            description: rest.description || rest.shortDescription || '',
            shortDescription: rest.shortDescription || '',
            price: rest.price || null,
            originalPrice: rest.originalPrice || null,
            image: rest.image || null,
            features: rest.features || null,
            videoCount: rest.videoCount || null,
            subjectCount: rest.subjectCount || null,
            duration: rest.duration || null,
            isPopular: rest.isPopular || false,
            isNew: rest.isNew || false,
            discount: rest.discount || null,
            isActive: rest.isActive !== undefined ? rest.isActive : true,
            order: rest.order || 0,
            branchId: rest.branchId || null
        };
        
        // If user is BRANCH_ADMIN, force branchId and create change request
        if (req.user?.role === 'BRANCH_ADMIN') {
            if (!req.user.branchId) {
                return res.status(403).json({ message: 'Branch admin must have a branch assigned' });
            }
            data.branchId = req.user.branchId;
            
            // Create change request
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'PACKAGE_CREATE',
                    branchId: req.user.branchId,
                    entityType: 'Package',
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
                        title: '🔔 Yeni Paket Ekleme Talebi',
                        message: `${req.user.name} yeni paket ekleme talebi oluşturdu (${data.name || 'İsimsiz'}).`,
                        userId: admin.id,
                        changeRequestId: changeRequest.id
                    }
                });
            }
            
            return res.status(201).json({ 
                message: 'Paket ekleme talebi oluşturuldu. Admin onayı bekleniyor.',
                data: changeRequest,
                isPending: true
            });
        }
        
        // Admin can create directly
        const pkg = await prisma.educationPackage.create({ data });
        res.status(201).json({ success: true, data: pkg });
    } catch (error) {
        res.status(500).json({ message: 'Error creating package', error });
    }
};

export const updatePackage = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        
        // If user is BRANCH_ADMIN, verify package belongs to their branch
        if (req.user?.role === 'BRANCH_ADMIN') {
            const existingPackage = await prisma.educationPackage.findUnique({
                where: { id }
            });
            
            if (!existingPackage || existingPackage.branchId !== req.user.branchId) {
                return res.status(403).json({ message: 'You can only update packages from your branch' });
            }
            
            // Check if there's already a pending update request
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    entityId: id,
                    changeType: 'PACKAGE_UPDATE',
                    status: 'PENDING'
                }
            });
            
            if (existingRequest) {
                return res.status(400).json({ 
                    message: 'Bu paket için zaten bekleyen bir güncelleme talebi var',
                    error: 'DUPLICATE_REQUEST'
                });
            }
            
            // Create change request
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'PACKAGE_UPDATE',
                    branchId: req.user.branchId!,
                    entityId: id,
                    entityType: 'Package',
                    oldData: existingPackage,
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
                        title: '🔔 Paket Güncelleme Talebi',
                        message: `${req.user.name} paket güncelleme talebi oluşturdu (${existingPackage.name}).`,
                        userId: admin.id,
                        changeRequestId: changeRequest.id
                    }
                });
            }
            
            return res.json({ 
                message: 'Paket güncelleme talebi oluşturuldu. Admin onayı bekleniyor.',
                data: changeRequest,
                isPending: true
            });
        }
        
        // Admin can update directly
        const { name, ...rest } = req.body;
        const updateData: any = {};
        
        if (name) {
            updateData.name = name;
            updateData.slug = name
                .toLowerCase()
                .replace(/ğ/g, 'g')
                .replace(/ü/g, 'u')
                .replace(/ş/g, 's')
                .replace(/ı/g, 'i')
                .replace(/ö/g, 'o')
                .replace(/ç/g, 'c')
                .replace(/[^a-z0-9]+/g, '-')
                .replace(/^-+|-+$/g, '');
        }
        
        if (rest.type !== undefined) updateData.type = rest.type;
        if (rest.description !== undefined) updateData.description = rest.description;
        if (rest.shortDescription !== undefined) updateData.shortDescription = rest.shortDescription;
        if (rest.price !== undefined) updateData.price = rest.price;
        if (rest.originalPrice !== undefined) updateData.originalPrice = rest.originalPrice;
        if (rest.image !== undefined) updateData.image = rest.image;
        if (rest.features !== undefined) updateData.features = rest.features;
        if (rest.videoCount !== undefined) updateData.videoCount = rest.videoCount;
        if (rest.subjectCount !== undefined) updateData.subjectCount = rest.subjectCount;
        if (rest.duration !== undefined) updateData.duration = rest.duration;
        if (rest.isPopular !== undefined) updateData.isPopular = rest.isPopular;
        if (rest.isNew !== undefined) updateData.isNew = rest.isNew;
        if (rest.discount !== undefined) updateData.discount = rest.discount;
        if (rest.isActive !== undefined) updateData.isActive = rest.isActive;
        if (rest.order !== undefined) updateData.order = rest.order;
        
        const pkg = await prisma.educationPackage.update({
            where: { id },
            data: updateData
        });
        res.json({ success: true, data: pkg });
    } catch (error) {
        res.status(500).json({ message: 'Error updating package', error });
    }
};

export const deletePackage = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        
        // If user is BRANCH_ADMIN, verify package belongs to their branch
        if (req.user?.role === 'BRANCH_ADMIN') {
            const existingPackage = await prisma.educationPackage.findUnique({
                where: { id }
            });
            
            if (!existingPackage || existingPackage.branchId !== req.user.branchId) {
                return res.status(403).json({ message: 'You can only delete packages from your branch' });
            }
            
            // Check if there's already a pending delete request
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    entityId: id,
                    changeType: 'PACKAGE_DELETE',
                    status: 'PENDING'
                }
            });
            
            if (existingRequest) {
                return res.status(400).json({ 
                    message: 'Bu paket için zaten bekleyen bir silme talebi var',
                    error: 'DUPLICATE_REQUEST'
                });
            }
            
            // Create change request
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'PACKAGE_DELETE',
                    branchId: req.user.branchId!,
                    entityId: id,
                    entityType: 'Package',
                    oldData: existingPackage,
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
                        title: '🔔 Paket Silme Talebi',
                        message: `${req.user.name} paket silme talebi oluşturdu (${existingPackage.name}).`,
                        userId: admin.id,
                        changeRequestId: changeRequest.id
                    }
                });
            }
            
            return res.json({ 
                message: 'Paket silme talebi oluşturuldu. Admin onayı bekleniyor.',
                data: changeRequest,
                isPending: true
            });
        }
        
        // Admin can delete directly
        await prisma.educationPackage.delete({ where: { id } });
        res.json({ success: true, message: 'Package deleted' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting package', error });
    }
};

export const reorderPackages = async (req: AuthRequest, res: Response) => {
    try {
        const { packages } = req.body; // Array of { id, order }
        
        if (!Array.isArray(packages)) {
            return res.status(400).json({ message: 'Packages must be an array' });
        }
        
        // Update all packages in a transaction
        await prisma.$transaction(
            packages.map((pkg: { id: string; order: number }) =>
                prisma.educationPackage.update({
                    where: { id: pkg.id },
                    data: { order: pkg.order }
                })
            )
        );
        
        res.json({ success: true, message: 'Package order updated' });
    } catch (error) {
        res.status(500).json({ message: 'Error reordering packages', error });
    }
};
