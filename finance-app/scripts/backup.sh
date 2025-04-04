#!/bin/bash

# Backup script for Personal Finance Management System
# This script creates a backup of the database and configuration files

# Set backup directory
BACKUP_DIR="/opt/personal-finance-system/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/finance_backup_${TIMESTAMP}.tar.gz"

# Create backup directory if it doesn't exist
mkdir -p ${BACKUP_DIR}

# Backup database
docker exec finance_app_postgres pg_dump -U ${DB_USER} -d ${DB_NAME} > ${BACKUP_DIR}/database_${TIMESTAMP}.sql

# Backup configuration files
cp docker-compose.yml ${BACKUP_DIR}/docker-compose_${TIMESTAMP}.yml
cp backend/.env ${BACKUP_DIR}/backend_env_${TIMESTAMP}
cp frontend/.env ${BACKUP_DIR}/frontend_env_${TIMESTAMP}

# Create compressed archive
tar -czf ${BACKUP_FILE} -C ${BACKUP_DIR} database_${TIMESTAMP}.sql docker-compose_${TIMESTAMP}.yml backend_env_${TIMESTAMP} frontend_env_${TIMESTAMP}

# Remove temporary files
rm ${BACKUP_DIR}/database_${TIMESTAMP}.sql ${BACKUP_DIR}/docker-compose_${TIMESTAMP}.yml ${BACKUP_DIR}/backend_env_${TIMESTAMP} ${BACKUP_DIR}/frontend_env_${TIMESTAMP}

echo "Backup completed: ${BACKUP_FILE}"

# Keep only the last 7 backups
ls -t ${BACKUP_DIR}/finance_backup_*.tar.gz | tail -n +8 | xargs -r rm

echo "Backup rotation completed. Keeping the 7 most recent backups."
