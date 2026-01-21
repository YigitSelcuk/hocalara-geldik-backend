import { Router } from 'express';
import {
    getAllSettings,
    getSettingByKey,
    getSettingsByGroup,
    updateSetting,
    updateMultipleSettings
} from '../controllers/settings.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';

const router = Router();

// Public routes (for frontend to get settings)
router.get('/', getAllSettings);
router.get('/key/:key', getSettingByKey);
router.get('/group/:group', getSettingsByGroup);

// Protected routes
router.put(
    '/:key',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    updateSetting
);

router.post(
    '/bulk',
    authenticate,
    authorize('SUPER_ADMIN', 'CENTER_ADMIN'),
    updateMultipleSettings
);

export default router;
