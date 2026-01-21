import { Request, Response } from 'express';
import prisma from '../config/database';

export const getAllPackages = async (req: Request, res: Response) => {
    const packages = await prisma.educationPackage.findMany({
        orderBy: { order: 'asc' }
    });
    res.json({ success: true, data: packages });
};

export const createPackage = async (req: Request, res: Response) => {
    const pkg = await prisma.educationPackage.create({
        data: req.body
    });
    res.status(201).json({ success: true, data: pkg });
};

export const updatePackage = async (req: Request, res: Response) => {
    const { id } = req.params;
    const pkg = await prisma.educationPackage.update({
        where: { id },
        data: req.body
    });
    res.json({ success: true, data: pkg });
};

export const deletePackage = async (req: Request, res: Response) => {
    const { id } = req.params;
    await prisma.educationPackage.delete({ where: { id } });
    res.json({ success: true, message: 'Package deleted' });
};
