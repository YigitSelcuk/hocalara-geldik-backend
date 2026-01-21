import { Router } from 'express';
import { PrismaClient } from '@prisma/client';

const router = Router();
const prisma = new PrismaClient();

// Get all social media
router.get('/', async (req, res) => {
    try {
        const socialMedia = await prisma.socialMedia.findMany({
            where: { isActive: true },
            orderBy: { order: 'asc' }
        });
        res.json({ success: true, data: socialMedia });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to fetch social media' });
    }
});

// Get single social media
router.get('/:id', async (req, res) => {
    try {
        const socialMedia = await prisma.socialMedia.findUnique({
            where: { id: req.params.id }
        });
        if (!socialMedia) {
            return res.status(404).json({ success: false, error: 'Social media not found' });
        }
        res.json({ success: true, data: socialMedia });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to fetch social media' });
    }
});

// Create social media
router.post('/', async (req, res) => {
    try {
        const socialMedia = await prisma.socialMedia.create({
            data: req.body
        });
        res.status(201).json({ success: true, data: socialMedia });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to create social media' });
    }
});

// Update social media
router.put('/:id', async (req, res) => {
    try {
        const socialMedia = await prisma.socialMedia.update({
            where: { id: req.params.id },
            data: req.body
        });
        res.json({ success: true, data: socialMedia });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to update social media' });
    }
});

// Delete social media
router.delete('/:id', async (req, res) => {
    try {
        await prisma.socialMedia.delete({
            where: { id: req.params.id }
        });
        res.json({ success: true, message: 'Social media deleted' });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to delete social media' });
    }
});

export default router;
