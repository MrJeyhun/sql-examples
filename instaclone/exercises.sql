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