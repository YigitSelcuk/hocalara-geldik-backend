import { Request, Response } from 'express';
import prisma from '../config/database';

export const seedDatabase = async (req: Request, res: Response) => {
    try {
        const { reset } = req.body;

        if (reset) {
            // Clear ALL data in correct order to avoid FK issues
            await prisma.menuItem.deleteMany();
            await prisma.menu.deleteMany();
            await prisma.media.deleteMany();
            await prisma.topStudent.deleteMany();
            await prisma.successBanner.deleteMany();
            await prisma.yearlySuccess.deleteMany();
            await prisma.examDate.deleteMany();
            await prisma.teacher.deleteMany();
            await prisma.page.deleteMany();
            await prisma.category.deleteMany();
            await prisma.videoLesson.deleteMany();
            await prisma.educationPackage.deleteMany();
            await prisma.slider.deleteMany();
            await prisma.bannerCard.deleteMany();
            await prisma.statistic.deleteMany();
            await prisma.feature.deleteMany();
            await prisma.blogPost.deleteMany();
            await prisma.youTubeChannel.deleteMany();
            await prisma.socialMedia.deleteMany();
            await prisma.homeSection.deleteMany();
            // Users except Super Admin
            await prisma.user.deleteMany({
                where: {
                    role: {
                        not: 'SUPER_ADMIN'
                    }
                }
            });
            await prisma.branch.deleteMany();
        }

        const superAdmin = await prisma.user.findFirst({ where: { role: 'SUPER_ADMIN' } });
        const adminId = superAdmin?.id || "";

        // 1. Branches
        if (await prisma.branch.count() === 0) {
            await prisma.branch.createMany({
                data: [
                    {
                        name: 'Genel Merkez',
                        slug: 'genel-merkez',
                        address: 'Eğitim Vadisi Sok. No:1 İstanbul',
                        phone: '0212 555 0100',
                        email: 'info@hocalarageldik.com',
                        lat: 41.0082,
                        lng: 28.9784,
                        isActive: true
                    },
                    {
                        name: 'Beşiktaş Şubesi',
                        slug: 'besiktas-subesi',
                        address: 'Beşiktaş Meydan No:5 İstanbul',
                        phone: '0212 555 0101',
                        lat: 41.0422,
                        lng: 29.0075,
                        isActive: true
                    }
                ]
            });
        }
        const branches = await prisma.branch.findMany();
        const branch1Id = branches.find(b => b.slug === 'besiktas-subesi')?.id;

        // 2. Users (Branch Admins)
        if (await prisma.user.count({ where: { role: 'BRANCH_ADMIN' } }) === 0) {
            await prisma.user.create({
                data: {
                    email: 'besiktas@hocalarageldik.com',
                    password: '$2a$10$XmO9y.fK/fF.V/v58v8v8.v8v8v8v8v8v8v8v8v8v8v8v8v8v8v8v', // password123 (hashed)
                    name: 'Beşiktaş Admin',
                    role: 'BRANCH_ADMIN',
                    branchId: branch1Id
                }
            });
        }

        // 2b. Sliders
        if (await prisma.slider.count() === 0) {
            await prisma.slider.createMany({
                data: [
                    {
                        title: "Geleceğin Eğitim Vizyonu Burada",
                        subtitle: "Hocalara Geldik ile Başarıya Odaklanın",
                        image: "https://images.unsplash.com/photo-1524178232363-1fb2b075b655?q=80&w=2070&auto=format&fit=crop",
                        target: "main",
                        order: 0,
                        createdById: adminId
                    },
                    {
                        title: "Beşiktaş Şubemize Bekliyoruz",
                        subtitle: "Yüz Yüze Eğitimin En Kaliteli Adresi",
                        image: "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=2070&auto=format&fit=crop",
                        target: branch1Id || 'main',
                        order: 1,
                        createdById: adminId
                    }
                ]
            });
        }

        // 3. Menus & MenuItems
        if (await prisma.menu.count() === 0) {
            const headerMenu = await prisma.menu.create({
                data: {
                    name: 'Ana Menü',
                    slug: 'header-menu',
                    position: 'HEADER',
                    createdById: adminId,
                    isActive: true
                }
            });

            await prisma.menuItem.createMany({
                data: [
                    { menuId: headerMenu.id, label: 'Anasayfa', url: '/', order: 0 },
                    { menuId: headerMenu.id, label: 'Şubelerimiz', url: '/subeler', order: 1 },
                    { menuId: headerMenu.id, label: 'Eğitim Paketleri', url: '/paketler', order: 2 },
                    { menuId: headerMenu.id, label: 'Hakkımızda', url: '/hakkimizda', order: 3 },
                    { menuId: headerMenu.id, label: 'İletişim', url: '/iletisim', order: 4 }
                ]
            });
        }

        // 4. Categories
        if (await prisma.category.count() === 0) {
            await prisma.category.createMany({
                data: [
                    { name: 'Rehberlik', slug: 'rehberlik', order: 0 },
                    { name: 'Sınav Stratejileri', slug: 'sinav-stratejileri', order: 1 },
                    { name: 'Motivasyon', slug: 'motivasyon', order: 2 }
                ]
            });
        }

        // 5. Pages & News
        if (await prisma.page.count() === 0) {
            await prisma.page.createMany({
                data: [
                    {
                        title: 'Hakkımızda',
                        slug: 'hakkimizda',
                        content: '<h1>Hocalara Geldik</h1><p>Türkiye\'nin en köklü eğitim platformlarından biri...</p>',
                        type: 'REGULAR',
                        status: 'PUBLISHED',
                        authorId: adminId
                    },
                    {
                        title: 'Yeni TYT Denemeleri Yayınlandı!',
                        slug: 'yeni-tyt-denemeleri',
                        content: '<p>2024 müfredatına tam uyumlu deneme sınavlarımız tüm şubelerimizde...</p>',
                        type: 'NEWS',
                        status: 'PUBLISHED',
                        authorId: adminId,
                        isFeatured: true
                    }
                ]
            });
        }

        // 6. Video Lessons
        if (await prisma.videoLesson.count() === 0) {
            await prisma.videoLesson.createMany({
                data: [
                    {
                        title: 'TYT Matematik - Temel Kavramlar',
                        description: 'Matematiğin temeli olan kavramları en ince ayrıntısına kadar öğrenin.',
                        thumbnail: 'https://images.unsplash.com/photo-1509228468518-180dd4864904?auto=format&fit=crop&q=80&w=800',
                        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
                        category: 'YKS_TYT',
                        subject: 'Matematik',
                        duration: '45:20',
                        views: 12500,
                        teacher: 'Vural Hoca',
                        difficulty: 'Başlangıç'
                    },
                    {
                        title: 'LGS Fen Bilimleri - Mevsimler',
                        description: 'Mevsimlerin oluşumu ve iklim hareketleri.',
                        thumbnail: 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&q=80&w=800',
                        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
                        category: 'LGS',
                        subject: 'Fen Bilimleri',
                        duration: '38:15',
                        views: 8900,
                        teacher: 'Zeynep Hoca',
                        difficulty: 'Orta'
                    }
                ]
            });
        }

        // 7. Education Packages
        if (await prisma.educationPackage.count() === 0) {
            await prisma.educationPackage.createMany({
                data: [
                    {
                        name: 'YKS 2026 VIP Hazırlık',
                        slug: 'yks-2026-vip',
                        type: 'YKS_2026',
                        shortDescription: 'Tüm TYT-AYT konuları ve canlı ders desteği.',
                        description: 'Bu paket ile sınava %100 hazır olacaksınız.',
                        price: 2499,
                        originalPrice: 3499,
                        image: 'https://images.unsplash.com/photo-1497633762265-9a177c8098a2?auto=format&fit=crop&q=80&w=800',
                        features: JSON.stringify(['Her gün canlı ders', 'Özel ders dökümanları', 'Sınırsız video erişimi']),
                        videoCount: 2500,
                        subjectCount: 15,
                        isPopular: true
                    }
                ]
            });
        }

        // 8. Teachers
        if (await prisma.teacher.count() === 0) {
            await prisma.teacher.createMany({
                data: [
                    {
                        name: 'Vural Aksankur',
                        subject: 'Matematik',
                        image: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?auto=format&fit=crop&q=80&w=300',
                        branchId: branch1Id,
                        isActive: true
                    },
                    {
                        name: 'Habil Hoca',
                        subject: 'Fizik',
                        image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=300',
                        branchId: branch1Id,
                        isActive: true
                    }
                ]
            });
        }

        // 9. Exam Dates
        if (await prisma.examDate.count() === 0) {
            await prisma.examDate.createMany({
                data: [
                    { examName: 'TYT 2024', examDate: new Date('2024-06-08'), order: 0 },
                    { examName: 'AYT 2024', examDate: new Date('2024-06-09'), order: 1 },
                    { examName: 'LGS 2024', examDate: new Date('2024-06-02'), order: 2 }
                ]
            });
        }

        // 10. Yearly Success
        if (await prisma.yearlySuccess.count() === 0) {
            const s2024 = await prisma.yearlySuccess.create({
                data: {
                    year: '2024',
                    totalDegrees: 150,
                    placementCount: 2500,
                    successRate: 98.5,
                    cityCount: 81,
                    top100Count: 15,
                    top1000Count: 120,
                    isActive: true
                }
            });

            await prisma.successBanner.create({
                data: {
                    yearlySuccessId: s2024.id,
                    title: '2024 Gurur Tablomuz',
                    subtitle: 'Başarı Bir Gelenektir',
                    description: 'Hocalara Geldik öğrencileri yine zirvede.',
                    image: 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&q=80&w=800'
                }
            });

            await prisma.topStudent.createMany({
                data: [
                    { yearlySuccessId: s2024.id, name: 'Ahmet Yılmaz', rank: '1.', exam: 'TYT', university: 'İTÜ', order: 0 },
                    { yearlySuccessId: s2024.id, name: 'Ayşe Demir', rank: '5.', exam: 'AYT', university: 'Boğaziçi', order: 1 }
                ]
            });
        }

        // 11. Homepage Essentials
        if (await prisma.bannerCard.count() === 0) {
            await prisma.bannerCard.createMany({
                data: [
                    { title: 'Franchise Başvuru', description: 'Hocalara Geldik Ailesine Katılın', icon: 'FileText', link: '/franchise', bgColor: 'bg-[#3b82f6]', hoverColor: '', order: 0 },
                    { title: 'Kayıt Başvurusu', description: 'Eğitiminize Hemen Başlayın', icon: 'GraduationCap', link: '/iletisim', bgColor: 'bg-[#a855f7]', hoverColor: '', order: 1 },
                    { title: 'Başarı Merkezleri', description: '81 İlde Güçlü Şube Ağı', icon: 'School', link: '/subeler', bgColor: 'bg-[#ec4899]', hoverColor: '', order: 2 },
                    { title: 'Dijital Platform', description: 'Yapay Zeka Destekli Eğitim', icon: 'Laptop', link: '/videolar', bgColor: 'bg-[#f97316]', hoverColor: '', order: 3 },
                    { title: 'YouTube Kanalı', description: 'Binlerce Ücretsiz İçerik', icon: 'Youtube', link: '/videolar', bgColor: 'bg-red-600', hoverColor: '', order: 4 }
                ]
            });
        }

        if (await prisma.statistic.count() === 0) {
            await prisma.statistic.createMany({
                data: [
                    { label: 'İl', value: '81', icon: 'MapPin', order: 0 },
                    { label: 'Şube', value: '250+', icon: 'School', order: 1 },
                    { label: 'Öğretmen', value: '1500+', icon: 'Users', order: 2 },
                    { label: 'Öğrenci', value: '50K+', icon: 'GraduationCap', order: 3 }
                ]
            });
        }

        if (await prisma.homeSection.count() === 0) {
            await prisma.homeSection.createMany({
                data: [
                    { key: 'centers', topTitle: 'BAŞARI MERKEZLERİMİZ', title: "Türkiye'nin En Büyük Eğitim Ağı", subtitle: "81 ilde güçlü şube ağımız, modern eğitim altyapımız ve uzman kadromuzla öğrencilerimize en kaliteli eğitimi sunuyoruz.", link: '/subeler', linkText: 'Şubelerimizi Keşfedin', order: 0 },
                    { key: 'digital', topTitle: 'DİJİTAL EĞİTİM SİSTEMİ', title: 'Yapay Zeka Destekli Eğitim Platformu', subtitle: 'Öğrenciler ve veliler için geliştirdiğimiz dijital altyapı ile eğitim sürecini her adımda takip edin ve kişiselleştirilmiş öğrenme deneyimi yaşayın.', order: 1 }
                ]
            });
        }

        if (await prisma.youTubeChannel.count() === 0) {
            await prisma.youTubeChannel.createMany({
                data: [
                    { name: 'Hocalara Geldik', description: 'Ana kanalımızda tüm derslerin konu anlatımları ve soru çözümleri yer alıyor.', thumbnail: 'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?auto=format&fit=crop&q=80&w=800', url: 'https://youtube.com/hocalarageldik', subscribers: '1M+', videoCount: '5000+', order: 0 }
                ]
            });
        }

        if (await prisma.socialMedia.count() === 0) {
            await prisma.socialMedia.createMany({
                data: [
                    { platform: 'YouTube', url: 'https://youtube.com/hocalarageldik', order: 0 },
                    { platform: 'Instagram', url: 'https://instagram.com/hocalarageldik', order: 1 }
                ]
            });
        }

        return res.status(200).json({
            success: true,
            message: 'Database seeded successfully with ALL site data'
        });
    } catch (error: any) {
        console.error('Seeding error:', error);
        return res.status(500).json({
            success: false,
            message: 'Seeding failed',
            error: error.message
        });
    }
};
