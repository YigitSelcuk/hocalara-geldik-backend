
import { Router } from 'express';
import * as yearlySuccessController from '../controllers/yearlySuccess.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

router.get('/', yearlySuccessController.getAllYearlySuccesses);
router.get('/:year', yearlySuccessController.getByYear);

// Admin only routes
router.post('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), yearlySuccessController.createYearlySuccess);
router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), yearlySuccessController.updateYearlySuccess);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), yearlySuccessController.deleteYearlySuccess);

// Student management
router.post('/:id/students', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), yearlySuccessController.addStudent);
router.delete('/:id/students/:studentId', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), yearlySuccessController.deleteStudent);

export default router;
