#!/bin/bash
set -e

# Enable pgAudit extension
echo "shared_preload_libraries = 'pgaudit'" >> ${PGDATA}/postgresql.conf

# Restart PostgreSQL to apply the changes
pg_ctl -D "$PGDATA" -m fast -w restart

# Create the pgAudit extension in the default database
psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS pgaudit;
EOSQL
