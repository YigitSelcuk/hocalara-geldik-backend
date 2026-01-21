import { Router } from 'express';
import { PrismaClient } from '@prisma/client';

const router = Router();
const prisma = new PrismaClient();

// Get all exam dates
router.get('/', async (req, res) => {
    try {
        const examDates = await prisma.examDate.findMany({
            where: { isActive: true },
            orderBy: { examDate: 'asc' }
        });
        res.json({ success: true, data: examDates });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to fetch exam dates' });
    }
});

// Get single exam date
router.get('/:id', async (req, res) => {
    try {
        const examDate = await prisma.examDate.findUnique({
            where: { id: req.params.id }
        });
        if (!examDate) {
            return res.status(404).json({ success: false, error: 'Exam date not found' });
        }
        res.json({ success: true, data: examDate });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to fetch exam date' });
    }
});

// Create exam date
router.post('/', async (req, res) => {
    try {
        const examDate = await prisma.examDate.create({
            data: req.body
        });
        res.status(201).json({ success: true, data: examDate });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to create exam date' });
    }
});

// Update exam date
router.put('/:id', async (req, res) => {
    try {
        const examDate = await prisma.examDate.update({
            where: { id: req.params.id },
            data: req.body
        });
        res.json({ success: true, data: examDate });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to update exam date' });
    }
});

// Delete exam date
router.delete('/:id', async (req, res) => {
    try {
        await prisma.examDate.delete({
            where: { id: req.params.id }
        });
        res.json({ success: true, message: 'Exam date deleted' });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to delete exam date' });
    }
});

export default router;
