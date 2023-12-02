CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR,
  last_name VARCHAR
);
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR,
  department VARCHAR,
  price INTEGER,
  weight INTEGER
);
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  product_id INTEGER REFERENCES products(id),
  paid BOOLEAN
);

-- How many paid/unpaid orders 
SELECT paid, COUNT(*)
FROM orders
GROUP BY paid;

-- first name, last name, paid
SELECT first_name, last_name, paid
FROM users
JOIN orders ON orders.user_id = users.id;

-- sort price lowest to highest (by default it sorts ASC)
SELECT * FROM products ORDER BY price;

-- sort price highest to lowest (DESC)
SELECT * FROM products ORDER BY price DESC;

-- sort price weight lowest to highest, and weight lowest to highest
SELECT * FROM products ORDER BY price, weight

-- sort price weight lowest to highest, and weight highest to lowest
SELECT * FROM products ORDER BY price, weight DESC;

-- if we have 50 users, it will show us last 10 users
SELECT * FROM users OFFSET 40;

-- first 5 users
SELECT * FROM users LIMIT 5;

-- order price by price, and retrieve 5 least expensive products
SELECT * FROM products ORDER BY price LIMIT 5;

-- order price by price, and retrieve 5 most expensive products
SELECT * FROM products ORDER BY price DESC LIMIT 5;

-- order price by price, and retrieve 5 most expensive products expect most expensive one
SELECT * FROM products ORDER BY price DESC LIMIT 5 OFFSET 1;

-- order by price (ASC), and show first page (every page has 20 products)
SELECT * FROM products ORDER BY price LIMIT 20 OFFSET 0;

-- second page
SELECT * FROM products ORDER BY price LIMIT 20 OFFSET 20;
-- third page
SELECT * FROM products ORDER BY price LIMIT 20 OFFSET 40;

-- find the 4 products with the highest price and
-- 4 products with the highest price/weight ratio
-- UNION removes duplicates, if we want to not remove duplicates, we should use UNION ALL
( 
  SELECT * 
  FROM products 
  ORDER BY price DESC 
  LIMIT 4
)
UNION
(
  SELECT * 
  FROM products 
  ORDER BY price / weight DESC 
  LIMIT 4
);

-- find the 4 products with the highest price and
-- 4 products with the highest price/weight ratio
-- show common products fit with both conditions
(
  SELECT *
  FROM products
  ORDER BY price DESC
  LIMIT 4
)
INTERSECT
(
  SELECT *
  FROM products
  ORDER BY price / weight DESC
  LIMIT 4
);

-- if this common appears more time 1 time in conditions, and we want to show all
(
  SELECT *
  FROM products
  ORDER BY price DESC
  LIMIT 4
)
INTERSECT ALL
(
  SELECT *
  FROM products
  ORDER BY price / weight DESC
  LIMIT 4
);


-- if products appear first condition appears second condition as well
-- remove it from first result
(
  SELECT *
  FROM products
  ORDER BY price DESC
  LIMIT 4
)
EXCEPT
(
  SELECT *
  FROM products
  ORDER BY price / weight DESC
  LIMIT 4
)

-- List the name and price of all products that are more expensive 
-- than all products in the "Toys" department (SUB QUERY)
SELECT name, price
FROM products
WHERE price > (
	SELECT MAX(price)
  FROM products
  WHERE department = 'Toys'
);


-- name , price, and max_price (price / max weight) ratio / SUB QUERY AS VALUE
SELECT name, price, price / (
    SELECT MAX(weight) FROM products
) AS price_ratio
FROM products;

-- subquery FROM
-- subquery must have an alias (so in this example, "p") to applied it
SELECT name, price_weight_ratio
FROM (
	SELECT name, price / weight AS price_weight_ratio
  FROM products
) AS p
WHERE price_weight_ratio > 5;

-- one single value FROM
SELECT *
FROM (
	SELECT MAX(price)
	FROM products
) AS p


-- Find the average number of orders for all users
-- p. is not required , so it can be just order_count
SELECT AVG(p.order_count)
FROM (
  SELECT user_id, COUNT(*) AS order_count
  FROM orders
  GROUP BY user_id
) AS p;


-- Subquery on JOIN
-- define the first name who ordered that product
SELECT first_name
FROM users
JOIN (
	SELECT user_id FROM orders WHERE product_id = 3
) AS o
ON o.user_id = users.id;

-- show the id of orders that involve a products 
-- with a price/weight ratio greater than 5
-- subquery in WHERE
SELECT id 
FROM orders
WHERE product_id IN (
    SELECT id
    FROM products
    WHERE price / weight > 50
);

-- show the name of all products with a price greater than
-- the the average product price
SELECT name 
FROM products
WHERE price > (
	SELECT AVG(price)
	FROM products
);
