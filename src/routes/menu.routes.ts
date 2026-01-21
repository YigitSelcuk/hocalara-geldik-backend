import { Router } from 'express';
import { body } from 'express-validator';
import {
    getAllMenus,
    getMenuById,
    getMenuBySlug,
    createMenu,
    updateMenu,
    deleteMenu,
    addMenuItem,
    updateMenuItem,
    deleteMenuItem,
    reorderMenuItems
} from '../controllers/menu.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

// Public routes
router.get('/', getAllMenus);
router.get('/:id', getMenuById);
router.get('/slug/:slug', getMenuBySlug);

// Protected routes (admin only)
router.post(
    '/',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    [
        body('name').notEmpty().withMessage('Name is required'),
        body('slug').notEmpty().withMessage('Slug is required'),
        body('position').isIn(['TOPBAR', 'HEADER', 'FOOTER']).withMessage('Invalid position')
    ],
    createMenu
);

router.put(
    '/:id',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    updateMenu
);

router.delete(
    '/:id',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    deleteMenu
);

// Menu items
router.post(
    '/:id/items',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    [
        body('label').notEmpty().withMessage('Label is required')
    ],
    addMenuItem
);

router.put(
    '/:id/items/:itemId',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    updateMenuItem
);

router.delete(
    '/:id/items/:itemId',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    deleteMenuItem
);

router.post(
    '/:id/reorder',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    reorderMenuItems
);

export default router;
