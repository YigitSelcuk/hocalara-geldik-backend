import { Router } from 'express';
import { body } from 'express-validator';
import {
    getAllPages,
    getPageById,
    getPageBySlug,
    createPage,
    updatePage,
    deletePage,
    publishPage,
    approvePage
} from '../controllers/page.controller';
import { authenticate, authorize, authorizeBranch } from '../middleware/auth.middleware';

const router = Router();

// Public routes
router.get('/', getAllPages);
router.get('/:id', getPageById);
router.get('/slug/:slug', getPageBySlug);

// Protected routes
router.post(
    '/',
    authenticate,
    [
        body('title').notEmpty().withMessage('Title is required'),
        body('content').notEmpty().withMessage('Content is required'),
        body('type').isIn(['REGULAR', 'NEWS', 'BLOG', 'PHOTO_GALLERY', 'VIDEO_GALLERY']).withMessage('Invalid type')
    ],
    createPage
);

router.put(
    '/:id',
    authenticate,
    updatePage
);

router.delete(
    '/:id',
    authenticate,
    deletePage
);

// Publish page (author or admin)
router.post(
    '/:id/publish',
    authenticate,
    publishPage
);

// Approve page (admin only - for branch content)
router.post(
    '/:id/approve',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    approvePage
);

export default router;
