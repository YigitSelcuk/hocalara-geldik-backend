import { Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import slugify from 'slugify';
import prisma from '../config/database';
import { AppError } from '../middleware/error.middleware';
import { AuthRequest } from '../middleware/auth.middleware';

// Get all pages
export const getAllPages = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { type, status, categoryId, branchId, isApproved, isFeatured, page = 1, limit = 20 } = req.query;

        const where: any = {};
        if (type) where.type = type as string;
        if (status) where.status = status as string;
        if (categoryId) where.categoryId = categoryId as string;
        if (branchId) where.branchId = branchId as string;
        if (isApproved !== undefined) where.isApproved = isApproved === 'true';
        if (isFeatured !== undefined) where.isFeatured = isFeatured === 'true';

        // Public users only see published and approved pages
        if (!req.user) {
            where.status = 'PUBLISHED';
            where.isApproved = true;
        }

        const skip = (Number(page) - 1) * Number(limit);

        const [pages, total] = await Promise.all([
            prisma.page.findMany({
                where,
                skip,
                take: Number(limit),
                orderBy: { publishedAt: 'desc' },
                include: {
                    author: { select: { id: true, name: true, email: true } },
                    category: true,
                    branch: true,
                    media: true
                }
            }),
            prisma.page.count({ where })
        ]);

        res.json({
            pages,
            pagination: {
                page: Number(page),
                limit: Number(limit),
                total,
                totalPages: Math.ceil(total / Number(limit))
            }
        });
    } catch (error) {
        next(error);
    }
};

// Get page by ID
export const getPageById = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;

        const page = await prisma.page.findUnique({
            where: { id },
            include: {
                author: { select: { id: true, name: true, email: true } },
                category: true,
                branch: true,
                media: true
            }
        });

        if (!page) {
            throw new AppError('Page not found', 404);
        }

        // Check permissions
        if (!req.user && (page.status !== 'PUBLISHED' || !page.isApproved)) {
            throw new AppError('Page not found', 404);
        }

        res.json({ page });
    } catch (error) {
        next(error);
    }
};

// Get page by slug
export const getPageBySlug = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { slug } = req.params;

        const page = await prisma.page.findUnique({
            where: { slug },
            include: {
                author: { select: { id: true, name: true, email: true } },
                category: true,
                branch: true,
                media: true
            }
        });

        if (!page) {
            throw new AppError('Page not found', 404);
        }

        // Check permissions
        if (!req.user && (page.status !== 'PUBLISHED' || !page.isApproved)) {
            throw new AppError('Page not found', 404);
        }

        res.json({ page });
    } catch (error) {
        next(error);
    }
};

// Create page
export const createPage = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const {
            type,
            title,
            slug: customSlug,
            content,
            excerpt,
            featuredImage,
            categoryId,
            branchId,
            status,
            isFeatured,
            seoTitle,
            seoDescription,
            seoKeywords
        } = req.body;

        // Generate slug if not provided
        const slug = customSlug || slugify(title, { lower: true, strict: true });

        // Check if slug exists
        const existingPage = await prisma.page.findUnique({ where: { slug } });
        if (existingPage) {
            throw new AppError('Slug already exists', 400);
        }

        // Branch admins can only create content for their branch
        let finalBranchId = branchId;
        if (req.user!.role === 'BRANCH_ADMIN') {
            if (!req.user!.branchId) {
                throw new AppError('Branch admin must be assigned to a branch', 400);
            }
            finalBranchId = req.user!.branchId;
        }

        // Branch content requires approval
        const isApproved = finalBranchId ? false : true;

        const page = await prisma.page.create({
            data: {
                type,
                title,
                slug,
                content,
                excerpt,
                featuredImage,
                categoryId,
                branchId: finalBranchId,
                authorId: req.user!.id,
                status: status || 'DRAFT',
                isApproved,
                isFeatured: isFeatured || false,
                seoTitle,
                seoDescription,
                seoKeywords,
                publishedAt: status === 'PUBLISHED' ? new Date() : null
            },
            include: {
                author: { select: { id: true, name: true, email: true } },
                category: true,
                branch: true
            }
        });

        res.status(201).json({ page });
    } catch (error) {
        next(error);
    }
};

