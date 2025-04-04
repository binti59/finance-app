#!/bin/bash

# Management script for Personal Finance Management System
# This script provides commands to manage the application

# Set installation directory
INSTALL_DIR="/opt/personal-finance-system"

# Function to display usage
usage() {
  echo "Usage: $0 [command]"
  echo "Commands:"
  echo "  start       - Start all services"
  echo "  stop        - Stop all services"
  echo "  restart     - Restart all services"
  echo "  status      - Check status of services"
  echo "  logs        - View logs"
  echo "  backup      - Create a backup"
  echo "  update      - Update the application"
  echo "  monitor     - Run monitoring check"
  echo "  help        - Display this help message"
}

# Check if command is provided
if [ $# -eq 0 ]; then
  usage
  exit 1
fi

# Process commands
case "$1" in
  start)
    echo "Starting services..."
    cd ${INSTALL_DIR} && docker-compose up -d
    echo "Services started"
    ;;
  stop)
    echo "Stopping services..."
    cd ${INSTALL_DIR} && docker-compose down
    echo "Services stopped"
    ;;
  restart)
    echo "Restarting services..."
    cd ${INSTALL_DIR} && docker-compose restart
    echo "Services restarted"
    ;;
  status)
    echo "Checking service status..."
    cd ${INSTALL_DIR} && docker-compose ps
    ;;
  logs)
    echo "Viewing logs..."
    cd ${INSTALL_DIR} && docker-compose logs
    ;;
  backup)
    echo "Creating backup..."
    ${INSTALL_DIR}/scripts/backup.sh
    ;;
  update)
    echo "Updating application..."
    cd ${INSTALL_DIR} && git pull
    docker-compose down
    docker-compose up -d --build
    echo "Application updated"
    ;;
  monitor)
    echo "Running monitoring check..."
    ${INSTALL_DIR}/scripts/monitor.sh
    ;;
  help)
    usage
    ;;
  *)
    echo "Unknown command: $1"
    usage
    exit 1
    ;;
esac

exit 0
