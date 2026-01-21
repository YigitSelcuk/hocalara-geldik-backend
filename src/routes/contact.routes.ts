import { Router } from 'express';
import { body } from 'express-validator';
import {
    submitContactForm,
    getAllSubmissions,
    getSubmissionById,
    markAsRead,
    deleteSubmission
} from '../controllers/contact.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

// Public route
router.post(
    '/submit',
    [
        body('name').notEmpty(),
        body('email').isEmail(),
        body('message').notEmpty()
    ],
    submitContactForm
);

// Protected routes
router.get('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), getAllSubmissions);
router.get('/:id', authenticate, getSubmissionById);
router.post('/:id/read', authenticate, markAsRead);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), deleteSubmission);

export default router;
