import { Router } from 'express';
import { getAllPackages, createPackage, updatePackage, deletePackage, reorderPackages } from '../controllers/package.controller';
import { authenticate, authorize, optionalAuthenticate } from '../middleware/auth.middleware';

const router = Router();

// Public route - no authentication required for viewing packages
router.get('/', optionalAuthenticate, getAllPackages);

// Protected routes - require authentication and authorization
router.post('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), createPackage);
router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), updatePackage);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), deletePackage);
router.post('/reorder', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), reorderPackages);

export default router;
