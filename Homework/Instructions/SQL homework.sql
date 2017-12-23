USE sakila;

/*1a.*/
SELECT first_name, last_name
FROM actor;

/*1b.*/
SELECT CONCAT(UPPER(first_name)," ",UPPER(last_name)) 
AS 'actor name'
FROM actor;


INSERT INTO Actor_Name (name)
SELECT CONCAT(first_name, " ", last_name)
FROM actor;

SELECT * FROM Actor_Name;

/*2a.*/
SELECT actor_id,first_name,last_name
FROM actor
WHERE first_name LIKE 'Joe';

/*2b.*/
SELECT first_name,last_name
FROM actor 
WHERE last_name LIKE '%Gen%';

/*2c.*/
SELECT last_name,first_name
FROM actor
WHERE last_name LIKE '%LI%';

/*2d.*/
SELECT country_id, country
FROM country 
WHERE country IN (
    'Afghanistan', 'Bangladesh', 'China'
    );

/*3a.*/
ALTER TABLE actor 
ADD middle_name VARCHAR(255)
AFTER first_name;
SELECT * FROM actor; 

/*3b.*/
ALTER TABLE actor 
MODIFY middle_name BLOB; 

/*3c.*/
ALTER TABLE actor 
DROP COLUMN middle_name;

/*4a.*/
SELECT last_name, COUNT(*) AS 'Count'
FROM actor 
GROUP BY last_name
ORDER BY COUNT(*) DESC;

/*4b.*/
SELECT last_name, COUNT(*) AS 'Count'
FROM actor 
GROUP BY last_name
HAVING COUNT(*) >= 2
ORDER BY COUNT(*) DESC;

/*4c.*/
UPDATE actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

/*4d.*/
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';

/*5a.*/
DESCRIBE sakila.address;
SHOW CREATE TABLE address; 

/*6a.*/
SELECT a.first_name, a.last_name, b.address
FROM staff a
LEFT JOIN address b
ON a.address_id = b.address_id;

/*6b. NEED TO FIX THE AND*/
SELECT payment.staff_id, staff.first_name, staff.last_name, SUM(payment.amount) AS 'Total_Amount', payment.payment_date 
FROM staff 
JOIN payment
ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY staff_id;  

/*6c.*/
SELECT b.title, COUNT(a.actor_id) AS 'Actor_Count'
FROM film b
INNER JOIN film_actor a
ON a.film_id = b.film_id
GROUP BY b.film_id
ORDER BY COUNT(a.actor_id) DESC;

/*6d.*/
SELECT COUNT(inventory_id)
FROM inventory 
WHERE film_id IN
(
	SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
);

SELECT b.title, COUNT(a.inventory_id) AS 'Total_Copies'
FROM inventory a
JOIN film b
ON a.film_id = b.film_id
WHERE b.title = 'Hunchback Impossible';


/*6e.*/
SELECT a.first_name, a.last_name, SUM(b.amount) AS 'Total Amount Paid'
FROM customer a
INNER JOIN payment b
ON a.customer_id = b.customer_id
GROUP BY b.customer_id
ORDER BY a.last_name ASC;

/*7a.*/
SELECT film.title, language.name 
FROM film
JOIN language
ON film.language_id = language.language_id
WHERE (film.title LIKE 'Q%' OR film.title LIKE 'K%') AND language.name = 'English';

/*7b.*/
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN
    (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
);

SELECT actor.first_name, actor.last_name, film.title
FROM actor 
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film.film_id = film_actor.film_id
WHERE film.title = 'Alone Trip';

/*7c.*/
SELECT first_name, last_name, email 
FROM customer
WHERE address_id IN
(
	SELECT address_id
    FROM address
    WHERE city_id IN
    (
		SELECT city_id
		FROM city
		WHERE country_id IN
        (
			SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

SELECT customer.first_name, customer.last_name, customer.email
FROM customer 
JOIN address ON customer.address_id = address.address_id 
JOIN city ON address.city_id = city.city_id 
JOIN country ON city.country_id = country.country_id
WHERE country like 'Canada';

/*7d.*/
SELECT title
 FROM film 
 WHERE film_id IN
 (
	SELECT film_id
    FROM film_category
    WHERE category_id IN
    (
		SELECT category_id
        FROM category
        WHERE name = 'family'
    )
 );

 SELECT a.title, c.name
 FROM film AS a
 JOIN film_category AS b ON a.film_id = b.film_id
 JOIN category AS c ON b.category_id = c.category_id
 WHERE c.name = 'family';

/*7e.*/
SELECT film.title, COUNT(rental.rental_date) AS total_count
FROM film 
JOIN inventory 
ON film.film_id = inventory.film_id 
JOIN rental 
ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title 
ORDER BY COUNT(rental.rental_date) DESC;

/*7f.*/
SELECT * FROM sales_by_store;

/*7g.*/
SELECT store.store_id, city.city, country.country
FROM store
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id;

/*7h.*/
SELECT * FROM sales_by_film_category
ORDER BY total_sales DESC LIMIT 5;

/*8a.*/

CREATE VIEW sales_by_film_category 
AS 
SELECT c.name AS category, SUM(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_sales DESC LIMIT 5;

/*8b.*/
SELECT * FROM sales_by_film_category;

/*8c.*/
DROP VIEW sales_by_film_category;

/**/
