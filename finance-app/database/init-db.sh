#!/bin/bash

# Database initialization script
# This script will be run when the PostgreSQL container starts

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    \c $POSTGRES_DB;
    
    -- Run the initialization SQL if tables don't exist
    DO \$\$
    BEGIN
        IF NOT EXISTS (SELECT FROM pg_tables WHERE tablename = 'users') THEN
            \i '/docker-entrypoint-initdb.d/init.sql';
        END IF;
    END
    \$\$;
EOSQL

echo "Database initialization completed."
