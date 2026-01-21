import { Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import prisma from '../config/database';
import { AppError } from '../middleware/error.middleware';
import { AuthRequest } from '../middleware/auth.middleware';

export const getAllCategories = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { isActive } = req.query;
        const where: any = {};
        if (isActive !== undefined) where.isActive = isActive === 'true';

        const categories = await prisma.category.findMany({
            where,
            orderBy: { order: 'asc' },
            include: {
                parent: true,
                children: { orderBy: { order: 'asc' } },
                _count: { select: { pages: true } }
            }
        });

        res.json({ categories });
    } catch (error) {
        next(error);
    }
};

export const getCategoryById = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const category = await prisma.category.findUnique({
            where: { id: req.params.id },
            include: { parent: true, children: true, pages: true }
        });
        if (!category) throw new AppError('Category not found', 404);
        res.json({ category });
    } catch (error) {
        next(error);
    }
};

export const getCategoryBySlug = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const category = await prisma.category.findUnique({
            where: { slug: req.params.slug },
            include: { parent: true, children: true, pages: { where: { status: 'PUBLISHED', isApproved: true } } }
        });
        if (!category) throw new AppError('Category not found', 404);
        res.json({ category });
    } catch (error) {
        next(error);
    }
};

export const createCategory = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

        const { name, slug, description, image, icon, parentId, seoTitle, seoDescription } = req.body;

        const maxOrder = await prisma.category.findFirst({
            where: { parentId: parentId || null },
            orderBy: { order: 'desc' }
        });

        const category = await prisma.category.create({
            data: {
                name, slug, description, image, icon, parentId,
                seoTitle, seoDescription,
                order: (maxOrder?.order || 0) + 1
            }
        });

        res.status(201).json({ category });
    } catch (error) {
        next(error);
    }
};

export const updateCategory = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { name, slug, description, image, icon, parentId, isActive, order, seoTitle, seoDescription } = req.body;

        const category = await prisma.category.update({
            where: { id: req.params.id },
            data: {
                ...(name !== undefined && { name }),
                ...(slug !== undefined && { slug }),
                ...(description !== undefined && { description }),
                ...(image !== undefined && { image }),
                ...(icon !== undefined && { icon }),
                ...(parentId !== undefined && { parentId }),
                ...(isActive !== undefined && { isActive }),
                ...(order !== undefined && { order }),
                ...(seoTitle !== undefined && { seoTitle }),
                ...(seoDescription !== undefined && { seoDescription })
            }
        });

        res.json({ category });
    } catch (error) {
        next(error);
    }
};

export const deleteCategory = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        await prisma.category.delete({ where: { id: req.params.id } });
        res.json({ message: 'Category deleted successfully' });
    } catch (error) {
        next(error);
    }
};

export const reorderCategories = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { categories } = req.body;
        if (!Array.isArray(categories)) throw new AppError('Invalid categories array', 400);

        await prisma.$transaction(
            categories.map(({ id, order }) => prisma.category.update({ where: { id }, data: { order } }))
        );

        res.json({ message: 'Categories reordered successfully' });
    } catch (error) {
        next(error);
    }
};
