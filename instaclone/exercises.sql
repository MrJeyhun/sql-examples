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

-- Show the username of users who were tagged in a caption or photo 
-- before January 7th 2010. Also show the date they were tagged

-- Quick solution: DOWNSIDE: inside JOIN clouse
SELECT username, tags.created_at
FROM users
JOIN (
	SELECT user_id, created_at FROM caption_tags
	UNION ALL
	SELECT user_id, created_at FROM photo_tags
) as tags ON tags.user_id = users.id
WHERE tags.created_at < '2010-01-07'

-- more readable solution: Common Table Expression
WITH tags AS (
	SELECT user_id, created_at FROM caption_tags
	UNION ALL
	SELECT user_id, created_at FROM photo_tags
)
SELECT username, tags.created_at
FROM users
JOIN tags ON tags.user_id = users.id
WHERE tags.created_at < '2010-01-07'


-- Recursive Common Table Expression
WITH RECURSIVE countdown(val) AS (
	SELECT 10 AS val
	UNION
	SELECT val - 1 FROM countdown WHERE val > 1
)

SELECT *
FROM countdown;


-- Suggestion Tree Recursion (Example on following suggestions)
WITH RECURSIVE suggestions(leader_id, follower_id, depth) AS ( 
    --
	SELECT leader_id, follower_id, 1 AS depth
	FROM followers                      -- non recursive / initial value
	WHERE follower_id = 1000
    --
	UNION
    --
	SELECT followers.leader_id, followers.follower_id, depth + 1 -- depth -tree depth
	FROM followers                       -- recursive case 
	JOIN suggestions ON suggestions.leader_id = followers.follower_id
	WHERE depth < 3
    --
)

SELECT DISTINCT users.id, users.username
FROM suggestions
JOIN users ON users.id = suggestions.leader_id
WHERE depth > 1
LIMIT 30


-- Show the most popular users the users who were tagged the most
SELECT username, COUNT(*)
FROM users
JOIN (
	SELECT user_id FROM photo_tags
	UNION ALL
	SELECT user_id FROM caption_tags
) AS tags ON tags.user_id = users.id
GROUP BY username
ORDER BY COUNT(*) DESC


-- UNIONING two table with View Table
CREATE VIEW tags AS (
	SELECT id, created_at, user_id, post_id, 'photo_tag' AS type FROM photo_tags
	UNION ALL
	SELECT id, created_at, user_id, post_id, 'caption_tag' AS type FROM caption_tags
)


-- 10 most recent posts table with View Table
CREATE VIEW recent_posts AS (
	SELECT *
	FROM posts
	ORDER BY created_at DESC
	LIMIT 10
);

-- update it to 15 most recent posts (Update View Table)
CREATE OR REPLACE VIEW recent_posts AS (
	SELECT *
	FROM posts
	ORDER BY created_at DESC
	LIMIT 15
)

-- delete View Table
DROP VIEW recent_posts


-- Materialized Views

-- For each week, show the number of likes that posts and comments received
-- Use the post and comment created_at date, not when the like was received
-- it's a expensive query (that's why we 'cache' the result with Materialized View)
SELECT 
	date_trunc('week', COALESCE(posts.created_at, comments.created_at)) AS week,-- rounded down to the nearest week
	COUNT(posts.id) AS num_likes_for_posts,
	COUNT(comments.id) AS num_likes_for_comments
FROM likes
LEFT JOIN posts ON posts.id = likes.post_id
LEFT JOIN comments ON comments.id = likes.comment_id
GROUP BY week
ORDER BY week



-- Materialized View of the above expensive query
CREATE MATERIALIZED VIEW weekly_likes AS (
	SELECT 
		date_trunc('week', COALESCE(posts.created_at, comments.created_at)) AS week,-- rounded down to the nearest week
		COUNT(posts.id) AS num_likes_for_posts,
		COUNT(comments.id) AS num_likes_for_comments
	FROM likes
	LEFT JOIN posts ON posts.id = likes.post_id
	LEFT JOIN comments ON comments.id = likes.comment_id
	GROUP BY week
	ORDER BY week
) with DATA; -- create a materialized view, run it one time, hold on all the results


-- After the every mutation query, we should REFRESH materialized view
REFRESH MATERIALIZED VIEW weekly_likes;