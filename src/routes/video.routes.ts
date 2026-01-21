import { Router } from 'express';
import { getAllVideos, createVideo, updateVideo, deleteVideo } from '../controllers/video.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

router.get('/', getAllVideos);
router.post('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), createVideo);
router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), updateVideo);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), deleteVideo);

export default router;
