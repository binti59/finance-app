#!/bin/bash

# Enhanced Uninstall Script for Personal Finance Management System
# This script removes all components installed by install_finance_app_enhanced.sh
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

# Function to confirm actions
confirm_action() {
    read -p "$1 (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return 1
    fi
    return 0
}

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    print_error "This script must be run as root (with sudo)"
    exit 1
fi

# Welcome message
clear
echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}    Enhanced Personal Finance Management System Uninstaller  ${NC}"
echo -e "${BLUE}============================================================${NC}"
echo
echo -e "This script will uninstall and remove all components of the Enhanced Personal Finance"
echo -e "Management System from your server, including all data and configurations."
echo -e "This action is irreversible and will delete all your financial data."
echo

# Confirm uninstallation
if ! confirm_action "Do you want to proceed with uninstallation? All data will be lost!"; then
    echo -e "\nUninstallation cancelled."
    exit 0
fi

# Configuration variables with defaults
INSTALL_DIR="/opt/personal-finance-system"

# Ask for installation directory
read -p "Enter the installation directory [${INSTALL_DIR}]: " input_install_dir
INSTALL_DIR=${input_install_dir:-$INSTALL_DIR}

# Confirm again with specific directory
if ! confirm_action "This will remove all files in ${INSTALL_DIR}. Are you sure?"; then
    echo -e "\nUninstallation cancelled."
    exit 0
fi

# Option to create a final backup before uninstallation
if confirm_action "Would you like to create a final backup before uninstallation?"; then
    print_section "Creating Final Backup"
    
    # Create backup directory if it doesn't exist
    BACKUP_DIR="/root/finance_final_backup"
    mkdir -p ${BACKUP_DIR}
    
    # Run the enhanced backup script if it exists
    if [ -f "${INSTALL_DIR}/scripts/enhanced_backup.sh" ]; then
        ${INSTALL_DIR}/scripts/enhanced_backup.sh
        
        # Copy the latest backup to the final backup directory
        LATEST_BACKUP=$(ls -t ${INSTALL_DIR}/backups/finance_backup_*.tar.gz 2>/dev/null | head -1)
        if [ -n "${LATEST_BACKUP}" ]; then
            cp ${LATEST_BACKUP} ${BACKUP_DIR}/
            print_success "Final backup created at: ${BACKUP_DIR}/$(basename ${LATEST_BACKUP})"
        else
            print_warning "No existing backups found. Creating a new backup..."
            
            # Create a manual backup of the database
            if docker ps | grep -q finance_app_postgres; then
                docker exec finance_app_postgres pg_dump -U finance_user -d finance_db > ${BACKUP_DIR}/final_db_backup.sql
                print_success "Database backup created at: ${BACKUP_DIR}/final_db_backup.sql"
            else
                print_warning "PostgreSQL container not running. Database backup skipped."
            fi
        fi
    else
        print_warning "Enhanced backup script not found. Creating a manual backup..."
        
        # Create a manual backup of the database
        if docker ps | grep -q finance_app_postgres; then
            docker exec finance_app_postgres pg_dump -U finance_user -d finance_db > ${BACKUP_DIR}/final_db_backup.sql
            print_success "Database backup created at: ${BACKUP_DIR}/final_db_backup.sql"
        else
            print_warning "PostgreSQL container not running. Database backup skipped."
        fi
    fi
    
    # Backup configuration files
    if [ -d "${INSTALL_DIR}" ]; then
        mkdir -p ${BACKUP_DIR}/config
        cp -r ${INSTALL_DIR}/docker-compose.yml ${BACKUP_DIR}/config/ 2>/dev/null || true
        cp -r ${INSTALL_DIR}/backend/.env ${BACKUP_DIR}/config/backend.env 2>/dev/null || true
        cp -r ${INSTALL_DIR}/frontend/.env ${BACKUP_DIR}/config/frontend.env 2>/dev/null || true
        print_success "Configuration files backed up to: ${BACKUP_DIR}/config/"
    fi
    
    print_success "Final backup process completed."
fi

# Stop and remove Docker containers
print_section "Stopping Docker Containers"
if [ -f "${INSTALL_DIR}/docker-compose.yml" ]; then
    cd ${INSTALL_DIR}
    docker-compose down -v
    print_success "Docker containers stopped and removed"
