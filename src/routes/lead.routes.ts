import { Router } from 'express';
import { createLead, getAllLeads, updateLeadStatus } from '../controllers/lead.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

// Public route - anyone can submit a lead
router.post('/', createLead);

// Protected routes - only admins can view/manage leads
router.get('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), getAllLeads);
router.patch('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), updateLeadStatus);

export default router;
