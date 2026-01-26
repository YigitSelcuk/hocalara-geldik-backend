import { Response, NextFunction } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/auth.middleware';
import { AppError } from '../middleware/error.middleware';

const prisma = new PrismaClient();

export const getAllBlogPosts = async (req: AuthRequest, res: Response) => {
    try {
        const { branchId } = req.query;
        const where: any = {};
        
        // If branchId query param is provided, filter by it
        if (branchId) {
            where.branchId = branchId as string;
        }
        
        // If user is authenticated
        if (req.user) {
            // If user is BRANCH_ADMIN, only show their branch's blog posts
            // SUPER_ADMIN and CENTER_ADMIN can see all blog posts
            if (req.user.role === 'BRANCH_ADMIN' && req.user.branchId) {
                where.branchId = req.user.branchId;
            }
            // Admin users can see all posts (including inactive)
        } else {
            // Public users: only show active and published posts
            where.isActive = true;
            // Optionally filter by publishedAt if you want only published posts
            // where.publishedAt = { not: null };
        }
        
        console.log('📰 Fetching blog posts for:', {
            role: req.user?.role,
            branchId: req.user?.branchId,
            queryBranchId: branchId,
            isPublic: !req.user,
            where
        });
        
        const blogPosts = await prisma.blogPost.findMany({
            where,
            include: { branch: true },
            orderBy: { createdAt: 'desc' }
        });
        
        console.log('📰 Found blog posts:', blogPosts.length);
        console.log('📰 Blog posts data:', blogPosts.map(p => ({
            id: p.id,
            title: p.title,
            isActive: p.isActive,
            publishedAt: p.publishedAt,
            branchId: p.branchId
        })));
        
        // If BRANCH_ADMIN, add pending status and filter out deleted ones
        if (req.user?.role === 'BRANCH_ADMIN') {
            const pendingRequests = await prisma.changeRequest.findMany({
                where: {
                    changeType: { in: ['BLOG_CREATE', 'BLOG_UPDATE', 'BLOG_DELETE'] },
                    status: 'PENDING',
                    branchId: req.user.branchId
                },
                select: { 
                    id: true,
                    entityId: true, 
                    changeType: true,
                    newData: true
                }
            });
            
            console.log('📰 Found pending requests:', pendingRequests.length);
            
            // Create a map of pending requests
            const pendingMap = new Map();
            const pendingDeleteIds = new Set();
            const pendingCreates: any[] = [];
            
            pendingRequests.forEach(req => {
                if (req.changeType === 'BLOG_DELETE') {
                    pendingDeleteIds.add(req.entityId);
                } else if (req.changeType === 'BLOG_CREATE') {
                    const pendingItem = {
                        ...(req.newData as any),
                        id: req.id,
                        isPending: true,
                        pendingType: 'CREATE',
                        createdAt: new Date().toISOString(),
                        updatedAt: new Date().toISOString()
                    };
                    console.log('📰 Pending create item:', pendingItem);
                    pendingCreates.push(pendingItem);
                } else if (req.changeType === 'BLOG_UPDATE') {
                    pendingMap.set(req.entityId, {
                        isPending: true,
                        pendingType: 'UPDATE'
                    });
                }
            });
            
            console.log('📰 Pending creates:', pendingCreates.length);
            console.log('📰 Pending updates:', pendingMap.size);
            console.log('📰 Pending deletes:', pendingDeleteIds.size);
            
            // Filter out deleted blog posts and add pending status
            const filteredBlogPosts = blogPosts
                .filter(p => !pendingDeleteIds.has(p.id))
                .map(p => ({
                    ...p,
                    ...(pendingMap.get(p.id) || {})
                }));
            
            // Add pending creates
            const allBlogPosts = [...filteredBlogPosts, ...pendingCreates];
            
            console.log('📰 Total blog posts (with pending):', allBlogPosts.length);
            
            return res.json({ success: true, data: allBlogPosts });
        }
        
        res.json({ success: true, data: blogPosts });
    } catch (error) {
        console.error('Error fetching blog posts:', error);
        res.status(500).json({ success: false, error: 'Failed to fetch blog posts' });
    }
};

