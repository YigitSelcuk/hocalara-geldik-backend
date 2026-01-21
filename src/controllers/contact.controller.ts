import { Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import prisma from '../config/database';
import { AppError } from '../middleware/error.middleware';
import { AuthRequest } from '../middleware/auth.middleware';

export const submitContactForm = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { name, email, phone, subject, message, branchId } = req.body;

        const submission = await prisma.contactSubmission.create({
            data: {
                name,
                email,
                phone,
                subject,
                message,
                branchId
            }
        });

        res.status(201).json({
            message: 'Form submitted successfully',
            submission: {
                id: submission.id,
                createdAt: submission.createdAt
            }
        });
    } catch (error) {
        next(error);
    }
};

export const getAllSubmissions = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { branchId, isRead, page = 1, limit = 20 } = req.query;

        const where: any = {};

        // Branch admins can only see their branch submissions
        if (req.user!.role === 'BRANCH_ADMIN') {
            where.branchId = req.user!.branchId;
        } else if (branchId) {
            where.branchId = branchId as string;
        }

        if (isRead !== undefined) where.isRead = isRead === 'true';

        const skip = (Number(page) - 1) * Number(limit);

        const [submissions, total] = await Promise.all([
            prisma.contactSubmission.findMany({
                where,
                skip,
                take: Number(limit),
                orderBy: { createdAt: 'desc' }
            }),
            prisma.contactSubmission.count({ where })
        ]);

        res.json({
            submissions,
            pagination: {
                page: Number(page),
                limit: Number(limit),
                total,
                totalPages: Math.ceil(total / Number(limit))
            }
        });
    } catch (error) {
        next(error);
    }
};

export const getSubmissionById = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const submission = await prisma.contactSubmission.findUnique({
            where: { id: req.params.id }
        });

        if (!submission) throw new AppError('Submission not found', 404);

        // Check permissions
        if (req.user!.role === 'BRANCH_ADMIN' && submission.branchId !== req.user!.branchId) {
            throw new AppError('Insufficient permissions', 403);
        }

        res.json({ submission });
    } catch (error) {
        next(error);
    }
};

export const markAsRead = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { isReplied } = req.body;

        const submission = await prisma.contactSubmission.update({
            where: { id: req.params.id },
            data: {
                isRead: true,
                ...(isReplied !== undefined && { isReplied })
            }
        });

        res.json({ submission });
    } catch (error) {
        next(error);
    }
};

export const deleteSubmission = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        await prisma.contactSubmission.delete({
            where: { id: req.params.id }
        });

        res.json({ message: 'Submission deleted successfully' });
    } catch (error) {
        next(error);
    }
};
