import { Request, Response, NextFunction } from 'express';
import { MulterError } from 'multer';

export class AppError extends Error {
    statusCode: number;
    isOperational: boolean;

    constructor(message: string, statusCode: number) {
        super(message);
        this.statusCode = statusCode;
        this.isOperational = true;

        Error.captureStackTrace(this, this.constructor);
    }
}

export const errorHandler = (
    err: Error | AppError,
    req: Request,
    res: Response,
    next: NextFunction
) => {
    if (err instanceof AppError) {
        return res.status(err.statusCode).json({
            status: 'error',
            message: err.message
        });
    }

    // Multer errors
    if (err instanceof MulterError || err.name === 'MulterError' || (err as any).code === 'LIMIT_FILE_SIZE') {
        if ((err as any).code === 'LIMIT_FILE_SIZE') {
            return res.status(413).json({
                status: 'error',
                message: 'Dosya boyutu çok büyük (Maksimum 5MB)'
            });
        }
        return res.status(400).json({
            status: 'error',
            message: err.message
        });
    }

    // Prisma errors
    if (err.name === 'PrismaClientKnownRequestError') {
        return res.status(400).json({
            status: 'error',
            message: 'Database operation failed'
        });
    }

    // Default error
    console.error('ERROR:', err);
    res.status(500).json({
        status: 'error',
        message: process.env.NODE_ENV === 'development' ? err.message : 'Internal server error'
    });
};