export const getBlogPostById = async (req: AuthRequest, res: Response) => {
    try {
        const { id } = req.params;
        
        // Try to find by ID first
        let blogPost = await prisma.blogPost.findUnique({
            where: { id },
            include: { branch: true }
        });
        
        // If not found by ID, try to find by slug
        if (!blogPost) {
            blogPost = await prisma.blogPost.findFirst({
                where: { slug: id },
                include: { branch: true }
            });
        }
        
        if (!blogPost) {
            return res.status(404).json({ success: false, error: 'Blog post not found' });
        }
        
        res.json({ success: true, data: blogPost });
    } catch (error) {
        console.error('Error fetching blog post:', error);
        res.status(500).json({ success: false, error: 'Failed to fetch blog post' });
    }
};

export const createBlogPost = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { title, slug, excerpt, content, category, author, date, image, readTime, isActive, isFeatured, seoTitle, seoDescription, seoKeywords } = req.body;
        
        console.log('📰 Blog post create request:', {
            user: req.user?.email,
            role: req.user?.role,
            branchId: req.user?.branchId,
            title,
            slug
        });
        
        // Check if slug already exists (if slug is provided)
        if (slug) {
            const existingSlug = await prisma.blogPost.findFirst({
                where: { slug }
            });
            
            if (existingSlug) {
                return res.status(400).json({ 
                    success: false, 
                    error: 'SLUG_EXISTS',
                    message: 'Bu slug zaten kullanılıyor. Lütfen farklı bir slug seçin.' 
                });
            }
        }
        
        // If BRANCH_ADMIN, create change request instead
        if (req.user?.role === 'BRANCH_ADMIN') {
            if (!req.user.branchId) {
                throw new AppError('Branch admin must be assigned to a branch', 400);
            }
            
            console.log('✅ Creating change request for BRANCH_ADMIN');
            
            // Check for existing pending request
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    changeType: 'BLOG_CREATE',
                    status: 'PENDING',
                    branchId: req.user.branchId,
                    newData: {
                        path: ['title'],
                        equals: title
                    }
                }
            });
            
            if (existingRequest) {
                console.log('⚠️ Duplicate request found');
                return res.status(400).json({ success: false, error: 'DUPLICATE_REQUEST' });
            }
            
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'BLOG_CREATE',
                    entityType: 'BlogPost',
                    branchId: req.user.branchId,
                    requestedBy: req.user.id,
                    newData: {
                        title,
                        slug,
                        excerpt,
                        content,
                        category: category || 'Genel', // Default category if not provided
                        author,
                        date,
                        image,
                        readTime,
                        isActive: isActive ?? true,
                        isFeatured: isFeatured ?? false,
                        seoTitle,
                        seoDescription,
                        seoKeywords,
                        branchId: req.user.branchId
                    }
                }
            });
            
            console.log('✅ Change request created:', changeRequest.id);
            
            return res.status(201).json({ 
                success: true, 
                message: 'Blog post creation request submitted for approval',
                data: changeRequest 
            });
        }
        
        // SUPER_ADMIN or CENTER_ADMIN can create directly
        console.log('📰 Creating blog post as admin:', {
            title,
            isActive: isActive ?? true,
            willSetPublishedAt: true
        });
        
        const blogPost = await prisma.blogPost.create({
            data: {
                title,
                slug,
                excerpt,
                content,
                category: category || 'Genel', // Default category if not provided
                author,
                date,
                image,
                readTime,
                isActive: isActive ?? true,
                isFeatured: isFeatured ?? false,
                seoTitle,
                seoDescription,
                seoKeywords,
                publishedAt: new Date() // Set publish date when admin creates
            }
        });
        
        console.log('✅ Blog post created:', {
            id: blogPost.id,
            title: blogPost.title,
            isActive: blogPost.isActive,
            publishedAt: blogPost.publishedAt
        });
        
        res.status(201).json({ success: true, data: blogPost });
    } catch (error) {
        next(error);
    }
};

