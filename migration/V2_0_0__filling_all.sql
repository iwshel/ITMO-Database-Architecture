INSERT INTO users (username, email, password_hash, online_status, registration_date)
SELECT
        'user' || generate_series,
        'user' || generate_series || '@example.com',
        md5(random()::text),
        random() < 0.5,
        NOW() - (random() * INTERVAL '365 days')
FROM
    generate_series(1, 1000000);

INSERT INTO servers (server_name, owner_id, creation_date)
SELECT
        'server' || generate_series,
        (SELECT user_id FROM users ORDER BY random() LIMIT 1),
    NOW() - (random() * INTERVAL '365 days')
FROM
    generate_series(1, 1000000);


INSERT INTO channels (channel_name, server_id, channel_type)
SELECT
        'channel' || generate_series,
        (SELECT server_id FROM servers ORDER BY random() LIMIT 1),
    CASE WHEN random() < 0.5 THEN 'text_channel' ELSE 'voice_channel' END
FROM
    generate_series(1, 1000000);


INSERT INTO roles (role_name, server_id)
SELECT
        'role' || generate_series,
        (SELECT server_id FROM servers ORDER BY random() LIMIT 1)
FROM
    generate_series(1, 10000);


INSERT INTO permissions (role_id, channel_id, can_send_messages, can_delete_messages, can_edit_messages, can_create_roles, can_ban_users)
SELECT
    (SELECT role_id FROM roles ORDER BY random() LIMIT 1),
    (SELECT channel_id FROM channels ORDER BY random() LIMIT 1),
    random() < 0.5,
    random() < 0.5,
    random() < 0.5,
    random() < 0.5,
    random() < 0.5
FROM
    generate_series(1, 50000);


INSERT INTO invitations (server_id, inviter_id, invited_user_id, invitation_date)
SELECT
    (SELECT server_id FROM servers ORDER BY random() LIMIT 1),
    (SELECT user_id FROM users ORDER BY random() LIMIT 1),
    (SELECT user_id FROM users ORDER BY random() LIMIT 1),
    NOW() - (random() * INTERVAL '365 days')
FROM
    generate_series(1, 10000);


INSERT INTO moderation_logs (moderator_id, user_id, action, reason, timestamp)
SELECT
    (SELECT user_id FROM users ORDER BY random() LIMIT 1),
    (SELECT user_id FROM users ORDER BY random() LIMIT 1),
    'action' || generate_series,
    'reason' || generate_series,
    NOW() - (random() * INTERVAL '365 days')
FROM
    generate_series(1, 10000);


INSERT INTO emojis (emoji_name, emoji_image, server_id, creator_id, creation_date)
SELECT
        'emoji' || generate_series,
        'https://example.com/emoji/' || generate_series || '.png',
        (SELECT server_id FROM servers ORDER BY random() LIMIT 1),
    (SELECT user_id FROM users ORDER BY random() LIMIT 1),
    NOW() - (random() * INTERVAL '365 days')
FROM
    generate_series(1, 10000);


INSERT INTO user_roles (user_id, role_id, server_id)
SELECT
    (SELECT user_id FROM users ORDER BY random() LIMIT 1),
    (SELECT role_id FROM roles ORDER BY random() LIMIT 1),
    (SELECT server_id FROM servers ORDER BY random() LIMIT 1)
FROM
    generate_series(1, 10000);


INSERT INTO user_settings (user_id, theme_preference, notification_settings, privacy_settings, other_preferences, language)
SELECT
    (SELECT user_id FROM users ORDER BY random() LIMIT 1),
    CASE WHEN random() < 0.5 THEN 'Light' ELSE 'Dark' END,
    'notification_setting' || generate_series,
    'privacy_setting' || generate_series,
    'other_preference' || generate_series,
    'English'
FROM
    generate_series(1, 1000000);


INSERT INTO bans (banned_user_id, banned_by_user_id, server_id, reason, timestamp)
SELECT
    (SELECT user_id FROM users ORDER BY random() LIMIT 1),
    (SELECT user_id FROM users ORDER BY random() LIMIT 1),
    (SELECT server_id FROM servers ORDER BY random() LIMIT 1),
    'reason' || generate_series,
    NOW() - (random() * INTERVAL '365 days')
FROM
    generate_series(1, 10000);
