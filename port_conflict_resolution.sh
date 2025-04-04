#!/bin/bash

# Port Conflict Resolution Script for Personal Finance Management System
# This script helps resolve port conflicts during installation
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
echo -e "${BLUE}    Port Conflict Resolution for Finance Management System    ${NC}"
echo -e "${BLUE}============================================================${NC}"
echo
echo -e "This script will help resolve port conflicts for the Enhanced Personal Finance Management System."
echo

# Check for port conflicts
print_section "Checking for Port Conflicts"

# Check PostgreSQL port (5432)
if netstat -tuln | grep -q ":5432 "; then
    print_warning "PostgreSQL port 5432 is already in use"
    echo -e "Checking what's using port 5432..."
    
    # Try to identify what's using the port
    if command -v lsof >/dev/null 2>&1; then
        lsof -i :5432 || true
    else
        netstat -tulpn | grep 5432 || true
    fi
    
    # Check if it's a PostgreSQL service
    if systemctl is-active --quiet postgresql; then
        print_warning "System PostgreSQL service is running"
        
        # Ask if user wants to stop the service
        read -p "Would you like to stop the PostgreSQL service? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            systemctl stop postgresql
            print_success "PostgreSQL service stopped"
            
            read -p "Would you like to disable PostgreSQL from starting automatically? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                systemctl disable postgresql
                print_success "PostgreSQL service disabled"
            fi
        else
            # If not stopping the service, suggest using a different port
            print_warning "You chose not to stop the PostgreSQL service"
            echo -e "You will need to use a different port for the Finance Management System database."
            
            # Suggest a new port
            NEW_DB_PORT=5433
            echo -e "Suggested alternative port: ${NEW_DB_PORT}"
            
            # Ask if user wants to modify the installation script
            read -p "Would you like to modify the installation script to use port ${NEW_DB_PORT}? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                # Check if installation script exists
                INSTALL_SCRIPT="/home/ubuntu/install_finance_app_enhanced_fixed.sh"
                if [ -f "$INSTALL_SCRIPT" ]; then
                    # Create a backup
                    cp "$INSTALL_SCRIPT" "${INSTALL_SCRIPT}.bak"
                    
                    # Modify the script to use the new port
                    sed -i "s/DB_PORT=\$(validate_port \"DB_PORT\" \"\${input_db_port}\" \"5432\")/DB_PORT=\$(validate_port \"DB_PORT\" \"\${input_db_port}\" \"${NEW_DB_PORT}\")/g" "$INSTALL_SCRIPT"
                    
                    print_success "Installation script modified to use port ${NEW_DB_PORT} by default"
                    echo -e "Original script backed up as ${INSTALL_SCRIPT}.bak"
                else
                    print_error "Installation script not found at ${INSTALL_SCRIPT}"
                    echo -e "Please manually specify port ${NEW_DB_PORT} when running the installation script."
                fi
            fi
        fi
    else
        # If it's not the system PostgreSQL, check for Docker containers
        if docker ps | grep -q "postgres"; then
            print_warning "PostgreSQL is running in a Docker container"
            
            # Ask if user wants to stop the container
            read -p "Would you like to stop the PostgreSQL container? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                # Get container ID
                PG_CONTAINER=$(docker ps | grep postgres | awk '{print $1}')
                if [ -n "$PG_CONTAINER" ]; then
                    docker stop $PG_CONTAINER
                    print_success "PostgreSQL container stopped"
                else
                    print_error "Could not identify PostgreSQL container"
                fi
            else
                # If not stopping the container, suggest using a different port
                print_warning "You chose not to stop the PostgreSQL container"
                echo -e "You will need to use a different port for the Finance Management System database."
                
                # Suggest a new port
                NEW_DB_PORT=5433
                echo -e "Suggested alternative port: ${NEW_DB_PORT}"
                
                # Ask if user wants to modify the installation script
                read -p "Would you like to modify the installation script to use port ${NEW_DB_PORT}? (y/n): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    # Check if installation script exists
                    INSTALL_SCRIPT="/home/ubuntu/install_finance_app_enhanced_fixed.sh"
                    if [ -f "$INSTALL_SCRIPT" ]; then
                        # Create a backup
                        cp "$INSTALL_SCRIPT" "${INSTALL_SCRIPT}.bak"
                        
                        # Modify the script to use the new port
                        sed -i "s/DB_PORT=\$(validate_port \"DB_PORT\" \"\${input_db_port}\" \"5432\")/DB_PORT=\$(validate_port \"DB_PORT\" \"\${input_db_port}\" \"${NEW_DB_PORT}\")/g" "$INSTALL_SCRIPT"
                        
                        print_success "Installation script modified to use port ${NEW_DB_PORT} by default"
                        echo -e "Original script backed up as ${INSTALL_SCRIPT}.bak"
                    else
                        print_error "Installation script not found at ${INSTALL_SCRIPT}"
                        echo -e "Please manually specify port ${NEW_DB_PORT} when running the installation script."
                    fi
                fi
            fi
        else
            print_warning "Port 5432 is in use, but could not identify the service"
            echo -e "You will need to use a different port for the Finance Management System database."
            
            # Suggest a new port
            NEW_DB_PORT=5433
            echo -e "Suggested alternative port: ${NEW_DB_PORT}"
            
            # Ask if user wants to modify the installation script
            read -p "Would you like to modify the installation script to use port ${NEW_DB_PORT}? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                # Check if installation script exists
                INSTALL_SCRIPT="/home/ubuntu/install_finance_app_enhanced_fixed.sh"
                if [ -f "$INSTALL_SCRIPT" ]; then
                    # Create a backup
                    cp "$INSTALL_SCRIPT" "${INSTALL_SCRIPT}.bak"
                    
                    # Modify the script to use the new port
                    sed -i "s/DB_PORT=\$(validate_port \"DB_PORT\" \"\${input_db_port}\" \"5432\")/DB_PORT=\$(validate_port \"DB_PORT\" \"\${input_db_port}\" \"${NEW_DB_PORT}\")/g" "$INSTALL_SCRIPT"
                    
                    print_success "Installation script modified to use port ${NEW_DB_PORT} by default"
                    echo -e "Original script backed up as ${INSTALL_SCRIPT}.bak"
                else
                    print_error "Installation script not found at ${INSTALL_SCRIPT}"
                    echo -e "Please manually specify port ${NEW_DB_PORT} when running the installation script."
                fi
            fi
        fi
    fi
