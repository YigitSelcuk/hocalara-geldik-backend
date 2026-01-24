import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function seedVideoGalleryPage() {
  console.log('🎬 Seeding Video Gallery page content...');

  const sections = [
    // Hero Section
    { page: 'video-gallery', section: 'video-gallery-hero-badge', title: 'Örnek Ders Videoları', subtitle: '', buttonText: '', order: 1 },
    { page: 'video-gallery', section: 'video-gallery-hero-title', title: 'Video', subtitle: '', buttonText: '', order: 2 },
    { page: 'video-gallery', section: 'video-gallery-hero-title-highlight', title: 'Kütüphanemiz', subtitle: '', buttonText: '', order: 3 },
    { page: 'video-gallery', section: 'video-gallery-hero-subtitle', title: '', subtitle: '5000+ saatlik profesyonel ders videoları ile akademik başarınızı artırın.', buttonText: '', order: 4 },

    // Search
    { page: 'video-gallery', section: 'video-gallery-search-placeholder', title: 'Video, ders veya konu ara...', subtitle: '', buttonText: '', order: 5 },

    // Category Tabs
    { page: 'video-gallery', section: 'video-gallery-tab-all', title: 'Tüm Videolar', subtitle: '', buttonText: '', order: 6 },
    { page: 'video-gallery', section: 'video-gallery-tab-yks-tyt', title: 'YKS TYT', subtitle: '', buttonText: '', order: 7 },
    { page: 'video-gallery', section: 'video-gallery-tab-yks-ayt', title: 'YKS AYT', subtitle: '', buttonText: '', order: 8 },
    { page: 'video-gallery', section: 'video-gallery-tab-lgs', title: 'LGS', subtitle: '', buttonText: '', order: 9 },
    { page: 'video-gallery', section: 'video-gallery-tab-kpss', title: 'KPSS', subtitle: '', buttonText: '', order: 10 },

    // Empty State
    { page: 'video-gallery', section: 'video-gallery-empty-message', title: 'Aradığınız kriterlere uygun video bulunamadı.', subtitle: '', buttonText: '', order: 11 },
  ];

  for (const section of sections) {
    await prisma.homeSection.upsert({
      where: {
        page_section: {
          page: section.page,
          section: section.section,
        },
      },
      update: section,
      create: section,
    });
  }

  console.log('✅ Video Gallery page content seeded');
}

// Run if called directly
if (require.main === module) {
  seedVideoGalleryPage()
    .catch((e) => {
      console.error(e);
      process.exit(1);
    })
    .finally(async () => {
      await prisma.$disconnect();
    });
}
