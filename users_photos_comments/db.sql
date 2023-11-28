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