import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getAll = async (req: Request, res: Response) => {
    try {
        const teachers = await prisma.teacher.findMany({
            include: { branch: true },
            orderBy: { order: 'asc' },
        });
        res.json(teachers);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching teachers', error });
    }
};

export const create = async (req: Request, res: Response) => {
    try {
        const teacher = await prisma.teacher.create({
            data: req.body,
        });
        res.status(201).json(teacher);
    } catch (error) {
        res.status(500).json({ message: 'Error creating teacher', error });
    }
};

export const update = async (req: Request, res: Response) => {
    try {
        const teacher = await prisma.teacher.update({
            where: { id: req.params.id },
            data: req.body,
        });
        res.json(teacher);
    } catch (error) {
        res.status(500).json({ message: 'Error updating teacher', error });
    }
};

export const deleteTeacher = async (req: Request, res: Response) => {
    try {
        await prisma.teacher.delete({
            where: { id: req.params.id },
        });
        res.json({ message: 'Teacher deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting teacher', error });
    }
};
