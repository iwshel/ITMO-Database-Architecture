#!/bin/bash

MIGRATIONS_DIR="./migration"
POSTGRES_USER="postgres"
POSTGRES_DB="discord-db"
PG_PASSWORD="mypassword"
PG_HOST="localhost"
PG_PORT="5432"

for migration_file in $MIGRATIONS_DIR/*.sql; do
    echo "Applying migration: $migration_file"
    psql -U $POSTGRES_USER -d $POSTGRES_DB -f $migration_file


    if [ $? -ne 0 ]; then
        echo "Migration failed: $migration_file"
        exit 1
    fi
done

# Массив имен пользователей
USERS=("user1" "user2" "user3")

# Функция для выполнения SQL запросов
execute_sql() {
  psql -h localhost -p $PG_PORT -U $POSTGRES_USER -d $POSTGRES_DB -c "$1"
}

# Создание ролей reader и writer
execute_sql "CREATE ROLE reader;"
execute_sql "CREATE ROLE writer;"

# Добавление прав для роли reader
execute_sql "GRANT SELECT ON ALL TABLES IN SCHEMA public TO reader;"

# Добавление прав для роли writer
execute_sql "GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO writer;"

# Создание пользователя analytic и дать ему доступ только к одной таблице
execute_sql "CREATE USER analytic WITH PASSWORD 'password';"
execute_sql "GRANT SELECT ON table_name TO analytic;"

# Создание групповой роли без доступа к базе данных
execute_sql "CREATE ROLE no_access;"

# Добавление пользователей с доступом только к подключению к базе данных
for user in "${USERS[@]}"
do
    execute_sql "CREATE USER $user WITH PASSWORD 'password';"
    execute_sql "GRANT CONNECT ON DATABASE $PG_DB TO $user;"
    execute_sql "GRANT no_access TO $user;"
done