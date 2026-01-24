import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function seedPackagesPage() {
  console.log('🌱 Seeding Packages Page content...');

  const packagesContent = [
    // Hero Section
    {
      page: 'packages',
      section: 'packages-hero-badge',
      title: 'Eğitim Paketlerimiz',
    },
    {
      page: 'packages',
      section: 'packages-hero-title',
      title: 'Başarıya Giden Yol',
    },
    {
      page: 'packages',
      section: 'packages-hero-subtitle',
      subtitle: 'İhtiyacınıza uygun paketi seçin ve akademik hedeflerinize ulaşın.',
    },

    // Filter Tabs
    {
      page: 'packages',
      section: 'packages-filter-all',
      title: 'Tüm Paketler',
    },
    {
      page: 'packages',
      section: 'packages-filter-yks2026',
      title: 'YKS 2026',
    },
    {
      page: 'packages',
      section: 'packages-filter-lgs2026',
      title: 'LGS 2026',
    },
    {
      page: 'packages',
      section: 'packages-filter-yks2027',
      title: 'YKS 2027',
    },
    {
      page: 'packages',
      section: 'packages-filter-9-10-11',
      title: '9-10-11. Sınıf',
    },
    {
      page: 'packages',
      section: 'packages-filter-kpss',
      title: 'KPSS',
    },
    {
      page: 'packages',
      section: 'packages-filter-dgs',
      title: 'DGS',
    },

    // Package Card Labels
    {
      page: 'packages',
      section: 'packages-card-popular',
      title: 'Popüler',
    },
    {
      page: 'packages',
      section: 'packages-card-new',
      title: 'Yeni',
    },
    {
      page: 'packages',
      section: 'packages-card-discount',
      title: 'İndirim',
    },
    {
      page: 'packages',
      section: 'packages-card-video-label',
      title: 'Video',
    },
    {
      page: 'packages',
      section: 'packages-card-duration-label',
      title: 'Süre',
    },
    {
      page: 'packages',
      section: 'packages-card-subject-label',
      title: 'Ders',
    },
    {
      page: 'packages',
      section: 'packages-card-content-label',
      title: 'Paket İçeriği',
    },
    {
      page: 'packages',
      section: 'packages-card-more-features',
      title: 'özellik daha',
    },
    {
      page: 'packages',
      section: 'packages-card-button',
      title: 'Detaylı İncele',
    },

    // Empty State
    {
      page: 'packages',
      section: 'packages-empty-message',
      title: 'Bu kategoriye ait paket bulunamadı.',
    },

    // Loading State
    {
      page: 'packages',
      section: 'packages-loading-message',
      title: 'Paketler yükleniyor...',
    },
  ];

  for (const content of packagesContent) {
    await prisma.homeSection.upsert({
      where: {
        page_section: {
          page: content.page,
          section: content.section,
        },
      },
      update: content,
      create: content,
    });
  }

  console.log('✅ Packages Page content seeded successfully');
}
