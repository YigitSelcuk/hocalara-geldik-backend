
import { Router } from 'express';
import * as youtubeChannelController from '../controllers/youtubeChannel.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';
import { UserRole } from '@prisma/client';

const router = Router();

router.get('/', youtubeChannelController.getAllChannels);
router.get('/:id', youtubeChannelController.getChannelById);

// Admin only routes
router.post('/', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), youtubeChannelController.createChannel);
router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), youtubeChannelController.updateChannel);
router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'CENTER_ADMIN'), youtubeChannelController.deleteChannel);

export default router;
