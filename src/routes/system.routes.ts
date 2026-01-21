import { Router } from 'express';
import { seedDatabase } from '../controllers/system.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

// Protect all routes - only SUPER_ADMIN can seed
router.use(authenticate);
router.use(authorize('SUPER_ADMIN'));

router.post('/seed', seedDatabase);

export default router;
