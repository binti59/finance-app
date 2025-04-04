#!/bin/bash

# Enhanced Installation Script for Personal Finance Management System
# This script installs the enhanced finance application with all features
# Created: April 04, 2025

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display section headers
print_section() {
    echo -e "\n${BLUE}==== $1 ====${NC}\n"
}

# Function to display success messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to display warning messages
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to display error messages
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    print_error "This script must be run as root (with sudo)"
    exit 1
fi

# Welcome message
clear
echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}    Enhanced Personal Finance Management System Installer    ${NC}"
echo -e "${BLUE}============================================================${NC}"
echo
echo -e "This script will install the Enhanced Personal Finance Management System"
echo -e "on your server using files from GitHub."
echo -e "This version includes comprehensive financial dashboard, multi-source data"
echo -e "integration, investment portfolio management, and financial independence planning."
echo

# Configuration variables with defaults
INSTALL_DIR="/opt/personal-finance-system"
DB_USER="finance_user"
DB_PASSWORD=$(openssl rand -base64 12)
DB_NAME="finance_db"
JWT_SECRET=$(openssl rand -base64 32)
DOMAIN_NAME=""
ADMIN_EMAIL=""

# Validate port variables
validate_port() {
    local port_name="$1"
    local port_value="$2"
    local default_value="$3"
    
    if [[ -z "$port_value" || ! "$port_value" =~ ^[0-9]+$ ]]; then
        print_warning "Invalid or empty $port_name value: '$port_value'. Using default: $default_value"
        echo "$default_value"
    else
        echo "$port_value"
    fi
}

# Validate and set port variables with defaults
FRONTEND_PORT=$(validate_port "FRONTEND_PORT" "${FRONTEND_PORT}" "3000")
BACKEND_PORT=$(validate_port "BACKEND_PORT" "${BACKEND_PORT}" "4000")
DB_PORT=$(validate_port "DB_PORT" "${DB_PORT}" "5432")

# Interactive configuration
print_section "Configuration Settings"

# Domain configuration
read -p "Enter your domain name (e.g., finance.example.com): " input_domain
if [ -n "$input_domain" ]; then
    DOMAIN_NAME=$input_domain
else
    print_warning "No domain provided. Using server IP address."
    DOMAIN_NAME=$(curl -s ifconfig.me)
fi

# Email configuration
read -p "Enter admin email address for SSL certificates: " input_email
if [ -n "$input_email" ]; then
    ADMIN_EMAIL=$input_email
else
    print_warning "No email provided. Using admin@example.com"
    ADMIN_EMAIL="admin@example.com"
fi

# Port configuration
print_section "Port Configuration"
print_warning "Note: Using ports 3000 and 4000 for the finance application"

read -p "Enter frontend port [${FRONTEND_PORT}]: " input_frontend_port
if [ -n "$input_frontend_port" ]; then
    FRONTEND_PORT=$input_frontend_port
fi

read -p "Enter backend port [${BACKEND_PORT}]: " input_backend_port
if [ -n "$input_backend_port" ]; then
    BACKEND_PORT=$input_backend_port
fi

read -p "Enter database port [${DB_PORT}]: " input_db_port
if [ -n "$input_db_port" ]; then
    DB_PORT=$input_db_port
fi

# Database configuration
print_section "Database Configuration"

read -p "Enter database user [${DB_USER}]: " input_db_user
if [ -n "$input_db_user" ]; then
    DB_USER=$input_db_user
fi

read -p "Enter database password [auto-generated]: " input_db_password
if [ -n "$input_db_password" ]; then
    DB_PASSWORD=$input_db_password
fi

read -p "Enter database name [${DB_NAME}]: " input_db_name
if [ -n "$input_db_name" ]; then
    DB_NAME=$input_db_name
fi

# Installation directory
print_section "Installation Directory"

read -p "Enter installation directory [${INSTALL_DIR}]: " input_install_dir
if [ -n "$input_install_dir" ]; then
    INSTALL_DIR=$input_install_dir
fi

# Create installation directory
mkdir -p ${INSTALL_DIR}
print_success "Installation directory created: ${INSTALL_DIR}"