else
    print_warning "Docker Compose file not found, attempting to stop containers manually"
    docker stop finance_app_frontend finance_app_backend finance_app_postgres 2>/dev/null || true
    docker rm finance_app_frontend finance_app_backend finance_app_postgres 2>/dev/null || true
    docker volume rm $(docker volume ls -q | grep postgres_data) 2>/dev/null || true
    docker network rm pfs-network 2>/dev/null || true
    print_success "Docker containers manually stopped and removed"
fi

# Remove Docker images
print_section "Removing Docker Images"
docker rmi $(docker images | grep finance_app | awk '{print $3}') 2>/dev/null || true
print_success "Docker images removed"

# Remove Nginx configuration
print_section "Removing Web Server Configuration"
if [ -f "/etc/nginx/sites-enabled/personal-finance.conf" ]; then
    rm -f /etc/nginx/sites-enabled/personal-finance.conf
    print_success "Nginx site configuration removed from sites-enabled"
fi

if [ -f "/etc/nginx/sites-available/personal-finance.conf" ]; then
    rm -f /etc/nginx/sites-available/personal-finance.conf
    print_success "Nginx site configuration removed from sites-available"
fi

# Reload Nginx
systemctl reload nginx
print_success "Nginx reloaded"

# Remove SSL certificates
print_section "Removing SSL Certificates"
# Extract domain name from Nginx config if possible
DOMAIN_NAME=$(grep -r "server_name" /etc/nginx/sites-available/ | grep -v "#" | grep -o "[a-zA-Z0-9.-]*finance[a-zA-Z0-9.-]*" | head -1)

if [ -n "$DOMAIN_NAME" ]; then
    certbot delete --cert-name ${DOMAIN_NAME} --non-interactive || true
    print_success "SSL certificates for ${DOMAIN_NAME} removed"
else
    print_warning "Domain name not found, skipping SSL certificate removal"
fi

# Remove firewall rules
print_section "Removing Firewall Rules"
# We'll keep essential rules (22, 80, 443) but remove application-specific ones
ufw status numbered | grep -E "3000|4000|5432" | cut -d"[" -f2 | cut -d"]" -f1 | sort -r | while read -r num; do
    ufw --force delete $num
done
print_success "Application-specific firewall rules removed"

# Remove cron job
print_section "Removing Scheduled Tasks"
(crontab -l 2>/dev/null | grep -v "${INSTALL_DIR}/scripts/backup.sh") | crontab -
(crontab -l 2>/dev/null | grep -v "${INSTALL_DIR}/scripts/monitor.sh") | crontab -
(crontab -l 2>/dev/null | grep -v "${INSTALL_DIR}/scripts/enhanced_backup.sh") | crontab -
(crontab -l 2>/dev/null | grep -v "${INSTALL_DIR}/scripts/enhanced_monitor.sh") | crontab -
print_success "Scheduled tasks removed"

# Remove management script symlink
if [ -f "/usr/local/bin/finance-manage" ]; then
    rm -f /usr/local/bin/finance-manage
    print_success "Management script symlink removed"
fi

# Remove installation directory
print_section "Removing Installation Directory"
if [ -d "${INSTALL_DIR}" ]; then
    rm -rf ${INSTALL_DIR}
    print_success "Installation directory removed: ${INSTALL_DIR}"
else
    print_warning "Installation directory not found: ${INSTALL_DIR}"
fi

# Clean up any remaining Docker volumes
print_section "Cleaning Up Docker Volumes"
docker volume ls -q | grep finance | xargs -r docker volume rm
print_success "Docker volumes cleaned up"

# Final message
print_section "Uninstallation Complete"
echo -e "The Enhanced Personal Finance Management System has been completely removed from your server."

if [ -d "${BACKUP_DIR}" ]; then
    echo -e "A final backup of your data was saved to: ${BACKUP_DIR}"
    echo -e "Please make sure to copy this backup to a safe location if you want to keep it."
fi

echo -e "If you want to reinstall it in the future, you can run the installation script again."
echo
print_success "Thank you for using the Enhanced Personal Finance Management System!"
