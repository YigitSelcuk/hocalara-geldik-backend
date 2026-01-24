import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const createLead = async (req: Request, res: Response) => {
    try {
        const { name, surname, phone, email, branchId } = req.body;
        
        if (!name || !surname || !phone) {
            return res.status(400).json({ 
                success: false, 
                error: 'Ad, soyad ve telefon zorunludur' 
            });
        }
        
        const lead = await prisma.lead.create({
            data: {
                name,
                surname,
                phone,
                email: email || null,
                branchId: branchId || null,
                status: 'NEW'
            }
        });
        
        res.status(201).json({ 
            success: true, 
            data: lead,
            message: 'Ön kaydınız başarıyla alındı. En kısa sürede sizinle iletişime geçeceğiz.' 
        });
    } catch (error: any) {
        console.error('Create lead error:', error);
        res.status(500).json({ 
            success: false, 
            error: 'Kayıt oluşturulamadı' 
        });
    }
};

export const getAllLeads = async (req: Request, res: Response) => {
    try {
        const { branchId, status } = req.query;
        const where: any = {};
        
        if (branchId) where.branchId = branchId as string;
        if (status) where.status = status as string;
        
        const leads = await prisma.lead.findMany({
            where,
            include: {
                branch: {
                    select: { id: true, name: true }
                }
            },
            orderBy: { createdAt: 'desc' }
        });
        
        res.json({ success: true, data: leads });
    } catch (error) {
        console.error('Get leads error:', error);
        res.status(500).json({ success: false, error: 'Kayıtlar getirilemedi' });
    }
};

export const updateLeadStatus = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const { status, notes } = req.body;
        
        const lead = await prisma.lead.update({
            where: { id },
            data: {
                status: status || undefined,
                notes: notes !== undefined ? notes : undefined
            }
        });
        
        res.json({ success: true, data: lead });
    } catch (error) {
        console.error('Update lead error:', error);
        res.status(500).json({ success: false, error: 'Kayıt güncellenemedi' });
    }
};
