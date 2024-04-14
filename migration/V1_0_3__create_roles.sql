CREATE TABLE roles (
                       role_id SERIAL PRIMARY KEY,
                       role_name VARCHAR NOT NULL,
                       server_id INTEGER NOT NULL REFERENCES servers(server_id)
);
