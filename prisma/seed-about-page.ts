import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function seedAboutPage() {
  console.log('🔵 Seeding About page...');

  const aboutSections = [
    // Hero
    { section: 'about-hero-badge', title: 'Kurumsal' },
    { section: 'about-hero-title', title: 'Hakkımızda' },
    { section: 'about-hero-subtitle', subtitle: 'Türkiye\'nin öncü eğitim markası olarak, binlerce öğrencinin hayallerine ulaşmasına yardımcı oluyoruz.' },
    
    // Misyon
    { section: 'about-mission-title', title: 'Misyonumuz' },
    { section: 'about-mission-description', description: 'Öğrencilerimize en kaliteli eğitimi sunarak, akademik hedeflerine ulaşmalarını sağlamak ve geleceğin lider bireylerini yetiştirmek.' },
    { section: 'about-mission-item1', title: 'Kaliteli ve erişilebilir eğitim' },
    { section: 'about-mission-item2', title: 'Öğrenci odaklı yaklaşım' },
    { section: 'about-mission-item3', title: 'Sürekli gelişim ve yenilik' },
    { section: 'about-mission-item4', title: 'Toplumsal sorumluluk bilinci' },
    
    // Vizyon
    { section: 'about-vision-title', title: 'Vizyonumuz' },
    { section: 'about-vision-description', description: 'Türkiye\'nin en güvenilir ve tercih edilen eğitim kurumu olmak, dijital dönüşümde öncü rol oynamak ve uluslararası standartlarda eğitim hizmeti sunmak.' },
    { section: 'about-vision-item1', title: 'Teknoloji destekli eğitim' },
    { section: 'about-vision-item2', title: 'Uluslararası standartlar' },
    { section: 'about-vision-item3', title: 'Sektörde liderlik' },
    { section: 'about-vision-item4', title: 'Sürdürülebilir başarı' },
    
    // Değerler
    { section: 'about-values-badge', title: 'Değerlerimiz' },
    { section: 'about-values-title', title: 'Temel Değerlerimiz' },
    { section: 'about-value1-title', title: 'Öğrenci Odaklılık' },
    { section: 'about-value1-desc', description: 'Her öğrencimizin ihtiyaçlarına özel çözümler üretiyoruz' },
    { section: 'about-value2-title', title: 'Kalite' },
    { section: 'about-value2-desc', description: 'En yüksek eğitim standartlarını koruyoruz' },
    { section: 'about-value3-title', title: 'Takım Çalışması' },
    { section: 'about-value3-desc', description: 'Güçlü ekip ruhuyla hareket ediyoruz' },
    { section: 'about-value4-title', title: 'Sürekli Gelişim' },
    { section: 'about-value4-desc', description: 'Kendimizi ve sistemlerimizi sürekli geliştiriyoruz' },
    
    // İstatistikler
    { section: 'about-stat1-value', title: '15+' },
    { section: 'about-stat1-label', subtitle: 'Yıllık Deneyim' },
    { section: 'about-stat2-value', title: '81' },
    { section: 'about-stat2-label', subtitle: 'İlde Şube' },
    { section: 'about-stat3-value', title: '50K+' },
    { section: 'about-stat3-label', subtitle: 'Mezun Öğrenci' },
    { section: 'about-stat4-value', title: '%98' },
    { section: 'about-stat4-label', subtitle: 'Başarı Oranı' },
    
    // CTA
    { section: 'about-cta-title', title: 'Başarı Hikayenizin Parçası Olun' },
    { section: 'about-cta-subtitle', subtitle: 'Binlerce öğrencinin tercih ettiği Hocalara Geldik ailesine katılın ve hayallerinize ulaşın.' },
    { section: 'about-cta-button1', buttonText: 'Şubelerimizi Keşfedin', buttonLink: '/subeler' },
    { section: 'about-cta-button2', buttonText: 'Bize Ulaşın', buttonLink: '/iletisim' },
  ];

  for (const sectionData of aboutSections) {
    await prisma.homeSection.upsert({
      where: { page_section: { page: 'about', section: sectionData.section } },
      update: sectionData,
      create: {
        page: 'about',
        ...sectionData,
        isActive: true
      }
    });
  }

  console.log('✅ About page seeded');
}

seedAboutPage()
  .catch((e) => {
    console.error('❌ Error seeding about page:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
