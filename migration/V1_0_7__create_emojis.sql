CREATE TABLE emojis (
                        emoji_id SERIAL PRIMARY KEY,
                        emoji_name VARCHAR NOT NULL,
                        emoji_image VARCHAR NOT NULL,
                        server_id INTEGER REFERENCES servers(server_id),
                        creator_id INTEGER NOT NULL REFERENCES users(user_id),
                        creation_date TIMESTAMP
);
