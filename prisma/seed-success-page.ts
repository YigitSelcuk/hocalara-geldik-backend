import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function seedSuccessPage() {
    console.log('🌱 Seeding Success Page content...');

    const successPageSections = [
        // Hero Section
        { page: 'success', section: 'success-hero-badge', title: 'Akademik Başarı Geçmişimiz', order: 0 },
        { page: 'success', section: 'success-hero-title', title: 'Gurur Tablomuz', order: 1 },
        { page: 'success', section: 'success-hero-subtitle', subtitle: 'Her yıl binlerce öğrencimiz hayallerine ulaşıyor. Yıllar içindeki başarı hikayelerimizi keşfedin.', order: 2 },
        
        // Filter Tabs
        { page: 'success', section: 'success-filter-all', title: 'Tüm Sınavlar', order: 3 },
        { page: 'success', section: 'success-filter-yks', title: 'YKS Başarıları', order: 4 },
        { page: 'success', section: 'success-filter-lgs', title: 'LGS Başarıları', order: 5 },
        
        // CTA Section
        { page: 'success', section: 'success-cta-title', title: 'Sıradaki Başarı Hikayesi Neden Sen Olmayasın?', order: 6 },
        { page: 'success', section: 'success-cta-subtitle', subtitle: 'Hemen sana en yakın şubemizi bul ve kaliteli eğitimle sınav hazırlığına başla.', order: 7 },
        { page: 'success', section: 'success-cta-button', title: 'Hemen Başla', buttonLink: '/subeler', order: 8 },
    ];

    for (const section of successPageSections) {
        await prisma.homeSection.upsert({
            where: {
                page_section: {
                    page: section.page,
                    section: section.section
                }
            },
            update: section,
            create: {
                ...section,
                isActive: true
            }
        });
    }

    console.log('✅ Success Page content seeded successfully');
}
