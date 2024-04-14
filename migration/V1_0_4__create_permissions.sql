CREATE TABLE permissions (
                             permission_id SERIAL PRIMARY KEY,
                             role_id INTEGER NOT NULL REFERENCES roles(role_id),
                             channel_id INTEGER NOT NULL REFERENCES channels(channel_id),
                             can_send_messages BOOLEAN,
                             can_delete_messages BOOLEAN,
                             can_edit_messages BOOLEAN,
                             can_create_roles BOOLEAN,
                             can_ban_users BOOLEAN
);
