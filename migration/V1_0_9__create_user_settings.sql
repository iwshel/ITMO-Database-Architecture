CREATE TABLE user_settings (
                               settings_id SERIAL PRIMARY KEY,
                               user_id INTEGER NOT NULL REFERENCES users(user_id),
                               theme_preference VARCHAR,
                               notification_settings VARCHAR,
                               privacy_settings VARCHAR,
                               other_preferences VARCHAR,
                               language VARCHAR
);
