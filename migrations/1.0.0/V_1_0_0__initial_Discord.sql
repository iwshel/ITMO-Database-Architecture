CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    online_status BOOLEAN,
    registration_date TIMESTAMP
    );

INSERT INTO  users (username, email, password_hash, online_status, registration_date)
SELECT
    'user' || generate_series,
    'user' || generate_series || '@example.com',
    md5(random()::text),
    random() < 0.5,
    NOW() - (random() * INTERVAL '365 days')
FROM
    generate_series(1, ${FILLING_AMOUNT});

CREATE TABLE IF NOT EXISTS  servers (
    server_id SERIAL PRIMARY KEY,
    server_name VARCHAR NOT NULL,
    owner_id INTEGER NOT NULL REFERENCES users(user_id),
    creation_date TIMESTAMP NOT NULL
    );

INSERT INTO servers (server_name, owner_id, creation_date)
SELECT
        'server' || generate_series,
        FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
        NOW() - (random() * INTERVAL '365 days')
FROM
    generate_series(1, ${FILLING_AMOUNT});

CREATE TABLE IF NOT EXISTS  channels (
    channel_id SERIAL PRIMARY KEY,
    channel_name VARCHAR NOT NULL,
    server_id INTEGER NOT NULL REFERENCES servers(server_id),
    channel_type VARCHAR NOT NULL
    );

INSERT INTO channels (channel_name, server_id, channel_type)
SELECT
        'channel' || generate_series,
        FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
        CASE WHEN random() < 0.5 THEN 'text_channel' ELSE 'voice_channel' END
FROM
    generate_series(1, ${FILLING_AMOUNT});

CREATE TABLE IF NOT EXISTS  roles (
     role_id SERIAL PRIMARY KEY,
     role_name VARCHAR NOT NULL,
     server_id INTEGER NOT NULL REFERENCES servers(server_id)
    );

INSERT INTO roles (role_name, server_id)
SELECT
        'role' || generate_series,
        FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1
FROM
    generate_series(1, ${FILLING_AMOUNT});

CREATE TABLE IF NOT EXISTS  permissions (
    permission_id SERIAL PRIMARY KEY,
    role_id INTEGER NOT NULL REFERENCES roles(role_id),
    channel_id INTEGER NOT NULL REFERENCES channels(channel_id),
    can_send_messages BOOLEAN,
    can_delete_messages BOOLEAN,
    can_edit_messages BOOLEAN,
    can_create_roles BOOLEAN,
    can_ban_users BOOLEAN
    );

INSERT INTO permissions (role_id, channel_id, can_send_messages, can_delete_messages, can_edit_messages, can_create_roles, can_ban_users)
SELECT
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    random() < 0.5,
    random() < 0.5,
    random() < 0.5,
    random() < 0.5,
    random() < 0.5
FROM
    generate_series(1, ${FILLING_AMOUNT});

CREATE TABLE IF NOT EXISTS  invitations (
    invitation_id SERIAL PRIMARY KEY,
    server_id INTEGER NOT NULL REFERENCES servers(server_id),
    inviter_id INTEGER REFERENCES users(user_id),
    invited_user_id INTEGER NOT NULL REFERENCES users(user_id),
    invitation_date TIMESTAMP
    );

INSERT INTO invitations (server_id, inviter_id, invited_user_id, invitation_date)
SELECT
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    NOW() - (random() * INTERVAL '365 days')
FROM
    generate_series(1, ${FILLING_AMOUNT});

CREATE TABLE IF NOT EXISTS  moderation_logs (
    log_id SERIAL PRIMARY KEY,
    moderator_id INTEGER NOT NULL REFERENCES users(user_id),
    user_id INTEGER REFERENCES users(user_id),
    action VARCHAR NOT NULL,
    reason VARCHAR,
    timestamp TIMESTAMP
    );

INSERT INTO moderation_logs (moderator_id, user_id, action, reason, timestamp)
SELECT
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    'action' || generate_series,
    'reason' || generate_series,
    NOW() - (random() * INTERVAL '365 days')
FROM
    generate_series(1, ${FILLING_AMOUNT});

CREATE TABLE IF NOT EXISTS  emojis (
    emoji_id SERIAL PRIMARY KEY,
    emoji_name VARCHAR NOT NULL,
    emoji_image VARCHAR NOT NULL,
    server_id INTEGER REFERENCES servers(server_id),
    creator_id INTEGER NOT NULL REFERENCES users(user_id),
    creation_date TIMESTAMP
    );

INSERT INTO emojis (emoji_name, emoji_image, server_id, creator_id, creation_date)
SELECT
        'emoji' || generate_series,
        'https://example.com/emoji/' || generate_series || '.png',
        FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
        FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
        NOW() - (random() * INTERVAL '365 days')
FROM
    generate_series(1, ${FILLING_AMOUNT});

CREATE TABLE IF NOT EXISTS  user_roles (
    user_role_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    role_id INTEGER NOT NULL REFERENCES roles(role_id),
    server_id INTEGER NOT NULL REFERENCES servers(server_id)
    );

INSERT INTO user_roles (user_id, role_id, server_id)
SELECT
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1
FROM
    generate_series(1, ${FILLING_AMOUNT});

CREATE TABLE IF NOT EXISTS  user_settings (
    settings_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    theme_preference VARCHAR,
    notification_settings VARCHAR,
    privacy_settings VARCHAR,
    other_preferences VARCHAR,
    language VARCHAR
    );

INSERT INTO user_settings (user_id, theme_preference, notification_settings, privacy_settings, other_preferences, language)
SELECT
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    CASE WHEN random() < 0.5 THEN 'Light' ELSE 'Dark' END,
    'notification_setting' || generate_series,
    'privacy_setting' || generate_series,
    'other_preference' || generate_series,
    'English'
FROM
    generate_series(1, ${FILLING_AMOUNT});

CREATE TABLE IF NOT EXISTS  bans (
    ban_id SERIAL PRIMARY KEY,
    banned_user_id INTEGER NOT NULL REFERENCES users(user_id),
    banned_by_user_id INTEGER NOT NULL REFERENCES users(user_id),
    server_id INTEGER NOT NULL REFERENCES servers(server_id),
    reason VARCHAR,
    timestamp TIMESTAMP NOT NULL
    );

INSERT INTO bans (banned_user_id, banned_by_user_id, server_id, reason, timestamp)
SELECT
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    FLOOR(RANDOM() * ${FILLING_AMOUNT}) + 1,
    'reason' || generate_series,
    NOW() - (random() * INTERVAL '365 days')
FROM
    generate_series(1, ${FILLING_AMOUNT});