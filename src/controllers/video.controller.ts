import { Request, Response } from 'express';
import prisma from '../config/database';
import { AppError } from '../middleware/error.middleware';

export const getAllVideos = async (req: Request, res: Response) => {
    const videos = await prisma.videoLesson.findMany({
        orderBy: { order: 'asc' }
    });
    res.json({ success: true, data: videos });
};

export const createVideo = async (req: Request, res: Response) => {
    const video = await prisma.videoLesson.create({
        data: req.body
    });
    res.status(201).json({ success: true, data: video });
};

export const updateVideo = async (req: Request, res: Response) => {
    const { id } = req.params;
    const video = await prisma.videoLesson.update({
        where: { id },
        data: req.body
    });
    res.json({ success: true, data: video });
};

export const deleteVideo = async (req: Request, res: Response) => {
    const { id } = req.params;
    await prisma.videoLesson.delete({ where: { id } });
    res.json({ success: true, message: 'Video deleted' });
};
