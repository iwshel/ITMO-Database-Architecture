CREATE TABLE servers (
                         server_id SERIAL PRIMARY KEY,
                         server_name VARCHAR NOT NULL,
                         owner_id INTEGER NOT NULL REFERENCES users(user_id),
                         creation_date TIMESTAMP NOT NULL
);
