# Devbaytech Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Devbaytech Platform                       │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│   Public Website │  │    Dashboard     │  │   Worker Queue   │
│   (Next.js)      │  │   (TanStack)     │  │    (BullMQ)      │
│   Port: Public   │  │   Port: 3000     │  │   Port: 9999     │
└────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘
         │                     │                      │
         └─────────────────────┼──────────────────────┘
                               │
                    ┌──────────▼──────────┐
                    │    Event API        │
                    │    (Fastify)        │
                    │    Port: 3333       │
                    └──────────┬──────────┘
                               │
         ┌─────────────────────┼─────────────────────┐
         │                     │                     │
    ┌────▼─────┐      ┌────────▼────────┐    ┌──────▼──────┐
    │PostgreSQL│      │   ClickHouse    │    │    Redis    │
    │  Port:   │      │   Ports: 8123   │    │  Port: 6379 │
    │  5432    │      │         9000    │    │             │
    └──────────┘      └─────────────────┘    └─────────────┘
     Main DB           Event Storage          Cache/Queue
```

## Components

### 1. **Frontend Applications**

#### Dashboard (apps/start)
- **Framework**: TanStack Start (React + Vite)
- **Port**: 3000
- **Purpose**: Main analytics dashboard
- **Features**:
  - Real-time analytics visualization
  - User management
  - Event tracking
  - Custom dashboards
  - Reports and funnels

#### Public Website (apps/public)
- **Framework**: Next.js 15
- **Purpose**: Marketing and documentation site
- **Features**:
  - Product information
  - Documentation
  - Pricing
  - Blog/Articles

### 2. **Backend Services**

#### Event API (apps/api)
- **Framework**: Fastify
- **Port**: 3333
- **Purpose**: Event ingestion and API endpoints
- **Features**:
  - Event tracking endpoint
  - REST API
  - tRPC API
  - Authentication
  - Data validation

#### Worker (apps/worker)
- **Framework**: Node.js with BullMQ
- **Port**: 9999 (Queue UI)
- **Purpose**: Background job processing
- **Features**:
  - Event processing
  - Data aggregation
  - Email notifications
  - Report generation
  - Scheduled tasks

### 3. **Data Storage**

#### PostgreSQL
- **Port**: 5432
- **Purpose**: Primary relational database
- **Stores**:
  - Users and organizations
  - Projects and configurations
  - Dashboards and reports
  - Session data
  - Integrations

#### ClickHouse
- **Ports**: 8123 (HTTP), 9000 (Native)
- **Purpose**: Event analytics database
- **Stores**:
  - Raw events
  - Page views
  - User actions
  - Session data
  - Time-series data

#### Redis
- **Port**: 6379
- **Purpose**: Cache and message queue
- **Uses**:
  - Session storage
  - Cache layer
  - Pub/Sub messaging
  - BullMQ queue
  - Rate limiting

## Data Flow

### Event Tracking Flow

```
User Browser/App
      │
      │ Track Event
      ▼
┌─────────────┐
│  SDK/Client │
└──────┬──────┘
       │
       │ POST /api/event
       ▼
┌─────────────┐
│  Event API  │──────┐
└──────┬──────┘      │
       │             │ Validate & Batch
       ▼             ▼
┌─────────────┐  ┌──────────┐
│    Redis    │  │  Worker  │
│   (Queue)   │  │  Queue   │
└──────┬──────┘  └────┬─────┘
       │              │
       │ Dequeue      │ Process
       └──────┬───────┘
              ▼
       ┌─────────────┐
       │ ClickHouse  │
       │  (Events)   │
       └─────────────┘
```

### Dashboard Query Flow

```
Dashboard UI
      │
      │ Request Data
      ▼
┌─────────────┐
│    tRPC     │
│     API     │
└──────┬──────┘
       │
       │ Query with Cache Check
       ▼
┌─────────────┐    Cache Hit    ┌─────────┐
│    Redis    │◄────────────────┤  Query  │
│   (Cache)   │                 │ Service │
└─────────────┘                 └────┬────┘
                                     │
                        Cache Miss   │
                                     ▼
                              ┌─────────────┐
                              │ ClickHouse  │
                              │  (Events)   │
                              └──────┬──────┘
                                     │
                      ┌──────────────┴──────────────┐
                      │                             │
               ┌──────▼──────┐             ┌────────▼────────┐
               │ PostgreSQL  │             │  Aggregated     │
               │  (Metadata) │             │     Data        │
               └─────────────┘             └────────┬────────┘
                                                    │
                                                    ▼
                                           ┌────────────────┐
                                           │  Dashboard UI  │
                                           └────────────────┘
