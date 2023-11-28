CREATE TABLE users (
	id SERIAL PRIMARY KEY,
    username VARCHAR(50)
);

CREATE TABLE photos (
	id SERIAL PRIMARY KEY,
    url VARCHAR(200),
	user_id INTEGER REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO users (username)
VALUES 
    ('testuser1'),
    ('testuser2'),
    ('testuser3'),
    ('testuser4');

INSERT INTO photos (url, user_id)
VALUES
	('http://one.jpg', 1),
	('http://one.jpg', 1),
	('http://one.jpg', 1),
	('http://one.jpg', 2),
	('http://one.jpg', 3),
	('http://one.jpg', 4),
	('http://one.jpg', 4);


SELECT * FROM photos WHERE user_id = 4;

-- With JOIN
SELECT url, username FROM photos
JOIN users ON users.id = photos.user_id;
