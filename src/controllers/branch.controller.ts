import { Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import prisma from '../config/database';
import { AppError } from '../middleware/error.middleware';
import { AuthRequest } from '../middleware/auth.middleware';

export const getAllBranches = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { isActive } = req.query;
        const where: any = {};
        if (isActive !== undefined) where.isActive = isActive === 'true';

        const branches = await prisma.branch.findMany({
            where,
            include: {
                _count: {
                    select: { users: true, pages: true }
                }
            }
        });

        res.json({ branches });
    } catch (error) {
        next(error);
    }
};

export const getBranchById = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const branch = await prisma.branch.findUnique({
            where: { id: req.params.id },
            include: {
                users: {
                    select: { id: true, name: true, email: true, role: true }
                },
                _count: {
                    select: { pages: true }
                }
            }
        });

        if (!branch) throw new AppError('Branch not found', 404);
        res.json({ branch });
    } catch (error) {
        next(error);
    }
};

export const getBranchBySlug = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const branch = await prisma.branch.findUnique({
            where: { slug: req.params.slug },
            include: {
                users: {
                    select: { id: true, name: true, email: true, role: true }
                },
                teachers: true,
                pages: {
                    where: { status: 'PUBLISHED', isApproved: true },
                    orderBy: { publishedAt: 'desc' },
                    take: 10
                }
            }
        });

        if (!branch) throw new AppError('Branch not found', 404);
        res.json({ branch });
    } catch (error) {
        next(error);
    }
};

export const createBranch = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

        const {
            name, slug, description, address, phone, whatsapp, email,
            lat, lng, image, customBanner, successBanner, logo, primaryColor
        } = req.body;

        const existingBranch = await prisma.branch.findUnique({ where: { slug } });
        if (existingBranch) throw new AppError('Slug already exists', 400);

        const branch = await prisma.branch.create({
            data: {
                name, slug, description, address, phone, whatsapp, email,
                lat, lng, image, customBanner, successBanner, logo, primaryColor
            }
        });

        res.status(201).json({ branch });
    } catch (error) {
        next(error);
    }
};

export const updateBranch = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const updateData = req.body;
        
        // If user is BRANCH_ADMIN, create change request
        if (req.user?.role === 'BRANCH_ADMIN') {
            if (req.user.branchId !== id) {
                throw new AppError('You can only update your own branch', 403);
            }
            
            const existingBranch = await prisma.branch.findUnique({ where: { id } });
            if (!existingBranch) throw new AppError('Branch not found', 404);
            
            // Check if there's already a pending update request for this branch
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    branchId: id,
                    changeType: 'BRANCH_UPDATE',
                    status: 'PENDING'
                }
            });
            
            if (existingRequest) {
                throw new AppError('Bu şube için zaten bekleyen bir güncelleme talebi var', 400);
            }
            
            // Clean the update data - only keep valid branch fields
            const {
                name, slug, description, address, phone, whatsapp, email,
                lat, lng, image, customBanner, successBanner, logo, primaryColor, isActive
            } = updateData;
            
            const cleanUpdateData: any = {};
            if (name !== undefined) cleanUpdateData.name = name;
            if (slug !== undefined) cleanUpdateData.slug = slug;
            if (description !== undefined) cleanUpdateData.description = description;
            if (address !== undefined) cleanUpdateData.address = address;
            if (phone !== undefined) cleanUpdateData.phone = phone;
            if (whatsapp !== undefined) cleanUpdateData.whatsapp = whatsapp;
            if (email !== undefined) cleanUpdateData.email = email;
            if (lat !== undefined) cleanUpdateData.lat = lat;
            if (lng !== undefined) cleanUpdateData.lng = lng;
            if (image !== undefined) cleanUpdateData.image = image;
            if (customBanner !== undefined) cleanUpdateData.customBanner = customBanner;
            if (successBanner !== undefined) cleanUpdateData.successBanner = successBanner;
            if (logo !== undefined) cleanUpdateData.logo = logo;
            if (primaryColor !== undefined) cleanUpdateData.primaryColor = primaryColor;
            if (isActive !== undefined) cleanUpdateData.isActive = isActive;
            
            // Create change request
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'BRANCH_UPDATE',
                    branchId: id,
                    entityId: id,
                    entityType: 'Branch',
                    oldData: existingBranch,
                    newData: cleanUpdateData,
                    requestedBy: req.user.id,
                    status: 'PENDING'
                },
                include: {
                    requester: { select: { id: true, name: true, email: true } },
                    branch: { select: { id: true, name: true } }
                }
            });
            
            return res.json({ 
                message: 'Şube güncelleme talebi oluşturuldu. Admin onayı bekleniyor.',
                data: changeRequest,
                isPending: true
            });
        }
        
        // Admin can update directly
        const {
            name, slug, description, address, phone, whatsapp, email,
            lat, lng, image, customBanner, successBanner, logo, primaryColor, isActive
        } = updateData;

        const branch = await prisma.branch.update({
            where: { id },
            data: {
                ...(name !== undefined && { name }),
                ...(slug !== undefined && { slug }),
                ...(description !== undefined && { description }),
                ...(address !== undefined && { address }),
                ...(phone !== undefined && { phone }),
                ...(whatsapp !== undefined && { whatsapp }),
                ...(email !== undefined && { email }),
                ...(lat !== undefined && { lat }),
                ...(lng !== undefined && { lng }),
                ...(image !== undefined && { image }),
                ...(customBanner !== undefined && { customBanner }),
                ...(successBanner !== undefined && { successBanner }),
                ...(logo !== undefined && { logo }),
                ...(primaryColor !== undefined && { primaryColor }),
                ...(isActive !== undefined && { isActive })
            }
        });

        res.json({ branch });
    } catch (error) {
        next(error);
    }
};

export const deleteBranch = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        await prisma.branch.delete({ where: { id: req.params.id } });
        res.json({ message: 'Branch deleted successfully' });
    } catch (error) {
        next(error);
    }
};

export const getBranchStats = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;

        const [branch, totalPages, publishedPages, pendingPages, totalUsers] = await Promise.all([
            prisma.branch.findUnique({ where: { id } }),
            prisma.page.count({ where: { branchId: id } }),
            prisma.page.count({ where: { branchId: id, status: 'PUBLISHED', isApproved: true } }),
            prisma.page.count({ where: { branchId: id, isApproved: false } }),
            prisma.user.count({ where: { branchId: id } })
        ]);

        if (!branch) throw new AppError('Branch not found', 404);

        res.json({
            stats: {
                totalPages,
                publishedPages,
                pendingPages,
                totalUsers
            }
        });
    } catch (error) {
        next(error);
    }
};
