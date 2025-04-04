#!/bin/bash

# Dependency Fix Script for Personal Finance Management System
# This script fixes missing dependencies in the frontend
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
echo -e "${BLUE}    Dependency Fix for Personal Finance Management System    ${NC}"
echo -e "${BLUE}============================================================${NC}"
echo
echo -e "This script will fix missing dependencies in the frontend application."
echo

# Configuration variables with defaults
INSTALL_DIR="/opt/personal-finance-system"

# Check if installation directory exists
if [ ! -d "$INSTALL_DIR" ]; then
    print_error "Installation directory not found: $INSTALL_DIR"
    read -p "Please enter the correct installation directory: " input_dir
    if [ -z "$input_dir" ]; then
        print_error "No directory specified. Exiting."
        exit 1
    fi
    INSTALL_DIR="$input_dir"
    if [ ! -d "$INSTALL_DIR" ]; then
        print_error "Directory does not exist: $INSTALL_DIR"
        exit 1
    fi
fi

# Check if frontend directory exists
if [ ! -d "$INSTALL_DIR/frontend" ]; then
    print_error "Frontend directory not found: $INSTALL_DIR/frontend"
    exit 1
fi

# Fix missing dependencies
print_section "Fixing Missing Dependencies"

# Method 1: Install dependencies directly in the container
echo -e "Method 1: Installing dependencies directly in the container..."

# Check if Docker is running
if ! systemctl is-active --quiet docker; then
    print_error "Docker service is not running!"
    echo -e "Starting Docker service..."
    systemctl start docker
    sleep 5
    if ! systemctl is-active --quiet docker; then
        print_error "Failed to start Docker service. Exiting."
        exit 1
    fi
    print_success "Docker service started successfully."
else
    print_success "Docker service is running."
fi

# Check if frontend container is running
FRONTEND_CONTAINER=$(docker ps -qf "name=frontend")
if [ -z "$FRONTEND_CONTAINER" ]; then
    print_warning "Frontend container is not running."
    echo -e "Checking for stopped containers..."
    
    STOPPED_CONTAINER=$(docker ps -aqf "name=frontend")
    if [ -n "$STOPPED_CONTAINER" ]; then
        echo -e "Found stopped frontend container. Starting it..."
        docker start $STOPPED_CONTAINER
        sleep 5
        FRONTEND_CONTAINER=$(docker ps -qf "name=frontend")
        if [ -z "$FRONTEND_CONTAINER" ]; then
            print_error "Failed to start frontend container."
        else
            print_success "Frontend container started successfully."
        fi
    else
        print_error "No frontend container found."
        echo -e "Will try to rebuild the container."
    fi
fi

# Install dependencies in the container if it's running
if [ -n "$FRONTEND_CONTAINER" ]; then
    echo -e "Installing dependencies in the running container..."
    docker exec -it $FRONTEND_CONTAINER npm install --save react-redux redux redux-thunk react-router-dom axios chart.js react-chartjs-2
    
    if [ $? -eq 0 ]; then
        print_success "Dependencies installed successfully in the container."
    else
        print_warning "Failed to install dependencies in the container."
    fi
fi

# Method 2: Update Dockerfile and rebuild
print_section "Updating Dockerfile and Rebuilding"

# Backup original Dockerfile
if [ -f "$INSTALL_DIR/frontend/Dockerfile" ]; then
    cp "$INSTALL_DIR/frontend/Dockerfile" "$INSTALL_DIR/frontend/Dockerfile.bak"
    print_success "Original Dockerfile backed up."
    
    # Check if Dockerfile already has the dependency installation
    if grep -q "npm install --save react-redux" "$INSTALL_DIR/frontend/Dockerfile"; then
        print_warning "Dockerfile already contains dependency installation commands."
    else
        # Update Dockerfile to include explicit dependency installation
        echo -e "Updating Dockerfile to include explicit dependency installation..."
        
        # Find the line with COPY . .
        COPY_LINE=$(grep -n "COPY \. \." "$INSTALL_DIR/frontend/Dockerfile" | cut -d: -f1)
        
        if [ -n "$COPY_LINE" ]; then
            # Insert dependency installation before COPY . .
            sed -i "${COPY_LINE}i# Install specific dependencies that might be missing\nRUN npm install --save react-redux redux redux-thunk react-router-dom axios chart.js react-chartjs-2" "$INSTALL_DIR/frontend/Dockerfile"
            print_success "Dockerfile updated successfully."
        else
            print_warning "Could not find 'COPY . .' line in Dockerfile."
            echo -e "Appending dependency installation to the end of the Dockerfile..."
            echo -e "\n# Install specific dependencies that might be missing\nRUN npm install --save react-redux redux redux-thunk react-router-dom axios chart.js react-chartjs-2" >> "$INSTALL_DIR/frontend/Dockerfile"
            print_success "Dockerfile updated successfully."
        fi
    fi
else
    print_error "Dockerfile not found: $INSTALL_DIR/frontend/Dockerfile"
    
    # Create a new Dockerfile
    echo -e "Creating a new Dockerfile..."
    mkdir -p "$INSTALL_DIR/frontend"
    cat > "$INSTALL_DIR/frontend/Dockerfile" << EOF
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

