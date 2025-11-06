# Devbaytech - Quick Start Guide

Welcome to **Devbaytech**, your self-hosted analytics platform!

## 🚀 One-Command Deployment

```bash
./deploy.sh
```

That's it! The script will:
✅ Detect your environment (Codespaces/Ubuntu VM)
✅ Install Node.js, pnpm, Docker if needed
✅ Setup PostgreSQL, ClickHouse, and Redis
✅ Run database migrations
✅ Start all services

## 📋 What You Need

The deploy script will install these automatically if missing:
- Node.js v20+
- pnpm v10+
- Docker & Docker Compose

## 🎯 After Deployment

Access your Devbaytech instance at:
- **Dashboard**: http://localhost:3000
- **API**: http://localhost:3333

### Default Login
- Email: `admin@devbaytech.com`
- Password: `admin123`

⚠️ **Important**: Change the password after first login!

## 🔄 Managing Services

### Start Services
```bash
pnpm dev
```

### Stop Services
```bash
# Press Ctrl+C in the terminal where pnpm dev is running
```

### Restart Docker Containers
```bash
pnpm dock:down
pnpm dock:up
```

## 📚 Need Help?

- **Full Guide**: See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) for detailed instructions
- **Troubleshooting**: Check the guide for common issues
- **Support**: Email hello@devbaytech.com

## 🛠️ Common Commands

```bash
# Development
pnpm dev                # Start all services
pnpm dock:up           # Start Docker containers
pnpm dock:down         # Stop Docker containers

# Database
pnpm migrate:deploy    # Run migrations
pnpm dock:ch           # Access ClickHouse CLI
pnpm dock:redis        # Access Redis CLI

# Code
pnpm typecheck         # Check TypeScript
pnpm lint              # Lint code
pnpm format            # Format code
```

## 🎨 Customization

### Theme Colors
The platform uses ZoomInfo-inspired colors:
- **Primary**: Red (#FF5A5F)
- **Secondary**: Dark Blue (#2A2A4A)
- **Accent**: Purple

Edit colors in:
- `/apps/public/app/global.css`
- `/apps/start/src/styles.css`

### Branding
Replace logos in:
- `/apps/start/public/logo.svg`
- `/apps/public/public/logo.svg`

## 🔐 Security Checklist

- [ ] Change default admin password
- [ ] Update database passwords in production
- [ ] Configure firewall rules
- [ ] Setup SSL/TLS certificates
- [ ] Enable automatic backups

## 📦 What's Included

- **Dashboard**: Real-time analytics interface
- **API**: RESTful and tRPC APIs
- **Event Tracking**: Web, mobile, and server-side SDKs
- **Databases**: PostgreSQL + ClickHouse + Redis
- **Queue System**: BullMQ for background jobs

## 🌟 Next Steps

1. Login to the dashboard
2. Create your first organization
3. Setup your first project
4. Get tracking code
5. Start collecting analytics!

---

Happy analyzing! 📊
