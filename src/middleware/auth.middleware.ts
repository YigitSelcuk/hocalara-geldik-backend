import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { AppError } from './error.middleware';

export interface AuthRequest extends Request {
    user?: {
        id: string;
        email: string;
        role: string;
        branchId?: string;
    };
}

export const authenticate = async (
    req: AuthRequest,
    res: Response,
    next: NextFunction
) => {
    try {
        const token = req.headers.authorization?.replace('Bearer ', '');

        if (!token) {
            throw new AppError('Authentication required', 401);
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET!) as any;
        req.user = decoded;

        next();
    } catch (error) {
        next(new AppError('Invalid or expired token', 401));
    }
};

export const authorize = (...roles: string[]) => {
    return (req: AuthRequest, res: Response, next: NextFunction) => {
        if (!req.user) {
            return next(new AppError('Authentication required', 401));
        }

        if (!roles.includes(req.user.role)) {
            return next(new AppError('Insufficient permissions', 403));
        }

        next();
    };
};

export const authorizeBranch = (
    req: AuthRequest,
    res: Response,
    next: NextFunction
) => {
    if (!req.user) {
        return next(new AppError('Authentication required', 401));
    }

    const branchId = req.params.branchId || req.body.branchId;

    // Super admin and center admin can access all branches
    if (['SUPER_ADMIN', 'CENTER_ADMIN'].includes(req.user.role)) {
        return next();
    }

    // Branch admin can only access their own branch
    if (req.user.role === 'BRANCH_ADMIN' && req.user.branchId === branchId) {
        return next();
    }

    next(new AppError('Access denied to this branch', 403));
};
