import { Router } from 'express';
import { PrismaClient } from '@prisma/client';

const router = Router();
const prisma = new PrismaClient();

// Get all blog posts (with optional category filter)
router.get('/', async (req, res) => {
    try {
        const { category } = req.query;
        const blogPosts = await prisma.blogPost.findMany({
            where: {
                isActive: true,
                ...(category && { category: category as string })
            },
            orderBy: { createdAt: 'desc' }
        });
        res.json({ success: true, data: blogPosts });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to fetch blog posts' });
    }
});

// Get single blog post
router.get('/:id', async (req, res) => {
    try {
        const blogPost = await prisma.blogPost.findUnique({
            where: { id: req.params.id }
        });
        if (!blogPost) {
            return res.status(404).json({ success: false, error: 'Blog post not found' });
        }
        res.json({ success: true, data: blogPost });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to fetch blog post' });
    }
});

// Create blog post
router.post('/', async (req, res) => {
    try {
        const blogPost = await prisma.blogPost.create({
            data: req.body
        });
        res.status(201).json({ success: true, data: blogPost });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to create blog post' });
    }
});

// Update blog post
router.put('/:id', async (req, res) => {
    try {
        const blogPost = await prisma.blogPost.update({
            where: { id: req.params.id },
            data: req.body
        });
        res.json({ success: true, data: blogPost });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to update blog post' });
    }
});

// Delete blog post
router.delete('/:id', async (req, res) => {
    try {
        await prisma.blogPost.delete({
            where: { id: req.params.id }
        });
        res.json({ success: true, message: 'Blog post deleted' });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Failed to delete blog post' });
    }
});

export default router;
