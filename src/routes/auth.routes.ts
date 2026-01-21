import { Router } from 'express';
import { body } from 'express-validator';
import { login, register, refreshToken, me, logout } from '../controllers/auth.controller';
import { authenticate } from '../middleware/auth.middleware';

const router = Router();

// Login
router.post(
    '/login',
    [
        body('email').isEmail().withMessage('Valid email is required'),
        body('password').notEmpty().withMessage('Password is required')
    ],
    login
);

// Register (only for super admin to create users)
router.post(
    '/register',
    authenticate,
    [
        body('email').isEmail().withMessage('Valid email is required'),
        body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
        body('name').notEmpty().withMessage('Name is required'),
        body('role').isIn(['SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN', 'EDITOR']).withMessage('Invalid role')
    ],
    register
);

// Refresh token
router.post('/refresh', refreshToken);

// Get current user
router.get('/me', authenticate, me);

// Logout
router.post('/logout', authenticate, logout);

export default router;
