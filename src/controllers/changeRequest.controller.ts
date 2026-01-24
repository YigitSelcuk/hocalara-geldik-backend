import { Response, NextFunction } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/auth.middleware';
import { AppError } from '../middleware/error.middleware';

const prisma = new PrismaClient();

// Get all change requests (admin can see all, branch admin sees only theirs)
export const getAll = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { status, branchId } = req.query;
        const where: any = {};
        
        if (status) where.status = status;
        if (branchId) where.branchId = branchId;
        
        // Branch admin can only see their own requests
        if (req.user?.role === 'BRANCH_ADMIN' && req.user.branchId) {
            where.branchId = req.user.branchId;
        }
        
        const requests = await prisma.changeRequest.findMany({
            where,
            include: {
                requester: { select: { id: true, name: true, email: true } },
                reviewer: { select: { id: true, name: true, email: true } },
                branch: { select: { id: true, name: true } }
            },
            orderBy: { createdAt: 'desc' }
        });
        
        res.json({ data: requests });
    } catch (error) {
        next(error);
    }
};

// Create a change request
export const create = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        if (!req.user) throw new AppError('Authentication required', 401);
        
        const { changeType, branchId, entityId, entityType, oldData, newData } = req.body;
        
        // Verify branch admin can only create requests for their branch
        if (req.user.role === 'BRANCH_ADMIN' && req.user.branchId !== branchId) {
            throw new AppError('You can only create requests for your branch', 403);
        }
        
        const request = await prisma.changeRequest.create({
            data: {
                changeType,
                branchId,
                entityId,
                entityType,
                oldData,
                newData,
                requestedBy: req.user.id,
                status: 'PENDING'
            },
            include: {
                requester: { select: { id: true, name: true, email: true } },
                branch: { select: { id: true, name: true } }
            }
        });
        
        res.status(201).json({ data: request });
    } catch (error) {
        next(error);
    }
};

// Approve a change request
export const approve = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        if (!req.user) throw new AppError('Authentication required', 401);
        
        // Only admins can approve
        if (!['SUPER_ADMIN', 'CENTER_ADMIN'].includes(req.user.role)) {
            throw new AppError('Only admins can approve changes', 403);
        }
        
        const { id } = req.params;
        const { reviewNote } = req.body;
        
        const request = await prisma.changeRequest.findUnique({
            where: { id },
            include: { branch: true }
        });
        
        if (!request) throw new AppError('Change request not found', 404);
        if (request.status !== 'PENDING') throw new AppError('Request already reviewed', 400);
        
        // Apply the changes based on changeType
        try {
            await applyChanges(request);
        } catch (applyError: any) {
            console.error('❌ Error applying changes:', applyError);
            return res.status(400).json({ 
                success: false, 
                error: applyError.message || 'Failed to apply changes' 
            });
        }
        
        // Update request status
        const updatedRequest = await prisma.changeRequest.update({
            where: { id },
            data: {
                status: 'APPROVED',
                reviewedBy: req.user.id,
                reviewedAt: new Date(),
                reviewNote
            },
            include: {
                requester: { select: { id: true, name: true, email: true } },
                reviewer: { select: { id: true, name: true, email: true } },
                branch: { select: { id: true, name: true } }
            }
        });
        
        // Create notification for branch admin
        await prisma.notification.create({
            data: {
                type: 'CHANGE_APPROVED',
                title: '✅ Değişiklik Onaylandı',
                message: `${getChangeTypeLabel(request.changeType)} talebiniz onaylandı ve yayınlandı.${reviewNote ? `\n\nYönetici Notu: ${reviewNote}` : ''}`,
                userId: request.requestedBy,
                changeRequestId: request.id
            }
        });
        
        res.json({ data: updatedRequest });
    } catch (error) {
        next(error);
    }
};

// Reject a change request
export const reject = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        if (!req.user) throw new AppError('Authentication required', 401);
        
        // Only admins can reject
        if (!['SUPER_ADMIN', 'CENTER_ADMIN'].includes(req.user.role)) {
            throw new AppError('Only admins can reject changes', 403);
        }
        
        const { id } = req.params;
        const { reviewNote } = req.body;
        
        const request = await prisma.changeRequest.findUnique({ where: { id } });
        if (!request) throw new AppError('Change request not found', 404);
        if (request.status !== 'PENDING') throw new AppError('Request already reviewed', 400);
        
        const updatedRequest = await prisma.changeRequest.update({
            where: { id },
            data: {
                status: 'REJECTED',
                reviewedBy: req.user.id,
                reviewedAt: new Date(),
                reviewNote
            },
            include: {
                requester: { select: { id: true, name: true, email: true } },
                reviewer: { select: { id: true, name: true, email: true } },
                branch: { select: { id: true, name: true } }
            }
        });
        
        // Create notification for branch admin
        await prisma.notification.create({
            data: {
                type: 'CHANGE_REJECTED',
                title: '❌ Değişiklik Reddedildi',
                message: `${getChangeTypeLabel(request.changeType)} talebiniz reddedildi.${reviewNote ? `\n\nRed Nedeni: ${reviewNote}` : ''}`,
                userId: request.requestedBy,
                changeRequestId: request.id
            }
        });
        
        res.json({ data: updatedRequest });
    } catch (error) {
        next(error);
    }
};

