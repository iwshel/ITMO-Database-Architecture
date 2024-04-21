CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    online_status BOOLEAN,
    registration_date TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS  servers (
    server_id SERIAL PRIMARY KEY,
    server_name VARCHAR NOT NULL,
    owner_id INTEGER NOT NULL REFERENCES users(user_id),
    creation_date TIMESTAMP NOT NULL
    );

CREATE TABLE IF NOT EXISTS  channels (
    channel_id SERIAL PRIMARY KEY,
    channel_name VARCHAR NOT NULL,
    server_id INTEGER NOT NULL REFERENCES servers(server_id),
    channel_type VARCHAR NOT NULL
    );

CREATE TABLE IF NOT EXISTS  roles (
     role_id SERIAL PRIMARY KEY,
     role_name VARCHAR NOT NULL,
     server_id INTEGER NOT NULL REFERENCES servers(server_id)
    );

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

CREATE TABLE IF NOT EXISTS  invitations (
    invitation_id SERIAL PRIMARY KEY,
    server_id INTEGER NOT NULL REFERENCES servers(server_id),
    inviter_id INTEGER REFERENCES users(user_id),
    invited_user_id INTEGER NOT NULL REFERENCES users(user_id),
    invitation_date TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS  moderation_logs (
    log_id SERIAL PRIMARY KEY,
    moderator_id INTEGER NOT NULL REFERENCES users(user_id),
    user_id INTEGER REFERENCES users(user_id),
    action VARCHAR NOT NULL,
    reason VARCHAR,
    timestamp TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS  emojis (
    emoji_id SERIAL PRIMARY KEY,
    emoji_name VARCHAR NOT NULL,
    emoji_image VARCHAR NOT NULL,
    server_id INTEGER REFERENCES servers(server_id),
    creator_id INTEGER NOT NULL REFERENCES users(user_id),
    creation_date TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS  user_roles (
    user_role_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    role_id INTEGER NOT NULL REFERENCES roles(role_id),
    server_id INTEGER NOT NULL REFERENCES servers(server_id)
    );


CREATE TABLE IF NOT EXISTS  user_settings (
    settings_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    theme_preference VARCHAR,
    notification_settings VARCHAR,
    privacy_settings VARCHAR,
    other_preferences VARCHAR,
    language VARCHAR
    );

CREATE TABLE IF NOT EXISTS  bans (
    ban_id SERIAL PRIMARY KEY,
    banned_user_id INTEGER NOT NULL REFERENCES users(user_id),
    banned_by_user_id INTEGER NOT NULL REFERENCES users(user_id),
    server_id INTEGER NOT NULL REFERENCES servers(server_id),
    reason VARCHAR,
    timestamp TIMESTAMP NOT NULL
    );
