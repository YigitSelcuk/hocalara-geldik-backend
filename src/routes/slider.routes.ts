import { Router } from 'express';
import { body } from 'express-validator';
import {
    getAllSliders,
    getSliderById,
    createSlider,
    updateSlider,
    deleteSlider,
    reorderSliders
} from '../controllers/slider.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

// Public routes
router.get('/', getAllSliders);
router.get('/:id', getSliderById);

// Protected routes (admin only)
router.post(
    '/',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    [
        body('title').notEmpty().withMessage('Title is required'),
        body('image').notEmpty().withMessage('Image is required')
    ],
    createSlider
);

router.put(
    '/:id',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    updateSlider
);

router.delete(
    '/:id',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    deleteSlider
);

router.post(
    '/reorder',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    reorderSliders
);

export default router;
