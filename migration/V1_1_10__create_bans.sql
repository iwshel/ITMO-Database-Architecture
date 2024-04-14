CREATE TABLE bans (
                      ban_id SERIAL PRIMARY KEY,
                      banned_user_id INTEGER NOT NULL REFERENCES users(user_id),
                      banned_by_user_id INTEGER NOT NULL REFERENCES users(user_id),
                      server_id INTEGER NOT NULL REFERENCES servers(server_id),
                      reason VARCHAR,
                      timestamp TIMESTAMP NOT NULL
);
