import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function seedFranchisePage() {
    console.log('🌱 Seeding Franchise Page content...');

    const franchisePageSections = [
        // Hero Section
        { page: 'franchise', section: 'franchise-hero-badge', title: 'Geleceğin Eğitim Yatırımı', order: 0 },
        { page: 'franchise', section: 'franchise-hero-title', title: 'Şubemiz Olun', order: 1 },
        { page: 'franchise', section: 'franchise-hero-subtitle', subtitle: 'Hocalara Geldik ekosistemine katılarak Türkiye\'nin en dinamik eğitim ağıyla başarıya ortak olun.', order: 2 },
        { page: 'franchise', section: 'franchise-hero-button-primary', buttonText: 'Başvuru Yap', buttonLink: '#apply', order: 3 },
        { page: 'franchise', section: 'franchise-hero-button-secondary', buttonText: 'Sunum Dosyası (PDF)', buttonLink: '#', order: 4 },
        
        // Why Us Section - Card 1
        { page: 'franchise', section: 'franchise-why-card1-title', title: 'Güçlü İçerik Altyapısı', order: 5 },
        { page: 'franchise', section: 'franchise-why-card1-desc', subtitle: 'Binlerce video ders, PDF yayınlar ve deneme sınavlarıyla içerik derdiniz olmasın.', order: 6 },
        
        // Why Us Section - Card 2
        { page: 'franchise', section: 'franchise-why-card2-title', title: 'Dijital Yönetim', order: 7 },
        { page: 'franchise', section: 'franchise-why-card2-desc', subtitle: 'Öğrenci takip, devamsızlık ve sınav analiz yazılımlarımızla şubenizi kolayca yönetin.', order: 8 },
        
        // Why Us Section - Card 3
        { page: 'franchise', section: 'franchise-why-card3-title', title: 'Bölge Güvencesi', order: 9 },
        { page: 'franchise', section: 'franchise-why-card3-desc', subtitle: 'Haksız rekabeti önlemek adına bölgenizde tek şube olma garantisi sağlıyoruz.', order: 10 },
        
        // Process Section
        { page: 'franchise', section: 'franchise-process-title', title: 'Franchise Süreci Nasıl İşler?', order: 11 },
        
        // Process Steps
        { page: 'franchise', section: 'franchise-process-step1-title', title: 'Başvuru & Ön Görüşme', order: 12 },
        { page: 'franchise', section: 'franchise-process-step1-desc', subtitle: 'Aşağıdaki formu doldurarak ilk adımı atın, temsilcilerimiz sizi arasın.', order: 13 },
        
        { page: 'franchise', section: 'franchise-process-step2-title', title: 'Bölge Analizi', order: 14 },
        { page: 'franchise', section: 'franchise-process-step2-desc', subtitle: 'Kurulması planlanan şube için pazar ve potansiyel analizi yapılır.', order: 15 },
        
        { page: 'franchise', section: 'franchise-process-step3-title', title: 'Sözleşme & Kurulum', order: 16 },
        { page: 'franchise', section: 'franchise-process-step3-desc', subtitle: 'Karşılıklı onay sonrası kurumsal kimliğimize uygun şube kurulumu başlar.', order: 17 },
        
        // Contact Section
        { page: 'franchise', section: 'franchise-contact-title', title: 'Hızlı İletişim', order: 18 },
        { page: 'franchise', section: 'franchise-contact-phone', title: '0212 555 00 00', order: 19 },
        { page: 'franchise', section: 'franchise-contact-email', title: 'kurumsal@hocalarageldik.com', order: 20 },
        
        // Form Section
        { page: 'franchise', section: 'franchise-form-title', title: 'Ön Başvuru Formu', order: 21 },
        { page: 'franchise', section: 'franchise-form-button', buttonText: 'Başvuruyu Tamamla', order: 22 },
        { page: 'franchise', section: 'franchise-form-privacy', subtitle: 'Verdiğiniz bilgiler KVKK kapsamında güvence altındadır.', order: 23 },
    ];

    for (const section of franchisePageSections) {
        await prisma.homeSection.upsert({
            where: {
                page_section: {
                    page: section.page,
                    section: section.section
                }
            },
            update: section,
            create: {
                ...section,
                isActive: true
            }
        });
    }

    console.log('✅ Franchise Page content seeded successfully');
}
