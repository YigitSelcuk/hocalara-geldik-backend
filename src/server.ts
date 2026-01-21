import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';
import path from 'path';

// Routes
import authRoutes from './routes/auth.routes';
import sliderRoutes from './routes/slider.routes';
import menuRoutes from './routes/menu.routes';
import pageRoutes from './routes/page.routes';
import categoryRoutes from './routes/category.routes';
import userRoutes from './routes/user.routes';
import branchRoutes from './routes/branch.routes';
import settingsRoutes from './routes/settings.routes';
import mediaRoutes from './routes/media.routes';
import contactRoutes from './routes/contact.routes';
import bannerCardRoutes from './routes/bannerCard.routes';
import statisticRoutes from './routes/statistic.routes';
import featureRoutes from './routes/feature.routes';
import blogPostRoutes from './routes/blogPost.routes';
import examDateRoutes from './routes/examDate.routes';
import socialMediaRoutes from './routes/socialMedia.routes';
import youtubeChannelRoutes from './routes/youtubeChannel.routes';
import yearlySuccessRoutes from './routes/yearlySuccess.routes';
import homeSectionRoutes from './routes/homeSection.routes';
import teacherRoutes from './routes/teacher.routes';
import systemRoutes from './routes/system.routes';
import videoRoutes from './routes/video.routes';
import packageRoutes from './routes/package.routes';



// Middleware
import { errorHandler } from './middleware/error.middleware';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 4000;

// Security middleware
app.use(helmet());

// CORS configuration
app.use(cors({
    origin: process.env.CORS_ORIGIN || 'http://localhost:3003',
    credentials: true
}));

// Body parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Static files (uploads)
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/sliders', sliderRoutes);
app.use('/api/menus', menuRoutes);
app.use('/api/pages', pageRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/users', userRoutes);
app.use('/api/branches', branchRoutes);
app.use('/api/settings', settingsRoutes);
app.use('/api/media', mediaRoutes);
app.use('/api/contact', contactRoutes);
app.use('/api/banner-cards', bannerCardRoutes);
app.use('/api/statistics', statisticRoutes);
app.use('/api/features', featureRoutes);
app.use('/api/blog-posts', blogPostRoutes);
app.use('/api/exam-dates', examDateRoutes);
app.use('/api/social-media', socialMediaRoutes);
app.use('/api/youtube-channels', youtubeChannelRoutes);
app.use('/api/yearly-successes', yearlySuccessRoutes);
app.use('/api/home-sections', homeSectionRoutes);
app.use('/api/teachers', teacherRoutes);
app.use('/api/system', systemRoutes);
app.use('/api/videos', videoRoutes);
app.use('/api/packages', packageRoutes);



// Error handling
app.use(errorHandler);

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
    console.log(`📊 Environment: ${process.env.NODE_ENV}`);
    console.log(`🗄️  Database: Connected`);
});

export default app;
