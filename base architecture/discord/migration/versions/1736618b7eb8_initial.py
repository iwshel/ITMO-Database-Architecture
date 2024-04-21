"""initial

Revision ID: 1736618b7eb8
Revises: 
Create Date: 2024-04-05 08:19:27.054602

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '1736618b7eb8'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('users',
    sa.Column('user_id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('username', sa.String(length=50), nullable=False),
    sa.Column('email', sa.String(length=100), nullable=False),
    sa.Column('password_hash', sa.String(length=255), nullable=False),
    sa.Column('online_status', sa.Boolean(), nullable=True),
    sa.Column('registration_date', sa.DateTime(), nullable=True),
    sa.PrimaryKeyConstraint('user_id'),
    sa.UniqueConstraint('email'),
    sa.UniqueConstraint('username')
    )
    op.create_table('moderation_logs',
    sa.Column('log_id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('moderator_id', sa.Integer(), nullable=False),
    sa.Column('user_id', sa.Integer(), nullable=True),
    sa.Column('action', sa.String(), nullable=False),
    sa.Column('reason', sa.String(), nullable=True),
    sa.Column('timestamp', sa.DateTime(), nullable=True),
    sa.ForeignKeyConstraint(['moderator_id'], ['users.user_id'], ),
    sa.ForeignKeyConstraint(['user_id'], ['users.user_id'], ),
    sa.PrimaryKeyConstraint('log_id')
    )
    op.create_table('servers',
    sa.Column('server_id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('server_name', sa.String(), nullable=False),
    sa.Column('owner_id', sa.Integer(), nullable=False),
    sa.Column('creation_date', sa.DateTime(), nullable=False),
    sa.ForeignKeyConstraint(['owner_id'], ['users.user_id'], ),
    sa.PrimaryKeyConstraint('server_id')
    )
    op.create_table('user_settings',
    sa.Column('settings_id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('theme_preference', sa.String(), nullable=True),
    sa.Column('notification_settings', sa.String(), nullable=True),
    sa.Column('privacy_settings', sa.String(), nullable=True),
    sa.Column('other_preferences', sa.String(), nullable=True),
    sa.Column('language', sa.Enum('English', 'Spanish', 'French', 'German', 'Italian', 'Dutch', 'Portuguese', 'Russian', 'Japanese', 'Korean', 'Chinese', 'Arabic', 'Turkish', 'Danish', 'Finnish', 'Norwegian', 'Polish', 'Swedish', 'Ukrainian', 'Czech', 'Croatian', 'Hungarian', 'Romanian', name='DiscordLanguage'), nullable=False),
    sa.Column('theme', sa.Enum('Light', 'Dark', name='DiscordTheme'), nullable=False),
    sa.ForeignKeyConstraint(['user_id'], ['users.user_id'], ),
    sa.PrimaryKeyConstraint('settings_id')
    )
    op.create_table('users_servers',
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('server_id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['server_id'], ['servers.server_id'], ),
    sa.ForeignKeyConstraint(['user_id'], ['users.user_id'], ),
    sa.PrimaryKeyConstraint('user_id', 'server_id')
    )
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('users_servers')
    op.drop_table('user_settings')
    op.drop_table('servers')
    op.drop_table('moderation_logs')
    op.drop_table('users')
    # ### end Alembic commands ###
