--Practice Joins
-- 1. Get all invoices where the unit_price on the invoice_line is greater than $0.99.
SELECT * FROM invoice AS i 
JOIN invoice_line AS il 
ON il.invoice_id = i.invoice_id 
WHERE il.unit_price > 0.99;
-- 2. Get the invoice_date, customer first_name and last_name, and total from all invoices.
SELECT i.invoice_date, c.first_name, c.last_name, i.total
FROM invoice AS i
JOIN customer AS c
ON i.customer_id = c.customer_id;
-- 3. Get the customer first_name and last_name and the support rep's first_name and last_name from all customers.
--      Support reps are on the employee table.
SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer AS c
JOIN employee AS e
ON c.support_rep_id = e.employee_id;
-- 4. Get the album title and the artist name from all albums.
SELECT al.title, ar.name
FROM album AS al
JOIN artist AS ar
ON al.album_id = ar.artist_id;
-- 5. Get all playlist_track track_ids where the playlist name is Music.
SELECT pt.track_id
FROM playlist_track AS pt
JOIN playlist AS p
ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music';
-- 6. Get all track names for playlist_id 5.
SELECT t.name
FROM track AS t
JOIN playlist_track AS pt
ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;
-- 7. Get all track names and the playlist name that they're on ( 2 joins ).
SELECT t.name, p.name
FROM track AS t
JOIN playlist_track AS pt
ON t.track_id = pt.track_id
JOIN playlist AS p
ON pt.playlist_id = p.playlist_id;
-- 8. Get all track names and album titles that are the genre Alternative & Punk ( 2 joins ).
SELECT t.name, a.title
FROM track AS t
JOIN album AS a
ON t.album_id = a.album_id
JOIN genre AS g
ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk';

--Practice Nested Queries
-- 1. Get all invoices where the unit_price on the invoice_line is greater than $0.99.
SELECT * FROM invoice
WHERE invoice_id IN (SELECT invoice_id FROM invoice_line WHERE unit_price > 0.99);
-- 2. Get all playlist tracks where the playlist name is Music.
SELECT * FROM playlist_track
WHERE playlist_id IN ( SELECT playlist_id FROM playlist WHERE name = 'Music');
-- 3. Get all track names for playlist_id 5.
SELECT name FROM track 
WHERE track_id IN (SELECT track_id FROM playlist_track WHERE playlist_id = 5);
-- 4. Get all tracks where the genre is Comedy.
SELECT * FROM track
WHERE genre_id IN ( SELECT genre_id FROM genre WHERE name = 'Comedy');
-- 5. Get all tracks where the album is Fireball.
SELECT * FROM track
WHERE album_id IN ( SELECT album_id FROM album WHERE title = 'Fireball');
-- 6. Get all tracks for the artist Queen ( 2 nested subqueries ).
SELECT * FROM track 
WHERE album_id IN (
  SELECT album_id FROM album WHERE artist_id IN (
    SELECT artist_id FROM artist WHERE name = 'Queen'
    )
  );

--Practice Updating Rows
-- 1. Find all customers with fax numbers and set those numbers to null.
UPDATE customer SET fax = null
WHERE fax IS NOT null;
-- 2. Find all customers with no company (null) and set their company to "Self".
UPDATE customer SET company = 'Self'
WHERE company IS null;
-- 3. Find the customer Julia Barnett and change her last name to Thompson.
UPDATE customer SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';
-- 4. Find the customer with this email luisrojas@yahoo.cl and change his support rep to 4.
UPDATE customer SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';
-- 5. Find all tracks that are the genre Metal and have no composer. Set the composer to "The darkness around us".
UPDATE track SET composer = 'The darkness around us'
WHERE genre_id = ( SELECT genre_id FROM genre WHERE name = 'Metal' )
AND composer IS null;
-- 6. Refresh your page to remove all database changes.
Command R shortkey on mac.

--Group By
-- 1. Find a count of how many tracks there are per genre. Display the genre name with the count.
SELECT COUNT(*), g.name
FROM track AS t
JOIN genre AS g
ON t.genre_id = g.genre_id
GROUP BY g.name;
-- 2. Find a count of how many tracks are the "Pop" genre and how many tracks are the "Rock" genre.
SELECT COUNT(*), g.name FROM track AS t
JOIN genre AS g ON g.genre_id = t.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;
-- 3. Find a list of all artists and how many albums they have.
SELECT ar.name, COUNT(*) FROM album AS al
JOIN artist AS ar ON ar.artist_id = al.artist_id
GROUP BY ar.name;

--Use Distinct
-- 1. From the track table find a unique list of all composers.
SELECT DISTINCT composer FROM track;
-- 2. From the invoice table find a unique list of all billing_postal_codes.
SELECT DISTINCT billing_postal_code FROM invoice;
-- 3. From the customer table find a unique list of all companys.
SELECT DISTINCT company FROM customer;

--Delete Rows
-- 1. Copy, paste, and run the SQL code from the summary.
-- 2. Delete all 'bronze' entries from the table.
DELETE FROM practice_delete WHERE type = 'bronze';
-- 3. Delete all 'silver' entries from the table.
DELETE FROM practice_delete WHERE type = 'silver';
-- 4. Delete all entries whose value is equal to 150.
DELETE FROM practice_delete WHERE value = 150;

--eCommmerce Simulation
-- 1. Create 3 tables following the criteria in the summary.
CREATE TABLE users
(id SERIAL PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 email VARCHAR(100) NOT NULL
);

CREATE TABLE products
(id SERIAL PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 price INTEGER NOT NULL
);

CREATE TABLE orders
(id SERIAL PRIMARY KEY,
 product_id INTEGER,
 FOREIGN KEY (id) references products(id)
);

-- 2. Add some data to fill up each table. At least 3 users, 3 products, 3 orders.
INSERT INTO users 
(name, email)
VALUES 
('Kyle', 'kyle@gmail.com'),
('Jon', 'jon@nightswatch.com'),
('Rob', 'rob@kingofthenorth.com');

INSERT INTO products 
(name, price)
VALUES 
('Modern Warfare', 60),
('Dragon Glass', 100),
('Supplies', 1000);

INSERT INTO orders
(product_id)
VALUES
(1), (2), (3);

-- 3. Run queries against your data.
    -- Get all products for the first order.
SELECT * FROM products AS p
INNER JOIN orders AS o
ON p.id = o.id
WHERE o.id = 1;

    -- Get all orders.
SELECT * FROM orders;

    -- Get the total cost of an order ( sum the price of all products on an order ).
SELECT o.id, SUM(p.price)
FROM products AS p
INNER JOIN orders AS o 
ON p.id = o.id
WHERE o.id = 3
GROUP BY o.id;

-- 4. Add a foreign key reference from orders to users.
ALTER TABLE users
ADD COLUMN order_id INTEGER
REFERENCES orders(id);

-- 5. Update the orders table to link a user to each order.
UPDATE users
SET order_id = 1
WHERE id = 1;

UPDATE users
SET order_id = 2
WHERE id = 2;

UPDATE users
SET order_id = 3
WHERE id = 3;

-- 6. Run queries against your data.
    -- Get all orders for a user.
SELECT * FROM users AS u
INNER JOIN orders AS o
ON o.id = u.order_id
WHERE u.id = 3;

    -- Get how many orders each user has.
SELECT COUNT(*) FROM users AS u
INNER JOIN orders AS o
ON o.id = u.order_id
WHERE u.id = 2;

    -- Get the total amount on all orders for each user. (Black Diamond)
SELECT o.id, SUM(p.price)
FROM products AS p
INNER JOIN orders AS o
ON p.id = o.id
GROUP BY o.id;