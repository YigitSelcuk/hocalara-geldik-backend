import { Router } from 'express';
import { body } from 'express-validator';
import {
    getAllUsers,
    getUserById,
    createUser,
    updateUser,
    deleteUser,
    updateUserRole,
    assignBranch
} from '../controllers/user.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

router.get('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), getAllUsers);
router.get('/:id', authenticate, getUserById);

router.post(
    '/',
    authenticate,
    authorize('SUPER_ADMIN'),
    [
        body('email').isEmail(),
        body('password').isLength({ min: 6 }),
        body('name').notEmpty(),
        body('role').isIn(['SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN', 'EDITOR'])
    ],
    createUser
);

router.put('/:id', authenticate, authorize('SUPER_ADMIN'), updateUser);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN'), deleteUser);
router.post('/:id/role', authenticate, authorize('SUPER_ADMIN'), updateUserRole);
router.post('/:id/branch', authenticate, authorize('SUPER_ADMIN'), assignBranch);

export default router;
