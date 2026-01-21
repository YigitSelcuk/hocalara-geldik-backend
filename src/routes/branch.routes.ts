import { Router } from 'express';
import { body } from 'express-validator';
import {
    getAllBranches,
    getBranchById,
    getBranchBySlug,
    createBranch,
    updateBranch,
    deleteBranch,
    getBranchStats
} from '../controllers/branch.controller';
import { authenticate, authorize, authorizeBranch } from '../middleware/auth.middleware';

const router = Router();

// Public routes
router.get('/', getAllBranches);
router.get('/:id', getBranchById);
router.get('/slug/:slug', getBranchBySlug);
router.get('/:id/stats', getBranchStats);

// Protected routes
router.post(
    '/',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    [
        body('name').notEmpty(),
        body('slug').notEmpty(),
        body('address').notEmpty(),
        body('phone').notEmpty(),
        body('lat').isFloat(),
        body('lng').isFloat()
    ],
    createBranch
);

router.put(
    '/:id',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'),
    authorizeBranch,
    updateBranch
);

router.delete(
    '/:id',
    authenticate,
    authorize('SUPER_ADMIN'),
    deleteBranch
);

export default router;
