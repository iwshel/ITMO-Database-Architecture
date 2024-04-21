#!/bin/bash

execute_sql() {
    psql -U "$DB_SUPERUSER" -d "$POSTGRES_DB" -c "$1"
}

if [[ -z "$DB_USERNAME" ]]; then
    echo "Username for connection doesn't specified"
    exit 1
fi

version=$DB_VERSION

if [ -z "$version" ]; then
  version=$(find /migrations -type d | sort | tail -n1 | awk -F '/' '{ print $3 }')
fi

# shellcheck disable=SC1073
# shellcheck disable=SC2044
for script in $(find /migrations/$version/ -name "*.sql" -type f); do
  psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f $script
done

for data in data/*.sql; do
    psql -U  "$DB_USERNAME" -d "$POSTGRES_DB" -f "$data"
done

if ! execute_sql "\\du" | grep -qw "reader"; then
    execute_sql "CREATE USER reader WITH ENCRYPTED PASSWORD 'readerpassword';"
fi

if ! execute_sql "\\du" | grep -qw "writer"; then
    execute_sql "CREATE USER writer WITH ENCRYPTED PASSWORD 'writerpassword';"
fi

# Create analytic role if it does not exist
if ! execute_sql "\\du" | grep -qw "analytic"; then
    execute_sql "CREATE ROLE analytic;"
fi

execute_sql "CREATE ROLE group_role;"
execute_sql "GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO group_role;"

for ((i=1; i<=4; i++)); do
    username="user$i"
    if ! execute_sql "\\du" | grep -qw "$username"; then
        execute_sql "CREATE USER $username WITH ENCRYPTED PASSWORD 'password$i';"
    fi
    execute_sql "GRANT group_role to $username;"
done

execute_sql "GRANT SELECT ON TABLE roles TO analytic;"

execute_sql "ALTER USER reader WITH NOCREATEDB;"
execute_sql "ALTER USER writer WITH CREATEDB;"