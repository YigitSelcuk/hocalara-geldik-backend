import express from 'express';
import { authenticate, authorize } from '../middleware/auth.middleware';
import {
    getAllBlogPosts,
    getBlogPostById,
    createBlogPost,
    updateBlogPost,
    deleteBlogPost
} from '../controllers/blog.controller';

const router = express.Router();

// Public routes
router.get('/', getAllBlogPosts);
router.get('/:id', getBlogPostById);

// Protected routes - BRANCH_ADMIN can create/update/delete (with approval)
router.post('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), createBlogPost);
router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), updateBlogPost);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), deleteBlogPost);

export default router;
