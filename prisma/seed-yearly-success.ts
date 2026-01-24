import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function seedYearlySuccess() {
    console.log('🔵 Seeding yearly success data...');

    // 2024 Success Data
    const success2024 = await prisma.yearlySuccess.upsert({
        where: { year: '2024' },
        update: {},
        create: {
            year: '2024',
            totalDegrees: 156,
            placementCount: 1247,
            successRate: 94.5,
            cityCount: 42,
            top100Count: 23,
            top1000Count: 89,
            yksAverage: 485.6,
            lgsAverage: 456.8,
            isActive: true,
            banner: {
                create: {
                    title: '2024 Yılı Başarılarımız',
                    subtitle: 'Türkiye Genelinde Rekor Başarı',
                    description: '2024 yılında öğrencilerimiz YKS ve LGS sınavlarında büyük başarılar elde etti. 156 derece, 1247 yerleşme ve %94.5 başarı oranı ile gurur duyuyoruz.',
                    image: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=1920',
                    highlightText: 'Türkiye Genelinde 156 Derece',
                    gradientFrom: '#2563eb',
                    gradientTo: '#1e40af'
                }
            },
            students: {
                create: [
                    {
                        name: 'Ahmet Yılmaz',
                        rank: '1',
                        exam: 'TYT',
                        image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
                        branch: 'İstanbul Kadıköy',
                        university: 'İTÜ Bilgisayar Mühendisliği',
                        score: 548.5,
                        order: 0
                    },
                    {
                        name: 'Ayşe Demir',
                        rank: '3',
                        exam: 'AYT',
                        image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
                        branch: 'Ankara Çankaya',
                        university: 'ODTÜ Tıp Fakültesi',
                        score: 542.8,
                        order: 1
                    },
                    {
                        name: 'Mehmet Kaya',
                        rank: '5',
                        exam: 'LGS',
                        image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
                        branch: 'İzmir Karşıyaka',
                        university: 'Fen Lisesi',
                        score: 498.2,
                        order: 2
                    }
                ]
            }
        }
    });

    console.log('✅ 2024 success data seeded');

    // 2023 Success Data
    const success2023 = await prisma.yearlySuccess.upsert({
        where: { year: '2023' },
        update: {},
        create: {
            year: '2023',
            totalDegrees: 142,
            placementCount: 1156,
            successRate: 92.8,
            cityCount: 38,
            top100Count: 19,
            top1000Count: 76,
            yksAverage: 478.3,
            lgsAverage: 448.5,
            isActive: true,
            banner: {
                create: {
                    title: '2023 Yılı Başarılarımız',
                    subtitle: 'Sürekli Artan Başarı Grafiği',
                    description: '2023 yılında öğrencilerimiz 142 derece ile Türkiye genelinde adından söz ettirdi. 38 ilde 1156 öğrencimiz hedeflerine ulaştı.',
                    image: 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=1920',
                    highlightText: '142 Derece ile Rekor Yıl',
                    gradientFrom: '#7c3aed',
                    gradientTo: '#5b21b6'
                }
            },
            students: {
                create: [
                    {
                        name: 'Zeynep Şahin',
                        rank: '2',
                        exam: 'TYT',
                        image: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
                        branch: 'Bursa Nilüfer',
                        university: 'Boğaziçi Üniversitesi',
                        score: 545.2,
                        order: 0
                    },
                    {
                        name: 'Can Öztürk',
                        rank: '7',
                        exam: 'AYT',
                        image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
                        branch: 'Antalya Muratpaşa',
                        university: 'Hacettepe Tıp',
                        score: 538.9,
                        order: 1
                    }
                ]
            }
        }
    });

    console.log('✅ 2023 success data seeded');

    // 2022 Success Data
    const success2022 = await prisma.yearlySuccess.upsert({
        where: { year: '2022' },
        update: {},
        create: {
            year: '2022',
            totalDegrees: 128,
            placementCount: 1089,
            successRate: 91.2,
            cityCount: 35,
            top100Count: 15,
            top1000Count: 68,
            yksAverage: 472.5,
            lgsAverage: 442.3,
            isActive: true,
            banner: {
                create: {
                    title: '2022 Yılı Başarılarımız',
                    subtitle: 'Güçlü Temeller, Parlak Gelecek',
                    description: '2022 yılında 128 derece ile öğrencilerimiz hayallerindeki üniversitelere yerleşti. 35 ilde 1089 başarı hikayesi yazdık.',
                    image: 'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=1920',
                    highlightText: '128 Derece ile Başarı',
                    gradientFrom: '#059669',
                    gradientTo: '#047857'
                }
            },
            students: {
                create: [
                    {
                        name: 'Elif Yıldız',
                        rank: '4',
                        exam: 'LGS',
                        image: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
                        branch: 'İstanbul Üsküdar',
                        university: 'Anadolu Lisesi',
                        score: 495.7,
                        order: 0
                    }
                ]
            }
        }
    });

    console.log('✅ 2022 success data seeded');
    console.log('✅ All yearly success data seeded successfully');
}
