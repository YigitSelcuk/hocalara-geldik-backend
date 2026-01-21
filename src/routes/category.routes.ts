import { Router } from 'express';
import { body } from 'express-validator';
import {
    getAllCategories,
    getCategoryById,
    getCategoryBySlug,
    createCategory,
    updateCategory,
    deleteCategory,
    reorderCategories
} from '../controllers/category.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

router.get('/', getAllCategories);
router.get('/:id', getCategoryById);
router.get('/slug/:slug', getCategoryBySlug);

router.post(
    '/',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    [body('name').notEmpty(), body('slug').notEmpty()],
    createCategory
);

router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), updateCategory);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), deleteCategory);
router.post('/reorder', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), reorderCategories);

export default router;
