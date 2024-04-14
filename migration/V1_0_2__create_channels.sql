CREATE TABLE channels (
                          channel_id SERIAL PRIMARY KEY,
                          channel_name VARCHAR NOT NULL,
                          server_id INTEGER NOT NULL REFERENCES servers(server_id),
                          channel_type VARCHAR NOT NULL
);
