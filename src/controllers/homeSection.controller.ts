import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getAll = async (req: Request, res: Response) => {
    try {
        const sections = await prisma.homeSection.findMany({
            orderBy: [
                { page: 'asc' },
                { order: 'asc' }
            ],
        });
        res.json({ data: sections });
    } catch (error) {
        res.status(500).json({ message: 'Error fetching home sections', error });
    }
};

export const getByPage = async (req: Request, res: Response) => {
    try {
        const sections = await prisma.homeSection.findMany({
            where: { page: req.params.page },
            orderBy: { order: 'asc' },
        });
        res.json({ data: sections });
    } catch (error) {
        res.status(500).json({ message: 'Error fetching page sections', error });
    }
};

export const getByPageAndSection = async (req: Request, res: Response) => {
    try {
        const section = await prisma.homeSection.findUnique({
            where: {
                page_section: {
                    page: req.params.page,
                    section: req.params.section,
                },
            },
        });
        if (!section) return res.status(404).json({ message: 'Section not found' });
        res.json(section);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching section', error });
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

