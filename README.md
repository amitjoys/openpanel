![hero](apps/public/public/ogimage.jpg)

<p align="center">
        <h1 align="center"><b>Devbaytech</b></h1>
<p align="center">
    An open-source analytics platform for modern businesses
    <br />
    <br />
    <a href="https://devbaytech.com">Website</a>
    ·
    <a href="https://devbaytech.com/docs">Docs</a>
    ·
    <a href="https://dashboard.devbaytech.com">Sign in</a>
    ·
    <a href="https://discord.gg/devbaytech">Discord</a>
    ·
    <a href="https://twitter.com/Devbaytech">X/Twitter</a>
  </p>
  <br />
  <br />
</p>
  
Devbaytech is an open-source web and product analytics platform that combines the power of Mixpanel with the ease of Plausible and one of the best Google Analytics replacements.

## ✨ Features

- **🔍 Advanced Analytics**: Funnels, cohorts, user profiles, and session history
- **📊 Real-time Dashboards**: Live data updates and interactive charts
- **🎯 A/B Testing**: Built-in variant testing with detailed breakdowns
- **🔔 Smart Notifications**: Event and funnel-based alerts
- **🌍 Privacy-First**: Cookieless tracking and GDPR compliance
- **🚀 Developer-Friendly**: Comprehensive SDKs and API access
- **📦 Self-Hosted**: Full control over your data and infrastructure
- **💸 Transparent Pricing**: No hidden costs or usage limits
- **🛠️ Custom Dashboards**: Flexible chart creation and data visualization
- **📱 Multi-Platform**: Web, mobile (iOS/Android), and server-side tracking

## 📊 Analytics Platform Comparison

| Feature                                | Devbaytech | Mixpanel | GA4       | Plausible |
|----------------------------------------|-----------|----------|-----------|--------|
| ✅ Open-source                         | ✅         | ❌        | ❌        | ✅         |
| 🧩 Self-hosting supported              | ✅         | ❌        | ❌        | ✅         |
| 🔒 Cookieless by default               | ✅         | ❌        | ❌        | ✅         |
| 🔁 Real-time dashboards                | ✅         | ✅        | ❌        | ✅         |
| 🔍 Funnels & cohort analysis           | ✅         | ✅        | ✅*       | ✅***         |
| 👤 User profiles & session history     | ✅         | ✅        | ❌        | ❌         |
| 📈 Custom dashboards & charts          | ✅         | ✅        | ✅        | ❌         |
| 💬 Event & funnel notifications        | ✅         | ✅        | ❌        | ❌         |
| 🌍 GDPR-compliant tracking             | ✅         | ✅        | ❌**      | ✅         |
| 📦 SDKs (Web, Swift, Kotlin, ReactNative) | ✅      | ✅        | ✅        | ❌         |
| 💸 Transparent pricing                 | ✅         | ❌        | ✅*       | ✅         |
| 🚀 Built for developers                | ✅         | ✅        | ❌        | ✅         |
| 🔧 A/B testing & variant breakdowns    | ✅         | ✅        | ❌        | ❌         |

> ✅* GA4 has a free tier but often requires BigQuery (paid) for raw data access.  
> ❌** GA4 has faced GDPR bans in several EU countries due to data transfers to US-based servers.  
> ✅*** Plausible has simple goals

## Stack

- **Nextjs** - the dashboard
- **Fastify** - event api
- **Postgres** - storing basic information
- **Clickhouse** - storing events
- **Redis** - cache layer, pub/sub and queue
- **BullMQ** - queue
- **GroupMQ** - for grouped queue
- **Resend** - email
- **Arctic** - oauth
- **Oslo** - auth
- **tRPC** - api
- **Tailwind** - styling
- **Shadcn** - ui

## Self-hosting

Devbaytech can be self-hosted and we have tried to make it as simple as possible.

