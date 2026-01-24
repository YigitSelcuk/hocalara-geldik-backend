import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function seedVideoLibraryPage() {
  console.log('🎥 Seeding Video Library page content...');

  const sections = [
    // Hero Section
    { page: 'video-library', section: 'video-hero-badge', title: 'Video Kütüphanesi', subtitle: '', buttonText: '', order: 1 },
    { page: 'video-library', section: 'video-hero-title', title: '5000+ Saat', subtitle: '', buttonText: '', order: 2 },
    { page: 'video-library', section: 'video-hero-title-highlight', title: 'Ders İçeriği', subtitle: '', buttonText: '', order: 3 },
    { page: 'video-library', section: 'video-hero-subtitle', title: '', subtitle: 'Tüm derslere ait binlerce video ders, konu anlatımı ve soru çözümü ile sınırsız erişim. İstediğiniz zaman, istediğiniz yerden öğrenin.', buttonText: '', order: 4 },

    // İstatistikler
    { page: 'video-library', section: 'video-stats-badge', title: 'Rakamlarla Video Kütüphanemiz', subtitle: '', buttonText: '', order: 5 },
    { page: 'video-library', section: 'video-stats-title', title: 'Sınırsız', subtitle: '', buttonText: '', order: 6 },
    { page: 'video-library', section: 'video-stats-title-highlight', title: 'Eğitim İçeriği', subtitle: '', buttonText: '', order: 7 },
    
    { page: 'video-library', section: 'video-stat1-value', title: '5000+', subtitle: '', buttonText: '', order: 8 },
    { page: 'video-library', section: 'video-stat1-label', title: 'Saat Video', subtitle: '', buttonText: '', order: 9 },
    
    { page: 'video-library', section: 'video-stat2-value', title: '15K+', subtitle: '', buttonText: '', order: 10 },
    { page: 'video-library', section: 'video-stat2-label', title: 'Video Ders', subtitle: '', buttonText: '', order: 11 },
    
    { page: 'video-library', section: 'video-stat3-value', title: '50+', subtitle: '', buttonText: '', order: 12 },
    { page: 'video-library', section: 'video-stat3-label', title: 'Öğretmen', subtitle: '', buttonText: '', order: 13 },
    
    { page: 'video-library', section: 'video-stat4-value', title: '100K+', subtitle: '', buttonText: '', order: 14 },
    { page: 'video-library', section: 'video-stat4-label', title: 'İzlenme', subtitle: '', buttonText: '', order: 15 },

    // Kategoriler
    { page: 'video-library', section: 'video-categories-title', title: 'Ders', subtitle: '', buttonText: '', order: 16 },
    { page: 'video-library', section: 'video-categories-title-highlight', title: 'Kategorileri', subtitle: '', buttonText: '', order: 17 },
    { page: 'video-library', section: 'video-categories-subtitle', title: '', subtitle: 'Tüm derslere ait kapsamlı video içerikleri', buttonText: '', order: 18 },

    // Özellikler
    { page: 'video-library', section: 'video-features-title', title: 'Video Kütüphanesi', subtitle: '', buttonText: '', order: 19 },
    { page: 'video-library', section: 'video-features-title-highlight', title: 'Özellikleri', subtitle: '', buttonText: '', order: 20 },

    { page: 'video-library', section: 'video-feature1-title', title: 'HD Kalite', subtitle: '', buttonText: '', order: 21 },
    { page: 'video-library', section: 'video-feature1-desc', title: '', subtitle: 'Tüm videolar Full HD kalitede, net görüntü ve ses ile hazırlanmıştır.', buttonText: '', order: 22 },
    
    { page: 'video-library', section: 'video-feature2-title', title: 'Konu Bazlı', subtitle: '', buttonText: '', order: 23 },
    { page: 'video-library', section: 'video-feature2-desc', title: '', subtitle: 'Her konu detaylı şekilde işlenmiş, adım adım anlatım ile öğrenin.', buttonText: '', order: 24 },
    
    { page: 'video-library', section: 'video-feature3-title', title: 'Sınırsız Erişim', subtitle: '', buttonText: '', order: 25 },
    { page: 'video-library', section: 'video-feature3-desc', title: '', subtitle: '7/24 erişim, istediğiniz zaman istediğiniz yerden izleyebilirsiniz.', buttonText: '', order: 26 },
    
    { page: 'video-library', section: 'video-feature4-title', title: 'Uzman Öğretmenler', subtitle: '', buttonText: '', order: 27 },
    { page: 'video-library', section: 'video-feature4-desc', title: '', subtitle: 'Alanında uzman öğretmenler tarafından hazırlanmış içerikler.', buttonText: '', order: 28 },
    
    { page: 'video-library', section: 'video-feature5-title', title: 'İnteraktif', subtitle: '', buttonText: '', order: 29 },
    { page: 'video-library', section: 'video-feature5-desc', title: '', subtitle: 'Videolar üzerinde not alma, işaretleme ve tekrar izleme özellikleri.', buttonText: '', order: 30 },
    
    { page: 'video-library', section: 'video-feature6-title', title: 'Sürekli Güncelleme', subtitle: '', buttonText: '', order: 31 },
    { page: 'video-library', section: 'video-feature6-desc', title: '', subtitle: 'Her hafta yeni videolar ekleniyor, içerik sürekli genişliyor.', buttonText: '', order: 32 },

    // CTA
    { page: 'video-library', section: 'video-cta-title', title: 'Binlerce Video Derse', subtitle: '', buttonText: '', order: 33 },
    { page: 'video-library', section: 'video-cta-title-highlight', title: 'Hemen Erişin', subtitle: '', buttonText: '', order: 34 },
    { page: 'video-library', section: 'video-cta-subtitle', title: '', subtitle: 'Kayıt olun ve 5000+ saat video içeriğe sınırsız erişim kazanın.', buttonText: '', order: 35 },
    { page: 'video-library', section: 'video-cta-button1', title: '', subtitle: '', buttonText: 'Video Galerisine Git', order: 36 },
    { page: 'video-library', section: 'video-cta-button2', title: '', subtitle: '', buttonText: 'Hemen Kayıt Ol', order: 37 },
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

  console.log('✅ Video Library page content seeded');
}

// Run if called directly
if (require.main === module) {
  seedVideoLibraryPage()
    .catch((e) => {
      console.error(e);
      process.exit(1);
    })
    .finally(async () => {
      await prisma.$disconnect();
    });
}
