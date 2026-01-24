import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const pageContents = [
  // ANASAYFA - Hero Slider
  {
    page: 'home',
    section: 'hero-subtitle',
    subtitle: 'Geleceğin Eğitim Vizyonu Burada',
  },
  {
    page: 'home',
    section: 'hero-button-primary',
    buttonText: 'Hemen Eğitime Başla',
    buttonLink: '/subeler',
  },
  {
    page: 'home',
    section: 'hero-button-secondary',
    buttonText: 'Yeni Şubemiz Olun',
    buttonLink: '/franchise',
  },

  // ANASAYFA - Banner Kartları (Default değerler)
  {
    page: 'home',
    section: 'banner-card-1',
    title: 'Franchise Başvuru',
    description: 'Hocalara Geldik Ailesine Katılın',
  },
  {
    page: 'home',
    section: 'banner-card-2',
    title: 'Kayıt Başvurusu',
    description: 'Eğitiminize Hemen Başlayın',
  },
  {
    page: 'home',
    section: 'banner-card-3',
    title: 'Başarı Merkezleri',
    description: '81 İlde Güçlü Şube Ağı',
  },
  {
    page: 'home',
    section: 'banner-card-4',
    title: 'Dijital Platform',
    description: 'Yapay Zeka Destekli Eğitim',
  },
  {
    page: 'home',
    section: 'banner-card-5',
    title: 'YouTube Kanalı',
    description: 'Binlerce Ücretsiz İçerik',
    subtitle: 'Geleceğin Eğitim Platformu',
  },

  // ANASAYFA - Başarı Merkezleri
  {
    page: 'home',
    section: 'centers-top-title',
    title: 'BAŞARI MERKEZLERİMİZ',
  },
  {
    page: 'home',
    section: 'centers-title',
    title: 'Türkiye\'nin En Büyük Eğitim Ağı',
  },
  {
    page: 'home',
    section: 'centers-subtitle',
    subtitle: '81 ilde güçlü şube ağımız, modern eğitim altyapımız ve uzman kadromuzla öğrencilerimize en kaliteli eğitimi sunuyoruz',
  },
  {
    page: 'home',
    section: 'centers-button',
    buttonText: 'Şubelerimizi Keşfedin',
    buttonLink: '/subeler',
  },
  {
    page: 'home',
    section: 'centers-feature-1',
    title: 'Merkezi Eğitim Sistemi ile Standart Kalite',
  },
  {
    page: 'home',
    section: 'centers-feature-2',
    title: 'Her Şubede Uzman Öğretmen Kadrosu',
  },
  {
    page: 'home',
    section: 'centers-feature-3',
    title: 'Modern Derslik ve Laboratuvar İmkanları',
  },
  {
    page: 'home',
    section: 'centers-feature-4',
    title: 'Dijital Platform Entegrasyonu',
  },
  {
    page: 'home',
    section: 'centers-feature-5',
    title: 'Veli Bilgilendirme ve Takip Sistemi',
  },

  // ANASAYFA - Dijital Platform
  {
    page: 'home',
    section: 'digital-top-title',
    title: 'DİJİTAL EĞİTİM SİSTEMİ',
  },
  {
    page: 'home',
    section: 'digital-title',
    title: 'Yapay Zeka Destekli Eğitim Platformu',
  },
  {
    page: 'home',
    section: 'digital-subtitle',
    subtitle: 'Öğrenciler ve veliler için geliştirdiğimiz dijital altyapı ile eğitim sürecini her adımda takip edin ve kişiselleştirilmiş öğrenme deneyimi yaşayın',
  },
  {
    page: 'home',
    section: 'digital-feature-1-title',
    title: 'Öğrenci Paneli',
  },
  {
    page: 'home',
    section: 'digital-feature-1-desc',
    description: 'Kişiye özel ders programı, performans takibi ve yapay zeka destekli analiz raporları',
  },
  {
    page: 'home',
    section: 'digital-feature-2-title',
    title: 'Veli Takip Sistemi',
  },
  {
    page: 'home',
    section: 'digital-feature-2-desc',
    description: 'Çocuğunuzun akademik gelişimini anlık olarak takip edin ve raporlara erişin',
  },
  {
    page: 'home',
    section: 'digital-feature-3-title',
    title: 'Mobil Uygulama',
  },
  {
    page: 'home',
    section: 'digital-feature-3-desc',
    description: 'iOS ve Android uygulamalarımızla her yerden eğitime erişim imkanı',
  },
  {
    page: 'home',
    section: 'digital-feature-4-title',
    title: 'Yapay Zeka Analizi',
  },
  {
    page: 'home',
    section: 'digital-feature-4-desc',
    description: 'Öğrenme stilinize göre kişiselleştirilmiş içerik önerileri ve çalışma planı',
  },

  // ANASAYFA - Yurtdışı Eğitim
  {
    page: 'home',
    section: 'global-title',
    title: 'Hocalara Geldik Yurt Dışı',
  },
  {
    page: 'home',
    section: 'global-subtitle',
    subtitle: 'Dünya\'nın en prestijli üniversitelerine yerleşme hayalinizi gerçeğe dönüştürüyoruz',
  },
  {
    page: 'home',
    section: 'global-feature-1-title',
    title: 'Yurt Dışı Danışmanlık',
  },
  {
    page: 'home',
    section: 'global-feature-1-desc',
    description: 'Üniversite seçiminden vize sürecine kadar tüm aşamalarda profesyonel destek',
  },
  {
    page: 'home',
    section: 'global-feature-2-title',
    title: 'Dil Eğitimi',
  },
  {
    page: 'home',
    section: 'global-feature-2-desc',
    description: 'TOEFL, IELTS, SAT ve diğer uluslararası sınavlara hazırlık programları',
  },
  {
    page: 'home',
    section: 'global-feature-3-title',
    title: 'Üniversite Yerleştirme',
  },
  {
    page: 'home',
    section: 'global-feature-3-desc',
    description: 'ABD, İngiltere, Kanada ve Avrupa üniversitelerine başarılı yerleştirme',
  },

  // ANASAYFA - YouTube ve Sosyal Medya
  {
    page: 'home',
    section: 'youtube-top-title',
    title: 'DİJİTAL İÇERİKLERİMİZ',
  },
  {
    page: 'home',
    section: 'youtube-title',
    title: 'YouTube Kanallarımız ve Sosyal Medya',
  },
  {
    page: 'home',
    section: 'youtube-subtitle',
    subtitle: 'Binlerce ücretsiz ders videosu ve güncel içeriklerimiz için kanallarımıza abone olun, sosyal medyada bizi takip edin!',
  },
  {
    page: 'home',
    section: 'social-title',
    title: 'Sosyal Medyada Bizi Takip Edin',
  },
  {
    page: 'home',
    section: 'social-subtitle',
    subtitle: 'Güncel duyurular, motivasyon içerikleri ve daha fazlası için sosyal medya hesaplarımızı takip edin!',
  },

  // ANASAYFA - Blog ve Rehberlik
  {
    page: 'home',
    section: 'blog-top-title',
    title: 'REHBERLİK VE İÇERİKLER',
  },
  {
    page: 'home',
    section: 'blog-title',
    title: 'Rehberlik ve Blog Notları',
  },
  {
    page: 'home',
    section: 'blog-subtitle',
    subtitle: 'Akademik ve psikolojik destek yazıları, sınav stratejileri ve motivasyon içerikleri ile başarıya giden yolda yanınızdayız',
  },

  // ANASAYFA - Puan Hesaplama
  {
    page: 'home',
    section: 'calculator-badge',
    title: 'Puan Hesaplama Araçları',
  },
  {
    page: 'home',
    section: 'calculator-title',
    title: 'Sınav Puanınızı Hesaplayın',
  },
  {
    page: 'home',
    section: 'calculator-subtitle',
    subtitle: 'Net sayılarınızı girerek yaklaşık sınav puanınızı hesaplayabilir ve hedeflerinize ne kadar yakın olduğunuzu görebilirsiniz',
  },
  {
    page: 'home',
    section: 'calculator-button',
    buttonText: 'Hesaplama Araçlarına Git',
    buttonLink: '/hesaplama',
  },

  // ANASAYFA - Çalışma Araçları
  {
    page: 'home',
    section: 'tools-top-title',
    title: 'ÇALIŞMA ARAÇLARI',
  },
  {
    page: 'home',
    section: 'tools-title',
    title: 'Sınav Geri Sayımı ve Pomodoro',
  },
  {
    page: 'home',
    section: 'tools-subtitle',
    subtitle: 'Sınavınıza kalan süreyi takip edin ve Pomodoro tekniği ile verimli çalışma seansları oluşturun',
  },
  {
    page: 'home',
    section: 'countdown-title',
    title: 'Sınava Kalan Süre',
  },
  {
    page: 'home',
    section: 'pomodoro-title',
    title: 'Pomodoro Zamanlayıcı',
  },

  // ANASAYFA - Paketler
  {
    page: 'home',
    section: 'packages-top-title',
    title: 'EĞİTİM PAKETLERİMİZ',
  },
  {
    page: 'home',
    section: 'packages-title',
    title: 'Size Uygun Paketi Seçin',
  },
  {
    page: 'home',
    section: 'packages-subtitle',
    subtitle: 'İhtiyacınıza uygun eğitim paketi ile akademik hedeflerinize ulaşın',
  },
  {
    page: 'home',
    section: 'packages-button',
    buttonText: 'Tüm Paketleri İncele',
    buttonLink: '/paketler',
  },

  // ANASAYFA - CTA
  {
    page: 'home',
    section: 'cta-badge',
    title: 'Sıradaki Başarı Öyküsü...',
  },
  {
    page: 'home',
    section: 'cta-question',
    title: 'Neden Sizin Başarı Hikayeniz Olmasın?',
  },
  {
    page: 'home',
    section: 'cta-main-title',
    title: 'Geleceği El Birliğiyle İnşa Edelim',
  },
  {
    page: 'home',
    section: 'cta-description',
    description: 'Akademik Hedeflerinize Ulaşmanız İçin Uzman Kadromuz, Modern Eğitim Materyallerimiz Ve Dijital Çözümlerimizle Yanınızdayız',
  },
  {
    page: 'home',
    section: 'cta-button-primary',
    buttonText: 'Hemen Kayıt Başvurusu',
    buttonLink: '/subeler',
  },
  {
    page: 'home',
    section: 'cta-button-secondary',
    buttonText: 'Akademik Şubemiz Olun',
    buttonLink: '/franchise',
  },
  {
    page: 'home',
    section: 'cta-testimonial',
    description: '81 Şehirde Binlerce Öğrenci Geleceğine Güvenle Hazırlanıyor',
  },

  // HAKKIMIZDA
  {
    page: 'about',
    section: 'hero',
    title: 'Hakkımızda',
    subtitle: 'Türkiye\'nin en büyük eğitim ailesi',
  },
  {
    page: 'about',
    section: 'mission',
    title: 'Misyonumuz',
    description: 'Öğrencilerimize en kaliteli eğitimi sunarak geleceğin liderlerini yetiştirmek',
  },
  {
    page: 'about',
    section: 'vision',
    title: 'Vizyonumuz',
    description: 'Türkiye\'nin en güvenilir ve tercih edilen eğitim kurumu olmak',
  },
  {
    page: 'about',
    section: 'values',
    title: 'Değerlerimiz',
    description: 'Kalite, güven, yenilikçilik ve öğrenci odaklılık',
  },
  {
    page: 'about',
    section: 'history',
    title: 'Tarihçemiz',
    content: 'Yılların deneyimi ve binlerce başarı hikayesi ile eğitimde öncü kurum',
  },

  // ŞUBELER
  {
    page: 'branches',
    section: 'hero',
    title: 'Şubelerimiz',
    subtitle: '81 İlde Güçlü Şube Ağı',
  },
  {
    page: 'branches',
    section: 'intro',
    title: 'Size En Yakın Şubeyi Bulun',
    description: 'Türkiye\'nin her yerinde modern eğitim merkezlerimizle hizmetinizdeyiz',
  },
  {
    page: 'branches',
    section: 'cta',
    title: 'Hemen Kayıt Olun',
    buttonText: 'Şube Bul',
    buttonLink: '/subeler',
  },

  // ÖĞRETMENLER
  {
    page: 'teachers',
    section: 'hero',
    title: 'Öğretmen Kadromuz',
    subtitle: 'Alanında uzman, deneyimli eğitmenler',
  },
  {
    page: 'teachers',
    section: 'intro',
    title: 'Başarının Anahtarı: Kaliteli Eğitim',
    description: 'Her biri alanında uzman, deneyimli ve öğrenci odaklı öğretmenlerimizle başarıya ulaşın',
  },
  {
    page: 'teachers',
    section: 'quality',
    title: 'Kalite Standartlarımız',
    description: 'Tüm öğretmenlerimiz düzenli eğitim ve gelişim programlarından geçer',
  },

  // BAŞARILAR
  {
    page: 'success',
    section: 'hero',
    title: 'Başarı Hikayelerimiz',
    subtitle: 'Gurur Tablomuz',
  },
  {
    page: 'success',
    section: 'intro',
    title: 'Her Yıl Binlerce Öğrenci',
    description: 'Öğrencilerimiz hayallerindeki üniversitelere yerleşiyor',
  },
  {
    page: 'success',
    section: 'cta',
    title: 'Sıradaki Başarı Hikayesi Senin Olsun',
    buttonText: 'Hemen Başla',
    buttonLink: '/iletisim',
  },

  // PAKETLER
  {
    page: 'packages',
    section: 'hero',
    title: 'Eğitim Paketlerimiz',
    subtitle: 'Size özel eğitim çözümleri',
  },
  {
    page: 'packages',
    section: 'intro',
    title: 'İhtiyacınıza Uygun Paket',
    description: 'Farklı ihtiyaçlara yönelik özel olarak tasarlanmış eğitim paketlerimiz',
  },
  {
    page: 'packages',
    section: 'cta',
    title: 'Paketleri İnceleyin',
    buttonText: 'Tüm Paketler',
    buttonLink: '/paketler',
  },

  // VİDEO KÜTÜPHANESİ
  {
    page: 'videos',
    section: 'hero',
    title: 'Video Kütüphanesi',
    subtitle: 'Binlerce ücretsiz eğitim videosu',
  },
  {
    page: 'videos',
    section: 'intro',
    title: 'Her Zaman Yanınızda',
    description: 'Tüm dersler için kapsamlı video arşivimizle istediğiniz zaman çalışın',
  },
  {
    page: 'videos',
    section: 'categories',
    title: 'Video Kategorileri',
    subtitle: 'Tüm dersler ve konular için videolar',
  },

  // DİJİTAL PLATFORM
  {
    page: 'digital',
    section: 'hero',
    title: 'Dijital Eğitim Platformu',
    subtitle: 'Yapay zeka destekli öğrenme deneyimi',
    buttonText: 'Platform\'u Keşfet',
    buttonLink: '/dijital-platform',
  },
  {
    page: 'digital',
    section: 'features',
    title: 'Platform Özellikleri',
    description: 'Kişiselleştirilmiş öğrenme, canlı dersler, soru çözümü ve daha fazlası',
  },
  {
    page: 'digital',
    section: 'benefits',
    title: 'Avantajlar',
    description: 'Her yerden erişim, performans takibi, yapay zeka analizi',
  },
  {
    page: 'digital',
    section: 'cta',
    title: 'Hemen Başlayın',
    buttonText: 'Ücretsiz Dene',
    buttonLink: '/kayit',
  },

  // YURTDIŞI EĞİTİM
  {
    page: 'international',
    section: 'hero',
    title: 'Yurtdışı Eğitim Danışmanlığı',
    subtitle: 'Dünya üniversitelerine açılan kapınız',
  },
  {
    page: 'international',
    section: 'intro',
    title: 'Hayalinizdeki Üniversite',
    description: 'ABD, İngiltere, Kanada ve Avrupa üniversitelerine başarılı yerleştirme',
  },
  {
    page: 'international',
    section: 'services',
    title: 'Hizmetlerimiz',
    description: 'Üniversite seçimi, başvuru süreci, vize danışmanlığı ve daha fazlası',
  },
  {
    page: 'international',
    section: 'cta',
    title: 'Danışmanlık Alın',
    buttonText: 'Randevu Oluştur',
    buttonLink: '/iletisim',
  },

  // FRANCHISE
  {
    page: 'franchise',
    section: 'hero',
    title: 'Franchise Fırsatı',
    subtitle: 'Hocalara Geldik ailesine katılın',
    buttonText: 'Başvuru Yap',
    buttonLink: '/franchise',
  },
  {
    page: 'franchise',
    section: 'intro',
    title: 'Başarılı Bir İş Modeli',
    description: 'Türkiye\'nin en büyük eğitim ağının bir parçası olun',
  },
  {
    page: 'franchise',
    section: 'benefits',
    title: 'Franchise Avantajları',
    description: 'Güçlü marka, merkezi destek, eğitim programları ve pazarlama desteği',
  },
  {
    page: 'franchise',
    section: 'requirements',
    title: 'Gereksinimler',
    description: 'Franchise olmak için gerekli şartlar ve yatırım bilgileri',
  },
  {
    page: 'franchise',
    section: 'cta',
    title: 'Hemen Başvurun',
    buttonText: 'Franchise Başvurusu',
    buttonLink: '/franchise',
  },

  // İLETİŞİM
  {
    page: 'contact',
    section: 'hero',
    title: 'İletişim',
    subtitle: 'Bize ulaşın, size yardımcı olalım',
  },
  {
    page: 'contact',
    section: 'intro',
    title: 'Sorularınız İçin',
    description: 'Size en kısa sürede dönüş yapalım',
  },
  {
    page: 'contact',
    section: 'form',
    title: 'İletişim Formu',
    buttonText: 'Gönder',
  },

  // REHBERLİK
  {
    page: 'guidance',
    section: 'hero',
    title: 'Rehberlik Hizmetleri',
    subtitle: 'Akademik ve psikolojik destek',
  },
  {
    page: 'guidance',
    section: 'intro',
    title: 'Uzman Rehberlik',
    description: 'Öğrencilerimize akademik ve psikolojik destek sağlıyoruz',
  },
  {
    page: 'guidance',
    section: 'services',
    title: 'Hizmetlerimiz',
    description: 'Meslek seçimi, üniversite tercihi, sınav kaygısı ve motivasyon',
  },

  // HESAPLAMA ARAÇLARI
  {
    page: 'calculator',
    section: 'hero',
    title: 'Hesaplama Araçları',
    subtitle: 'Puan ve sıralama hesaplayıcıları',
  },
  {
    page: 'calculator',
    section: 'intro',
    title: 'Hedeflerinizi Belirleyin',
    description: 'TYT, AYT, LGS puan hesaplama ve sıralama tahmin araçları',
  },

  // HABERLER
  {
    page: 'news',
    section: 'hero',
    title: 'Haberler',
    subtitle: 'Güncel eğitim haberleri ve duyurular',
  },
  {
    page: 'news',
    section: 'intro',
    title: 'Son Haberler',
    description: 'Eğitim dünyasından güncel haberler ve kurumumuzdan duyurular',
  },
];

async function seedPageContents() {
  console.log('🌱 Seeding page contents...');

  for (const content of pageContents) {
    try {
      await prisma.homeSection.upsert({
        where: {
          // Composite unique constraint
          page_section: {
            page: content.page,
            section: content.section,
          },
        },
        update: content,
        create: content,
      });
      console.log(`✅ Created/Updated: ${content.page} - ${content.section}`);
    } catch (error) {
      console.error(`❌ Error with ${content.page} - ${content.section}:`, error);
    }
  }

  console.log('✨ Page contents seeding completed!');
}

seedPageContents()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
