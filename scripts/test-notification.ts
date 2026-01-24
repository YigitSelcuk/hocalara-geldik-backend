import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function testNotification() {
  try {
    // Find a pending change request
    const pendingRequest = await prisma.changeRequest.findFirst({
      where: { status: 'PENDING' },
      include: { requester: true, branch: true }
    });

    if (!pendingRequest) {
      console.log('No pending requests found');
      return;
    }

    console.log('Found pending request:', pendingRequest.id);
    console.log('Requester:', pendingRequest.requester.email);

    // Find an admin user
    const admin = await prisma.user.findFirst({
      where: { role: 'SUPER_ADMIN' }
    });

    if (!admin) {
      console.log('No admin found');
      return;
    }

    console.log('Admin:', admin.email);

    // Approve the request
    const updatedRequest = await prisma.changeRequest.update({
      where: { id: pendingRequest.id },
      data: {
        status: 'APPROVED',
        reviewedBy: admin.id,
        reviewedAt: new Date(),
        reviewNote: 'Test approval from script'
      }
    });

    console.log('Request approved:', updatedRequest.id);

    // Create notification
    const notification = await prisma.notification.create({
      data: {
        type: 'CHANGE_APPROVED',
        title: '✅ Değişiklik Onaylandı',
        message: `Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.\n\nYönetici Notu: Test approval from script`,
        userId: pendingRequest.requestedBy,
        changeRequestId: pendingRequest.id
      }
    });

    console.log('Notification created:', notification.id);

    // Verify notification
    const notifications = await prisma.notification.findMany({
      where: { userId: pendingRequest.requestedBy },
      include: { user: { select: { name: true, email: true } } }
    });

    console.log('\nAll notifications for user:');
    console.log(JSON.stringify(notifications, null, 2));

  } catch (error) {
    console.error('Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

testNotification();
