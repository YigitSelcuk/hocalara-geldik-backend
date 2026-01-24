import { Response, NextFunction } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/auth.middleware';
import { AppError } from '../middleware/error.middleware';

const prisma = new PrismaClient();

// Get user's notifications
export const getMyNotifications = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        if (!req.user) throw new AppError('Authentication required', 401);
        
        const { isRead } = req.query;
        const where: any = { userId: req.user.id };
        
        if (isRead !== undefined) {
            where.isRead = isRead === 'true';
        }
        
        const notifications = await prisma.notification.findMany({
            where,
            include: {
                changeRequest: {
                    select: {
                        id: true,
                        changeType: true,
                        status: true
                    }
                }
            },
            orderBy: { createdAt: 'desc' },
            take: 50
        });
        
        res.json({ data: notifications });
    } catch (error) {
        next(error);
    }
};

// Mark notification as read
export const markAsRead = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        if (!req.user) throw new AppError('Authentication required', 401);
        
        const { id } = req.params;
        
        // Verify notification belongs to user
        const notification = await prisma.notification.findUnique({
            where: { id }
        });
        
        if (!notification) throw new AppError('Notification not found', 404);
        if (notification.userId !== req.user.id) throw new AppError('Access denied', 403);
        
        const updated = await prisma.notification.update({
            where: { id },
            data: { isRead: true }
        });
        
        res.json({ data: updated });
    } catch (error) {
        next(error);
    }
};

// Mark all notifications as read
export const markAllAsRead = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        if (!req.user) throw new AppError('Authentication required', 401);
        
        await prisma.notification.updateMany({
            where: {
                userId: req.user.id,
                isRead: false
            },
            data: { isRead: true }
        });
        
        res.json({ message: 'All notifications marked as read' });
    } catch (error) {
        next(error);
    }
};

// Delete notification
export const deleteNotification = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        if (!req.user) throw new AppError('Authentication required', 401);
        
        const { id } = req.params;
        
        // Verify notification belongs to user
        const notification = await prisma.notification.findUnique({
            where: { id }
        });
        
        if (!notification) throw new AppError('Notification not found', 404);
        if (notification.userId !== req.user.id) throw new AppError('Access denied', 403);
        
        await prisma.notification.delete({
            where: { id }
        });
        
        res.json({ message: 'Notification deleted' });
    } catch (error) {
        next(error);
    }
};

// Get unread count
export const getUnreadCount = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        if (!req.user) throw new AppError('Authentication required', 401);
        
        const count = await prisma.notification.count({
            where: {
                userId: req.user.id,
                isRead: false
            }
        });
        
        res.json({ count });
    } catch (error) {
        next(error);
    }
};
