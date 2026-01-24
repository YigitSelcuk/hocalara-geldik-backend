import { Router } from 'express';
import * as homeSectionController from '../controllers/homeSection.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

router.get('/', homeSectionController.getAll);
router.get('/page/:page', homeSectionController.getByPage);
router.get('/page/:page/section/:section', homeSectionController.getByPageAndSection);
router.post('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), homeSectionController.create);
router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), homeSectionController.update);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), homeSectionController.deleteSection);

export default router;
