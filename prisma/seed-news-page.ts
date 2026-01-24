import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function seedNewsPage() {
    console.log('🌱 Seeding News Page content...');

    const newsPageSections = [
        // Hero Section
        { page: 'news', section: 'news-hero-badge', title: 'HABERLER VE DUYURULAR', order: 0 },
        { page: 'news', section: 'news-hero-title', title: 'Hocalara Geldik Dünyasından Haberler', order: 1 },
        { page: 'news', section: 'news-hero-subtitle', subtitle: 'Tüm şubelerimizden en güncel başarı hikayeleri, duyurular ve etkinliklerden haberdar olun.', order: 2 },
        
        // Search and Filter
        { page: 'news', section: 'news-search-placeholder', title: 'Haberlerde ara...', order: 3 },
        { page: 'news', section: 'news-filter-all', title: 'Tüm Şubeler', order: 4 },
        
        // News Card
        { page: 'news', section: 'news-card-general', title: 'Genel Haber', order: 5 },
        { page: 'news', section: 'news-card-today', title: 'Bugün', order: 6 },
        { page: 'news', section: 'news-card-read-more', title: 'DETAYLI OKU', order: 7 },
        
        // Empty State
        { page: 'news', section: 'news-empty-title', title: 'Haber Bulunamadı', order: 8 },
        { page: 'news', section: 'news-empty-subtitle', subtitle: 'Arama kriterlerinize uygun haber bulunmamaktadır.', order: 9 },
        { page: 'news', section: 'news-empty-button', buttonText: 'Filtreleri Temizle', order: 10 },
    ];

    for (const section of newsPageSections) {
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

    console.log('✅ News Page content seeded successfully');
}
