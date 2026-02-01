import { Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import bcrypt from 'bcryptjs';
import prisma from '../config/database';
import { AppError } from '../middleware/error.middleware';
import { AuthRequest } from '../middleware/auth.middleware';

export const getAllUsers = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { role, branchId, isActive } = req.query;
        const where: any = {};
        if (role) where.role = role as string;
        if (branchId) where.branchId = branchId as string;
        if (isActive !== undefined) where.isActive = isActive === 'true';

        const users = await prisma.user.findMany({
            where,
            select: {
                id: true, email: true, name: true, role: true, avatar: true,
                branchId: true, branch: true, isActive: true,
                createdAt: true, lastLoginAt: true
            }
        });

        res.json({ users });
    } catch (error) {
        next(error);
    }
};

export const getUserById = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const user = await prisma.user.findUnique({
            where: { id: req.params.id },
            select: {
                id: true, email: true, name: true, role: true, avatar: true,
                branchId: true, branch: true, isActive: true,
                createdAt: true, lastLoginAt: true
            }
        });

        if (!user) throw new AppError('User not found', 404);
        res.json({ user });
    } catch (error) {
        next(error);
    }
};

export const createUser = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

        const { email, password, name, role, branchId, avatar } = req.body;

        const existingUser = await prisma.user.findUnique({ where: { email } });
        if (existingUser) throw new AppError('User already exists', 400);

        const hashedPassword = await bcrypt.hash(password, 10);

        const user = await prisma.user.create({
            data: { email, password: hashedPassword, name, role, branchId, avatar },
            select: {
                id: true, email: true, name: true, role: true, avatar: true,
                branchId: true, branch: true, isActive: true
            }
        });

        res.status(201).json({ user });
    } catch (error) {
        next(error);
    }
};

export const updateUser = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { name, avatar, isActive, password, role, branchId, email } = req.body;
        const data: any = {};
        
        if (name !== undefined) data.name = name;
        if (avatar !== undefined) data.avatar = avatar;
        if (isActive !== undefined) data.isActive = isActive;
        if (role !== undefined) data.role = role;
        if (email !== undefined) data.email = email;
        if (password) data.password = await bcrypt.hash(password, 10);
        
        // Handle branchId explicitly - allow null to clear the branch assignment
        if (branchId !== undefined) {
            data.branchId = branchId === null || branchId === '' ? null : branchId;
        }

        console.log('👤 Updating user:', req.params.id);
        console.log('👤 Update data:', data);

        const user = await prisma.user.update({
            where: { id: req.params.id },
            data,
            select: {
                id: true, email: true, name: true, role: true, avatar: true,
                branchId: true, branch: true, isActive: true
            }
        });

        console.log('✅ User updated:', user);

        res.json({ user });
    } catch (error) {
        console.error('❌ User update error:', error);
        next(error);
    }
};

export const deleteUser = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        await prisma.user.delete({ where: { id: req.params.id } });
        res.json({ message: 'User deleted successfully' });
    } catch (error) {
        next(error);
    }
};

export const updateUserRole = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { role } = req.body;
        const user = await prisma.user.update({
            where: { id: req.params.id },
            data: { role }
        });
        res.json({ user });
    } catch (error) {
        next(error);
    }
};

export const assignBranch = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { branchId } = req.body;
        const user = await prisma.user.update({
            where: { id: req.params.id },
            data: { branchId },
            include: { branch: true }
        });
        res.json({ user });
    } catch (error) {
        next(error);
    }
};
