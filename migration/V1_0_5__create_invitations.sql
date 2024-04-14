CREATE TABLE invitations (
                             invitation_id SERIAL PRIMARY KEY,
                             server_id INTEGER NOT NULL REFERENCES servers(server_id),
                             inviter_id INTEGER REFERENCES users(user_id),
                             invited_user_id INTEGER NOT NULL REFERENCES users(user_id),
                             invitation_date TIMESTAMP
);
