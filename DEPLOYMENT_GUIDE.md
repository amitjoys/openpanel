# Devbaytech Deployment Guide

## Quick Start (Automated)

The easiest way to deploy Devbaytech is using the automated deployment script:

```bash
chmod +x deploy.sh
./deploy.sh
```

The script will automatically:
- Detect your environment (Codespaces/Ubuntu VM)
- Install missing dependencies (Node.js, pnpm, Docker)
- Setup databases (PostgreSQL, ClickHouse, Redis)
- Initialize and migrate databases
- Start all services

## Manual Deployment

### Prerequisites

- **Node.js** v20 or higher
- **pnpm** v10 or higher
- **Docker** and **Docker Compose**
- **Ubuntu/Debian** OS (or similar)

### Step 1: Install Dependencies

#### Install Node.js (if not installed)
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### Install pnpm
```bash
npm install -g pnpm
```

#### Install Docker
```bash
# Add Docker's official GPG key
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group
sudo usermod -aG docker $USER
```

### Step 2: Setup Project

```bash
# Navigate to project directory
cd /app  # or your project directory

# Install project dependencies
pnpm install
```

### Step 3: Start Docker Containers

```bash
# Start PostgreSQL, ClickHouse, and Redis
pnpm dock:up

# OR manually with docker compose
docker compose up -d
```

### Step 4: Initialize Database

```bash
# Generate Prisma client
pnpm codegen

# Run database migrations
pnpm migrate:deploy
```

### Step 5: Start Services

```bash
# Start all services in development mode
pnpm dev
```

## Access the Application

Once deployed, you can access:

- **Dashboard**: http://localhost:3000
- **API**: http://localhost:3333
- **Queue Manager (BullMQ)**: http://localhost:9999

### Default Credentials

- **Email**: admin@devbaytech.com
- **Password**: admin123

## Required Ports

Make sure these ports are available:

- `3000` - Frontend Dashboard
- `3333` - API Server
- `5432` - PostgreSQL
- `6379` - Redis
- `8123` - ClickHouse HTTP
- `9000` - ClickHouse Native
- `9999` - BullMQ Queue Manager

## Docker Containers

The application uses three Docker containers:

1. **op-db** (PostgreSQL) - Main database
2. **op-kv** (Redis) - Cache and queue
3. **op-ch** (ClickHouse) - Event storage

### Managing Containers

```bash
# Start containers
pnpm dock:up

# Stop containers
pnpm dock:down

# View container logs
docker logs op-db
docker logs op-kv
docker logs op-ch

# Access ClickHouse CLI
pnpm dock:ch

# Access Redis CLI
pnpm dock:redis
```

## Environment Variables

Create a `.env` file in the root directory if you need custom configuration:

```env
# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/openpanel

# ClickHouse
CLICKHOUSE_URL=http://localhost:8123
CLICKHOUSE_USER=default
CLICKHOUSE_PASSWORD=

# Redis
REDIS_URL=redis://localhost:6379

# Application
NODE_ENV=development
PORT=3333
```

## Troubleshooting

### Port Already in Use

If you get "port already in use" errors:

```bash
# Find process using port
lsof -i :3000  # Replace with the port number
# or
sudo netstat -tuln | grep 3000

# Kill the process
kill -9 <PID>
```

### Docker Containers Not Starting

```bash
# Check container status
docker ps -a

# View container logs
docker logs op-db
docker logs op-kv
docker logs op-ch

# Remove and recreate containers
docker compose down
docker compose up -d
```

### Database Connection Issues

```bash
# Check if PostgreSQL is running
docker ps | grep op-db

# Check PostgreSQL logs
docker logs op-db

# Restart PostgreSQL
docker restart op-db

# Wait a few seconds and try migrations again
sleep 5
pnpm migrate:deploy
```

### pnpm Installation Fails

```bash
# Clear pnpm cache
pnpm store prune

# Try installing with force
pnpm install --force

# Or remove node_modules and reinstall
rm -rf node_modules
pnpm install
```

## Production Deployment

For production deployment:

1. **Update Environment Variables** for production settings
2. **Build the applications**:
   ```bash
   pnpm -r build
   ```
3. **Use production Docker Compose** (if available)
4. **Setup reverse proxy** (Nginx/Caddy) for SSL
5. **Configure domain names**
6. **Setup monitoring and logging**

## GitHub Codespaces

When deploying in GitHub Codespaces:

1. The deployment script auto-detects Codespaces
2. Ports are automatically forwarded
3. Access via Codespaces provided URLs
4. Docker may need additional configuration

## Ubuntu VM Deployment

For Ubuntu VMs:

1. Ensure you have sudo access
2. Run the automated deployment script
3. Make sure firewall allows required ports:
   ```bash
   sudo ufw allow 3000
   sudo ufw allow 3333
   ```

## Health Checks

Check if everything is running:

```bash
# Check Docker containers
docker ps

# Check if services are listening
netstat -tuln | grep -E '3000|3333|5432|6379|8123'

# Test API endpoint
curl http://localhost:3333/health
```

## Useful Commands

```bash
# Development
pnpm dev              # Start all services
pnpm dev:public       # Start public website only

# Database
pnpm codegen          # Generate Prisma client
pnpm migrate          # Create new migration
pnpm migrate:deploy   # Run migrations

# Docker
pnpm dock:up          # Start containers
pnpm dock:down        # Stop containers
pnpm dock:ch          # ClickHouse CLI
pnpm dock:redis       # Redis CLI

# Testing
pnpm test             # Run tests

# Code Quality
pnpm format           # Format code
pnpm format:fix       # Format and fix
pnpm lint             # Lint code
pnpm lint:fix         # Lint and fix
pnpm typecheck        # TypeScript check
```

## Support

For issues or questions:
- Email: hello@devbaytech.com
- Check logs: `docker logs <container-name>`
- Review application logs in the apps directories

## Next Steps

After successful deployment:

1. **Create your first organization** in the dashboard
2. **Setup your first project**
3. **Integrate tracking code** in your application
4. **Configure event tracking**
5. **Create custom dashboards**
6. **Setup notifications and alerts**

## Security Notes

- Change default admin password immediately after first login
- Use strong passwords for production
- Configure firewall rules appropriately
- Use SSL/TLS in production
- Keep Docker images updated
- Regular database backups
- Monitor system resources

## License

MIT License - see LICENSE.md for details
