import { Router } from 'express';
import { getAllPackages, createPackage, updatePackage, deletePackage } from '../controllers/package.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

router.get('/', getAllPackages);
router.post('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), createPackage);
router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), updatePackage);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), deletePackage);

export default router;
