# Hocalara Geldik CMS - Backend Setup Guide

## 🚀 Quick Start

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Setup Environment Variables

```bash
cp .env.example .env
```

Edit `.env` and update the values if needed (defaults should work for local development).

### 3. Start Docker Services

```bash
# From project root
docker-compose up -d postgres redis
```

This will start:
- PostgreSQL on port 5432
- Redis on port 6379

### 4. Run Database Migrations

```bash
cd backend
npx prisma migrate dev --name init
```

### 5. Seed Database

```bash
npm run prisma:seed
```

This creates:
- Super Admin user (admin@hocalarageldik.com / admin123)
- Sample branch (İstanbul Kadıköy)
- Branch Admin user (kadikoy@hocalarageldik.com / admin123)
- Sample slider, menu, category, and settings

### 6. Start Backend Server

```bash
npm run dev
```

Server will run on http://localhost:4000

## 📡 API Endpoints

### Authentication
- `POST /api/auth/login` - Login
- `POST /api/auth/register` - Register new user (admin only)
- `POST /api/auth/refresh` - Refresh access token
- `GET /api/auth/me` - Get current user
- `POST /api/auth/logout` - Logout

### Sliders
- `GET /api/sliders` - Get all sliders
- `GET /api/sliders/:id` - Get slider by ID
- `POST /api/sliders` - Create slider (admin only)
- `PUT /api/sliders/:id` - Update slider (admin only)
- `DELETE /api/sliders/:id` - Delete slider (admin only)
- `POST /api/sliders/reorder` - Reorder sliders (admin only)

### Other Endpoints
- Menus: `/api/menus/*` (TODO)
- Pages: `/api/pages/*` (TODO)
- Categories: `/api/categories/*` (TODO)
- Users: `/api/users/*` (TODO)
- Branches: `/api/branches/*` (TODO)
- Settings: `/api/settings/*` (TODO)
- Media: `/api/media/*` (TODO)
- Contact: `/api/contact/*` (TODO)

## 🧪 Testing API

### Login Example

```bash
curl -X POST http://localhost:4000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@hocalarageldik.com","password":"admin123"}'
```

### Get Sliders Example

```bash
curl http://localhost:4000/api/sliders
```

### Create Slider Example (requires auth token)

```bash
curl -X POST http://localhost:4000/api/sliders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "title": "Test Slider",
    "subtitle": "Test subtitle",
    "image": "https://example.com/image.jpg",
    "target": "main",
    "isActive": true
  }'
```

## 🗄️ Database Management

### Prisma Studio (GUI)
```bash
npm run prisma:studio
```

Opens a web interface at http://localhost:5555 to view and edit database records.

### Create New Migration
```bash
npx prisma migrate dev --name your_migration_name
```

### Reset Database
```bash
npx prisma migrate reset
```

## 🐳 Docker Commands

### Start all services
```bash
docker-compose up -d
```

### Stop all services
```bash
docker-compose down
```

### View logs
```bash
docker-compose logs -f backend
docker-compose logs -f postgres
```

### Rebuild backend container
```bash
docker-compose up -d --build backend
```

## 📝 User Roles

- **SUPER_ADMIN**: Full system access
- **CENTER_ADMIN**: Manage all branches, approve content
- **BRANCH_ADMIN**: Manage assigned branch only
- **EDITOR**: Create/edit content, no publish rights

## 🔒 Security Notes

- Change JWT secrets in production
- Change database password in production
- Use HTTPS in production
- Implement rate limiting for production
- Add CSRF protection for production

## 📦 Next Steps

1. Implement remaining route controllers (menu, page, category, etc.)
2. Add file upload functionality for media
3. Implement frontend API integration
4. Add comprehensive error handling
5. Write unit and integration tests
6. Setup CI/CD pipeline
7. Deploy to production

## 🐛 Troubleshooting

### Database connection error
- Make sure Docker is running
- Check if PostgreSQL container is up: `docker ps`
- Verify DATABASE_URL in .env

### Port already in use
- Change PORT in .env
- Or kill the process using the port

### Prisma Client errors
- Regenerate Prisma Client: `npx prisma generate`
- Run migrations: `npx prisma migrate dev`
