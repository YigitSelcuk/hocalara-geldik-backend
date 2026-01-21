import { Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import prisma from '../config/database';
import { AppError } from '../middleware/error.middleware';
import { AuthRequest } from '../middleware/auth.middleware';

// Generate JWT tokens
const generateTokens = (userId: string, email: string, role: string, branchId?: string) => {
    const accessToken = jwt.sign(
        { id: userId, email, role, branchId },
        process.env.JWT_SECRET!,
        { expiresIn: (process.env.JWT_EXPIRES_IN || '1h') as any }
    );

    const refreshToken = jwt.sign(
        { id: userId },
        process.env.JWT_REFRESH_SECRET!,
        { expiresIn: (process.env.JWT_REFRESH_EXPIRES_IN || '7d') as any }
    );

    return { accessToken, refreshToken };
};

// Login
export const login = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        console.log('🔐 Login attempt:', req.body);
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            console.log('❌ Validation errors:', errors.array());
            return res.status(400).json({ errors: errors.array() });
        }

        const { email, password } = req.body;
        console.log('✅ Validation passed, looking for user:', email);

        // Find user
        const user = await prisma.user.findUnique({
            where: { email },
            include: { branch: true }
        });

        if (!user || !user.isActive) {
            throw new AppError('Invalid credentials', 401);
        }

        // Verify password
        const isValidPassword = await bcrypt.compare(password, user.password);
        if (!isValidPassword) {
            throw new AppError('Invalid credentials', 401);
        }

        // Generate tokens
        const { accessToken, refreshToken } = generateTokens(
            user.id,
            user.email,
            user.role,
            user.branchId || undefined
        );

        // Update last login
        await prisma.user.update({
            where: { id: user.id },
            data: { lastLoginAt: new Date() }
        });

        res.json({
            user: {
                id: user.id,
                email: user.email,
                name: user.name,
                role: user.role,
                avatar: user.avatar,
                branchId: user.branchId,
                branch: user.branch
            },
            accessToken,
            refreshToken
        });
    } catch (error) {
        next(error);
    }
};

// Register (admin only)
export const register = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        // Only super admin can create users
        if (req.user?.role !== 'SUPER_ADMIN') {
            throw new AppError('Only super admin can create users', 403);
        }

        const { email, password, name, role, branchId } = req.body;

        // Check if user exists
        const existingUser = await prisma.user.findUnique({ where: { email } });
        if (existingUser) {
            throw new AppError('User already exists', 400);
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create user
        const user = await prisma.user.create({
            data: {
                email,
                password: hashedPassword,
                name,
                role,
                branchId: branchId || null
            },
            include: { branch: true }
        });

        res.status(201).json({
            user: {
                id: user.id,
                email: user.email,
                name: user.name,
                role: user.role,
                branchId: user.branchId,
                branch: user.branch
            }
        });
    } catch (error) {
        next(error);
    }
};

// Refresh token
export const refreshToken = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { refreshToken } = req.body;

        if (!refreshToken) {
            throw new AppError('Refresh token required', 400);
        }

        const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET!) as any;

        const user = await prisma.user.findUnique({
            where: { id: decoded.id }
        });

        if (!user || !user.isActive) {
            throw new AppError('Invalid refresh token', 401);
        }

        const { accessToken, refreshToken: newRefreshToken } = generateTokens(
            user.id,
            user.email,
            user.role,
            user.branchId || undefined
        );

        res.json({ accessToken, refreshToken: newRefreshToken });
    } catch (error) {
        next(new AppError('Invalid refresh token', 401));
    }
};

// Get current user
export const me = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const user = await prisma.user.findUnique({
            where: { id: req.user!.id },
            select: {
                id: true,
                email: true,
                name: true,
                role: true,
                avatar: true,
                branchId: true,
                branch: true,
                isActive: true,
                createdAt: true,
                lastLoginAt: true
            }
        });

        if (!user) {
            throw new AppError('User not found', 404);
        }

        res.json({ user });
    } catch (error) {
        next(error);
    }
};

// Logout
export const logout = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        // In a production app, you would invalidate the token here
        // For now, just send success response
        res.json({ message: 'Logged out successfully' });
    } catch (error) {
        next(error);
    }
};