# Install dependencies
print_section "Installing Dependencies"

# Update package lists
apt update

# Install required packages
apt install -y docker.io docker-compose nginx certbot python3-certbot-nginx git curl apt-transport-https ca-certificates software-properties-common netcat-openbsd

# Install Node.js from NodeSource repository (includes npm)
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Install additional dependencies for enhanced features
apt install -y python3-pip python3-dev libpq-dev postgresql-client
pip3 install pandas numpy matplotlib seaborn scikit-learn

# Verify Node.js and npm installation
node -v
npm -v

print_success "Dependencies installed"

# Clone repository
print_section "Cloning Repository"

git clone https://github.com/binti59/finance-app.git /tmp/finance-app
cd /tmp/finance-app

print_success "Repository cloned"

# Copy files to installation directory
print_section "Setting Up Application Files"

cp -r /tmp/finance-app/* ${INSTALL_DIR}/
chmod +x ${INSTALL_DIR}/scripts/*.sh

print_success "Application files copied to installation directory"

# Configure environment variables
print_section "Configuring Environment Variables"

# Update .env files with configured values
sed -i "s/\${FRONTEND_PORT}/${FRONTEND_PORT}/g" ${INSTALL_DIR}/frontend/.env
sed -i "s/\${DOMAIN_NAME}/${DOMAIN_NAME}/g" ${INSTALL_DIR}/frontend/.env
sed -i "s/\${BACKEND_URL}/http:\/\/localhost:${BACKEND_PORT}/g" ${INSTALL_DIR}/frontend/.env

sed -i "s/\${BACKEND_PORT}/${BACKEND_PORT}/g" ${INSTALL_DIR}/backend/.env
sed -i "s/\${DB_NAME}/${DB_NAME}/g" ${INSTALL_DIR}/backend/.env
sed -i "s/\${DB_USER}/${DB_USER}/g" ${INSTALL_DIR}/backend/.env
sed -i "s/\${DB_PASSWORD}/${DB_PASSWORD}/g" ${INSTALL_DIR}/backend/.env
sed -i "s/\${JWT_SECRET}/${JWT_SECRET}/g" ${INSTALL_DIR}/backend/.env
sed -i "s/\${DB_PORT}/${DB_PORT}/g" ${INSTALL_DIR}/backend/.env

# Add new environment variables for enhanced features
cat >> ${INSTALL_DIR}/backend/.env << EOF

# API Keys for Financial Institutions
HSBC_API_KEY=
TRADING212_API_KEY=
MONEYBOX_API_KEY=

# Data Processing Settings
ENABLE_AUTO_CATEGORIZATION=true
ENABLE_FINANCIAL_INSIGHTS=true
ENABLE_INVESTMENT_ANALYSIS=true

# Financial Independence Settings
DEFAULT_WITHDRAWAL_RATE=4
DEFAULT_EXPECTED_RETURN=7
EOF

# Update docker-compose.yml with configured values
sed -i "s/\${FRONTEND_PORT}/${FRONTEND_PORT}/g" ${INSTALL_DIR}/docker-compose.yml
sed -i "s/\${BACKEND_PORT}/${BACKEND_PORT}/g" ${INSTALL_DIR}/docker-compose.yml
sed -i "s/\${DB_PORT}/${DB_PORT}/g" ${INSTALL_DIR}/docker-compose.yml
sed -i "s/\${DB_NAME}/${DB_NAME}/g" ${INSTALL_DIR}/docker-compose.yml
sed -i "s/\${DB_USER}/${DB_USER}/g" ${INSTALL_DIR}/docker-compose.yml
sed -i "s/\${DB_PASSWORD}/${DB_PASSWORD}/g" ${INSTALL_DIR}/docker-compose.yml
sed -i "s/\${JWT_SECRET}/${JWT_SECRET}/g" ${INSTALL_DIR}/docker-compose.yml
sed -i "s/\${DOMAIN_NAME}/${DOMAIN_NAME}/g" ${INSTALL_DIR}/docker-compose.yml

print_success "Environment variables configured"

# Set up Nginx configuration
print_section "Setting Up Web Server"

cat > /etc/nginx/sites-available/personal-finance.conf << EOF
server {
    listen 80;
    server_name ${DOMAIN_NAME};

    location / {
        proxy_pass http://localhost:${FRONTEND_PORT};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    location /api {
        proxy_pass http://localhost:${BACKEND_PORT};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    # Additional configuration for file uploads
    client_max_body_size 50M;
}
EOF

# Enable the site
ln -s /etc/nginx/sites-available/personal-finance.conf /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx

print_success "Web server configuration completed"

# Set up SSL with Certbot
print_section "Setting Up SSL"
certbot --nginx -d ${DOMAIN_NAME} --non-interactive --agree-tos -m ${ADMIN_EMAIL}
print_success "SSL certificates installed"

# Set up firewall
print_section "Configuring Firewall"
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp

# Add port rules with validation
if [[ "${FRONTEND_PORT}" =~ ^[0-9]+$ ]]; then
    ufw allow "${FRONTEND_PORT}/tcp"
else
    print_warning "Invalid FRONTEND_PORT value: ${FRONTEND_PORT}. Skipping firewall rule."
fi

if [[ "${BACKEND_PORT}" =~ ^[0-9]+$ ]]; then
    ufw allow "${BACKEND_PORT}/tcp"
else
    print_warning "Invalid BACKEND_PORT value: ${BACKEND_PORT}. Skipping firewall rule."
fi

if [[ "${DB_PORT}" =~ ^[0-9]+$ ]]; then
    ufw allow "${DB_PORT}/tcp"
else
    print_warning "Invalid DB_PORT value: ${DB_PORT}. Skipping firewall rule."
fi

ufw --force enable
print_success "Firewall configured"

# Set up enhanced backup system
print_section "Setting Up Enhanced Backup System"
chmod +x ${INSTALL_DIR}/scripts/backup.sh

# Create enhanced backup script
cat > ${INSTALL_DIR}/scripts/enhanced_backup.sh << EOF
#!/bin/bash

# Enhanced Backup Script for Personal Finance Management System
# This script performs comprehensive backups of all system components
# Created: April 04, 2025

# Configuration
BACKUP_DIR="${INSTALL_DIR}/backups"
DB_NAME="${DB_NAME}"
DB_USER="${DB_USER}"
DB_PASSWORD="${DB_PASSWORD}"
DB_PORT="${DB_PORT}"
TIMESTAMP=\$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="\${BACKUP_DIR}/finance_backup_\${TIMESTAMP}.tar.gz"
LOG_FILE="\${BACKUP_DIR}/backup_log.txt"

# Create backup directory if it doesn't exist
mkdir -p \${BACKUP_DIR}

# Log function
log() {
    echo "\$(date +"%Y-%m-%d %H:%M:%S") - \$1" >> \${LOG_FILE}
    echo "\$1"
}

log "Starting enhanced backup process..."

# Backup database
log "Backing up PostgreSQL database..."
docker exec finance_app_postgres pg_dump -U \${DB_USER} -d \${DB_NAME} > \${BACKUP_DIR}/db_backup_\${TIMESTAMP}.sql
if [ \$? -eq 0 ]; then
    log "Database backup successful."
else
    log "ERROR: Database backup failed!"
fi

# Backup configuration files
log "Backing up configuration files..."
mkdir -p \${BACKUP_DIR}/config_\${TIMESTAMP}
cp ${INSTALL_DIR}/docker-compose.yml \${BACKUP_DIR}/config_\${TIMESTAMP}/
cp ${INSTALL_DIR}/backend/.env \${BACKUP_DIR}/config_\${TIMESTAMP}/backend.env
cp ${INSTALL_DIR}/frontend/.env \${BACKUP_DIR}/config_\${TIMESTAMP}/frontend.env

# Create compressed archive of all backups
log "Creating compressed archive..."
tar -czf \${BACKUP_FILE} -C \${BACKUP_DIR} db_backup_\${TIMESTAMP}.sql config_\${TIMESTAMP}

# Clean up temporary files
log "Cleaning up temporary files..."
rm \${BACKUP_DIR}/db_backup_\${TIMESTAMP}.sql
rm -rf \${BACKUP_DIR}/config_\${TIMESTAMP}

# Rotate backups (keep last 10)
log "Rotating backups..."
ls -t \${BACKUP_DIR}/finance_backup_*.tar.gz | tail -n +11 | xargs -r rm

log "Backup completed successfully: \${BACKUP_FILE}"
EOF

chmod +x ${INSTALL_DIR}/scripts/enhanced_backup.sh

# Add backup job to crontab
(crontab -l 2>/dev/null; echo "0 2 * * * ${INSTALL_DIR}/scripts/enhanced_backup.sh") | crontab -

print_success "Enhanced backup system configured"

# Set up enhanced monitoring
print_section "Setting Up Enhanced Monitoring"
chmod +x ${INSTALL_DIR}/scripts/monitor.sh

# Create enhanced monitoring script
cat > ${INSTALL_DIR}/scripts/enhanced_monitor.sh << EOF
#!/bin/bash

# Enhanced Monitoring Script for Personal Finance Management System
# This script monitors all components of the system and sends alerts if issues are detected
# Created: April 04, 2025

# Configuration
INSTALL_DIR="${INSTALL_DIR}"
LOG_DIR="${INSTALL_DIR}/logs"
ALERT_EMAIL="${ADMIN_EMAIL}"
FRONTEND_PORT="${FRONTEND_PORT}"
BACKEND_PORT="${BACKEND_PORT}"
DB_PORT="${DB_PORT}"
TIMESTAMP=\$(date +"%Y%m%d_%H%M%S")
LOG_FILE="\${LOG_DIR}/monitor_\${TIMESTAMP}.log"

# Create log directory if it doesn't exist
mkdir -p \${LOG_DIR}

# Log function
log() {
    echo "\$(date +"%Y-%m-%d %H:%M:%S") - \$1" >> \${LOG_FILE}
    echo "\$1"
}

# Alert function
send_alert() {
    echo "\$1" | mail -s "ALERT: Personal Finance System Issue" \${ALERT_EMAIL}
    log "Alert sent: \$1"
}

log "Starting enhanced monitoring process..."

# Check Docker service
log "Checking Docker service..."
if ! systemctl is-active --quiet docker; then
    log "ERROR: Docker service is not running!"
    send_alert "Docker service is not running on the finance system server."
    systemctl start docker
    log "Attempted to start Docker service."
fi

# Check Docker containers
log "Checking Docker containers..."
CONTAINERS=("finance_app_frontend" "finance_app_backend" "finance_app_postgres")
for CONTAINER in "\${CONTAINERS[@]}"; do
    if ! docker ps | grep -q \${CONTAINER}; then
        log "ERROR: Container \${CONTAINER} is not running!"
        send_alert "Container \${CONTAINER} is not running on the finance system server."
        
        # Attempt to restart the container
        log "Attempting to restart \${CONTAINER}..."
        cd \${INSTALL_DIR} && docker-compose up -d \${CONTAINER}
    fi
done

# Check service ports
log "Checking service ports..."
if ! nc -z localhost \${FRONTEND_PORT}; then
    log "ERROR: Frontend service not responding on port \${FRONTEND_PORT}!"
    send_alert "Frontend service not responding on port \${FRONTEND_PORT}."
fi

if ! nc -z localhost \${BACKEND_PORT}; then
    log "ERROR: Backend service not responding on port \${BACKEND_PORT}!"
    send_alert "Backend service not responding on port \${BACKEND_PORT}."
fi

if ! nc -z localhost \${DB_PORT}; then
    log "ERROR: Database service not responding on port \${DB_PORT}!"
    send_alert "Database service not responding on port \${DB_PORT}."
fi

# Check disk space
log "Checking disk space..."
DISK_USAGE=\$(df -h / | awk 'NR==2 {print \$5}' | sed 's/%//')
if [ \${DISK_USAGE} -gt 90 ]; then
    log "WARNING: Disk usage is at \${DISK_USAGE}%!"
    send_alert "Disk usage on the finance system server is at \${DISK_USAGE}%."
fi

# Check memory usage
log "Checking memory usage..."
MEM_USAGE=\$(free | grep Mem | awk '{print int(\$3/\$2 * 100)}')
if [ \${MEM_USAGE} -gt 90 ]; then
    log "WARNING: Memory usage is at \${MEM_USAGE}%!"
    send_alert "Memory usage on the finance system server is at \${MEM_USAGE}%."
fi

# Check CPU load
log "Checking CPU load..."
CPU_LOAD=\$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - \$1}')
if (( \$(echo "\${CPU_LOAD} > 90" | bc -l) )); then
    log "WARNING: CPU usage is at \${CPU_LOAD}%!"
    send_alert "CPU usage on the finance system server is at \${CPU_LOAD}%."
fi

# Rotate logs (keep last 30)
find \${LOG_DIR} -name "monitor_*.log" -type f -mtime +30 -delete

log "Monitoring completed successfully."
EOF

chmod +x ${INSTALL_DIR}/scripts/enhanced_monitor.sh

# Add monitoring job to crontab
(crontab -l 2>/dev/null; echo "*/15 * * * * ${INSTALL_DIR}/scripts/enhanced_monitor.sh") | crontab -

