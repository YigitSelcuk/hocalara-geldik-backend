import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding statistics and features...');

  // Statistics
  const statistics = [
    {
      value: '81',
      label: 'İl',
      icon: '🏛️',
      order: 1
    },
    {
      value: '250+',
      label: 'Şube',
      icon: '🏫',
      order: 2
    },
    {
      value: '1500+',
      label: 'Öğretmen',
      icon: '👨‍🏫',
      order: 3
    },
    {
      value: '50K+',
      label: 'Öğrenci',
      icon: '🎓',
      order: 4
    }
  ];

  for (const stat of statistics) {
    await prisma.statistic.upsert({
      where: { id: 'temp-stat-' + stat.order },
      update: stat,
      create: stat
    });
  }

  // Features for Centers section
  const centerFeatures = [
    {
      title: 'Merkezi Eğitim Sistemi ile Standart Kalite',
      description: 'Tüm şubelerimizde aynı kalitede eğitim',
      icon: '✅',
      section: 'centers',
      order: 1
    },
    {
      title: 'Her Şubede Uzman Öğretmen Kadrosu',
      description: 'Alanında uzman öğretmenler',
      icon: '✅',
      section: 'centers',
      order: 2
    },
    {
      title: 'Modern Derslik ve Laboratuvar İmkanları',
      description: 'En son teknoloji ile donatılmış sınıflar',
      icon: '✅',
      section: 'centers',
      order: 3
    },
    {
      title: 'Dijital Platform Entegrasyonu',
      description: 'Online ve offline eğitim bir arada',
      icon: '✅',
      section: 'centers',
      order: 4
    },
    {
      title: 'Veli Bilgilendirme ve Takip Sistemi',
      description: 'Öğrenci gelişimini anlık takip',
      icon: '✅',
      section: 'centers',
      order: 5
    }
  ];

  for (const feature of centerFeatures) {
    await prisma.feature.upsert({
      where: { id: 'temp-feature-' + feature.section + '-' + feature.order },
      update: feature,
      create: feature
    });
  }

  // Features for Digital section
  const digitalFeatures = [
    {
      title: 'Öğrenci Paneli',
      description: 'Kişiye özel ders programı, performans takibi ve yapay zeka destekli analiz raporları',
      icon: '💻',
      section: 'digital',
      order: 1,
      features: ['Ders Programı', 'Sınav Sonuçları', 'İlerleme Grafikleri']
    },
    {
      title: 'Veli Takip Sistemi',
      description: 'Çocuğunuzun akademik gelişimini anlık olarak takip edin ve raporlara erişin',
      icon: '👥',
      section: 'digital',
      order: 2,
      features: ['Devam Takibi', 'Not Bildirimleri', 'Öğretmen Görüşmeleri']
    },
    {
      title: 'Mobil Uygulama',
      description: 'iOS ve Android uygulamalarımızla her yerden eğitime erişim imkanı',
      icon: '📱',
      section: 'digital',
      order: 3,
      features: ['Canlı Dersler', 'Video Arşivi', 'Soru Çözüm']
    },
    {
      title: 'Yapay Zeka Analizi',
      description: 'Öğrenme stilinize göre kişiselleştirilmiş içerik önerileri ve çalışma planı',
      icon: '🧠',
      section: 'digital',
      order: 4,
      features: ['Eksik Analizi', 'Öneri Sistemi', 'Hedef Belirleme']
    }
  ];

  for (const feature of digitalFeatures) {
    await prisma.feature.upsert({
      where: { id: 'temp-feature-' + feature.section + '-' + feature.order },
      update: feature,
      create: feature
    });
  }

  // Features for Global section
  const globalFeatures = [
    {
      title: 'Yurt Dışı Danışmanlık',
      description: 'Üniversite seçiminden vize sürecine kadar tüm aşamalarda profesyonel destek',
      icon: '🎯',
      section: 'global',
      order: 1,
      features: ['Üniversite Seçimi', 'Başvuru Süreci', 'Vize Danışmanlığı', 'Burs İmkanları']
    },
    {
      title: 'Dil Eğitimi',
      description: 'TOEFL, IELTS, SAT ve diğer uluslararası sınavlara hazırlık programları',
      icon: '📚',
      section: 'global',
      order: 2,
      features: ['TOEFL Hazırlık', 'IELTS Kursu', 'SAT Eğitimi', 'Akademik İngilizce']
    },
    {
      title: 'Üniversite Yerleştirme',
      description: 'ABD, İngiltere, Kanada ve Avrupa üniversitelerine başarılı yerleştirme',
      icon: '🎓',
      section: 'global',
      order: 3,
      features: ['Profil Oluşturma', 'Essay Desteği', 'Mülakat Hazırlığı', 'Takip Sistemi']
    }
  ];

  for (const feature of globalFeatures) {
    await prisma.feature.upsert({
      where: { id: 'temp-feature-' + feature.section + '-' + feature.order },
      update: feature,
      create: feature
    });
  }

  console.log('✅ Statistics and features seeded successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Error seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
