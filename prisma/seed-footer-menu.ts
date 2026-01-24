import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function seedFooterMenu() {
  console.log('🔵 Seeding footer menu...');

  // Footer column titles
  const columnTitles = [
    {
      page: 'home',
      section: 'footer-menu-column1',
      title: 'Hızlı Menü Linkleri',
      isActive: true
    },
    {
      page: 'home',
      section: 'footer-menu-column2',
      title: 'Eğitim Programları',
      isActive: true
    },
    {
      page: 'home',
      section: 'footer-menu-column3',
      title: 'Genel İletişim Hattı',
      isActive: true
    }
  ];

  for (const title of columnTitles) {
    await prisma.homeSection.upsert({
      where: { page_section: { page: title.page, section: title.section } },
      update: title,
      create: title
    });
  }

  console.log('✅ Column titles seeded');

  // Column 1 - Hızlı Menü Linkleri
  const column1Items = [
    { title: 'Akademi Ana Sayfası', url: '/', order: 0 },
    { title: 'Tüm Akademik Şubelerimiz', url: '/subeler', order: 1 },
    { title: 'Öğrenci Gurur Tablomuz', url: '/basarilarimiz', order: 2 },
    { title: 'Franchise Başvuru Formu', url: '/franchise', order: 3 },
    { title: 'Güncel Haberler Ve Duyurular', url: '/haberler', order: 4 }
  ];

  for (const item of column1Items) {
    await prisma.homeSection.create({
      data: {
        page: 'home',
        section: `footer-menu-column1-item-${Date.now()}-${item.order}`,
        title: item.title,
        buttonLink: item.url,
        order: item.order,
        isActive: true
      }
    });
  }

  console.log('✅ Column 1 items seeded');

  // Column 2 - Eğitim Programları
  const column2Items = [
    { title: 'Üniversite Hazırlık (YKS)', url: '#', order: 0 },
    { title: 'Lise Giriş Sınavı (LGS)', url: '#', order: 1 },
    { title: 'Dijital Soru Çözüm Arşivi', url: '#', order: 2 },
    { title: 'Uzman Rehberlik Hizmetleri', url: '#', order: 3 },
    { title: 'Haftalık Deneme Sınavları', url: '#', order: 4 }
  ];

  for (const item of column2Items) {
    await prisma.homeSection.create({
      data: {
        page: 'home',
        section: `footer-menu-column2-item-${Date.now()}-${item.order}`,
        title: item.title,
        buttonLink: item.url,
        order: item.order,
        isActive: true
      }
    });
  }

  console.log('✅ Column 2 items seeded');

  // Column 3 - Genel İletişim Hattı
  const column3Items = [
    { title: 'Hakkımızda', url: '/hakkimizda', order: 0 },
    { title: 'İletişim', url: '/iletisim', order: 1 },
    { title: 'Gizlilik Sözleşmesi', url: '/gizlilik', order: 2 },
    { title: 'Kullanım Şartları', url: '/kullanim-sartlari', order: 3 },
    { title: 'KVKK Aydınlatma Metni', url: '/kvkk', order: 4 }
  ];

  for (const item of column3Items) {
    await prisma.homeSection.create({
      data: {
        page: 'home',
        section: `footer-menu-column3-item-${Date.now()}-${item.order}`,
        title: item.title,
        buttonLink: item.url,
        order: item.order,
        isActive: true
      }
    });
  }

  console.log('✅ Column 3 items seeded');

  // Footer description and copyright
  await prisma.homeSection.upsert({
    where: { page_section: { page: 'home', section: 'footer-description' } },
    update: {
      description: 'Türkiye\'nin Öncü Eğitim Markası Olarak, Akademik Başarınızı En Modern Teknolojiler Ve Uzman Kadromuzla Destekliyoruz.'
    },
    create: {
      page: 'home',
      section: 'footer-description',
      description: 'Türkiye\'nin Öncü Eğitim Markası Olarak, Akademik Başarınızı En Modern Teknolojiler Ve Uzman Kadromuzla Destekliyoruz.',
      isActive: true
    }
  });

  await prisma.homeSection.upsert({
    where: { page_section: { page: 'home', section: 'footer-copyright' } },
    update: {
      title: 'Hocalara Geldik Akademi Grubu. Tüm hakları saklıdır.'
    },
    create: {
      page: 'home',
      section: 'footer-copyright',
      title: 'Hocalara Geldik Akademi Grubu. Tüm hakları saklıdır.',
      isActive: true
    }
  });

  console.log('✅ Footer description and copyright seeded');

  // Footer logo
  await prisma.homeSection.upsert({
    where: { page_section: { page: 'home', section: 'footer-logo' } },
    update: {
      buttonLink: '/assets/images/logoblue.svg'
    },
    create: {
      page: 'home',
      section: 'footer-logo',
      buttonLink: '/assets/images/logoblue.svg',
      isActive: true
    }
  });

  console.log('✅ Footer logo seeded');

  // Footer bottom links
  const bottomLinks = [
    { title: 'Gizlilik Sözleşmesi', url: '/gizlilik', order: 0 },
    { title: 'Kullanım Şartları', url: '/kullanim-sartlari', order: 1 },
    { title: 'KVKK Aydınlatma Metni', url: '/kvkk', order: 2 }
  ];

  for (const link of bottomLinks) {
    await prisma.homeSection.create({
      data: {
        page: 'home',
        section: `footer-bottom-link-${Date.now()}-${link.order}`,
        title: link.title,
        buttonLink: link.url,
        order: link.order,
        isActive: true
      }
    });
  }

  console.log('✅ Footer bottom links seeded');
  console.log('🎉 Footer menu seeding completed!');
}

seedFooterMenu()
  .catch((e) => {
    console.error('❌ Error seeding footer menu:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
