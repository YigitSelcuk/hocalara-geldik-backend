import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function fixBranchUser() {
  try {
    console.log('🔍 Finding user sube@urla.com...');
    
    const user = await prisma.user.findUnique({
      where: { email: 'sube@urla.com' }
    });
    
    if (!user) {
      console.log('❌ User not found');
      return;
    }
    
    console.log('✅ User found:', {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      branchId: user.branchId
    });
    
    if (user.branchId) {
      console.log('✅ User already has a branchId:', user.branchId);
      const branch = await prisma.branch.findUnique({
        where: { id: user.branchId }
      });
      console.log('📍 Assigned branch:', branch?.name);
      return;
    }
    
    console.log('🔍 Finding Urla branch...');
    const urlaBranch = await prisma.branch.findFirst({
      where: { slug: 'urla' }
    });
    
    if (!urlaBranch) {
      console.log('❌ Urla branch not found. Available branches:');
      const branches = await prisma.branch.findMany({
        select: { id: true, name: true, slug: true }
      });
      branches.forEach((branch, index) => {
        console.log(`  ${index + 1}. ${branch.name} (${branch.slug})`);
      });
      return;
    }
    
    console.log(`🔧 Assigning user to branch: ${urlaBranch.name}`);
    
    const updatedUser = await prisma.user.update({
      where: { id: user.id },
      data: { branchId: urlaBranch.id },
      include: { branch: true }
    });
    
    console.log('✅ User updated successfully!');
    console.log('📝 Updated user:', {
      id: updatedUser.id,
      name: updatedUser.name,
      email: updatedUser.email,
      role: updatedUser.role,
      branchId: updatedUser.branchId,
      branchName: updatedUser.branch?.name
    });
    
    console.log('\n✨ Done! You can now login with:');
    console.log(`   Email: ${updatedUser.email}`);
    console.log(`   Branch: ${updatedUser.branch?.name}`);
    
  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

fixBranchUser();
