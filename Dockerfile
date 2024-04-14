FROM postgres:latest

ENV MIGRATION_VERSION=latest

COPY start_migrations.sh /docker-entrypoint-initdb.d/start_migrations.sh

RUN chmod +x /docker-entrypoint-initdb.d/start_migrations.sh

EXPOSE 5432