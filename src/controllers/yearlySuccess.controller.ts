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
    try {
        const { year, banner, totalDegrees, placementCount, successRate, cityCount, top100Count, top1000Count, yksAverage, lgsAverage } = req.body;
        
        const success = await prisma.yearlySuccess.create({
            data: {
                year,
                totalDegrees: totalDegrees || 0,
                placementCount: placementCount || 0,
                successRate: successRate || 0,
                cityCount: cityCount || 0,
                top100Count: top100Count || 0,
                top1000Count: top1000Count || 0,
                yksAverage: yksAverage || 0,
                lgsAverage: lgsAverage || 0,
                banner: banner ? {
                    create: {
                        title: banner.title,
                        subtitle: banner.subtitle,
                        description: banner.description,
                        image: banner.image,
                        highlightText: banner.highlightText || null,
                        gradientFrom: banner.gradientFrom || '#2563eb',
                        gradientTo: banner.gradientTo || '#1e40af'
                    }
                } : undefined
            },
            include: { 
                banner: true,
                students: {
                    orderBy: { order: 'asc' }
                }
            }
        });
        res.status(201).json({ success: true, data: success });
    } catch (error: any) {
        console.error('Create yearly success error:', error);
        res.status(500).json({ success: false, error: error.message || 'Oluşturulamadı' });
    }
};

export const updateYearlySuccess = async (req: Request, res: Response) => {
    try {
        const { banner, totalDegrees, placementCount, successRate, cityCount, top100Count, top1000Count, yksAverage, lgsAverage } = req.body;
        
        const success = await prisma.yearlySuccess.update({
            where: { id: req.params.id },
            data: {
                totalDegrees: totalDegrees !== undefined ? totalDegrees : undefined,
                placementCount: placementCount !== undefined ? placementCount : undefined,
                successRate: successRate !== undefined ? successRate : undefined,
                cityCount: cityCount !== undefined ? cityCount : undefined,
                top100Count: top100Count !== undefined ? top100Count : undefined,
                top1000Count: top1000Count !== undefined ? top1000Count : undefined,
                yksAverage: yksAverage !== undefined ? yksAverage : undefined,
                lgsAverage: lgsAverage !== undefined ? lgsAverage : undefined,
                banner: banner ? {
                    upsert: {
                        create: {
                            title: banner.title,
                            subtitle: banner.subtitle,
                            description: banner.description,
                            image: banner.image,
                            highlightText: banner.highlightText || null,
                            gradientFrom: banner.gradientFrom || '#2563eb',
                            gradientTo: banner.gradientTo || '#1e40af'
                        },
                        update: {
                            title: banner.title,
                            subtitle: banner.subtitle,
                            description: banner.description,
                            image: banner.image,
                            highlightText: banner.highlightText || null,
                            gradientFrom: banner.gradientFrom || '#2563eb',
                            gradientTo: banner.gradientTo || '#1e40af'
                        }
                    }
                } : undefined
            },
            include: { 
                banner: true,
                students: {
                    orderBy: { order: 'asc' }
                }
            }
        });
        res.json({ success: true, data: success });
    } catch (error: any) {
        console.error('Update yearly success error:', error);
        res.status(500).json({ success: false, error: error.message || 'Güncellenemedi' });
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
        const { name, exam, rank, image, branch, university, score, order } = req.body;
        
        const student = await prisma.topStudent.create({
            data: {
                yearlySuccessId: req.params.id,
                name,
                exam,
                rank,
                image: image || null,
                branch: branch || null,
                university: university || null,
                score: score ? parseFloat(score) : null,
                order: order || 0
            }
        });
        res.status(201).json({ success: true, data: student });
    } catch (error: any) {
        console.error('Add student error:', error);
        res.status(500).json({ success: false, error: error.message || 'Öğrenci eklenemedi' });
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
