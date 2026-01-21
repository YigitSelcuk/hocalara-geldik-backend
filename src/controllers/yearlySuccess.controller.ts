import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getAllYearlySuccesses = async (req: Request, res: Response) => {
    try {
        const successes = await prisma.yearlySuccess.findMany({
            include: {
                banner: true,
                students: {
                    orderBy: { order: 'asc' }
                }
            },
            orderBy: { year: 'desc' }
        });
        res.json({ success: true, data: successes });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Başarılar getirilemedi' });
    }
};

export const getByYear = async (req: Request, res: Response) => {
    try {
        const success = await prisma.yearlySuccess.findUnique({
            where: { year: req.params.year },
            include: {
                banner: true,
                students: {
                    orderBy: { order: 'asc' }
                }
            }
        });
        if (!success) return res.status(404).json({ success: false, error: 'Yıl bulunamadı' });
        res.json({ success: true, data: success });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Veri getirilemedi' });
    }
};

export const createYearlySuccess = async (req: Request, res: Response) => {
    const { year, banner, stats } = req.body;
    try {
        const success = await prisma.yearlySuccess.create({
            data: {
                year,
                ...stats,
                banner: banner ? {
                    create: banner
                } : undefined
            },
            include: { banner: true }
        });
        res.status(201).json({ success: true, data: success });
    } catch (error: any) {
        res.status(500).json({ success: false, error: error.message || 'Oluşturulamadı' });
    }
};

export const updateYearlySuccess = async (req: Request, res: Response) => {
    const { stats, banner } = req.body;
    try {
        const success = await prisma.yearlySuccess.update({
            where: { id: req.params.id },
            data: {
                ...stats,
                banner: banner ? {
                    upsert: {
                        create: banner,
                        update: banner
                    }
                } : undefined
            },
            include: { banner: true }
        });
        res.json({ success: true, data: success });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Güncellenemedi' });
    }
};

export const deleteYearlySuccess = async (req: Request, res: Response) => {
    try {
        await prisma.yearlySuccess.delete({
            where: { id: req.params.id }
        });
        res.json({ success: true, message: 'Silindi' });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Silinemedi' });
    }
};

// Top Student Handlers
export const addStudent = async (req: Request, res: Response) => {
    try {
        const student = await prisma.topStudent.create({
            data: {
                ...req.body,
                yearlySuccessId: req.params.id
            }
        });
        res.status(201).json({ success: true, data: student });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Öğrenci eklenemedi' });
    }
};

export const deleteStudent = async (req: Request, res: Response) => {
    try {
        await prisma.topStudent.delete({
            where: { id: req.params.studentId }
        });
        res.json({ success: true, message: 'Öğrenci silindi' });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Öğrenci silinemedi' });
    }
};
