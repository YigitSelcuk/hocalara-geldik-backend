import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

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
    const menu = await prisma.menu.create({
        data: {
            name: 'Ana Menü',
            slug: 'ana-menu',
            position: 'HEADER',
            isActive: true,
            createdById: superAdmin.id
        }
    });

    console.log('✅ Sample menu created');

    // Create sample categories
    const category = await prisma.category.create({
        data: {
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
