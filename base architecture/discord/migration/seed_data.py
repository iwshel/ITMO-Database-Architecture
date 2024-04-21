from datetime import datetime

from sqlalchemy.orm import Session
from app import *


def seed_data(session: Session) -> None:
    for i in range(0, 10 ** 4):
        user = User(email='EMAIL', username='user' + str(i), password_hash='<PASSWORD>',
                    online_status=True, registration_date=datetime.datetime.now())
        session.add(user)
    session.commit()
