import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getAllChannels = async (req: Request, res: Response) => {
    try {
        const channels = await prisma.youTubeChannel.findMany({
            orderBy: { order: 'asc' }
        });
        res.json({ success: true, data: channels });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Kanallar getirilemedi' });
    }
};

export const getChannelById = async (req: Request, res: Response) => {
    try {
        const channel = await prisma.youTubeChannel.findUnique({
            where: { id: req.params.id }
        });
        if (!channel) return res.status(404).json({ success: false, error: 'Kanal bulunamadı' });
        res.json({ success: true, data: channel });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Kanal getirilemedi' });
    }
};

export const createChannel = async (req: Request, res: Response) => {
    try {
        const channel = await prisma.youTubeChannel.create({
            data: req.body
        });
        res.status(201).json({ success: true, data: channel });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Kanal oluşturulamadı' });
    }
};

export const updateChannel = async (req: Request, res: Response) => {
    try {
        const channel = await prisma.youTubeChannel.update({
            where: { id: req.params.id },
            data: req.body
        });
        res.json({ success: true, data: channel });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Kanal güncellenemedi' });
    }
};

export const deleteChannel = async (req: Request, res: Response) => {
    try {
        await prisma.youTubeChannel.delete({
            where: { id: req.params.id }
        });
        res.json({ success: true, message: 'Kanal silindi' });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Kanal silinemedi' });
    }
};
