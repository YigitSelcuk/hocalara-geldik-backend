import { Response, NextFunction } from 'express';
import fs from 'fs/promises';
import path from 'path';
import sharp from 'sharp';
import prisma from '../config/database';
import { AppError } from '../middleware/error.middleware';
import { AuthRequest } from '../middleware/auth.middleware';

export const uploadFile = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        if (!req.file) {
            throw new AppError('No file uploaded', 400);
        }

        const { pageId, alt, caption } = req.body;

        // Determine media type
        let type: 'IMAGE' | 'VIDEO' | 'DOCUMENT' = 'DOCUMENT';
        if (req.file.mimetype.startsWith('image/')) {
            type = 'IMAGE';
        } else if (req.file.mimetype.startsWith('video/')) {
            type = 'VIDEO';
        }

        const url = `/uploads/${req.file.filename}`;
        let thumbnail = null;

        // Generate thumbnail for images
        if (type === 'IMAGE') {
            const thumbnailFilename = `thumb-${req.file.filename}`;
            const thumbnailPath = path.join('uploads', thumbnailFilename);

            await sharp(req.file.path)
                .resize(300, 300, { fit: 'cover' })
                .toFile(thumbnailPath);

            thumbnail = `/uploads/${thumbnailFilename}`;
        }

        const mediaData: any = {
            type,
            filename: req.file.filename,
            originalName: req.file.originalname,
            mimeType: req.file.mimetype,
            size: req.file.size,
            url,
            thumbnail,
            alt,
            caption
        };

        // Only add pageId if it exists
        if (pageId) {
            mediaData.pageId = pageId;
        }

        const media = await prisma.media.create({
            data: mediaData
        });

        // Return with url field for frontend
        res.status(201).json({ 
            success: true,
            url: media.url, // Direct url field for easier access
            data: {
                ...media,
                url: media.url
            }
        });
    } catch (error) {
        console.error('Upload error:', error);
        // Clean up uploaded file if error occurs
        if (req.file) {
            await fs.unlink(req.file.path).catch(() => { });
        }
        next(error);
    }
};

export const getAllMedia = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { type, pageId, page = 1, limit = 20 } = req.query;

        const where: any = {};
        if (type) where.type = type as string;
        if (pageId) where.pageId = pageId as string;

        const skip = (Number(page) - 1) * Number(limit);

        const [media, total] = await Promise.all([
            prisma.media.findMany({
                where,
                skip,
                take: Number(limit),
                orderBy: { createdAt: 'desc' }
            }),
            prisma.media.count({ where })
        ]);

        res.json({
            media,
            pagination: {
                page: Number(page),
                limit: Number(limit),
                total,
                totalPages: Math.ceil(total / Number(limit))
            }
        });
    } catch (error) {
        next(error);
    }
};

export const getMediaById = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const media = await prisma.media.findUnique({
            where: { id: req.params.id },
            include: { page: true }
        });

        if (!media) throw new AppError('Media not found', 404);

        res.json({ media });
    } catch (error) {
        next(error);
    }
};

export const deleteMedia = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const media = await prisma.media.findUnique({
            where: { id: req.params.id }
        });

        if (!media) throw new AppError('Media not found', 404);

        // Delete files from disk
        const filePath = path.join(process.cwd(), media.url);
        await fs.unlink(filePath).catch(() => { });

        if (media.thumbnail) {
            const thumbnailPath = path.join(process.cwd(), media.thumbnail);
            await fs.unlink(thumbnailPath).catch(() => { });
        }

        // Delete from database
        await prisma.media.delete({ where: { id: req.params.id } });

        res.json({ message: 'Media deleted successfully' });
    } catch (error) {
        next(error);
    }
};