export const updateBlogPost = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const { title, slug, excerpt, content, category, author, date, image, readTime, isActive, isFeatured, seoTitle, seoDescription, seoKeywords } = req.body;
        
        const existingBlogPost = await prisma.blogPost.findUnique({ where: { id } });
        if (!existingBlogPost) {
            throw new AppError('Blog post not found', 404);
        }
        
        // Check if slug already exists (if slug is provided and different from current)
        if (slug && slug !== existingBlogPost.slug) {
            const existingSlug = await prisma.blogPost.findFirst({
                where: { 
                    slug,
                    id: { not: id } // Exclude current blog post
                }
            });
            
            if (existingSlug) {
                return res.status(400).json({ 
                    success: false, 
                    error: 'SLUG_EXISTS',
                    message: 'Bu slug zaten kullanılıyor. Lütfen farklı bir slug seçin.' 
                });
            }
        }
        
        // If BRANCH_ADMIN, create change request instead
        if (req.user?.role === 'BRANCH_ADMIN') {
            if (!req.user.branchId || existingBlogPost.branchId !== req.user.branchId) {
                throw new AppError('Unauthorized', 403);
            }
            
            // Check for existing pending request
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    changeType: 'BLOG_UPDATE',
                    entityId: id,
                    status: 'PENDING',
                    branchId: req.user.branchId
                }
            });
            
            if (existingRequest) {
                return res.status(400).json({ success: false, error: 'DUPLICATE_REQUEST' });
            }
            
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'BLOG_UPDATE',
                    entityId: id,
                    entityType: 'BlogPost',
                    branchId: req.user.branchId,
                    requestedBy: req.user.id,
                    oldData: existingBlogPost,
                    newData: {
                        title,
                        slug,
                        excerpt,
                        content,
                        category: category || existingBlogPost.category || 'Genel',
                        author,
                        date,
                        image,
                        readTime,
                        isActive,
                        isFeatured,
                        seoTitle,
                        seoDescription,
                        seoKeywords
                    }
                }
            });
            
            return res.json({ 
                success: true, 
                message: 'Blog post update request submitted for approval',
                data: changeRequest 
            });
        }
        
        // SUPER_ADMIN or CENTER_ADMIN can update directly
        const blogPost = await prisma.blogPost.update({
            where: { id },
            data: {
                title,
                slug,
                excerpt,
                content,
                category: category || existingBlogPost.category || 'Genel',
                author,
                date,
                image,
                readTime,
                isActive,
                isFeatured,
                seoTitle,
                seoDescription,
                seoKeywords
            }
        });
        
        res.json({ success: true, data: blogPost });
    } catch (error) {
        next(error);
    }
};

export const deleteBlogPost = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        
        const existingBlogPost = await prisma.blogPost.findUnique({ where: { id } });
        if (!existingBlogPost) {
            throw new AppError('Blog post not found', 404);
        }
        
        // If BRANCH_ADMIN, create change request instead
        if (req.user?.role === 'BRANCH_ADMIN') {
            if (!req.user.branchId || existingBlogPost.branchId !== req.user.branchId) {
                throw new AppError('Unauthorized', 403);
            }
            
            // Check for existing pending request
            const existingRequest = await prisma.changeRequest.findFirst({
                where: {
                    changeType: 'BLOG_DELETE',
                    entityId: id,
                    status: 'PENDING',
                    branchId: req.user.branchId
                }
            });
            
            if (existingRequest) {
                return res.status(400).json({ success: false, error: 'DUPLICATE_REQUEST' });
            }
            
            const changeRequest = await prisma.changeRequest.create({
                data: {
                    changeType: 'BLOG_DELETE',
                    entityId: id,
                    entityType: 'BlogPost',
                    branchId: req.user.branchId,
                    requestedBy: req.user.id,
                    oldData: existingBlogPost,
                    newData: { deleted: true },
                    status: 'PENDING'
                }
            });
            
            return res.json({ 
                success: true, 
                message: 'Blog post deletion request submitted for approval',
                data: changeRequest 
            });
        }
        
        // SUPER_ADMIN or CENTER_ADMIN can delete directly
        await prisma.blogPost.delete({ where: { id } });
        
        res.json({ success: true, message: 'Blog post deleted successfully' });
    } catch (error) {
        next(error);
    }
};