// Helper function to get change type label
function getChangeTypeLabel(type: string): string {
    const labels: Record<string, string> = {
        TEACHER_CREATE: 'Yeni öğretmen ekleme',
        TEACHER_UPDATE: 'Öğretmen güncelleme',
        TEACHER_DELETE: 'Öğretmen silme',
        BRANCH_UPDATE: 'Şube bilgisi güncelleme',
        PACKAGE_CREATE: 'Yeni paket ekleme',
        PACKAGE_UPDATE: 'Paket güncelleme',
        PACKAGE_DELETE: 'Paket silme',
        BLOG_CREATE: 'Yeni haber ekleme',
        BLOG_UPDATE: 'Haber güncelleme',
        BLOG_DELETE: 'Haber silme',
        SUCCESS_CREATE: 'Yeni başarı ekleme',
        SUCCESS_UPDATE: 'Başarı güncelleme',
        SUCCESS_DELETE: 'Başarı silme',
        STUDENT_CREATE: 'Yeni öğrenci ekleme',
        STUDENT_DELETE: 'Öğrenci silme',
    };
    return labels[type] || type;
}

// Helper function to apply approved changes
async function applyChanges(request: any) {
    const { changeType, entityId, newData } = request;
    
    switch (changeType) {
        case 'BRANCH_UPDATE':
            if (entityId) {
                // Clean the data - remove fields that shouldn't be updated
                const { id, users, _count, createdAt, updatedAt, ...cleanData } = newData;
                await prisma.branch.update({
                    where: { id: entityId },
                    data: cleanData
                });
            }
            break;
            
        case 'TEACHER_CREATE':
            // Clean the data for teacher creation
            const { id: teacherId, createdAt: tCreatedAt, updatedAt: tUpdatedAt, ...cleanTeacherData } = newData;
            await prisma.teacher.create({
                data: cleanTeacherData
            });
            break;
            
        case 'TEACHER_UPDATE':
            if (entityId) {
                // Clean the data for teacher update
                const { id: tId, createdAt: tcAt, updatedAt: tuAt, ...cleanUpdateData } = newData;
                await prisma.teacher.update({
                    where: { id: entityId },
                    data: cleanUpdateData
                });
            }
            break;
            
        case 'TEACHER_DELETE':
            if (entityId) {
                await prisma.teacher.delete({
                    where: { id: entityId }
                });
            }
            break;
            
        case 'PACKAGE_CREATE':
            // Clean the data for package creation
            const { id: pkgId, createdAt: pCreatedAt, updatedAt: pUpdatedAt, ...cleanPackageData } = newData;
            await prisma.educationPackage.create({
                data: cleanPackageData
            });
            break;
            
        case 'PACKAGE_UPDATE':
            if (entityId) {
                // Clean the data for package update
                const { id: pId, createdAt: pcAt, updatedAt: puAt, ...cleanPkgUpdateData } = newData;
                await prisma.educationPackage.update({
                    where: { id: entityId },
                    data: cleanPkgUpdateData
                });
            }
            break;
            
        case 'PACKAGE_DELETE':
            if (entityId) {
                await prisma.educationPackage.delete({
                    where: { id: entityId }
                });
            }
            break;
            
        case 'BLOG_CREATE':
            // Clean the data for blog post creation
            console.log('📰 Creating blog post from change request:', newData);
            const { id: blogId, createdAt: bCreatedAt, updatedAt: bUpdatedAt, ...cleanBlogData } = newData;
            
            // Check if slug already exists
            if (cleanBlogData.slug) {
                const existingSlug = await prisma.blogPost.findFirst({
                    where: { slug: cleanBlogData.slug }
                });
                
                if (existingSlug) {
                    throw new Error(`Slug "${cleanBlogData.slug}" zaten kullanılıyor. Lütfen farklı bir slug seçin.`);
                }
            }
            
            console.log('📰 Clean blog data:', cleanBlogData);
            const createdBlogPost = await prisma.blogPost.create({
                data: {
                    ...cleanBlogData,
                    publishedAt: new Date() // Set publish date when approved
                }
            });
            console.log('✅ Blog post created:', createdBlogPost.id);
            break;
            
        case 'BLOG_UPDATE':
            if (entityId) {
                // Clean the data for blog post update
                const { id: bId, createdAt: bcAt, updatedAt: buAt, ...cleanBlogUpdateData } = newData;
                
                // Check if slug already exists (if changing slug)
                if (cleanBlogUpdateData.slug) {
                    const existingSlug = await prisma.blogPost.findFirst({
                        where: { 
                            slug: cleanBlogUpdateData.slug,
                            id: { not: entityId }
                        }
                    });
                    
                    if (existingSlug) {
                        throw new Error(`Slug "${cleanBlogUpdateData.slug}" zaten kullanılıyor. Lütfen farklı bir slug seçin.`);
                    }
                }
                await prisma.blogPost.update({
                    where: { id: entityId },
                    data: cleanBlogUpdateData
                });
            }
            break;
            
        case 'BLOG_DELETE':
            if (entityId) {
                await prisma.blogPost.delete({
                    where: { id: entityId }
                });
            }
            break;
            
        case 'SUCCESS_CREATE':
            // Clean the data for yearly success creation
            console.log('🏆 Creating yearly success from change request:', newData);
            const { id: successId, createdAt: sCreatedAt, updatedAt: sUpdatedAt, banner, ...cleanSuccessData } = newData;
            
            // Check if year already exists for this branch
            const existingYearSuccess = await prisma.yearlySuccess.findFirst({
                where: {
                    year: String(cleanSuccessData.year),
                    branchId: cleanSuccessData.branchId
                }
            });
            
            if (existingYearSuccess) {
                throw new Error(`${cleanSuccessData.year} yılı için bu şubede zaten bir başarı kaydı var. Lütfen mevcut kaydı düzenleyin.`);
            }
            
            const createdSuccess = await prisma.yearlySuccess.create({
                data: {
                    ...cleanSuccessData,
                    year: String(cleanSuccessData.year), // Ensure year is string
                    banner: banner ? {
                        create: {
                            title: banner.title || '',
                            subtitle: banner.subtitle || '',
                            description: banner.description || '',
                            image: banner.image || '',
                            highlightText: banner.highlightText || null,
                            gradientFrom: banner.gradientFrom || '#2563eb',
                            gradientTo: banner.gradientTo || '#1e40af'
                        }
                    } : undefined
                }
            });
            console.log('✅ Yearly success created:', createdSuccess.id);
            break;
            
        case 'SUCCESS_UPDATE':
            if (entityId) {
                // Clean the data for yearly success update
                const { id: sId, createdAt: scAt, updatedAt: suAt, banner: sBanner, students, ...cleanSuccessUpdateData } = newData;
                
                await prisma.yearlySuccess.update({
                    where: { id: entityId },
                    data: {
                        ...cleanSuccessUpdateData,
                        banner: sBanner ? {
                            upsert: {
                                create: {
                                    title: sBanner.title || '',
                                    subtitle: sBanner.subtitle || '',
                                    description: sBanner.description || '',
                                    image: sBanner.image || '',
                                    highlightText: sBanner.highlightText || null,
                                    gradientFrom: sBanner.gradientFrom || '#2563eb',
                                    gradientTo: sBanner.gradientTo || '#1e40af'
                                },
                                update: {
                                    title: sBanner.title || '',
                                    subtitle: sBanner.subtitle || '',
                                    description: sBanner.description || '',
                                    image: sBanner.image || '',
                                    highlightText: sBanner.highlightText || null,
                                    gradientFrom: sBanner.gradientFrom || '#2563eb',
                                    gradientTo: sBanner.gradientTo || '#1e40af'
                                }
                            }
                        } : undefined
                    }
                });
            }
            break;
            
        case 'SUCCESS_DELETE':
            if (entityId) {
                await prisma.yearlySuccess.delete({
                    where: { id: entityId }
                });
            }
            break;
            
        case 'STUDENT_CREATE':
            // Clean the data for student creation
            console.log('👨‍🎓 Creating student from change request:', newData);
            const { id: studentId, createdAt: stCreatedAt, updatedAt: stUpdatedAt, ...cleanStudentData } = newData;
            
            const createdStudent = await prisma.topStudent.create({
                data: cleanStudentData
            });
            console.log('✅ Student created:', createdStudent.id);
            break;
            
        case 'STUDENT_DELETE':
            if (entityId) {
                await prisma.topStudent.delete({
                    where: { id: entityId }
                });
            }
            break;
            
        default:
            throw new Error(`Unknown change type: ${changeType}`);
    }
}
