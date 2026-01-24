# Fix Branch User Assignment

## Problem ✅ FIXED
User `sube@urla.com` had `branchId: null` in database, causing "Şube Bulunamadı" error.

**Status**: User is now assigned to Urla branch and can access the branch admin panel.

## What Was Fixed

### 1. Frontend Type Mismatch
- Changed `assignedBranchId` to `branchId` in `types.ts` to match backend
- Updated `BranchAdminPanel.tsx` to use `user.branchId` instead of `user.assignedBranchId`

### 2. Database Assignment
- Assigned user `sube@urla.com` to the Urla branch
- User can now access branch management interface

## How to Fix Similar Issues in Future

### Option 1: Use the Fix Script
```bash
cd hocalara-geldik-backend
npx ts-node scripts/fix-branch-user.ts
```

This script will:
- Find the user `sube@urla.com`
- Check if they have a branch assigned
- Assign them to the Urla branch if not already assigned

### Option 2: Create New Branch with Manager (RECOMMENDED for new branches)
1. Logout from current account
2. Login as SUPER_ADMIN:
   - Email: `admin@hocalarageldik.com`
   - Password: `admin123`
3. Go to Admin Panel > Şubeler
4. Click "Yeni Şube Ekle"
5. Fill branch details + admin credentials
6. System creates both branch and manager account
7. Logout and login with new credentials

### Option 3: Manual Database Fix
If you need to assign a different branch:

#### Using Prisma Studio:
```bash
cd hocalara-geldik-backend
npx prisma studio
```

Then:
1. Open `User` table
2. Find user with email `sube@urla.com`
3. Copy the desired branch ID from `Branch` table
4. Update user's `branchId` field
5. Save changes

#### Using SQL (if you have direct database access):
```sql
-- First, get a branch ID
SELECT id, name FROM "Branch" WHERE slug = 'urla';

-- Then update the user (replace YOUR_BRANCH_ID with actual ID)
UPDATE "User" 
SET "branchId" = 'YOUR_BRANCH_ID' 
WHERE email = 'sube@urla.com';
```

## Verification
After fixing, login with branch manager account and you should see:
- Branch name in header (e.g., "Urla")
- Only branch management interface (not full admin panel)
- Ability to edit branch details, images, contact info
- No access to other branches or system-wide settings

## Current System Status
✅ Role detection working
✅ Redirect to BranchAdminPanel working
✅ Backend returns branchId correctly
✅ Frontend parses user data correctly
✅ User assigned to Urla branch
✅ Type mismatch fixed (assignedBranchId → branchId)

## Test Credentials
- Email: `sube@urla.com`
- Branch: Urla
- Role: BRANCH_ADMIN
