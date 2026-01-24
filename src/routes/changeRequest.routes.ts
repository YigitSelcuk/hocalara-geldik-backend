import { Router } from 'express';
import * as changeRequestController from '../controllers/changeRequest.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

// Get all change requests
router.get('/', authenticate, changeRequestController.getAll);

// Create a change request (branch admin)
router.post('/', authenticate, authorize('BRANCH_ADMIN'), changeRequestController.create);

// Approve/reject (admin only)
router.post('/:id/approve', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), changeRequestController.approve);
router.post('/:id/reject', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), changeRequestController.reject);

export default router;
