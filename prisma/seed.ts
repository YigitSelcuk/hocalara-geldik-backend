import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';
import { seedBranchesPage } from './seed-branches-page';
import { seedPackagesPage } from './seed-packages-page';
import { seedYearlySuccess } from './seed-yearly-success';
import { seedSuccessPage } from './seed-success-page';
import { seedNewsPage } from './seed-news-page';
import { seedFranchisePage } from './seed-franchise-page';
import { seedContactPage } from './seed-contact-page';
import { seedNews } from './seed-news';
import { seedVideoLibraryPage } from './seed-video-library-page';
import { seedVideoGalleryPage } from './seed-video-gallery-page';

const prisma = new PrismaClient();

async function main() {
    console.log('🌱 Starting database seed...');

    // Create Super Admin
    const hashedPassword = await bcrypt.hash('admin123', 10);

    const superAdmin = await prisma.user.upsert({
        where: { email: 'admin@hocalarageldik.com' },
        update: {},
        create: {
            email: 'admin@hocalarageldik.com',
            password: hashedPassword,
            name: 'Super Admin',
            role: 'SUPER_ADMIN',
            isActive: true
        }
    });

    console.log('✅ Super Admin created:', superAdmin.email);

    // Create sample branch
    const branch = await prisma.branch.upsert({
        where: { slug: 'istanbul-kadikoy' },
        update: {},
        create: {
            name: 'İstanbul Kadıköy',
            slug: 'istanbul-kadikoy',
            description: 'Kadıköy merkez şubemiz',
            address: 'Kadıköy, İstanbul',
            phone: '0216 XXX XX XX',
            whatsapp: '0532 XXX XX XX',
            email: 'kadikoy@hocalarageldik.com',
            lat: 40.9903,
            lng: 29.0245,
            isActive: true
        }
    });

    console.log('✅ Sample branch created:', branch.name);

    // Create branch admin
    const branchAdmin = await prisma.user.upsert({
        where: { email: 'kadikoy@hocalarageldik.com' },
        update: {},
        create: {
            email: 'kadikoy@hocalarageldik.com',
            password: hashedPassword,
            name: 'Kadıköy Yöneticisi',
            role: 'BRANCH_ADMIN',
            branchId: branch.id,
            isActive: true
        }
    });

    console.log('✅ Branch Admin created:', branchAdmin.email);

    // Create sample slider
    const slider = await prisma.slider.create({
        data: {
            title: 'Hocalara Geldik\'e Hoş Geldiniz',
            subtitle: 'Türkiye\'nin en büyük eğitim ağı',
            image: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=1920',
            link: '/hakkimizda',
            target: 'main',
            order: 1,
            isActive: true,
            createdById: superAdmin.id
        }
    });

    console.log('✅ Sample slider created');

    // Create sample menu
    const menu = await prisma.menu.upsert({
        where: { slug: 'ana-menu' },
        update: {},
        create: {
            name: 'Ana Menü',
            slug: 'ana-menu',
            position: 'HEADER',
            isActive: true,
            createdById: superAdmin.id
        }
    });

    console.log('✅ Sample menu created');

    // Create sample categories
    const category = await prisma.category.upsert({
        where: { slug: 'haberler' },
        update: {},
        create: {
            name: 'Haberler',
            slug: 'haberler',
            description: 'Kurumsal haberler ve duyurular',
            order: 1,
            isActive: true
        }
    });

    console.log('✅ Sample category created');

    // Create sample settings
    const settings = [
        { key: 'site_name', value: 'Hocalara Geldik', group: 'general' },
        { key: 'site_tagline', value: 'Türkiye\'nin En Büyük Eğitim Ağı', group: 'general' },
        { key: 'contact_phone', value: '0212 XXX XX XX', group: 'contact' },
        { key: 'contact_email', value: 'info@hocalarageldik.com', group: 'contact' },
        { key: 'social_facebook', value: 'https://facebook.com/hocalarageldik', group: 'social' },
        { key: 'social_instagram', value: 'https://instagram.com/hocalarageldik', group: 'social' },
        { key: 'social_twitter', value: 'https://twitter.com/hocalarageldik', group: 'social' }
    ];

    for (const setting of settings) {
        await prisma.setting.upsert({
            where: { key: setting.key },
            update: {},
            create: setting
        });
    }

    console.log('✅ Sample settings created');

    // Seed footer menu
    console.log('🔵 Seeding footer menu...');

    // Footer column titles
    const columnTitles = [
        {
            page: 'home',
            section: 'footer-menu-column1',
            title: 'Hızlı Menü Linkleri',
            isActive: true
        },
        {
            page: 'home',
            section: 'footer-menu-column2',
            title: 'Eğitim Programları',
            isActive: true
        },
        {
            page: 'home',
            section: 'footer-menu-column3',
            title: 'Genel İletişim Hattı',
            isActive: true
        }
    ];

    for (const title of columnTitles) {
        await prisma.homeSection.upsert({
            where: { page_section: { page: title.page, section: title.section } },
            update: title,
            create: title
        });
    }

    // Column 1 - Hızlı Menü Linkleri
    const column1Items = [
        { title: 'Akademi Ana Sayfası', url: '/', order: 0 },
        { title: 'Tüm Akademik Şubelerimiz', url: '/subeler', order: 1 },
        { title: 'Öğrenci Gurur Tablomuz', url: '/basarilarimiz', order: 2 },
        { title: 'Franchise Başvuru Formu', url: '/franchise', order: 3 },
        { title: 'Güncel Haberler Ve Duyurular', url: '/haberler', order: 4 }
    ];

    for (const item of column1Items) {
        const existing = await prisma.homeSection.findFirst({
            where: {
                page: 'home',
                section: { startsWith: 'footer-menu-column1-item' },
                title: item.title
            }
        });

        if (!existing) {
            await prisma.homeSection.create({
                data: {
                    page: 'home',
                    section: `footer-menu-column1-item-${Date.now()}-${item.order}`,
                    title: item.title,
                    buttonLink: item.url,
                    order: item.order,
                    isActive: true
                }
            });
        }
    }

    // Column 2 - Eğitim Programları
    const column2Items = [
        { title: 'Üniversite Hazırlık (YKS)', url: '#', order: 0 },
        { title: 'Lise Giriş Sınavı (LGS)', url: '#', order: 1 },
        { title: 'Dijital Soru Çözüm Arşivi', url: '#', order: 2 },
        { title: 'Uzman Rehberlik Hizmetleri', url: '#', order: 3 },
        { title: 'Haftalık Deneme Sınavları', url: '#', order: 4 }
    ];

    for (const item of column2Items) {
        const existing = await prisma.homeSection.findFirst({
            where: {
                page: 'home',
                section: { startsWith: 'footer-menu-column2-item' },
                title: item.title
            }
        });

        if (!existing) {
            await prisma.homeSection.create({
                data: {
                    page: 'home',
                    section: `footer-menu-column2-item-${Date.now()}-${item.order}`,
                    title: item.title,
                    buttonLink: item.url,
                    order: item.order,
                    isActive: true
                }
            });
        }
    }

    // Column 3 - Genel İletişim Hattı
    const column3Items = [
        { title: 'Hakkımızda', url: '/hakkimizda', order: 0 },
        { title: 'İletişim', url: '/iletisim', order: 1 },
        { title: 'Gizlilik Sözleşmesi', url: '/gizlilik', order: 2 },
        { title: 'Kullanım Şartları', url: '/kullanim-sartlari', order: 3 },
        { title: 'KVKK Aydınlatma Metni', url: '/kvkk', order: 4 }
    ];

    for (const item of column3Items) {
        const existing = await prisma.homeSection.findFirst({
            where: {
                page: 'home',
                section: { startsWith: 'footer-menu-column3-item' },
                title: item.title
            }
        });

        if (!existing) {
            await prisma.homeSection.create({
                data: {
                    page: 'home',
                    section: `footer-menu-column3-item-${Date.now()}-${item.order}`,
                    title: item.title,
                    buttonLink: item.url,
                    order: item.order,
                    isActive: true
                }
            });
        }
    }

    // Footer description and copyright
    await prisma.homeSection.upsert({
        where: { page_section: { page: 'home', section: 'footer-description' } },
        update: {
            description: 'Türkiye\'nin Öncü Eğitim Markası Olarak, Akademik Başarınızı En Modern Teknolojiler Ve Uzman Kadromuzla Destekliyoruz.'
        },
        create: {
            page: 'home',
            section: 'footer-description',
            description: 'Türkiye\'nin Öncü Eğitim Markası Olarak, Akademik Başarınızı En Modern Teknolojiler Ve Uzman Kadromuzla Destekliyoruz.',
            isActive: true
        }
    });

    await prisma.homeSection.upsert({
        where: { page_section: { page: 'home', section: 'footer-copyright' } },
        update: {
            title: 'Hocalara Geldik Akademi Grubu. Tüm hakları saklıdır.'
        },
        create: {
            page: 'home',
            section: 'footer-copyright',
            title: 'Hocalara Geldik Akademi Grubu. Tüm hakları saklıdır.',
            isActive: true
        }
    });

    // Footer logo
    await prisma.homeSection.upsert({
        where: { page_section: { page: 'home', section: 'footer-logo' } },
        update: {
            buttonLink: '/assets/images/logoblue.svg'
        },
        create: {
            page: 'home',
            section: 'footer-logo',
            buttonLink: '/assets/images/logoblue.svg',
            isActive: true
        }
    });

    // Footer bottom links
    const bottomLinks = [
        { title: 'Gizlilik Sözleşmesi', url: '/gizlilik', order: 0 },
        { title: 'Kullanım Şartları', url: '/kullanim-sartlari', order: 1 },
        { title: 'KVKK Aydınlatma Metni', url: '/kvkk', order: 2 }
    ];

    for (const link of bottomLinks) {
        const existing = await prisma.homeSection.findFirst({
            where: {
                page: 'home',
                section: { startsWith: 'footer-bottom-link' },
                title: link.title
            }
        });

        if (!existing) {
            await prisma.homeSection.create({
                data: {
                    page: 'home',
                    section: `footer-bottom-link-${Date.now()}-${link.order}`,
                    title: link.title,
                    buttonLink: link.url,
                    order: link.order,
                    isActive: true
                }
            });
        }
    }

    console.log('✅ Footer menu seeded');

    // Header data
    console.log('🔵 Seeding header data...');

    // Header logo
    await prisma.homeSection.upsert({
        where: { page_section: { page: 'home', section: 'header-logo' } },
        update: {
            buttonLink: '/assets/images/logoblue.svg'
        },
        create: {
            page: 'home',
            section: 'header-logo',
            buttonLink: '/assets/images/logoblue.svg',
            isActive: true
        }
    });

    // Header phone
    await prisma.homeSection.upsert({
        where: { page_section: { page: 'home', section: 'header-phone' } },
        update: {
            title: '0212 000 00 00'
        },
        create: {
            page: 'home',
            section: 'header-phone',
            title: '0212 000 00 00',
            isActive: true
        }
    });

    // Header topbar links
    const headerTopbarLinks = [
        { title: 'Hakkımızda', url: '/hakkimizda', order: 0 },
        { title: 'Şubeler', url: '/subeler', order: 1 },
        { title: 'İletişim', url: '/iletisim', order: 2 }
    ];

    for (const link of headerTopbarLinks) {
        const existing = await prisma.homeSection.findFirst({
            where: {
                page: 'home',
                section: { startsWith: 'header-topbar-link' },
                title: link.title
            }
        });

        if (!existing) {
            await prisma.homeSection.create({
                data: {
                    page: 'home',
                    section: `header-topbar-link-${Date.now()}-${link.order}`,
                    title: link.title,
                    buttonLink: link.url,
                    order: link.order,
                    isActive: true
                }
            });
        }
    }

    // Header main menu links
    const headerMenuLinks = [
        { title: 'Ana Sayfa', url: '/', order: 0 },
        { title: 'Videolar', url: '/videolar', order: 1 },
        { title: 'Paketler', url: '/paketler', order: 2 },
        { title: 'Şubeler', url: '/subeler', order: 3 },
        { title: 'Başarılar', url: '/basarilarimiz', order: 4 },
        { title: 'Haberler', url: '/haberler', order: 5 },
        { title: 'Franchise', url: '/franchise', order: 6 }
    ];

    for (const link of headerMenuLinks) {
        const existing = await prisma.homeSection.findFirst({
            where: {
                page: 'home',
                section: { startsWith: 'header-menu-link' },
                title: link.title
            }
        });

        if (!existing) {
            await prisma.homeSection.create({
                data: {
                    page: 'home',
                    section: `header-menu-link-${Date.now()}-${link.order}`,
                    title: link.title,
                    buttonLink: link.url,
                    order: link.order,
                    isActive: true
                }
            });
        }
    }

    console.log('✅ Header data seeded');

    // Seed branches page content
    await seedBranchesPage();

    // Seed packages page content
    await seedPackagesPage();

    // Seed yearly success data
    await seedYearlySuccess();

    // Seed success page content
    await seedSuccessPage();

    // Seed news page content
    await seedNewsPage();

    // Seed actual news articles
    await seedNews();

    // Seed franchise page content
    await seedFranchisePage();

    // Seed contact page content
    await seedContactPage();

    // Seed video library page content
    await seedVideoLibraryPage();

    // Seed video gallery page content
    await seedVideoGalleryPage();

    console.log('🎉 Database seed completed!');
    console.log('\n📧 Login credentials:');
    console.log('   Email: admin@hocalarageldik.com');
    console.log('   Password: admin123');
}

main()
    .catch((e) => {
        console.error('❌ Seed error:', e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