print_success "Enhanced monitoring system configured"

# Create enhanced management script
print_section "Setting Up Enhanced Management Script"

cat > ${INSTALL_DIR}/scripts/enhanced_manage.sh << EOF
#!/bin/bash

# Enhanced Management Script for Personal Finance Management System
# This script provides comprehensive management commands for the system
# Created: April 04, 2025

# Configuration
INSTALL_DIR="${INSTALL_DIR}"
FRONTEND_PORT="${FRONTEND_PORT}"
BACKEND_PORT="${BACKEND_PORT}"
DB_PORT="${DB_PORT}"

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage
show_usage() {
    echo -e "\n${BLUE}Personal Finance Management System - Management Script${NC}"
    echo -e "\nUsage: finance-manage [command]"
    echo -e "\nCommands:"
    echo -e "  status            Show status of all services"
    echo -e "  start             Start all services"
    echo -e "  stop              Stop all services"
    echo -e "  restart           Restart all services"
    echo -e "  logs [service]    Show logs (frontend, backend, database, or all)"
    echo -e "  backup            Run manual backup"
    echo -e "  restore [file]    Restore from backup file"
    echo -e "  update            Update to latest version"
    echo -e "  reset-password    Reset admin password"
    echo -e "  health            Run health check"
    echo -e "  help              Show this help message"
    echo
}

