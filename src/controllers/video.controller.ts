import { Request, Response } from 'express';
import prisma from '../config/database';
import { AppError } from '../middleware/error.middleware';

export const getAllVideos = async (req: Request, res: Response) => {
    try {
        const videos = await prisma.videoLesson.findMany({
            orderBy: { order: 'asc' }
        });
        res.json({ success: true, data: videos });
    } catch (error: any) {
        console.error('Get videos error:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Videolar yüklenirken hata oluştu.',
            error: error.message 
        });
    }
};

export const createVideo = async (req: Request, res: Response) => {
    try {
        const { title, description, thumbnail, videoUrl, category, subject, duration, teacher, difficulty, order } = req.body;
        
        console.log('📹 Creating video with data:', req.body);
        
        // Required fields validation
        if (!title) {
            return res.status(400).json({ 
                success: false, 
                message: 'Başlık alanı zorunludur.' 
            });
        }
        
        if (!videoUrl) {
            return res.status(400).json({ 
                success: false, 
                message: 'Video URL alanı zorunludur.' 
            });
        }
        
        if (!category) {
            return res.status(400).json({ 
                success: false, 
                message: 'Kategori alanı zorunludur.' 
            });
        }
        
        if (!subject) {
            return res.status(400).json({ 
                success: false, 
                message: 'Ders alanı zorunludur.' 
            });
        }

        const video = await prisma.videoLesson.create({
            data: {
                title,
                description: description || '',
                thumbnail,
                videoUrl,
                category,
                subject,
                duration,
                teacher,
                difficulty,
                order: order || 0
            }
        });
        
        console.log('✅ Video created:', video.id);
        res.status(201).json({ success: true, data: video });
    } catch (error: any) {
        console.error('❌ Video creation error:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Video oluşturulurken hata oluştu.',
            error: error.message 
        });
    }
};

export const updateVideo = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const { title, description, thumbnail, videoUrl, category, subject, duration, teacher, difficulty, order, isActive } = req.body;
        
        const video = await prisma.videoLesson.update({
            where: { id },
            data: {
                ...(title && { title }),
                ...(description !== undefined && { description }),
                ...(thumbnail !== undefined && { thumbnail }),
                ...(videoUrl && { videoUrl }),
                ...(category && { category }),
                ...(subject && { subject }),
                ...(duration !== undefined && { duration }),
                ...(teacher !== undefined && { teacher }),
                ...(difficulty !== undefined && { difficulty }),
                ...(order !== undefined && { order }),
                ...(isActive !== undefined && { isActive })
            }
        });
        
        res.json({ success: true, data: video });
    } catch (error: any) {
        console.error('Video update error:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Video güncellenirken hata oluştu.',
            error: error.message 
        });
    }
};

export const deleteVideo = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        await prisma.videoLesson.delete({ where: { id } });
        res.json({ success: true, message: 'Video deleted' });
    } catch (error: any) {
        console.error('Video delete error:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Video silinirken hata oluştu.',
            error: error.message 
        });
    }
};
