import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function seedBranchesPage() {
  console.log('🌱 Seeding Branches Page content...');

  const branchesContent = [
    // Hero Section
    {
      page: 'branches',
      section: 'branches-hero-title',
      title: 'Türkiye Şubelerimiz',
    },
    {
      page: 'branches',
      section: 'branches-hero-subtitle',
      subtitle: '81 şubemiz ve binlerce öğrencimizle kocaman bir aileyiz. Size en yakın şubeyi bulup hemen başlayın.',
    },
    {
      page: 'branches',
      section: 'branches-hero-search-label',
      title: 'Şube bul',
    },
    {
      page: 'branches',
      section: 'branches-hero-search-placeholder',
      subtitle: 'İl veya ilçe ara...',
    },

    // View Toggle
    {
      page: 'branches',
      section: 'branches-view-list',
      title: 'Liste görünümü',
    },
    {
      page: 'branches',
      section: 'branches-view-map',
      title: 'Harita görünümü',
    },

    // Branch Card
    {
      page: 'branches',
      section: 'branches-card-badge',
      title: 'Yeni dönem kayıtları',
    },
    {
      page: 'branches',
      section: 'branches-card-button',
      title: 'Şubeyi incele',
    },
    {
      page: 'branches',
      section: 'branches-card-empty',
      title: 'Aradığınız kriterde şube bulunamadı.',
    },
    {
      page: 'branches',
      section: 'branches-card-empty-button',
      title: 'Tüm listeyi gör',
    },

    // Map Info
    {
      page: 'branches',
      section: 'branches-map-info-title',
      title: 'Harita Navigasyonu',
    },
    {
      page: 'branches',
      section: 'branches-map-info-desc',
      description: 'Şube pinlerine tıklayarak detaylı bilgilere ulaşabilir ve Google Maps\'te açabilirsiniz.',
    },
    {
      page: 'branches',
      section: 'branches-map-total-label',
      title: 'Toplam Şube',
    },
    {
      page: 'branches',
      section: 'branches-map-detail-button',
      title: 'Şube Detayları',
    },
  ];

  for (const content of branchesContent) {
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

  console.log('✅ Branches Page content seeded successfully');
}
