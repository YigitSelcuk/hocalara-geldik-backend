import { Router } from 'express';
import * as teacherController from '../controllers/teacher.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

router.get('/', teacherController.getAll);
router.post('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), teacherController.create);
router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), teacherController.update);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), teacherController.deleteTeacher);

export default router;