# Function to check status
check_status() {
    echo -e "${BLUE}Checking status of Personal Finance Management System...${NC}"
    cd ${INSTALL_DIR} && docker-compose ps
    
    echo -e "\n${BLUE}Service Health:${NC}"
    if nc -z localhost ${FRONTEND_PORT}; then
        echo -e "${GREEN}Frontend: Running on port ${FRONTEND_PORT}${NC}"
    else
        echo -e "${RED}Frontend: Not responding on port ${FRONTEND_PORT}${NC}"
    fi
    
    if nc -z localhost ${BACKEND_PORT}; then
        echo -e "${GREEN}Backend: Running on port ${BACKEND_PORT}${NC}"
    else
        echo -e "${RED}Backend: Not responding on port ${BACKEND_PORT}${NC}"
    fi
    
    if nc -z localhost ${DB_PORT}; then
        echo -e "${GREEN}Database: Running on port ${DB_PORT}${NC}"
    else
        echo -e "${RED}Database: Not responding on port ${DB_PORT}${NC}"
    fi
}

# Function to start services
start_services() {
    echo -e "${BLUE}Starting Personal Finance Management System...${NC}"
    cd ${INSTALL_DIR} && docker-compose up -d
    echo -e "${GREEN}Services started.${NC}"
}

# Function to stop services
stop_services() {
    echo -e "${BLUE}Stopping Personal Finance Management System...${NC}"
    cd ${INSTALL_DIR} && docker-compose down
    echo -e "${GREEN}Services stopped.${NC}"
}

