import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { AppError } from './error.middleware';

export interface AuthRequest extends Request {
    user?: {
        id: string;
        email: string;
        name: string;
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

        console.log('🔑 Authentication attempt:', {
            hasToken: !!token,
            path: req.path,
            method: req.method
        });

        if (!token) {
            throw new AppError('Authentication required', 401);
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET!) as any;
        req.user = decoded;

        console.log('✅ User authenticated:', {
            email: decoded.email,
            role: decoded.role,
            branchId: decoded.branchId
        });

        next();
    } catch (error) {
        console.log('❌ Authentication failed:', error);
        next(new AppError('Invalid or expired token', 401));
    }
};

// Optional authentication middleware - doesn't fail if no token
export const optionalAuthenticate = async (
    req: AuthRequest,
    res: Response,
    next: NextFunction
) => {
    try {
        const token = req.headers.authorization?.replace('Bearer ', '');

        if (token) {
            try {
                const decoded = jwt.verify(token, process.env.JWT_SECRET!) as any;
                req.user = decoded;
                console.log('✅ User authenticated (optional):', {
                    email: decoded.email,
                    role: decoded.role,
                    branchId: decoded.branchId
                });
            } catch (error) {
                // Token invalid but continue anyway
                console.log('⚠️ Invalid token in optional auth, continuing as public');
            }
        }

        next();
    } catch (error) {
        next(error);
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

    const branchId = req.params.id || req.params.branchId || req.body.branchId;

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
