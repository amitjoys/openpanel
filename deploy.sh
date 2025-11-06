#!/bin/bash

###############################################################################
# Devbaytech Auto-Deployment Script
# Automatically detects environment, installs dependencies, and deploys
# Compatible with GitHub Codespaces and Ubuntu VMs
###############################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Banner
print_banner() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  ${GREEN}Devbaytech Analytics Platform - Auto Deployment${NC}      ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Detect OS
detect_os() {
    log_info "Detecting operating system..."
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VER=$VERSION_ID
        log_success "Detected: $PRETTY_NAME"
    else
        log_error "Cannot detect OS. This script supports Ubuntu/Debian systems."
        exit 1
    fi
    
    # Check if running in Codespaces
    if [ -n "$CODESPACES" ]; then
        log_info "Running in GitHub Codespaces"
        IS_CODESPACES=true
    else
        IS_CODESPACES=false
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Auto-detect project directory
detect_project_dir() {
    log_info "Detecting project directory..."
    
    # Try to find package.json
    if [ -f "./package.json" ]; then
        PROJECT_DIR=$(pwd)
        log_success "Project directory: $PROJECT_DIR"
        return 0
    fi
    
    # Check if we're in /app
    if [ -d "/app" ] && [ -f "/app/package.json" ]; then
        PROJECT_DIR="/app"
        cd "$PROJECT_DIR"
        log_success "Project directory: $PROJECT_DIR"
        return 0
    fi
    
    # Search in common locations
    for dir in ~/workspace/* ~/project ~/devbaytech /workspace/*; do
        if [ -d "$dir" ] && [ -f "$dir/package.json" ]; then
            PROJECT_DIR="$dir"
            cd "$PROJECT_DIR"
            log_success "Project directory: $PROJECT_DIR"
            return 0
        fi
    done
    
    log_error "Could not find project directory. Please run this script from the project root."
    read -p "Enter the full path to the project directory: " user_dir
    if [ -d "$user_dir" ] && [ -f "$user_dir/package.json" ]; then
        PROJECT_DIR="$user_dir"
        cd "$PROJECT_DIR"
        log_success "Using directory: $PROJECT_DIR"
    else
        log_error "Invalid directory. Exiting."
        exit 1
    fi
}

# Check and install Node.js
check_nodejs() {
    log_info "Checking Node.js installation..."
    
    if command_exists node; then
        NODE_VERSION=$(node -v)
        log_success "Node.js is installed: $NODE_VERSION"
        
        # Check version (need >= 18)
        MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
        if [ "$MAJOR_VERSION" -lt 18 ]; then
            log_warning "Node.js version is too old. Upgrading to v20..."
            install_nodejs
        fi
    else
        log_warning "Node.js not found. Installing..."
        install_nodejs
    fi
}

install_nodejs() {
    log_info "Installing Node.js v20..."
    
    # Install Node.js based on OS
    if [[ "$OS" == "ubuntu" ]] || [[ "$OS" == "debian" ]]; then
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    else
        log_error "Unsupported OS for automatic Node.js installation"
        read -p "Please install Node.js v20+ manually and press Enter to continue..."
    fi
    
    if command_exists node; then
        log_success "Node.js installed: $(node -v)"
    else
        log_error "Failed to install Node.js"
        exit 1
    fi
}

# Check and install pnpm
check_pnpm() {
    log_info "Checking pnpm installation..."
    
    if command_exists pnpm; then
        PNPM_VERSION=$(pnpm -v)
        log_success "pnpm is installed: v$PNPM_VERSION"
    else
        log_warning "pnpm not found. Installing..."
        install_pnpm
    fi
}

install_pnpm() {
    log_info "Installing pnpm..."
    
    npm install -g pnpm
    
    if command_exists pnpm; then
        log_success "pnpm installed: v$(pnpm -v)"
    else
        log_error "Failed to install pnpm"
        exit 1
    fi
}

# Check and install Docker
check_docker() {
    log_info "Checking Docker installation..."
    
    if command_exists docker; then
        DOCKER_VERSION=$(docker --version)
        log_success "Docker is installed: $DOCKER_VERSION"
        
        # Check if Docker daemon is running
        if ! docker ps >/dev/null 2>&1; then
            log_warning "Docker daemon is not running. Starting..."
            sudo systemctl start docker || log_error "Failed to start Docker. Please start it manually."
        fi
    else
        log_warning "Docker not found. Installing..."
        install_docker
    fi
}

install_docker() {
    log_info "Installing Docker..."
    
    if [[ "$OS" == "ubuntu" ]] || [[ "$OS" == "debian" ]]; then
        # Install Docker
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl gnupg
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/$OS/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
        
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        
        # Add current user to docker group
        sudo usermod -aG docker $USER
        
        log_success "Docker installed successfully"
        log_warning "You may need to log out and back in for group changes to take effect"
    else
        log_error "Unsupported OS for automatic Docker installation"
        read -p "Please install Docker manually and press Enter to continue..."
    fi
}

# Check Docker Compose
check_docker_compose() {
    log_info "Checking Docker Compose..."
    
    if command_exists docker-compose || docker compose version >/dev/null 2>&1; then
        log_success "Docker Compose is available"
    else
        log_error "Docker Compose not found and required"
        exit 1
    fi
}

# Check port availability
check_ports() {
    log_info "Checking port availability..."
    
    REQUIRED_PORTS=(3000 8123 5432 6379 9000)
    PORTS_IN_USE=()
    
    for port in "${REQUIRED_PORTS[@]}"; do
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1 || netstat -tuln 2>/dev/null | grep -q ":$port "; then
            PORTS_IN_USE+=($port)
            log_warning "Port $port is already in use"
        fi
    done
    
    if [ ${#PORTS_IN_USE[@]} -gt 0 ]; then
        log_warning "The following ports are in use: ${PORTS_IN_USE[*]}"
        read -p "Do you want to continue anyway? (y/n): " continue_anyway
        if [[ ! "$continue_anyway" =~ ^[Yy]$ ]]; then
            log_error "Please free up the required ports and try again"
            exit 1
        fi
    else
        log_success "All required ports are available"
    fi
}

# Install project dependencies
install_dependencies() {
    log_info "Installing project dependencies..."
    
    cd "$PROJECT_DIR"
    
    if [ -f "pnpm-lock.yaml" ]; then
        log_info "Installing with pnpm..."
        pnpm install || {
            log_error "Failed to install dependencies"
            read -p "Do you want to try again? (y/n): " retry
            if [[ "$retry" =~ ^[Yy]$ ]]; then
                pnpm install --force
            else
                exit 1
            fi
        }
        log_success "Dependencies installed"
    else
        log_error "pnpm-lock.yaml not found"
        exit 1
    fi
}

# Setup Docker containers
setup_docker_containers() {
    log_info "Setting up Docker containers..."
    
    cd "$PROJECT_DIR"
    
    # Stop existing containers if any
    docker compose down 2>/dev/null || docker-compose down 2>/dev/null || true
    
    # Start containers
    log_info "Starting PostgreSQL, ClickHouse, and Redis..."
    if command_exists docker-compose; then
        docker-compose up -d || {
            log_error "Failed to start containers"
            exit 1
        }
    else
        docker compose up -d || {
            log_error "Failed to start containers"
            exit 1
        }
    fi
    
    log_success "Docker containers started"
    
    # Wait for services to be ready
    log_info "Waiting for services to be ready..."
    sleep 10
    
    # Check if containers are running
    if docker ps | grep -q "op-db\|op-kv\|op-ch"; then
        log_success "All containers are running"
    else
        log_warning "Some containers may not be running properly"
        docker ps
    fi
}

# Run database migrations
run_migrations() {
    log_info "Running database migrations..."
    
    cd "$PROJECT_DIR"
    
    # Generate Prisma client
    log_info "Generating Prisma client..."
    pnpm codegen || {
        log_error "Failed to generate Prisma client"
        exit 1
    }
    
    # Run migrations
    log_info "Deploying database migrations..."
    pnpm migrate:deploy || {
        log_error "Failed to run migrations"
        read -p "Do you want to continue anyway? (y/n): " continue_anyway
        if [[ ! "$continue_anyway" =~ ^[Yy]$ ]]; then
            exit 1
        fi
    }
    
    log_success "Database migrations completed"
}

# Start development servers
start_services() {
    log_info "Starting Devbaytech services..."
    
    cd "$PROJECT_DIR"
    
    log_info "Starting all services in development mode..."
    log_warning "This will run in the foreground. Press Ctrl+C to stop."
    log_info ""
    log_info "Once started, you can access:"
    log_info "  - Dashboard: http://localhost:3000"
    log_info "  - API: http://localhost:3333"
    log_info "  - Default login: admin@devbaytech.com / admin123"
    log_info ""
    
    sleep 3
    
    # Start services
    pnpm dev
}

# Health check
health_check() {
    log_info "Performing health check..."
    
    # Check Docker containers
    if docker ps | grep -q "op-db\|op-kv\|op-ch"; then
        log_success "Docker containers: OK"
    else
        log_error "Docker containers: NOT OK"
        return 1
    fi
    
    # Check if ports are listening
    sleep 5
    if netstat -tuln 2>/dev/null | grep -q ":5432 " || lsof -Pi :5432 -sTCP:LISTEN >/dev/null 2>&1; then
        log_success "PostgreSQL: OK"
    else
        log_warning "PostgreSQL: May not be ready yet"
    fi
    
    log_success "Health check completed"
}

# Cleanup on failure
cleanup_on_failure() {
    log_error "Deployment failed. Cleaning up..."
    docker compose down 2>/dev/null || docker-compose down 2>/dev/null || true
}

# Main execution
main() {
    print_banner
    
    # Trap errors
    trap cleanup_on_failure ERR
    
    # Step 1: Environment detection
    detect_os
    detect_project_dir
    
    # Step 2: Check and install dependencies
    check_nodejs
    check_pnpm
    check_docker
    check_docker_compose
    
    # Step 3: Check ports
    check_ports
    
    # Step 4: Install project dependencies
    install_dependencies
    
    # Step 5: Setup Docker containers
    setup_docker_containers
    
    # Step 6: Run migrations
    run_migrations
    
    # Step 7: Health check
    health_check
    
    # Success message
    echo ""
    log_success "╔════════════════════════════════════════════════════════╗"
    log_success "║  Devbaytech deployment completed successfully!        ║"
    log_success "╚════════════════════════════════════════════════════════╝"
    echo ""
    log_info "To start the services, run: pnpm dev"
    log_info "Or continue with: "
    echo ""
    
    # Ask if user wants to start services now
    read -p "Start services now? (y/n): " start_now
    if [[ "$start_now" =~ ^[Yy]$ ]]; then
        start_services
    else
        log_info "You can start services later with: pnpm dev"
        log_info "Default credentials: admin@devbaytech.com / admin123"
    fi
}

# Run main function
main "$@"
