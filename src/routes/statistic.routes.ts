import { Router } from 'express';
import { PrismaClient } from '@prisma/client';

const router = Router();
const prisma = new PrismaClient();

// Get all statistics
router.get('/', async (req, res) => {
    try {
        const statistics = await prisma.statistic.findMany({
            where: { isActive: true },
            orderBy: { order: 'asc' }
        });
        res.json({ success: true, data: statistics });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to fetch statistics' });
    }
});

// Get single statistic
router.get('/:id', async (req, res) => {
    try {
        const statistic = await prisma.statistic.findUnique({
            where: { id: req.params.id }
        });
        if (!statistic) {
            return res.status(404).json({ success: false, error: 'Statistic not found' });
        }
        res.json({ success: true, data: statistic });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to fetch statistic' });
    }
});

// Create statistic
router.post('/', async (req, res) => {
    try {
        const statistic = await prisma.statistic.create({
            data: req.body
        });
        res.status(201).json({ success: true, data: statistic });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to create statistic' });
    }
});

// Update statistic
router.put('/:id', async (req, res) => {
    try {
        const statistic = await prisma.statistic.update({
            where: { id: req.params.id },
            data: req.body
        });
        res.json({ success: true, data: statistic });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to update statistic' });
    }
});

// Delete statistic
router.delete('/:id', async (req, res) => {
    try {
        await prisma.statistic.delete({
            where: { id: req.params.id }
        });
        res.json({ success: true, message: 'Statistic deleted' });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to delete statistic' });
    }
});

export default router;