# Function to restart services
restart_services() {
    echo -e "${BLUE}Restarting Personal Finance Management System...${NC}"
    cd ${INSTALL_DIR} && docker-compose restart
    echo -e "${GREEN}Services restarted.${NC}"
}

# Function to show logs
show_logs() {
    local service=\$1
    
    case \$service in
        frontend)
            echo -e "${BLUE}Showing frontend logs...${NC}"
            cd ${INSTALL_DIR} && docker-compose logs --tail=100 -f frontend
            ;;
        backend)
            echo -e "${BLUE}Showing backend logs...${NC}"
            cd ${INSTALL_DIR} && docker-compose logs --tail=100 -f backend
            ;;
        database)
            echo -e "${BLUE}Showing database logs...${NC}"
            cd ${INSTALL_DIR} && docker-compose logs --tail=100 -f postgres
            ;;
        *)
            echo -e "${BLUE}Showing all logs...${NC}"
            cd ${INSTALL_DIR} && docker-compose logs --tail=100 -f
            ;;
    esac
}

# Function to run manual backup
run_backup() {
    echo -e "${BLUE}Running manual backup...${NC}"
    ${INSTALL_DIR}/scripts/enhanced_backup.sh
    echo -e "${GREEN}Backup completed.${NC}"
}

# Function to restore from backup
restore_backup() {
    local backup_file=\$1
    
    if [ -z "\$backup_file" ]; then
        echo -e "${RED}Error: Backup file not specified.${NC}"
        echo -e "Usage: finance-manage restore [backup_file]"
        exit 1
    fi
    
    if [ ! -f "\$backup_file" ]; then
        echo -e "${RED}Error: Backup file not found: \$backup_file${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}WARNING: This will replace your current database with the backup.${NC}"
    echo -e "${YELLOW}All current data will be lost.${NC}"
    read -p "Are you sure you want to proceed? (y/n): " -n 1 -r
    echo
    
    if [[ ! \$REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Restore cancelled.${NC}"
        exit 0
    fi
    
    echo -e "${BLUE}Restoring from backup: \$backup_file${NC}"
    
    # Extract backup
    TEMP_DIR=\$(mktemp -d)
    tar -xzf "\$backup_file" -C "\$TEMP_DIR"
    
    # Find SQL file
    SQL_FILE=\$(find "\$TEMP_DIR" -name "*.sql" | head -1)
    
    if [ -z "\$SQL_FILE" ]; then
        echo -e "${RED}Error: No SQL file found in backup.${NC}"
        rm -rf "\$TEMP_DIR"
        exit 1
    fi
    
    # Stop services
    cd ${INSTALL_DIR} && docker-compose down
    
    # Restore database
    echo -e "${BLUE}Restoring database...${NC}"
    cd ${INSTALL_DIR} && docker-compose up -d postgres
    sleep 10  # Wait for database to start
    
    # Drop and recreate database
    docker exec finance_app_postgres psql -U ${DB_USER} -c "DROP DATABASE IF EXISTS ${DB_NAME};"
    docker exec finance_app_postgres psql -U ${DB_USER} -c "CREATE DATABASE ${DB_NAME};"
    
    # Restore data
    cat "\$SQL_FILE" | docker exec -i finance_app_postgres psql -U ${DB_USER} -d ${DB_NAME}
    
    # Start services
    cd ${INSTALL_DIR} && docker-compose up -d
    
    # Clean up
    rm -rf "\$TEMP_DIR"
    
    echo -e "${GREEN}Restore completed successfully.${NC}"
}

# Function to update system
update_system() {
    echo -e "${BLUE}Updating Personal Finance Management System...${NC}"
    
    # Create backup before update
    echo -e "${BLUE}Creating backup before update...${NC}"
    ${INSTALL_DIR}/scripts/enhanced_backup.sh
    
    # Pull latest code
    echo -e "${BLUE}Pulling latest code...${NC}"
    cd ${INSTALL_DIR}
    git pull origin main
    
    # Rebuild and restart
    echo -e "${BLUE}Rebuilding and restarting services...${NC}"
    docker-compose down
    docker-compose build
    docker-compose up -d
    
    echo -e "${GREEN}Update completed successfully.${NC}"
}

# Function to reset admin password
reset_password() {
    echo -e "${BLUE}Resetting admin password...${NC}"
    
    # Generate new password
    NEW_PASSWORD=\$(openssl rand -base64 12)
    
    # Update password in database
    docker exec finance_app_postgres psql -U ${DB_USER} -d ${DB_NAME} -c "UPDATE users SET password_hash = crypt('\${NEW_PASSWORD}', gen_salt('bf')) WHERE email = 'admin@example.com' OR username = 'admin';"
    
    echo -e "${GREEN}Admin password reset to: \${NEW_PASSWORD}${NC}"
    echo -e "${YELLOW}Please change this password after logging in.${NC}"
}

# Function to run health check
run_health_check() {
    echo -e "${BLUE}Running health check...${NC}"
    
    # Check services
    check_status
    
    # Check disk space
    echo -e "\n${BLUE}Disk Space:${NC}"
    df -h /
    
    # Check memory usage
    echo -e "\n${BLUE}Memory Usage:${NC}"
    free -h
    
    # Check CPU load
    echo -e "\n${BLUE}CPU Load:${NC}"
    uptime
    
    # Check Docker status
    echo -e "\n${BLUE}Docker Status:${NC}"
    docker info | grep "Server Version\|Containers\|Images"
    
    # Check database connection
    echo -e "\n${BLUE}Database Connection:${NC}"
    if docker exec finance_app_postgres pg_isready -U ${DB_USER} -d ${DB_NAME}; then
        echo -e "${GREEN}Database connection successful.${NC}"
    else
        echo -e "${RED}Database connection failed.${NC}"
    fi
    
    # Check API health
    echo -e "\n${BLUE}API Health:${NC}"
    if curl -s http://localhost:${BACKEND_PORT}/api/health | grep -q "ok"; then
        echo -e "${GREEN}API health check successful.${NC}"
    else
        echo -e "${RED}API health check failed.${NC}"
    fi
    
    echo -e "\n${GREEN}Health check completed.${NC}"
}

# Main script logic
case "\$1" in
    status)
        check_status
        ;;
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    logs)
        show_logs "\$2"
        ;;
    backup)
        run_backup
        ;;
    restore)
        restore_backup "\$2"
        ;;
    update)
        update_system
        ;;
    reset-password)
        reset_password
        ;;
    health)
        run_health_check
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        echo -e "${RED}Unknown command: \$1${NC}"
        show_usage
        exit 1
        ;;
