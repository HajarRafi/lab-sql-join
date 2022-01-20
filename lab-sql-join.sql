-- lab-sql-join

use sakila;

-- 1. List the number of films per category.

-- check
SELECT 
    *
FROM
    sakila.category;

SELECT 
    *
FROM
    sakila.film_category;

SELECT 
    c.category_id, COUNT(f.film_id) AS n_films
FROM
    sakila.category c
        JOIN
    sakila.film_category f ON c.category_id = f.category_id
GROUP BY c.category_id;

-- 2. Display the first and the last names, as well as the address, of each staff member.

-- check
SELECT 
    *
FROM
    sakila.staff;

SELECT 
    *
FROM
    sakila.address;

SELECT 
    s.first_name, s.last_name, a.address
FROM
    sakila.staff s
        JOIN
    sakila.address a ON s.address_id = a.address_id;

-- 3. Display the total amount rung up by each staff member in August 2005.

-- check
SELECT 
    *
FROM
    sakila.staff;

SELECT 
    *
FROM
    sakila.payment;

SELECT 
    s.first_name,
    s.last_name,
    SUM(p.amount) AS 'august_total',
    SUBSTRING(p.payment_date, 1, 7) AS 'date'
FROM
    sakila.staff s
        JOIN
    sakila.payment p ON s.staff_id = p.staff_id
WHERE
    SUBSTRING(p.payment_date, 1, 7) = '2005-08'
GROUP BY SUBSTRING(p.payment_date, 1, 7), s.first_name, s.last_name;

-- 4. List all films and the number of actors who are listed for each film.

-- check
SELECT 
    *
FROM
    sakila.film;

SELECT 
    *
FROM
    sakila.film_actor;

SELECT 
    f.title, COUNT(fa.actor_id) AS n_actors
FROM
    sakila.film f
		JOIN
    sakila.film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title 
ORDER BY n_actors DESC;


-- 5. Using the payment and the customer tables as well as the JOIN command, 
-- list the total amount paid by each customer. List the customers alphabetically by their last names.

-- check
SELECT 
    *
FROM
    sakila.payment;

SELECT 
    *
FROM
    sakila.customer;

SELECT 
    c.last_name, c.first_name, SUM(p.amount) AS total_paid
FROM
    sakila.customer AS c
        JOIN
    sakila.payment AS p ON c.customer_id = p.customer_id
GROUP BY  c.last_name, c.first_name
ORDER BY c.last_name;

