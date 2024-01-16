-- Select 3 users with the highest IDs from the users table:
SELECT *
FROM users
ORDER BY id DESC
LIMIT 3


-- Join the users and posts table. Show the username of ID 200 and the captions of all posts they have create
SELECT username, caption
FROM users
JOIN posts ON posts.user_id = users.id
WHERE users.id = 200



-- Show each username and the number of likes that they have created
SELECT username, COUNT(*)
FROM users
JOIN likes ON likes.user_id = users.id
GROUP BY username;

-- Creating index example
CREATE INDEX ON users (username);
-- we can manually set name of index
CREATE INDEX users_username_idx ON users (username);

-- Deleting index:
DROP INDEX users_username_idx;

-- analyzing benchmark
EXPLAIN ANALYZE SELECT *
FROM users
WHERE username = 'Emil30'

-- To check indexes inside the database:
SELECT relname, relkind
FROM pg_class
WHERE relkind = 'i'