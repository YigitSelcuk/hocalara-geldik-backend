import { Router } from 'express';
import { getAllPackages, createPackage, updatePackage, deletePackage } from '../controllers/package.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

router.get('/', authenticate, getAllPackages);
router.post('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), createPackage);
router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), updatePackage);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), deletePackage);

export default router;
