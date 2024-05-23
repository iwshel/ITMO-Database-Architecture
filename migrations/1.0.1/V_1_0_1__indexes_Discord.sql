CREATE INDEX idx_servers_owner_id ON servers (owner_id);
CREATE INDEX idx_user_roles_server_user_id ON user_roles (server_id, user_id);
CREATE INDEX idx_user_roles_user_id_server_id ON user_roles (user_id, server_id);
CREATE INDEX idx_channels_channel_type ON channels (channel_type);