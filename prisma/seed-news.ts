import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function seedNews() {
  console.log('🗞️  Seeding news...');

  // Get first user as author
  const author = await prisma.user.findFirst();
  if (!author) {
    console.log('⚠️  No user found, skipping news seed');
    return;
  }

  // Get some branches for branch-specific news
  const branches = await prisma.branch.findMany({ take: 3 });

  const newsData = [
    {
      type: 'NEWS' as const,
      status: 'PUBLISHED' as const,
      title: '2024 YKS Sonuçları Açıklandı - Rekorlar Kırıldı!',
      slug: '2024-yks-sonuclari-aciklandi',
      content: `
        <h2>Hocalara Geldik Ailesi Olarak Gurur Duyuyoruz!</h2>
        <p>2024 YKS sınavında öğrencilerimiz muhteşem bir başarıya imza attı. Toplam 450 öğrencimiz ilk 1000'e girmeyi başardı.</p>
        
        <h3>Öne Çıkan Başarılar</h3>
        <ul>
          <li>15 öğrencimiz Türkiye genelinde ilk 100'e girdi</li>
          <li>78 öğrencimiz ilk 500'de yer aldı</li>
          <li>Tıp Fakültesi yerleşme oranımız %92'ye ulaştı</li>
          <li>Mühendislik fakültelerine yerleşme oranı %87</li>
        </ul>
        
        <p>Tüm öğrencilerimizi ve ailelerini kutluyoruz. Bu başarı, kaliteli eğitim anlayışımızın ve öğrencilerimizin azimli çalışmalarının bir sonucudur.</p>
      `,
      excerpt: '2024 YKS sınavında öğrencilerimiz muhteşem bir başarıya imza attı. 450 öğrencimiz ilk 1000\'e girdi!',
      featuredImage: '/uploads/1769017507090-30489801.jpeg',
      authorId: author.id,
      isApproved: true,
      isFeatured: true,
      publishedAt: new Date('2024-07-15'),
      seoTitle: '2024 YKS Sonuçları - Hocalara Geldik Başarıları',
      seoDescription: 'Hocalara Geldik öğrencileri 2024 YKS sınavında rekorlar kırdı. 450 öğrenci ilk 1000\'e girdi.',
      seoKeywords: 'YKS 2024, üniversite sınavı, başarı, Hocalara Geldik'
    },
    {
      type: 'NEWS' as const,
      status: 'PUBLISHED' as const,
      title: 'LGS 2024 Sonuçları: Öğrencilerimiz Yine Zirvede',
      slug: 'lgs-2024-sonuclari-ogrencilerimiz-zirvede',
      content: `
        <h2>LGS'de Bir Başarı Hikayesi Daha</h2>
        <p>2024 LGS sınavında öğrencilerimiz beklentilerin üzerinde bir performans sergiledi. Toplam 280 öğrencimiz %90 ve üzeri puan aldı.</p>
        
        <h3>Başarı İstatistikleri</h3>
        <ul>
          <li>8 öğrencimiz tam puan aldı</li>
          <li>45 öğrenci 490 ve üzeri puan</li>
          <li>Fen Lisesi yerleşme oranı %78</li>
          <li>Anadolu Lisesi yerleşme oranı %95</li>
        </ul>
        
        <p>Öğrencilerimizin bu başarısı, deneyimli öğretmen kadromuz ve modern eğitim yöntemlerimizin bir sonucudur.</p>
      `,
      excerpt: 'LGS 2024\'te öğrencilerimiz muhteşem bir performans sergiledi. 8 öğrencimiz tam puan aldı!',
      featuredImage: '/uploads/1769017525886-706214747.jpeg',
      authorId: author.id,
      isApproved: true,
      isFeatured: true,
      publishedAt: new Date('2024-06-20'),
      seoTitle: 'LGS 2024 Sonuçları - Hocalara Geldik',
      seoDescription: 'Hocalara Geldik öğrencileri LGS 2024\'te zirvede. 8 öğrenci tam puan aldı.',
      seoKeywords: 'LGS 2024, lise sınavı, tam puan, başarı'
    },
    {
      type: 'NEWS' as const,
      status: 'PUBLISHED' as const,
      title: 'Yeni Şubemiz Açıldı: Modern Eğitim Kampüsü',
      slug: 'yeni-subemiz-acildi-modern-egitim-kampusu',
      content: `
        <h2>Eğitimde Yeni Bir Soluk</h2>
        <p>Hocalara Geldik ailesi büyümeye devam ediyor. Yeni açılan şubemiz, modern eğitim anlayışını en son teknoloji ile buluşturuyor.</p>
        
        <h3>Kampüs Özellikleri</h3>
        <ul>
          <li>50 adet akıllı sınıf</li>
          <li>Dijital kütüphane ve etüt alanları</li>
          <li>Bilim laboratuvarları</li>
          <li>Spor ve sosyal aktivite alanları</li>
          <li>Kafeterya ve dinlenme alanları</li>
        </ul>
        
        <p>Yeni şubemiz, öğrencilerimize en iyi eğitim ortamını sunmak için tasarlandı. Kayıtlar başladı!</p>
      `,
      excerpt: 'Modern eğitim anlayışını teknoloji ile buluşturan yeni şubemiz hizmete açıldı. Kayıtlar başladı!',
      featuredImage: '/uploads/1769017540975-385019996.jpg',
      authorId: author.id,
      branchId: branches[0]?.id,
      isApproved: true,
      isFeatured: false,
      publishedAt: new Date('2024-09-01'),
      seoTitle: 'Yeni Şube Açılışı - Hocalara Geldik',
      seoDescription: 'Modern eğitim kampüsümüz hizmete açıldı. 50 akıllı sınıf ve dijital kütüphane.',
      seoKeywords: 'yeni şube, eğitim kampüsü, kayıt'
    },
    {
      type: 'NEWS' as const,
      status: 'PUBLISHED' as const,
      title: 'Üniversite Tercih Danışmanlığı Başladı',
      slug: 'universite-tercih-danismanligi-basladi',
      content: `
        <h2>Doğru Tercih İçin Uzman Desteği</h2>
        <p>YKS sonuçlarının açıklanmasının ardından, öğrencilerimiz için ücretsiz tercih danışmanlığı hizmeti başladı.</p>
        
        <h3>Hizmet İçeriği</h3>
        <ul>
          <li>Birebir tercih görüşmeleri</li>
          <li>Bölüm ve üniversite analizi</li>
          <li>Kariyer planlama desteği</li>
          <li>Online tercih simülasyonu</li>
          <li>7/24 destek hattı</li>
        </ul>
        
        <p>Deneyimli rehber öğretmenlerimiz ve mezun öğrencilerimiz, tercih sürecinde yanınızda.</p>
      `,
      excerpt: 'YKS sonrası ücretsiz tercih danışmanlığı hizmeti başladı. Uzman kadromuz yanınızda!',
      featuredImage: '/uploads/1769017559570-670588552.jpeg',
      authorId: author.id,
      isApproved: true,
      isFeatured: false,
      publishedAt: new Date('2024-07-20'),
      seoTitle: 'Üniversite Tercih Danışmanlığı - Hocalara Geldik',
      seoDescription: 'Ücretsiz tercih danışmanlığı hizmeti. Birebir görüşme ve kariyer planlama.',
      seoKeywords: 'tercih danışmanlığı, üniversite tercihi, kariyer planlama'
    },
    {
      type: 'NEWS' as const,
      status: 'PUBLISHED' as const,
      title: 'Dijital Eğitim Platformumuz Yenilendi',
      slug: 'dijital-egitim-platformumuz-yenilendi',
      content: `
        <h2>Eğitimde Dijital Dönüşüm</h2>
        <p>Online eğitim platformumuz, yeni özellikleri ve gelişmiş altyapısı ile yenilendi. Artık daha hızlı, daha kullanışlı!</p>
        
        <h3>Yeni Özellikler</h3>
        <ul>
          <li>Canlı ders kayıtları ve tekrar izleme</li>
          <li>Yapay zeka destekli soru çözüm asistanı</li>
          <li>Kişiselleştirilmiş öğrenme yolları</li>
          <li>Mobil uygulama desteği</li>
          <li>Gelişmiş performans takip sistemi</li>
        </ul>
        
        <p>Tüm öğrencilerimiz yeni platforma ücretsiz erişim sağlayabilir.</p>
      `,
      excerpt: 'Dijital eğitim platformumuz yeni özellikleri ile yenilendi. Yapay zeka destekli öğrenme!',
      featuredImage: '/uploads/1769017731540-57626579.jpg',
      authorId: author.id,
      isApproved: true,
      isFeatured: false,
      publishedAt: new Date('2024-08-15'),
      seoTitle: 'Dijital Eğitim Platformu Yenilendi - Hocalara Geldik',
      seoDescription: 'Yeni dijital eğitim platformumuz yapay zeka desteği ve mobil uygulama ile hizmetinizde.',
      seoKeywords: 'dijital eğitim, online platform, yapay zeka, mobil uygulama'
    },
    {
      type: 'NEWS' as const,
      status: 'PUBLISHED' as const,
      title: 'Motivasyon Semineri: Başarının Sırları',
      slug: 'motivasyon-semineri-basarinin-sirlari',
      content: `
        <h2>Ünlü Motivasyon Konuşmacısı Şubemizde</h2>
        <p>Öğrencilerimiz için düzenlediğimiz motivasyon seminerinde, başarılı iş insanları ve akademisyenler deneyimlerini paylaştı.</p>
        
        <h3>Seminer Konuları</h3>
        <ul>
          <li>Hedef belirleme ve planlama</li>
          <li>Zaman yönetimi teknikleri</li>
          <li>Stres yönetimi</li>
          <li>Etkili çalışma yöntemleri</li>
          <li>Sınav kaygısı ile başa çıkma</li>
        </ul>
        
        <p>Seminer kayıtları platformumuzda yayınlandı. Tüm öğrencilerimiz izleyebilir.</p>
      `,
      excerpt: 'Başarının sırları motivasyon seminerinde konuşuldu. Kayıtlar platformda yayında!',
      featuredImage: '/uploads/1769017852588-499224677.jpg',
      authorId: author.id,
      branchId: branches[1]?.id,
      isApproved: true,
      isFeatured: false,
      publishedAt: new Date('2024-05-10'),
      seoTitle: 'Motivasyon Semineri - Hocalara Geldik',
      seoDescription: 'Başarının sırları motivasyon seminerinde paylaşıldı. Hedef belirleme ve zaman yönetimi.',
      seoKeywords: 'motivasyon, seminer, başarı, hedef belirleme'
    },
    {
      type: 'NEWS' as const,
      status: 'PUBLISHED' as const,
      title: 'Yaz Dönemi Kursları Kayıtları Başladı',
      slug: 'yaz-donemi-kurslari-kayitlari-basladi',
      content: `
        <h2>Yaz Tatilini Verimli Geçirin</h2>
        <p>2024-2025 eğitim öğretim yılına hazırlık için yaz dönemi kurslarımız başlıyor. Erken kayıt fırsatlarından yararlanın!</p>
        
        <h3>Kurs Programları</h3>
        <ul>
          <li>YKS Hazırlık Kursu (TYT-AYT)</li>
          <li>LGS Hazırlık Kursu</li>
          <li>9. Sınıf Hazırlık Programı</li>
          <li>İngilizce Yoğunlaştırma Kursu</li>
          <li>Matematik Olimpiyat Hazırlık</li>
        </ul>
        
        <p>Erken kayıt indirimi: %20! Son kayıt tarihi: 15 Haziran 2024</p>
      `,
      excerpt: 'Yaz dönemi kursları için kayıtlar başladı. Erken kayıt fırsatı %20 indirim!',
      featuredImage: '/uploads/1769017980743-614444383.jpg',
      authorId: author.id,
      isApproved: true,
      isFeatured: true,
      publishedAt: new Date('2024-05-25'),
      seoTitle: 'Yaz Dönemi Kursları - Hocalara Geldik',
      seoDescription: 'Yaz dönemi kursları kayıtları başladı. YKS, LGS ve İngilizce kursları. %20 erken kayıt indirimi.',
      seoKeywords: 'yaz kursu, YKS hazırlık, LGS hazırlık, erken kayıt'
    },
    {
      type: 'NEWS' as const,
      status: 'PUBLISHED' as const,
      title: 'Bilim Şenliği Düzenlendi: Geleceğin Bilim İnsanları',
      slug: 'bilim-senligi-duzenlendi',
      content: `
        <h2>Bilim ve Teknoloji Buluşması</h2>
        <p>Öğrencilerimizin bilime olan ilgisini artırmak için düzenlediğimiz bilim şenliği büyük ilgi gördü.</p>
        
        <h3>Etkinlik İçeriği</h3>
        <ul>
          <li>Robotik kodlama atölyeleri</li>
          <li>Kimya deneyleri gösterisi</li>
          <li>Fizik ve matematik yarışmaları</li>
          <li>Uzay ve astronomi sunumları</li>
          <li>Bilim insanları ile söyleşi</li>
        </ul>
        
        <p>500'den fazla öğrenci katıldı. Etkinlik fotoğrafları galerimizde!</p>
      `,
      excerpt: 'Bilim şenliğimiz büyük ilgi gördü. Robotik, kimya, fizik atölyeleri ve yarışmalar.',
      featuredImage: '/uploads/1769019596733-961689994.jpeg',
      authorId: author.id,
      branchId: branches[2]?.id,
      isApproved: true,
      isFeatured: false,
      publishedAt: new Date('2024-04-15'),
      seoTitle: 'Bilim Şenliği - Hocalara Geldik',
      seoDescription: 'Bilim şenliğimizde robotik, kimya ve fizik atölyeleri düzenlendi. 500+ öğrenci katıldı.',
      seoKeywords: 'bilim şenliği, robotik, kodlama, kimya deneyleri'
    }
  ];

  for (const news of newsData) {
    await prisma.page.upsert({
      where: { slug: news.slug },
      update: news,
      create: news
    });
  }

  console.log('✅ News seeded successfully');
}
