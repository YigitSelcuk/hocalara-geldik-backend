import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const homeSections = [
  // Hero Section
  {
    page: 'home',
    section: 'hero-subtitle',
    subtitle: 'Geleceğin Eğitim Vizyonu Burada',
    order: 1
  },
  {
    page: 'home',
    section: 'hero-button-primary',
    buttonText: 'Hemen Eğitime Başla',
    buttonLink: '/iletisim',
    order: 2
  },
  {
    page: 'home',
    section: 'hero-button-secondary',
    buttonText: 'Yeni Şubemiz Olun',
    buttonLink: '/franchise',
    order: 3
  },

  // Banner Cards
  {
    page: 'home',
    section: 'banner-card-1',
    title: 'Franchise Başvuru',
    description: 'Hocalara Geldik Ailesine Katılın',
    order: 4
  },
  {
    page: 'home',
    section: 'banner-card-2',
    title: 'Kayıt Başvurusu',
    description: 'Eğitiminize Hemen Başlayın',
    order: 5
  },
  {
    page: 'home',
    section: 'banner-card-3',
    title: 'Başarı Merkezleri',
    description: '81 İlde Güçlü Şube Ağı',
    order: 6
  },
  {
    page: 'home',
    section: 'banner-card-4',
    title: 'Dijital Platform',
    description: 'Yapay Zeka Destekli Eğitim',
    order: 7
  },
  {
    page: 'home',
    section: 'banner-card-5',
    title: 'YouTube',
    subtitle: 'Geleceğin Eğitim Platformu',
    description: 'Binlerce Ücretsiz İçerik',
    order: 8
  },

  // Başarı Merkezleri Section
  {
    page: 'home',
    section: 'centers-top-title',
    title: 'BAŞARI MERKEZLERİMİZ',
    order: 9
  },
  {
    page: 'home',
    section: 'centers-title',
    title: "Türkiye'nin En Büyük Eğitim Ağı",
    order: 10
  },
  {
    page: 'home',
    section: 'centers-subtitle',
    subtitle: '81 ilde güçlü şube ağımız, modern eğitim altyapımız ve uzman kadromuzla öğrencilerimize en kaliteli eğitimi sunuyoruz.',
    order: 11
  },
  {
    page: 'home',
    section: 'centers-button',
    buttonText: 'Şubelerimizi Keşfedin',
    buttonLink: '/subeler',
    order: 12
  },
  {
    page: 'home',
    section: 'centers-feature-1',
    title: 'Merkezi Eğitim Sistemi ile Standart Kalite',
    order: 13
  },
  {
    page: 'home',
    section: 'centers-feature-2',
    title: 'Her Şubede Uzman Öğretmen Kadrosu',
    order: 14
  },
  {
    page: 'home',
    section: 'centers-feature-3',
    title: 'Modern Derslik ve Laboratuvar İmkanları',
    order: 15
  },
  {
    page: 'home',
    section: 'centers-feature-4',
    title: 'Dijital Platform Entegrasyonu',
    order: 16
  },
  {
    page: 'home',
    section: 'centers-feature-5',
    title: 'Veli Bilgilendirme ve Takip Sistemi',
    order: 17
  },

  // Dijital Platform Section
  {
    page: 'home',
    section: 'digital-top-title',
    title: 'DİJİTAL EĞİTİM SİSTEMİ',
    order: 18
  },
  {
    page: 'home',
    section: 'digital-title',
    title: 'Yapay Zeka Destekli Eğitim Platformu',
    order: 19
  },
  {
    page: 'home',
    section: 'digital-subtitle',
    subtitle: 'Öğrenciler ve veliler için geliştirdiğimiz dijital altyapı ile eğitim sürecini her adımda takip edin ve kişiselleştirilmiş öğrenme deneyimi yaşayın.',
    order: 20
  },

  // Yurt Dışı Section
  {
    page: 'home',
    section: 'global-title',
    title: 'Hocalara Geldik Yurt Dışı',
    order: 21
  },
  {
    page: 'home',
    section: 'global-subtitle',
    subtitle: "Dünya'nın en prestijli üniversitelerine yerleşme hayalinizi gerçeğe dönüştürüyoruz",
    order: 22
  },

  // YouTube Section
  {
    page: 'home',
    section: 'youtube-top-title',
    title: 'DİJİTAL İÇERİKLERİMİZ',
    order: 23
  },
  {
    page: 'home',
    section: 'youtube-title',
    title: 'YouTube Kanallarımız ve Sosyal Medya',
    order: 24
  },
  {
    page: 'home',
    section: 'youtube-subtitle',
    subtitle: 'Binlerce ücretsiz ders videosu ve güncel içeriklerimiz için kanallarımıza abone olun, sosyal medyada bizi takip edin!',
    order: 25
  },
  {
    page: 'home',
    section: 'youtube-social-title',
    title: 'Sosyal Medyada Bizi Takip Edin',
    order: 26
  },
  {
    page: 'home',
    section: 'youtube-social-subtitle',
    subtitle: 'Güncel duyurular, motivasyon içerikleri ve daha fazlası için sosyal medya hesaplarımızı takip edin!',
    order: 27
  },

  // Blog Section
  {
    page: 'home',
    section: 'blog-top-title',
    title: 'REHBERLİK VE İÇERİKLER',
    order: 28
  },
  {
    page: 'home',
    section: 'blog-title',
    title: 'Rehberlik ve Blog Notları',
    order: 29
  },
  {
    page: 'home',
    section: 'blog-subtitle',
    subtitle: 'Akademik ve psikolojik destek yazıları, sınav stratejileri ve motivasyon içerikleri ile başarıya giden yolda yanınızdayız.',
    order: 30
  },

  // Calculator Section
  {
    page: 'home',
    section: 'calculator-badge',
    title: 'Puan Hesaplama Araçları',
    order: 31
  },
  {
    page: 'home',
    section: 'calculator-title',
    title: 'Sınav Puanınızı Hesaplayın',
    order: 32
  },
  {
    page: 'home',
    section: 'calculator-subtitle',
    subtitle: 'Net sayılarınızı girerek yaklaşık sınav puanınızı hesaplayabilir ve hedeflerinize ne kadar yakın olduğunuzu görebilirsiniz.',
    order: 33
  },
  {
    page: 'home',
    section: 'calculator-button',
    buttonText: 'Hesaplama Araçlarına Git',
    buttonLink: '/hesaplama',
    order: 34
  },

  // Tools Section
  {
    page: 'home',
    section: 'tools-top-title',
    title: 'ÇALIŞMA ARAÇLARI',
    order: 35
  },
  {
    page: 'home',
    section: 'tools-title',
    title: 'Sınav Geri Sayımı ve Pomodoro',
    order: 36
  },
  {
    page: 'home',
    section: 'tools-subtitle',
    subtitle: 'Sınavınıza kalan süreyi takip edin ve Pomodoro tekniği ile verimli çalışma seansları oluşturun.',
    order: 37
  },
  {
    page: 'home',
    section: 'tools-countdown-title',
    title: 'Sınava Kalan Süre',
    order: 38
  },
  {
    page: 'home',
    section: 'tools-pomodoro-title',
    title: 'Pomodoro Zamanlayıcı',
    order: 39
  },

  // Packages Section
  {
    page: 'home',
    section: 'packages-top-title',
    title: 'EĞİTİM PAKETLERİMİZ',
    order: 40
  },
  {
    page: 'home',
    section: 'packages-title',
    title: 'Size Uygun Paketi Seçin',
    order: 41
  },
  {
    page: 'home',
    section: 'packages-subtitle',
    subtitle: 'İhtiyacınıza uygun eğitim paketi ile akademik hedeflerinize ulaşın.',
    order: 42
  },
  {
    page: 'home',
    section: 'packages-button',
    buttonText: 'Tüm Paketleri İncele',
    buttonLink: '/paketler',
    order: 43
  },

  // CTA Section
  {
    page: 'home',
    section: 'cta-badge',
    title: 'Sıradaki Başarı Öyküsü...',
    order: 44
  },
  {
    page: 'home',
    section: 'cta-question',
    title: 'Neden Sizin Başarı Hikayeniz Olmasın?',
    order: 45
  },
  {
    page: 'home',
    section: 'cta-main-title',
    title: 'Geleceği El Birliğiyle İnşa Edelim.',
    order: 46
  },
  {
    page: 'home',
    section: 'cta-description',
    description: 'Akademik Hedeflerinize Ulaşmanız İçin Uzman Kadromuz, Modern Eğitim Materyallerimiz Ve Dijital Çözümlerimizle Yanınızdayız.',
    order: 47
  },
  {
    page: 'home',
    section: 'cta-button-primary',
    buttonText: 'Hemen Kayıt Başvurusu',
    buttonLink: '/subeler',
    order: 48
  },
  {
    page: 'home',
    section: 'cta-button-secondary',
    buttonText: 'Akademik Şubemiz Olun',
    buttonLink: '/franchise',
    order: 49
  },
  {
    page: 'home',
    section: 'cta-testimonial',
    description: '81 Şehirde Binlerce Öğrenci Geleceğine Güvenle Hazırlanıyor.',
    order: 50
  },
];

async function seedHomeSections() {
  console.log('🌱 Seeding home sections...');

  for (const section of homeSections) {
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

  console.log('✅ Home sections seeded successfully!');
}

seedHomeSections()
  .catch((e) => {
    console.error('❌ Error seeding home sections:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