```

## Technology Stack

### Frontend
- **React 19** - UI library
- **TanStack Router** - Client-side routing
- **TanStack Query** - Data fetching and caching
- **Tailwind CSS v4** - Styling
- **Recharts** - Chart visualizations
- **Radix UI** - Component primitives
- **tRPC** - Type-safe API client

### Backend
- **Fastify** - HTTP server
- **Prisma** - Database ORM
- **tRPC** - Type-safe API
- **BullMQ** - Queue management
- **Oslo** - Authentication
- **Arctic** - OAuth provider

### Data
- **PostgreSQL 14** - Relational data
- **ClickHouse 24** - Analytics data
- **Redis 7** - Cache and queue

### DevOps
- **Docker** - Containerization
- **Docker Compose** - Orchestration
- **pnpm** - Package management
- **Vite** - Build tool
- **Biome** - Linting and formatting

## Package Structure

```
/app
├── apps/                      # Applications
│   ├── api/                   # Fastify API server
│   ├── public/                # Next.js public site
│   ├── start/                 # TanStack dashboard
│   └── worker/                # Background worker
│
├── packages/                  # Shared packages
│   ├── auth/                  # Authentication logic
│   ├── common/                # Shared utilities
│   ├── constants/             # App constants
│   ├── db/                    # Database (Prisma)
│   ├── email/                 # Email service
│   ├── geo/                   # Geolocation
│   ├── importer/              # Data import
│   ├── integrations/          # Third-party integrations
│   ├── json/                  # JSON utilities
│   ├── logger/                # Logging
│   ├── payments/              # Payment processing
│   ├── queue/                 # Queue management
│   ├── redis/                 # Redis client
│   ├── sdks/                  # Client SDKs
│   ├── trpc/                  # tRPC setup
│   └── validation/            # Schema validation
│
├── self-hosting/              # Self-hosting configs
│   ├── caddy/                 # Caddy reverse proxy
│   ├── clickhouse/            # ClickHouse setup
│   └── docker-compose files   # Production configs
│
└── scripts/                   # Build and utility scripts
```

## Scaling Considerations

### Horizontal Scaling

```
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│   API       │  │   API       │  │   API       │
│ Instance 1  │  │ Instance 2  │  │ Instance 3  │
└──────┬──────┘  └──────┬──────┘  └──────┬──────┘
       └────────────┬────────────────────┘
                    │
             ┌──────▼──────┐
             │ Load        │
             │ Balancer    │
             └─────────────┘
```

### Database Scaling

- **PostgreSQL**: Read replicas for queries
- **ClickHouse**: Distributed tables and sharding
- **Redis**: Redis Cluster or Sentinel

## Security

### Authentication
- Session-based authentication
- OAuth providers support
- Secure password hashing (bcrypt)
- CSRF protection

### Data
- Environment variable isolation
- Database credentials rotation
- API rate limiting
- Input validation and sanitization

### Network
- CORS configuration
- HTTP security headers
- SSL/TLS encryption
- Firewall rules

## Performance

### Caching Strategy
1. **Redis Cache**: Short-term (minutes to hours)
   - Session data
   - API responses
   - Computed metrics

2. **Browser Cache**: Client-side
   - Static assets
   - API responses with cache headers

### Optimization
- Database query optimization
- Index management
- Event batching
- Background processing for heavy tasks
- CDN for static assets

## Monitoring

### Metrics to Track
- API response times
- Event processing rate
- Database query performance
- Queue depth and processing time
- Memory and CPU usage
- Error rates

### Logging
- Application logs
- Database query logs
- Worker job logs
- System logs

### Health Checks
- Service availability
- Database connections
- Queue processing
- Disk space

## Deployment Options

### 1. Self-Hosted (Current)
- Full control
- Data privacy
- Custom configurations
- Manual updates

### 2. Docker Compose
- Easy local development
- Reproducible environments
- Simple orchestration

### 3. Kubernetes (Future)
- Auto-scaling
- High availability
- Rolling updates
- Service mesh

## Backup Strategy

### Critical Data
- PostgreSQL database (daily)
- ClickHouse data (weekly)
- Configuration files
- User uploads

### Backup Methods
- PostgreSQL: `pg_dump`
- ClickHouse: `clickhouse-backup`
- Redis: RDB snapshots
- File storage: rsync/rclone

## Resource Requirements

### Minimum (Development)
- **CPU**: 2 cores
- **RAM**: 4 GB
- **Disk**: 20 GB SSD

### Recommended (Production)
- **CPU**: 4+ cores
- **RAM**: 8+ GB
- **Disk**: 100+ GB SSD
- **Network**: 1 Gbps

### Heavy Usage (Enterprise)
- **CPU**: 8+ cores
- **RAM**: 16+ GB
- **Disk**: 500+ GB NVMe
- **Network**: 10 Gbps
- **Scaling**: Horizontal with load balancer

---

**Last Updated**: January 2025
**Version**: 1.0.0
