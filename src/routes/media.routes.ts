import { Router } from 'express';
import multer from 'multer';
import path from 'path';
import {
    uploadFile,
    getAllMedia,
    getMediaById,
    deleteMedia
} from '../controllers/media.controller';
import { authenticate } from '../middleware/auth.middleware';

const router = Router();

// Configure multer for file uploads
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, uniqueSuffix + path.extname(file.originalname));
    }
});

const upload = multer({
    storage,
    limits: {
        fileSize: parseInt(process.env.MAX_FILE_SIZE || '5242880') // 5MB default
    },
    fileFilter: (req, file, cb) => {
        const allowedTypes = /jpeg|jpg|png|gif|webp|mp4|mov|avi|pdf|doc|docx/;
        const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
        const mimetype = allowedTypes.test(file.mimetype);

        if (mimetype && extname) {
            return cb(null, true);
        } else {
            cb(new Error('Invalid file type'));
        }
    }
});

// Routes
router.post('/upload', authenticate, upload.single('file'), uploadFile);
router.get('/', authenticate, getAllMedia);
router.get('/:id', authenticate, getMediaById);
router.delete('/:id', authenticate, deleteMedia);

export default router;
