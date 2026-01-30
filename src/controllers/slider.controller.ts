import { Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import prisma from '../config/database';
import { AppError } from '../middleware/error.middleware';
import { AuthRequest } from '../middleware/auth.middleware';

// Get all sliders
export const getAllSliders = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { target, isActive } = req.query;

        const where: any = {};
        if (target) where.target = target as string;
        if (isActive !== undefined) where.isActive = isActive === 'true';

        const sliders = await prisma.slider.findMany({
            where,
            orderBy: { order: 'asc' },
            include: {
                createdBy: {
                    select: { id: true, name: true, email: true }
                }
            }
        });

        res.json({ sliders });
    } catch (error) {
        next(error);
    }
};

// Get slider by ID
export const getSliderById = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;

        const slider = await prisma.slider.findUnique({
            where: { id },
            include: {
                createdBy: {
                    select: { id: true, name: true, email: true }
                }
            }
        });

        if (!slider) {
            throw new AppError('Slider not found', 404);
        }

        res.json({ slider });
    } catch (error) {
        next(error);
    }
};

// Create slider
export const createSlider = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { 
            title, subtitle, image, link, target, isActive,
            primaryButtonText, primaryButtonLink,
            secondaryButtonText, secondaryButtonLink
        } = req.body;

        // Get the highest order number
        const maxOrder = await prisma.slider.findFirst({
            where: { target },
            orderBy: { order: 'desc' },
            select: { order: true }
        });

        const slider = await prisma.slider.create({
            data: {
                title,
                subtitle,
                image,
                link,
                target: target || 'main',
                isActive: isActive !== undefined ? isActive : true,
                order: (maxOrder?.order || 0) + 1,
                primaryButtonText,
                primaryButtonLink,
                secondaryButtonText,
                secondaryButtonLink,
                createdById: req.user!.id
            },
            include: {
                createdBy: {
                    select: { id: true, name: true, email: true }
                }
            }
        });

        res.status(201).json({ slider });
    } catch (error) {
        next(error);
    }
};

// Update slider
export const updateSlider = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const { 
            title, subtitle, image, link, target, isActive, order,
            primaryButtonText, primaryButtonLink,
            secondaryButtonText, secondaryButtonLink
        } = req.body;

        const slider = await prisma.slider.update({
            where: { id },
            data: {
                ...(title !== undefined && { title }),
                ...(subtitle !== undefined && { subtitle }),
                ...(image !== undefined && { image }),
                ...(link !== undefined && { link }),
                ...(target !== undefined && { target }),
                ...(isActive !== undefined && { isActive }),
                ...(order !== undefined && { order }),
                ...(primaryButtonText !== undefined && { primaryButtonText }),
                ...(primaryButtonLink !== undefined && { primaryButtonLink }),
                ...(secondaryButtonText !== undefined && { secondaryButtonText }),
                ...(secondaryButtonLink !== undefined && { secondaryButtonLink })
            },
            include: {
                createdBy: {
                    select: { id: true, name: true, email: true }
                }
            }
        });

        res.json({ slider });
    } catch (error) {
        next(error);
    }
};

// Delete slider
export const deleteSlider = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;

        await prisma.slider.delete({
            where: { id }
        });

        res.json({ message: 'Slider deleted successfully' });
    } catch (error) {
        next(error);
    }
};

// Reorder sliders
export const reorderSliders = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { sliders } = req.body; // Array of { id, order }

        if (!Array.isArray(sliders)) {
            throw new AppError('Invalid sliders array', 400);
        }

        // Update all sliders in a transaction
        await prisma.$transaction(
            sliders.map(({ id, order }) =>
                prisma.slider.update({
                    where: { id },
                    data: { order }
                })
            )
        );

        res.json({ message: 'Sliders reordered successfully' });
    } catch (error) {
        next(error);
    }
};
