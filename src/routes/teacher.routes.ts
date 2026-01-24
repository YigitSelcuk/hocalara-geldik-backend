import { Router } from 'express';
import * as teacherController from '../controllers/teacher.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

// Public route - anyone can view teachers
router.get('/', teacherController.getAll);

// Protected routes - BRANCH_ADMIN can manage their own branch's teachers
router.post('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), teacherController.create);
router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), teacherController.update);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN', 'BRANCH_ADMIN'), teacherController.deleteTeacher);

export default router;
