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

## Development

### Prerequisites

- Docker
- Docker Compose
- Node
- pnpm

### Quick Start with Auto-Deploy Script

```bash
# Make the deploy script executable
chmod +x deploy.sh

# Run the deployment script (auto-detects and installs dependencies)
./deploy.sh
```

The deployment script will automatically:
- Detect your environment (Codespaces/Ubuntu VM)
- Install missing dependencies (Node.js, pnpm, Docker)
- Setup databases (PostgreSQL, ClickHouse, Redis)
- Initialize and migrate databases
- Start all services

### Manual Start

```bash
pnpm dock:up
pnpm codegen
pnpm migrate:deploy # once to setup the db
pnpm dev
```

You can now access the following:

- Dashboard: https://localhost:3000
- API: https://api.localhost:3333
- Bullboard (queue): http://localhost:9999
- `pnpm dock:ch` to access clickhouse terminal
- `pnpm dock:redis` to access redis terminal

### Default Credentials

- Email: admin@devbaytech.com
- Password: admin123

## License

MIT

## Contact

For support, email hello@devbaytech.com