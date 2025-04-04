#!/bin/bash

# Monitoring script for Personal Finance Management System
# This script checks the health of the application components

# Set log directory
LOG_DIR="/opt/personal-finance-system/logs"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Create log directory if it doesn't exist
mkdir -p ${LOG_DIR}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
  echo "[${TIMESTAMP}] ERROR: Docker is not running" | tee -a ${LOG_DIR}/monitor.log
  exit 1
fi

# Check if containers are running
if ! docker ps | grep -q finance_app_postgres; then
  echo "[${TIMESTAMP}] ERROR: PostgreSQL container is not running" | tee -a ${LOG_DIR}/monitor.log
else
  echo "[${TIMESTAMP}] INFO: PostgreSQL container is running" | tee -a ${LOG_DIR}/monitor.log
fi

if ! docker ps | grep -q finance_app_backend; then
  echo "[${TIMESTAMP}] ERROR: Backend container is not running" | tee -a ${LOG_DIR}/monitor.log
else
  echo "[${TIMESTAMP}] INFO: Backend container is running" | tee -a ${LOG_DIR}/monitor.log
fi

if ! docker ps | grep -q finance_app_frontend; then
  echo "[${TIMESTAMP}] ERROR: Frontend container is not running" | tee -a ${LOG_DIR}/monitor.log
else
  echo "[${TIMESTAMP}] INFO: Frontend container is running" | tee -a ${LOG_DIR}/monitor.log
fi

# Check if services are responding
if curl -s http://localhost:${BACKEND_PORT}/api/health > /dev/null; then
  echo "[${TIMESTAMP}] INFO: Backend API is responding" | tee -a ${LOG_DIR}/monitor.log
else
  echo "[${TIMESTAMP}] ERROR: Backend API is not responding" | tee -a ${LOG_DIR}/monitor.log
fi

if curl -s http://localhost:${FRONTEND_PORT} > /dev/null; then
  echo "[${TIMESTAMP}] INFO: Frontend is responding" | tee -a ${LOG_DIR}/monitor.log
else
  echo "[${TIMESTAMP}] ERROR: Frontend is not responding" | tee -a ${LOG_DIR}/monitor.log
fi

# Check disk space
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ ${DISK_USAGE} -gt 90 ]; then
  echo "[${TIMESTAMP}] WARNING: Disk usage is high (${DISK_USAGE}%)" | tee -a ${LOG_DIR}/monitor.log
else
  echo "[${TIMESTAMP}] INFO: Disk usage is normal (${DISK_USAGE}%)" | tee -a ${LOG_DIR}/monitor.log
fi

# Check memory usage
MEM_USAGE=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
if [ ${MEM_USAGE} -gt 90 ]; then
  echo "[${TIMESTAMP}] WARNING: Memory usage is high (${MEM_USAGE}%)" | tee -a ${LOG_DIR}/monitor.log
else
  echo "[${TIMESTAMP}] INFO: Memory usage is normal (${MEM_USAGE}%)" | tee -a ${LOG_DIR}/monitor.log
fi

echo "[${TIMESTAMP}] INFO: Monitoring completed" | tee -a ${LOG_DIR}/monitor.log