# Install specific dependencies that might be missing
RUN npm install --save react-redux redux redux-thunk react-router-dom axios chart.js react-chartjs-2

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
EOF
    print_success "New Dockerfile created."
fi

# Rebuild the frontend container
print_section "Rebuilding Frontend Container"

cd "$INSTALL_DIR"

echo -e "Stopping containers..."
docker-compose down frontend

echo -e "Building frontend container..."
docker-compose build frontend

echo -e "Starting containers..."
docker-compose up -d

if [ $? -eq 0 ]; then
    print_success "Frontend container rebuilt and started successfully."
else
    print_error "Failed to rebuild and start frontend container."
fi

# Method 3: Manual package.json update
print_section "Updating package.json"

# Check if package.json exists
if [ -f "$INSTALL_DIR/frontend/package.json" ]; then
    # Backup original package.json
    cp "$INSTALL_DIR/frontend/package.json" "$INSTALL_DIR/frontend/package.json.bak"
    print_success "Original package.json backed up."
    
    # Check if dependencies are already in package.json
    if grep -q "\"react-redux\":" "$INSTALL_DIR/frontend/package.json"; then
        print_warning "react-redux is already in package.json."
    else
        echo -e "Adding missing dependencies to package.json..."
        
        # Use jq if available, otherwise use sed
        if command -v jq &> /dev/null; then
            # Create a temporary file with updated dependencies
            jq '.dependencies["react-redux"] = "^8.0.5" | .dependencies["redux"] = "^4.2.1" | .dependencies["redux-thunk"] = "^2.4.2"' "$INSTALL_DIR/frontend/package.json" > "$INSTALL_DIR/frontend/package.json.tmp"
            mv "$INSTALL_DIR/frontend/package.json.tmp" "$INSTALL_DIR/frontend/package.json"
            print_success "package.json updated using jq."
        else
            # Use sed as a fallback
            sed -i 's/"dependencies": {/"dependencies": {\n    "react-redux": "^8.0.5",\n    "redux": "^4.2.1",\n    "redux-thunk": "^2.4.2",/g' "$INSTALL_DIR/frontend/package.json"
            print_success "package.json updated using sed."
        fi
    fi
else
    print_error "package.json not found: $INSTALL_DIR/frontend/package.json"
    
    # Create a basic package.json
    echo -e "Creating a basic package.json..."
    mkdir -p "$INSTALL_DIR/frontend"
    cat > "$INSTALL_DIR/frontend/package.json" << EOF
{
  "name": "finance-app-frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "@material-ui/core": "^4.12.4",
    "@material-ui/icons": "^4.11.3",
    "@material-ui/lab": "^4.0.0-alpha.61",
    "@testing-library/jest-dom": "^5.16.5",
    "@testing-library/react": "^13.4.0",
    "@testing-library/user-event": "^14.4.3",
    "axios": "^1.3.4",
    "chart.js": "^4.2.1",
    "date-fns": "^2.29.3",
    "formik": "^2.2.9",
    "jwt-decode": "^3.1.2",
    "lodash": "^4.17.21",
    "react": "^18.2.0",
    "react-chartjs-2": "^5.2.0",
    "react-dom": "^18.2.0",
    "react-dropzone": "^14.2.3",
    "react-number-format": "^5.1.4",
    "react-redux": "^8.0.5",
    "react-router-dom": "^6.9.0",
    "react-scripts": "5.0.1",
    "redux": "^4.2.1",
    "redux-thunk": "^2.4.2",
    "web-vitals": "^3.3.0",
    "yup": "^1.0.2"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
EOF
    print_success "Basic package.json created with all required dependencies."
fi

# Install dependencies locally and rebuild
print_section "Installing Dependencies Locally and Rebuilding"

cd "$INSTALL_DIR/frontend"

echo -e "Installing dependencies locally..."
npm install --save react-redux redux redux-thunk react-router-dom axios chart.js react-chartjs-2

echo -e "Building frontend..."
npm run build

if [ $? -eq 0 ]; then
    print_success "Frontend built successfully."
else
    print_warning "Failed to build frontend locally."
fi

# Restart frontend container
print_section "Restarting Frontend Container"

cd "$INSTALL_DIR"
docker-compose restart frontend

if [ $? -eq 0 ]; then
    print_success "Frontend container restarted successfully."
else
    print_error "Failed to restart frontend container."
fi

# Final message
print_section "Dependency Fix Complete"
echo -e "The dependency fix process is complete. The frontend should now have all required dependencies."
echo
echo -e "If you still encounter issues, try accessing the application in a different browser or in incognito mode to rule out browser extension conflicts."
echo
echo -e "You can access your application at:"
if [ -f "/etc/nginx/sites-available/personal-finance.conf" ]; then
    DOMAIN=$(grep "server_name" /etc/nginx/sites-available/personal-finance.conf | awk '{print $2}' | tr -d ';')
    if [ -n "$DOMAIN" ] && [ "$DOMAIN" != "_" ]; then
        echo -e "https://$DOMAIN"
    else
        echo -e "http://$(hostname -I | awk '{print $1}'):3000"
    fi
else
    echo -e "http://$(hostname -I | awk '{print $1}'):3000"
fi
echo
print_success "Thank you for using the Enhanced Personal Finance Management System!"
