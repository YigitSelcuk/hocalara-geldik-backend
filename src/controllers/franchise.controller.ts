import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/auth.middleware';

const prisma = new PrismaClient();

export const createFranchiseApplication = async (req: Request, res: Response) => {
    try {
        const { name, surname, phone, email, city, message } = req.body;
        
        if (!name || !surname || !phone || !email) {
            return res.status(400).json({ 
                success: false, 
                error: 'Ad, soyad, telefon ve e-posta zorunludur' 
            });
        }
        
        const application = await prisma.franchiseApplication.create({
            data: {
                name,
                surname,
                phone,
                email,
                city: city || null,
                message: message || null,
                status: 'NEW'
            }
        });
        
        res.status(201).json({ 
            success: true, 
            data: application,
            message: 'Franchise başvurunuz başarıyla alındı. En kısa sürede sizinle iletişime geçeceğiz.' 
        });
    } catch (error: any) {
        console.error('Create franchise application error:', error);
        res.status(500).json({ 
            success: false, 
            error: 'Başvuru oluşturulamadı' 
        });
    }
};

export const getAllFranchiseApplications = async (req: AuthRequest, res: Response) => {
    try {
        const { status } = req.query;
        const where: any = {};
        
        if (status) where.status = status as string;
        
        const applications = await prisma.franchiseApplication.findMany({
            where,
            orderBy: { createdAt: 'desc' }
        });
        
        res.json({ success: true, data: applications });
    } catch (error) {
        console.error('Get franchise applications error:', error);
        res.status(500).json({ success: false, error: 'Başvurular getirilemedi' });
    }
};

export const updateFranchiseApplicationStatus = async (req: AuthRequest, res: Response) => {
    try {
        const { id } = req.params;
        const { status, notes } = req.body;
        
        const application = await prisma.franchiseApplication.update({
            where: { id },
            data: {
                status: status || undefined,
                notes: notes !== undefined ? notes : undefined
            }
        });
        
        res.json({ success: true, data: application });
    } catch (error) {
        console.error('Update franchise application error:', error);
        res.status(500).json({ success: false, error: 'Başvuru güncellenemedi' });
    }
};

export const deleteFranchiseApplication = async (req: AuthRequest, res: Response) => {
    try {
        const { id } = req.params;
        
        await prisma.franchiseApplication.delete({
            where: { id }
        });
        
        res.json({ success: true, message: 'Başvuru silindi' });
    } catch (error) {
        console.error('Delete franchise application error:', error);
        res.status(500).json({ success: false, error: 'Başvuru silinemedi' });
    }
};
