import { Response, NextFunction } from 'express';
import prisma from '../config/database';
import { AppError } from '../middleware/error.middleware';
import { AuthRequest } from '../middleware/auth.middleware';

export const getAllSettings = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const settings = await prisma.setting.findMany();

        // Convert to key-value object
        const settingsObject = settings.reduce((acc: any, setting) => {
            acc[setting.key] = setting.value;
            return acc;
        }, {});

        res.json({ settings: settingsObject });
    } catch (error) {
        next(error);
    }
};

export const getSettingByKey = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { key } = req.params;

        const setting = await prisma.setting.findUnique({
            where: { key }
        });

        if (!setting) throw new AppError('Setting not found', 404);

        res.json({ setting: { key: setting.key, value: setting.value } });
    } catch (error) {
        next(error);
    }
};

export const getSettingsByGroup = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { group } = req.params;

        const settings = await prisma.setting.findMany({
            where: { group }
        });

        const settingsObject = settings.reduce((acc: any, setting) => {
            acc[setting.key] = setting.value;
            return acc;
        }, {});

        res.json({ settings: settingsObject });
    } catch (error) {
        next(error);
    }
};

export const updateSetting = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { key } = req.params;
        const { value } = req.body;

        const setting = await prisma.setting.upsert({
            where: { key },
            update: { value },
            create: {
                key,
                value,
                type: 'string',
                group: 'general'
            }
        });

        res.json({ setting });
    } catch (error) {
        next(error);
    }
};

export const updateMultipleSettings = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { settings } = req.body; // Object with key-value pairs

        if (!settings || typeof settings !== 'object') {
            throw new AppError('Invalid settings object', 400);
        }

        const updates = Object.entries(settings).map(([key, value]) =>
            prisma.setting.upsert({
                where: { key },
                update: { value: value as string },
                create: {
                    key,
                    value: value as string,
                    type: 'string',
                    group: 'general'
                }
            })
        );

        await prisma.$transaction(updates);

        res.json({ message: 'Settings updated successfully' });
    } catch (error) {
        next(error);
    }
};
