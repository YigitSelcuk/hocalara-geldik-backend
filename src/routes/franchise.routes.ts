import { Router } from 'express';
import { 
    createFranchiseApplication, 
    getAllFranchiseApplications, 
    updateFranchiseApplicationStatus,
    deleteFranchiseApplication
} from '../controllers/franchise.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

// Public route - anyone can submit a franchise application
router.post('/', createFranchiseApplication);

// Protected routes - only admins can view/manage applications
router.get('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), getAllFranchiseApplications);
router.patch('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), updateFranchiseApplicationStatus);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN'), deleteFranchiseApplication);

export default router;
