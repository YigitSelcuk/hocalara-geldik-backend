import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getAll = async (req: Request, res: Response) => {
    try {
        const sections = await prisma.homeSection.findMany({
            orderBy: { order: 'asc' },
        });
        res.json(sections);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching home sections', error });
    }
};

export const getByKey = async (req: Request, res: Response) => {
    try {
        const section = await prisma.homeSection.findUnique({
            where: { key: req.params.key },
        });
        if (!section) return res.status(404).json({ message: 'Section not found' });
        res.json(section);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching home section', error });
    }
};

export const create = async (req: Request, res: Response) => {
    try {
        const section = await prisma.homeSection.create({
            data: req.body,
        });
        res.status(201).json(section);
    } catch (error) {
        res.status(500).json({ message: 'Error creating home section', error });
    }
};

export const update = async (req: Request, res: Response) => {
    try {
        const section = await prisma.homeSection.update({
            where: { id: req.params.id },
            data: req.body,
        });
        res.json(section);
    } catch (error) {
        res.status(500).json({ message: 'Error updating home section', error });
    }
};

export const deleteSection = async (req: Request, res: Response) => {
    try {
        await prisma.homeSection.delete({
            where: { id: req.params.id },
        });
        res.json({ message: 'Home section deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting home section', error });
    }
};
