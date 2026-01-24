import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function seedContactPage() {
    console.log('🌱 Seeding Contact Page content...');

    const contactPageSections = [
        // Hero Section
        { page: 'contact', section: 'contact-hero-badge', title: 'Bize Ulaşın', order: 0 },
        { page: 'contact', section: 'contact-hero-title', title: 'İletişim', order: 1 },
        { page: 'contact', section: 'contact-hero-subtitle', subtitle: 'Sorularınız için bize ulaşın. Size yardımcı olmaktan mutluluk duyarız.', order: 2 },
        
        // Contact Info Section
        { page: 'contact', section: 'contact-info-title', title: 'İletişim Bilgileri', order: 3 },
        { page: 'contact', section: 'contact-info-desc', subtitle: 'Sorularınız, önerileriniz veya kayıt başvurunuz için bizimle iletişime geçebilirsiniz.', order: 4 },
        
        // Address
        { page: 'contact', section: 'contact-address-title', title: 'Adres', order: 5 },
        { page: 'contact', section: 'contact-address-line1', subtitle: 'İstanbul Genel Merkez Ofisi', order: 6 },
        { page: 'contact', section: 'contact-address-line2', subtitle: 'Beşiktaş Plaza, Kat: 5', order: 7 },
        { page: 'contact', section: 'contact-address-line3', subtitle: 'Beşiktaş / İstanbul', order: 8 },
        
        // Phone
        { page: 'contact', section: 'contact-phone-title', title: 'Telefon', order: 9 },
        { page: 'contact', section: 'contact-phone-line1', subtitle: '0212 000 00 00', order: 10 },
        { page: 'contact', section: 'contact-phone-line2', subtitle: '0850 000 00 00 (Ücretsiz)', order: 11 },
        
        // Email
        { page: 'contact', section: 'contact-email-title', title: 'E-posta', order: 12 },
        { page: 'contact', section: 'contact-email-line1', subtitle: 'bilgi@hocalarageldik.com', order: 13 },
        { page: 'contact', section: 'contact-email-line2', subtitle: 'destek@hocalarageldik.com', order: 14 },
        
        // Working Hours
        { page: 'contact', section: 'contact-hours-title', title: 'Çalışma Saatleri', order: 15 },
        { page: 'contact', section: 'contact-hours-line1', subtitle: 'Pazartesi - Cuma: 09:00 - 18:00', order: 16 },
        { page: 'contact', section: 'contact-hours-line2', subtitle: 'Cumartesi: 10:00 - 16:00', order: 17 },
        { page: 'contact', section: 'contact-hours-line3', subtitle: 'Pazar: Kapalı', order: 18 },
        
        // Social Media
        { page: 'contact', section: 'contact-social-title', title: 'Sosyal Medya', order: 19 },
        
        // Form Section
        { page: 'contact', section: 'contact-form-title', title: 'Bize Mesaj Gönderin', order: 20 },
        { page: 'contact', section: 'contact-form-button', buttonText: 'Mesajı Gönder', order: 21 },
    ];

    for (const section of contactPageSections) {
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

    console.log('✅ Contact Page content seeded successfully');
}
