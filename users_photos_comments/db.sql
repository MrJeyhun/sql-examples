CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username VARCHAR(50)
);
 
CREATE TABLE photos (
  id SERIAL PRIMARY KEY,
  url VARCHAR(200),
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE
);
 
CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  contents VARCHAR(240),
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  photo_id INTEGER REFERENCES photos(id) ON DELETE CASCADE
);


-- Getting all comments alogn with who created it
SELECT contents, username
FROM comments 
JOIN users ON users.id = comments.user_id;

-- Getting all comments along with photo url that comment belongs to
SELECT contents, url
FROM comments 
JOIN photos ON photos.id = comments.photo_id;

-- Because of both photos & comments table has columns with same name (id):
SELECT photos.id AS photo_id, comments.id AS comment_id 
FROM COMMENTS
JOIN photos ON photos.id = comments.photo_id;

-- Renaming tables 
SELECT photos.id AS photo_id, com.id
FROM COMMENTS AS com
JOIN photos ON photos.id = com.photo_id;

-- CASE: one of the photos.user_id is NULL (we want to get all photos)
SELECT url, username
FROM photos
LEFT JOIN users ON users.id = photos.user_id;

-- CASE: one of the photos.user_id is NULL, and one of the user doesn't have any photo 
-- (we want to get all users)
SELECT url, username
FROM photos
RIGHT JOIN users ON users.id = photos.user_id;


-- CASE: we want to get all (FULL JOIN)
SELECT url, username
FROM photos
FULL JOIN users ON users.id = photos.user_id;


-- CASE: who is commenting on their own photos? (THREE WAY JOINS)
SELECT url, contents, username
FROM COMMENTS
JOIN photos ON photos.id = comments.photo_id
JOIN users ON users.id = comments.user_id AND users.id = photos.user_id;

-- GROUP BY (find the set of all unique user_id s 
-- group by the user_id, without aggregation it's not useful actually) 
SELECT user_id
FROM comments
GROUP BY user_id; 


-- Number of comments users have created (aggregation)
SELECT user_id, COUNT(id) AS num_comments_created
FROM COMMENTS
GROUP BY user_id

-- Number of comments users have created (with user name)
SELECT username, COUNT(*)
FROM COMMENTS
JOIN users ON users.id = comments.user_id
GROUP BY users.username;

-- Number of photos users have created (but, one of them is setted to NULL)
-- NULL values are not counted
SELECT user_id, COUNT(user_id) 
FROM photos
GROUP BY user_id
-- NULL values are counted
SELECT user_id, COUNT(*) 
FROM photos
GROUP BY user_id


-- Number of comments for each photo
SELECT photo_id, COUNT(*) AS num_of_comments
FROM COMMENTS
GROUP BY photo_id;


-- FILTERING GROUPS

-- Find the number of comments for each photo where the photo_id is less than 3
-- and the photo has more than 2 comments
SELECT photo_id, COUNT(*)
FROM COMMENTS
WHERE photo_id < 3
GROUP BY photo_id
HAVING COUNT(*) > 2;


-- Find the user_ids where user has commented on the first 50 photo
-- and the users added more than 20 comments on thoose photos
SELECT user_id, COUNT(*)
FROM COMMENTS
WHERE photo_id < 50
GROUP BY user_id
HAVING COUNT(*) > 20;