else
    print_success "PostgreSQL port 5432 is available"
fi

# Check Frontend port (3000)
if netstat -tuln | grep -q ":3000 "; then
    print_warning "Frontend port 3000 is already in use"
    
    # Suggest a new port
    NEW_FRONTEND_PORT=3001
    echo -e "Suggested alternative port: ${NEW_FRONTEND_PORT}"
    
    # Ask if user wants to modify the installation script
    read -p "Would you like to modify the installation script to use port ${NEW_FRONTEND_PORT}? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Check if installation script exists
        INSTALL_SCRIPT="/home/ubuntu/install_finance_app_enhanced_fixed.sh"
        if [ -f "$INSTALL_SCRIPT" ]; then
            # Create a backup if not already done
            if [ ! -f "${INSTALL_SCRIPT}.bak" ]; then
                cp "$INSTALL_SCRIPT" "${INSTALL_SCRIPT}.bak"
            fi
            
            # Modify the script to use the new port
            sed -i "s/FRONTEND_PORT=\$(validate_port \"FRONTEND_PORT\" \"\${input_frontend_port}\" \"3000\")/FRONTEND_PORT=\$(validate_port \"FRONTEND_PORT\" \"\${input_frontend_port}\" \"${NEW_FRONTEND_PORT}\")/g" "$INSTALL_SCRIPT"
            
            print_success "Installation script modified to use port ${NEW_FRONTEND_PORT} for frontend"
            echo -e "Original script backed up as ${INSTALL_SCRIPT}.bak"
        else
            print_error "Installation script not found at ${INSTALL_SCRIPT}"
            echo -e "Please manually specify port ${NEW_FRONTEND_PORT} when running the installation script."
        fi
    fi
else
    print_success "Frontend port 3000 is available"
fi

# Check Backend port (4000)
if netstat -tuln | grep -q ":4000 "; then
    print_warning "Backend port 4000 is already in use"
    
    # Suggest a new port
    NEW_BACKEND_PORT=4001
    echo -e "Suggested alternative port: ${NEW_BACKEND_PORT}"
    
    # Ask if user wants to modify the installation script
    read -p "Would you like to modify the installation script to use port ${NEW_BACKEND_PORT}? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Check if installation script exists
        INSTALL_SCRIPT="/home/ubuntu/install_finance_app_enhanced_fixed.sh"
        if [ -f "$INSTALL_SCRIPT" ]; then
            # Create a backup if not already done
            if [ ! -f "${INSTALL_SCRIPT}.bak" ]; then
                cp "$INSTALL_SCRIPT" "${INSTALL_SCRIPT}.bak"
            fi
            
            # Modify the script to use the new port
            sed -i "s/BACKEND_PORT=\$(validate_port \"BACKEND_PORT\" \"\${input_backend_port}\" \"4000\")/BACKEND_PORT=\$(validate_port \"BACKEND_PORT\" \"\${input_backend_port}\" \"${NEW_BACKEND_PORT}\")/g" "$INSTALL_SCRIPT"
            
            print_success "Installation script modified to use port ${NEW_BACKEND_PORT} for backend"
            echo -e "Original script backed up as ${INSTALL_SCRIPT}.bak"
        else
            print_error "Installation script not found at ${INSTALL_SCRIPT}"
            echo -e "Please manually specify port ${NEW_BACKEND_PORT} when running the installation script."
        fi
    fi
else
    print_success "Backend port 4000 is available"
fi

# Final message
print_section "Port Conflict Resolution Complete"
echo -e "The port conflict check and resolution process is complete."
echo
echo -e "If any port conflicts were found, you can:"
echo -e "1. Use the modified installation script with alternative ports"
echo -e "2. Stop conflicting services before installation"
echo -e "3. Manually specify different ports during installation"
echo
print_success "You can now proceed with the installation using:"
echo -e "sudo ./install_finance_app_enhanced_fixed.sh"
echo
echo -e "Thank you for using the Enhanced Personal Finance Management System!"
