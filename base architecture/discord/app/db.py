from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Enum
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'

    user_id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(50), nullable=False, unique=True)
    email = Column(String(100), nullable=False, unique=True)
    password_hash = Column(String(255), nullable=False)
    online_status = Column(Boolean)
    registration_date = Column(DateTime)

class Server(Base):
    __tablename__ = 'servers'

    server_id = Column(Integer, primary_key=True, autoincrement=True)
    server_name = Column(String, nullable=False)
    owner_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    creation_date = Column(DateTime, nullable=False)
    owner = relationship("User")

class UserServer(Base):
    __tablename__ = 'users_servers'

    user_id = Column(Integer, ForeignKey('users.user_id'), primary_key=True)
    server_id = Column(Integer, ForeignKey('servers.server_id'), primary_key=True)

class ModerationLog(Base):
    __tablename__ = 'moderation_logs'

    log_id = Column(Integer, primary_key=True, autoincrement=True)
    moderator_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    user_id = Column(Integer, ForeignKey('users.user_id'))
    action = Column(String, nullable=False)
    reason = Column(String)
    timestamp = Column(DateTime)

class DiscordTheme(Enum):
    Light = 'Light'
    Dark = 'Dark'

class UserSettings(Base):
    __tablename__ = 'user_settings'

    settings_id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    theme_preference = Column(String)
    notification_settings = Column(String)
    privacy_settings = Column(String)
    other_preferences = Column(String)
    language = Column(Enum('English', 'Spanish', 'French', 'German', 'Italian', 'Dutch',
                           'Portuguese', 'Russian', 'Japanese', 'Korean', 'Chinese', 'Arabic', 'Turkish',
                           'Danish', 'Finnish', 'Norwegian', 'Polish', 'Swedish', 'Ukrainian', 'Czech', 'Croatian',
                           'Hungarian', 'Romanian', name='DiscordLanguage'), nullable=False)
    theme = Column(Enum('Light', 'Dark', name='DiscordTheme'), nullable=False)

class Channel(Base):
    __tablename__ = 'channels'

    channel_id = Column(Integer, primary_key=True)
    channel_name = Column(String, nullable=False)
    server_id = Column(Integer, ForeignKey('servers.server_id'), nullable=False)
    channel_type = Column(Enum('text_channel', 'voice_channel', name="ChannelType"), nullable=False)


class Message(Base):
    __tablename__ = 'messages'

    message_id = Column(Integer, primary_key=True, autoincrement=True)
    message_content = Column(String, nullable=False)
    user_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    channel_id = Column(Integer, ForeignKey('channels.channel_id'))
    timestamp = Column(DateTime)


class Role(Base):
    __tablename__ = 'roles'

    role_id = Column(Integer, primary_key=True, autoincrement=True)
    role_name = Column(String, nullable=False)
    server_id = Column(Integer, ForeignKey('servers.server_id'), nullable=False)


class Permission(Base):
    __tablename__ = 'permissions'

    permission_id = Column(Integer, primary_key=True)
    role_id = Column(Integer, ForeignKey('roles.role_id'), nullable=False)
    channel_id = Column(Integer, ForeignKey('channels.channel_id'), nullable=False)
    can_send_messages = Column(Boolean)
    can_delete_messages = Column(Boolean)
    can_edit_messages = Column(Boolean)
    can_create_roles = Column(Boolean)
    can_ban_users = Column(Boolean)


class Invitation(Base):
    __tablename__ = 'invitations'

    invitation_id = Column(Integer, primary_key=True)
    server_id = Column(Integer, ForeignKey('servers.server_id'), nullable=False)
    inviter_id = Column(Integer, ForeignKey('users.user_id'))
    invited_user_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    invitation_date = Column(DateTime)


class UserRole(Base):
    __tablename__ = 'user_roles'

    user_role_id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    role_id = Column(Integer, ForeignKey('roles.role_id'), nullable=False)
    server_id = Column(Integer, ForeignKey('servers.server_id'), nullable=False)


class Emoji(Base):
    __tablename__ = 'emojis'

    emoji_id = Column(Integer, primary_key=True, autoincrement=True)
    emoji_name = Column(String, nullable=False)
    emoji_image = Column(String, nullable=False)
    server_id = Column(Integer, ForeignKey('servers.server_id'))
    creator_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    creation_date = Column(DateTime)


class Ban(Base):
    __tablename__ = 'bans'

    ban_id = Column(Integer, primary_key=True, autoincrement=True)
    banned_user_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    banned_by_user_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    server_id = Column(Integer, ForeignKey('servers.server_id'), nullable=False)
    reason = Column(String)
    timestamp = Column(DateTime, nullable=False)