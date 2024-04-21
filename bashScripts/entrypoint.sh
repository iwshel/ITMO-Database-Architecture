#!/bin/bash

execute_sql() {
    psql -U "$DB_SUPERUSER" -d "$POSTGRES_DB" -c "$1"
}

database_exists() {
    psql -U "$DB_SUPERUSER" -lqt | cut -d \| -f 1 | grep -qw "$1"
}

if ! database_exists "$POSTGRES_DB"; then
    execute_sql "CREATE DATABASE $POSTGRES_DB;"
fi

exec "$@"
