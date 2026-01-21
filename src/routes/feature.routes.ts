import { Router } from 'express';
import { PrismaClient } from '@prisma/client';

const router = Router();
const prisma = new PrismaClient();

// Get all features (with optional section filter)
router.get('/', async (req, res) => {
    try {
        const { section } = req.query;
        const features = await prisma.feature.findMany({
            where: {
                isActive: true,
                ...(section && { section: section as string })
            },
            orderBy: { order: 'asc' }
        });
        res.json({ success: true, data: features });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to fetch features' });
    }
});

// Get single feature
router.get('/:id', async (req, res) => {
    try {
        const feature = await prisma.feature.findUnique({
            where: { id: req.params.id }
        });
        if (!feature) {
            return res.status(404).json({ success: false, error: 'Feature not found' });
        }
        res.json({ success: true, data: feature });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to fetch feature' });
    }
});

// Create feature
router.post('/', async (req, res) => {
    try {
        const feature = await prisma.feature.create({
            data: req.body
        });
        res.status(201).json({ success: true, data: feature });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to create feature' });
    }
});

// Update feature
router.put('/:id', async (req, res) => {
    try {
        const feature = await prisma.feature.update({
            where: { id: req.params.id },
            data: req.body
        });
        res.json({ success: true, data: feature });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to update feature' });
    }
});

// Delete feature
router.delete('/:id', async (req, res) => {
    try {
        await prisma.feature.delete({
            where: { id: req.params.id }
        });
        res.json({ success: true, message: 'Feature deleted' });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to delete feature' });
    }
});

export default router;
