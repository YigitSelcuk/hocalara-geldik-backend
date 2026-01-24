import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding banner cards...');

  const bannerCards = [
    {
      icon: '📄',
      title: 'Franchise Başvuru',
      description: 'Hocalara Geldik Ailesine Katılın',
      bgColor: 'bg-[#3b82f6]',
      hoverColor: 'hover:bg-[#2563eb]',
      link: '/franchise',
      buttonText: 'DETAYLI BİLGİ',
      order: 1,
      isActive: true
    },
    {
      icon: '🎓',
      title: 'Kayıt Başvurusu',
      description: 'Eğitiminize Hemen Başlayın',
      bgColor: 'bg-[#a855f7]',
      hoverColor: 'hover:bg-[#9333ea]',
      link: '/iletisim',
      buttonText: 'DETAYLI BİLGİ',
      order: 2,
      isActive: true
    },
    {
      icon: '🏫',
      title: 'Başarı Merkezleri',
      description: '81 İlde Güçlü Şube Ağı',
      bgColor: 'bg-[#ec4899]',
      hoverColor: 'hover:bg-[#db2777]',
      link: '/subeler',
      buttonText: 'DETAYLI BİLGİ',
      order: 3,
      isActive: true
    },
    {
      icon: '💻',
      title: 'Dijital Platform',
      description: 'Yapay Zeka Destekli Eğitim',
      bgColor: 'bg-[#f97316]',
      hoverColor: 'hover:bg-[#ea580c]',
      link: '/videolar',
      buttonText: 'DETAYLI BİLGİ',
      order: 4,
      isActive: true
    },
    {
      icon: '▶️',
      title: 'YouTube',
      description: 'Binlerce Ücretsiz İçerik',
      bgColor: 'bg-red-600',
      hoverColor: 'hover:bg-red-700',
      link: '/videolar',
      buttonText: 'KANALA GİT',
      order: 5,
      isActive: true
    }
  ];

  for (const card of bannerCards) {
    await prisma.bannerCard.upsert({
      where: { id: 'temp-' + card.order }, // Temporary ID for upsert
      update: card,
      create: card
    });
  }

  console.log('✅ Banner cards seeded successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Error seeding banner cards:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