You can find the how to [here](https://devbaytech.com/docs/self-hosting/self-hosting)

**Give us a star if you like it!**

[![Star History Chart](https://api.star-history.com/svg?repos=Devbaytech/devbaytech&type=Date)](https://star-history.com/#Devbaytech/devbaytech&Date)

## 🚀 Quick Start

### One-Command Deployment (Recommended)

```bash
./deploy.sh
```

The automated deployment script will:
- ✅ Detect your environment (Codespaces/Ubuntu VM)
- ✅ Auto-install missing dependencies (Node.js v20+, pnpm, Docker)
- ✅ Setup databases (PostgreSQL, ClickHouse, Redis)
- ✅ Run database migrations
- ✅ Start all services with health checks

### Verify Setup

```bash
./verify_setup.sh  # Check if everything is configured correctly
```

### Prerequisites

The deploy script will install these automatically if missing:
- **Node.js** v20 or higher
- **pnpm** v10 or higher
- **Docker** and **Docker Compose**
- **Ubuntu/Debian** OS (or compatible)

### Manual Deployment

If you prefer manual control:

```bash
# 1. Start Docker containers
pnpm dock:up

# 2. Generate Prisma client
pnpm codegen

# 3. Run database migrations
pnpm migrate:deploy

# 4. Start all services
pnpm dev
```

## 📍 Access Points

Once deployed, access your Devbaytech instance:

- **Dashboard**: http://localhost:3000
- **API**: http://localhost:3333
- **Queue Manager**: http://localhost:9999

### Default Credentials

- **Email**: admin@devbaytech.com
- **Password**: admin123

⚠️ **Important**: Change password immediately after first login!

## 📚 Documentation

- **[QUICK_START.md](./QUICK_START.md)** - Fast setup guide
- **[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)** - Comprehensive deployment manual
- **[WHITELABEL_SUMMARY.md](./WHITELABEL_SUMMARY.md)** - White label changes summary

## 🛠️ Useful Commands

```bash
# Development
pnpm dev              # Start all services
pnpm dev:public       # Start public website only

# Docker Management
pnpm dock:up          # Start containers
pnpm dock:down        # Stop containers
pnpm dock:ch          # Access ClickHouse CLI
pnpm dock:redis       # Access Redis CLI

# Database
pnpm codegen          # Generate Prisma client
pnpm migrate          # Create new migration
pnpm migrate:deploy   # Run migrations

# Code Quality
pnpm typecheck        # TypeScript check
pnpm lint             # Lint code
pnpm format           # Format code
```

## 🎨 Customization

### Theme Colors (ZoomInfo-Inspired)

The platform uses a modern color scheme:
- **Primary**: Red `#FF5A5F`
- **Secondary**: Dark Blue `#2A2A4A`
- **Accent**: Purple

Edit colors in:
- `/apps/public/app/global.css`
- `/apps/start/src/styles.css`

### Logos

Replace SVG logos in:
- `/apps/start/public/logo.svg`
- `/apps/public/public/logo.svg`
- `/apps/public/public/favicon.svg`

## 🔒 Security

- Change default admin password after first login
- Update database passwords for production
- Configure firewall rules for required ports
- Setup SSL/TLS certificates
- Enable automatic backups

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Find and kill process using port
lsof -i :3000
kill -9 <PID>
```

### Docker Issues
```bash
# Check container status
docker ps -a

# View logs
docker logs op-db
docker logs op-kv
docker logs op-ch

# Restart containers
docker compose down && docker compose up -d
```

### Installation Problems
```bash
# Clear and reinstall
rm -rf node_modules
pnpm store prune
pnpm install
```

For more troubleshooting, see [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)

## 🌟 Features

- **Real-time Analytics**: Live dashboards with instant updates
- **Event Tracking**: Web, mobile, and server-side SDKs
- **User Profiles**: Individual user tracking and analysis
- **Funnels & Cohorts**: Advanced conversion analysis
- **A/B Testing**: Built-in variant testing
- **Custom Dashboards**: Flexible chart creation
- **Privacy-First**: GDPR compliant, cookieless tracking
- **Self-Hosted**: Complete data control

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

MIT License - see [LICENSE.md](./LICENSE.md) for details

## 📧 Support

- **Email**: hello@devbaytech.com
- **Documentation**: [devbaytech.com/docs](https://devbaytech.com/docs)
- **Issues**: Check logs and [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)

---

Built with ❤️ by the Devbaytech Team