esac

exit 0
EOF

chmod +x ${INSTALL_DIR}/scripts/enhanced_manage.sh

# Create management script symlink
ln -s ${INSTALL_DIR}/scripts/enhanced_manage.sh /usr/local/bin/finance-manage
chmod +x /usr/local/bin/finance-manage

print_success "Enhanced management script installed"

# Build and start the application
print_section "Building and Starting the Application"
cd ${INSTALL_DIR}
docker-compose up -d

print_success "Application built and started"

# Clean up
print_section "Cleaning Up"
rm -rf /tmp/finance-app

print_success "Temporary files removed"

# Final message
print_section "Installation Complete"
echo -e "The Enhanced Personal Finance Management System has been installed successfully."
echo -e "You can access the application at: https://${DOMAIN_NAME}"
echo -e "To manage the application, use the command: finance-manage"
echo -e "For example: finance-manage status"
echo
echo -e "Database Information:"
echo -e "  User: ${DB_USER}"
echo -e "  Password: ${DB_PASSWORD}"
echo -e "  Database: ${DB_NAME}"
echo -e "  Port: ${DB_PORT}"
echo
echo -e "Application Ports:"
echo -e "  Frontend: ${FRONTEND_PORT}"
echo -e "  Backend: ${BACKEND_PORT}"
echo
echo -e "Installation Directory: ${INSTALL_DIR}"
echo
echo -e "New Features:"
echo -e "  - Comprehensive Financial Dashboard"
echo -e "  - Multi-source Data Integration (HSBC, Trading212, Moneybox)"
echo -e "  - CSV/PDF Statement Upload and Parsing"
echo -e "  - Investment Portfolio Management"
echo -e "  - Financial Independence Planning Tools"
echo -e "  - Advanced Financial KPIs"
echo -e "  - Goal Setting and Tracking"
echo -e "  - Enhanced Backup and Monitoring"
echo
print_success "Thank you for installing the Enhanced Personal Finance Management System!"
