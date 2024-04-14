CREATE TABLE moderation_logs (
                                 log_id SERIAL PRIMARY KEY,
                                 moderator_id INTEGER NOT NULL REFERENCES users(user_id),
                                 user_id INTEGER REFERENCES users(user_id),
                                 action VARCHAR NOT NULL,
                                 reason VARCHAR,
                                 timestamp TIMESTAMP
);
