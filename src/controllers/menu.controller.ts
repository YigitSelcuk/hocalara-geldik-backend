import { Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import prisma from '../config/database';
import { AppError } from '../middleware/error.middleware';
import { AuthRequest } from '../middleware/auth.middleware';

// Get all menus
export const getAllMenus = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { position, isActive } = req.query;

        const where: any = {};
        if (position) where.position = position as string;
        if (isActive !== undefined) where.isActive = isActive === 'true';

        const menus = await prisma.menu.findMany({
            where,
            include: {
                items: {
                    where: { isActive: true },
                    orderBy: { order: 'asc' },
                    include: {
                        children: {
                            where: { isActive: true },
                            orderBy: { order: 'asc' },
                            include: {
                                page: { select: { id: true, title: true, slug: true } },
                                category: { select: { id: true, name: true, slug: true } }
                            }
                        },
                        page: { select: { id: true, title: true, slug: true } },
                        category: { select: { id: true, name: true, slug: true } }
                    }
                }
            }
        });

        res.json({ menus });
    } catch (error) {
        next(error);
    }
};

// Get menu by ID
export const getMenuById = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;

        const menu = await prisma.menu.findUnique({
            where: { id },
            include: {
                items: {
                    orderBy: { order: 'asc' },
                    include: {
                        children: {
                            orderBy: { order: 'asc' }
                        },
                        page: true,
                        category: true
                    }
                }
            }
        });

        if (!menu) {
            throw new AppError('Menu not found', 404);
        }

        res.json({ menu });
    } catch (error) {
        next(error);
    }
};

// Get menu by slug
export const getMenuBySlug = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { slug } = req.params;

        const menu = await prisma.menu.findUnique({
            where: { slug },
            include: {
                items: {
                    where: { isActive: true, parentId: null },
                    orderBy: { order: 'asc' },
                    include: {
                        children: {
                            where: { isActive: true },
                            orderBy: { order: 'asc' },
                            include: {
                                page: { select: { id: true, title: true, slug: true } },
                                category: { select: { id: true, name: true, slug: true } }
                            }
                        },
                        page: { select: { id: true, title: true, slug: true } },
                        category: { select: { id: true, name: true, slug: true } }
                    }
                }
            }
        });

        if (!menu) {
            throw new AppError('Menu not found', 404);
        }

        res.json({ menu });
    } catch (error) {
        next(error);
    }
};

// Create menu
export const createMenu = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { name, slug, position, isActive } = req.body;

        const menu = await prisma.menu.create({
            data: {
                name,
                slug,
                position,
                isActive: isActive !== undefined ? isActive : true,
                createdById: req.user!.id
            }
        });

        res.status(201).json({ menu });
    } catch (error) {
        next(error);
    }
};

// Update menu
export const updateMenu = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const { name, slug, position, isActive } = req.body;

        const menu = await prisma.menu.update({
            where: { id },
            data: {
                ...(name !== undefined && { name }),
                ...(slug !== undefined && { slug }),
                ...(position !== undefined && { position }),
                ...(isActive !== undefined && { isActive })
            }
        });

        res.json({ menu });
    } catch (error) {
        next(error);
    }
};

// Delete menu
export const deleteMenu = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;

        await prisma.menu.delete({
            where: { id }
        });

        res.json({ message: 'Menu deleted successfully' });
    } catch (error) {
        next(error);
    }
};

// Add menu item
export const addMenuItem = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { id } = req.params;
        const { label, url, pageId, categoryId, parentId, target, seoTitle, seoNoFollow, isActive } = req.body;

        // Get the highest order number for this menu/parent
        const maxOrder = await prisma.menuItem.findFirst({
            where: { menuId: id, parentId: parentId || null },
            orderBy: { order: 'desc' },
            select: { order: true }
        });

        const menuItem = await prisma.menuItem.create({
            data: {
                menuId: id,
                label,
                url,
                pageId,
                categoryId,
                parentId,
                target: target || '_self',
                seoTitle,
                seoNoFollow: seoNoFollow || false,
                isActive: isActive !== undefined ? isActive : true,
                order: (maxOrder?.order || 0) + 1
            },
            include: {
                page: true,
                category: true
            }
        });

        res.status(201).json({ menuItem });
    } catch (error) {
        next(error);
    }
};

// Update menu item
export const updateMenuItem = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { itemId } = req.params;
        const { label, url, pageId, categoryId, parentId, target, seoTitle, seoNoFollow, isActive, order } = req.body;

        const menuItem = await prisma.menuItem.update({
            where: { id: itemId },
            data: {
                ...(label !== undefined && { label }),
                ...(url !== undefined && { url }),
                ...(pageId !== undefined && { pageId }),
                ...(categoryId !== undefined && { categoryId }),
                ...(parentId !== undefined && { parentId }),
                ...(target !== undefined && { target }),
                ...(seoTitle !== undefined && { seoTitle }),
                ...(seoNoFollow !== undefined && { seoNoFollow }),
                ...(isActive !== undefined && { isActive }),
                ...(order !== undefined && { order })
            },
            include: {
                page: true,
                category: true
            }
        });

        res.json({ menuItem });
    } catch (error) {
        next(error);
    }
};

// Delete menu item
export const deleteMenuItem = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { itemId } = req.params;

        await prisma.menuItem.delete({
            where: { id: itemId }
        });

        res.json({ message: 'Menu item deleted successfully' });
    } catch (error) {
        next(error);
    }
};

// Reorder menu items
export const reorderMenuItems = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { items } = req.body; // Array of { id, order }

        if (!Array.isArray(items)) {
            throw new AppError('Invalid items array', 400);
        }

        await prisma.$transaction(
            items.map(({ id, order }) =>
                prisma.menuItem.update({
                    where: { id },
                    data: { order }
                })
            )
        );

        res.json({ message: 'Menu items reordered successfully' });
    } catch (error) {
        next(error);
    }
};
