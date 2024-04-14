CREATE TABLE user_roles (
                            user_role_id SERIAL PRIMARY KEY,
                            user_id INTEGER NOT NULL REFERENCES users(user_id),
                            role_id INTEGER NOT NULL REFERENCES roles(role_id),
                            server_id INTEGER NOT NULL REFERENCES servers(server_id)
);
