import { Router } from 'express';
import { PrismaClient } from '@prisma/client';

const router = Router();
const prisma = new PrismaClient();

// Get all banner cards
router.get('/', async (req, res) => {
    try {
        const bannerCards = await prisma.bannerCard.findMany({
            where: { isActive: true },
            orderBy: { order: 'asc' }
        });
        res.json({ success: true, data: bannerCards });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to fetch banner cards' });
    }
});

// Get single banner card
router.get('/:id', async (req, res) => {
    try {
        const bannerCard = await prisma.bannerCard.findUnique({
            where: { id: req.params.id }
        });
        if (!bannerCard) {
            return res.status(404).json({ success: false, error: 'Banner card not found' });
        }
        res.json({ success: true, data: bannerCard });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to fetch banner card' });
    }
});

// Create banner card
router.post('/', async (req, res) => {
    try {
        const bannerCard = await prisma.bannerCard.create({
            data: req.body
        });
        res.status(201).json({ success: true, data: bannerCard });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to create banner card' });
    }
});

// Update banner card
router.put('/:id', async (req, res) => {
    try {
        const bannerCard = await prisma.bannerCard.update({
            where: { id: req.params.id },
            data: req.body
        });
        res.json({ success: true, data: bannerCard });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to update banner card' });
    }
});

// Delete banner card
router.delete('/:id', async (req, res) => {
    try {
        await prisma.bannerCard.delete({
            where: { id: req.params.id }
        });
        res.json({ success: true, message: 'Banner card deleted' });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to delete banner card' });
    }
});

export default router;
