ALTER TABLE user_roles RENAME TO user_roles_old;

CREATE TABLE user_roles
(
    user_role_id SERIAL PRIMARY KEY,
    user_id      INTEGER NOT NULL REFERENCES users (user_id),
    role_id      INTEGER NOT NULL REFERENCES roles (role_id),
    server_id    INTEGER NOT NULL REFERENCES servers (server_id)
) PARTITION BY RANGE (user_role_id);

ALTER TABLE user_roles_old
    ADD CONSTRAINT user_roles_old
        CHECK (user_role_id >= 1 AND user_role_id <= 100000);

CREATE TABLE user_roles_1 PARTITION OF user_roles
    FOR VALUES FROM
(
    1
) TO
(
    50000
);

CREATE TABLE user_roles_2 PARTITION OF user_roles
    FOR VALUES FROM
(
    50000
) TO
(
    100001
);

WITH moved_rows AS (
DELETE
FROM user_roles_old a
WHERE user_role_id >= 1
  AND user_role_id < 50000 RETURNING a.*
)
INSERT
INTO user_roles_1
SELECT *
FROM moved_rows;

WITH moved_rows AS (
DELETE
FROM user_roles_old a
WHERE user_role_id >= 50000
  AND user_role_id < 100001 RETURNING a.*
)
INSERT
INTO user_roles_2
SELECT *
FROM moved_rows;

ALTER TABLE user_roles_old DROP CONSTRAINT user_roles_old;