// Update page
export const updatePage = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;

        // Check if page exists and user has permission
        const existingPage = await prisma.page.findUnique({ where: { id } });
        if (!existingPage) {
            throw new AppError('Page not found', 404);
        }

        // Check permissions
        const isAuthor = existingPage.authorId === req.user!.id;
        const isAdmin = ['SUPER_ADMIN', 'CENTER_ADMIN'].includes(req.user!.role);
        const isBranchAdmin = req.user!.role === 'BRANCH_ADMIN' && existingPage.branchId === req.user!.branchId;

        if (!isAuthor && !isAdmin && !isBranchAdmin) {
            throw new AppError('Insufficient permissions', 403);
        }

        const {
            title,
            slug,
            content,
            excerpt,
            featuredImage,
            categoryId,
            status,
            isFeatured,
            seoTitle,
            seoDescription,
            seoKeywords
        } = req.body;

        // If slug is being changed, check if it's available
        if (slug && slug !== existingPage.slug) {
            const slugExists = await prisma.page.findUnique({ where: { slug } });
            if (slugExists) {
                throw new AppError('Slug already exists', 400);
            }
        }

        // If branch content is being updated, reset approval
        const isApproved = existingPage.branchId && (title || content) ? false : existingPage.isApproved;

        const page = await prisma.page.update({
            where: { id },
            data: {
                ...(title !== undefined && { title }),
                ...(slug !== undefined && { slug }),
                ...(content !== undefined && { content }),
                ...(excerpt !== undefined && { excerpt }),
                ...(featuredImage !== undefined && { featuredImage }),
                ...(categoryId !== undefined && { categoryId }),
                ...(status !== undefined && { status }),
                ...(isFeatured !== undefined && { isFeatured }),
                ...(seoTitle !== undefined && { seoTitle }),
                ...(seoDescription !== undefined && { seoDescription }),
                ...(seoKeywords !== undefined && { seoKeywords }),
                isApproved,
                ...(status === 'PUBLISHED' && !existingPage.publishedAt && { publishedAt: new Date() })
            },
            include: {
                author: { select: { id: true, name: true, email: true } },
                category: true,
                branch: true
            }
        });

        res.json({ page });
    } catch (error) {
        next(error);
    }
};

// Delete page
export const deletePage = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;

        const page = await prisma.page.findUnique({ where: { id } });
        if (!page) {
            throw new AppError('Page not found', 404);
        }

        // Check permissions
        const isAuthor = page.authorId === req.user!.id;
        const isAdmin = ['SUPER_ADMIN', 'CENTER_ADMIN'].includes(req.user!.role);

        if (!isAuthor && !isAdmin) {
            throw new AppError('Insufficient permissions', 403);
        }

        await prisma.page.delete({ where: { id } });

        res.json({ message: 'Page deleted successfully' });
    } catch (error) {
        next(error);
    }
};

// Publish page
export const publishPage = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;

        const page = await prisma.page.findUnique({ where: { id } });
        if (!page) {
            throw new AppError('Page not found', 404);
        }

        // Check permissions
        const isAuthor = page.authorId === req.user!.id;
        const isAdmin = ['SUPER_ADMIN', 'CENTER_ADMIN'].includes(req.user!.role);

        if (!isAuthor && !isAdmin) {
            throw new AppError('Insufficient permissions', 403);
        }

        const updatedPage = await prisma.page.update({
            where: { id },
            data: {
                status: 'PUBLISHED',
                publishedAt: page.publishedAt || new Date()
            },
            include: {
                author: { select: { id: true, name: true, email: true } },
                category: true,
                branch: true
            }
        });

        res.json({ page: updatedPage });
    } catch (error) {
        next(error);
    }
};

// Approve page (for branch content)
export const approvePage = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const { isFeatured } = req.body;

        const page = await prisma.page.update({
            where: { id },
            data: {
                isApproved: true,
                ...(isFeatured !== undefined && { isFeatured })
            },
            include: {
                author: { select: { id: true, name: true, email: true } },
                category: true,
                branch: true
            }
        });

        res.json({ page });
    } catch (error) {
        next(error);
    }
};
