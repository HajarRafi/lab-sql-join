-- lab-sql-join-multiple-tables

use sakila;

-- 1. Write a query to display for each store its store ID, city, and country.

-- check
SELECT 
    *
FROM
    sakila.store;

SELECT 
    *
FROM
    sakila.address;

SELECT 
    *
FROM
    sakila.city;

SELECT 
    *
FROM
    sakila.country;
    
SELECT 
    s.store_id, c.city, co.country
FROM
    sakila.store s
        LEFT JOIN
    sakila.address a USING (address_id)
        JOIN
    sakila.city c USING (city_id)
        JOIN
    sakila.country co USING (country_id);
    
-- 2. Write a query to display how much business, in dollars, each store brought in.

-- check
SELECT 
    *
FROM
    sakila.store;

SELECT 
    *
FROM
    sakila.payment;

SELECT 
    *
FROM
    sakila.staff;

SELECT 
    s.store_id, SUM(p.amount) AS revenue
FROM
    sakila.store s
        LEFT JOIN
    sakila.staff st USING (store_id)
        JOIN
    sakila.payment p USING (staff_id)
GROUP BY s.store_id;

-- 3. What is the average running time of films by category?

-- check
SELECT 
    *
FROM
    sakila.film;

SELECT 
    *
FROM
    sakila.film_category;

SELECT 
    *
FROM
    sakila.category;

SELECT 
    c.name, FLOOR(AVG(f.length)) AS avg_film_length
FROM
    sakila.film f
        JOIN
    sakila.film_category fc USING (film_id)
        JOIN
    sakila.category c USING (category_id)
GROUP BY c.name
ORDER BY avg_film_length DESC;

-- 4. Which film categories are longest?

SELECT 
    c.name, FLOOR(AVG(f.length)) AS avg_film_length
FROM
    sakila.film f
        JOIN
    sakila.film_category fc USING (film_id)
        JOIN
    sakila.category c USING (category_id)
GROUP BY c.name
ORDER BY avg_film_length DESC
LIMIT 5;

-- 5. Display the most frequently rented movies in descending order.

-- check
SELECT 
    *
FROM
    sakila.film;

SELECT 
    *
FROM
    sakila.rental;

SELECT 
    *
FROM
    sakila.inventory;
    
SELECT 
    f.title, COUNT(r.rental_id) AS n_rental
FROM
    sakila.film f
        LEFT JOIN
    sakila.inventory i USING (film_id)
        LEFT JOIN
    sakila.rental r USING (inventory_id)
GROUP BY f.title
ORDER BY n_rental DESC;

-- 6. List the top five genres in gross revenue in descending order.

-- check
SELECT 
    *
FROM
    sakila.film_category;

SELECT 
    *
FROM
    sakila.payment;

SELECT 
    *
FROM
    sakila.rental;
    
SELECT 
    *
FROM
    sakila.inventory;
    
SELECT 
    c.name, SUM(p.amount) AS revenue
FROM
    sakila.category c
        JOIN
    sakila.film_category fc USING (category_id)
        JOIN
    sakila.inventory i USING (film_id)
        JOIN
    sakila.rental r USING (inventory_id)
        JOIN
    sakila.payment p USING (rental_id)
GROUP BY c.name
ORDER BY revenue DESC
LIMIT 5;

-- 7. Is "Academy Dinosaur" available for rent from Store 1?

-- check
SELECT 
    *
FROM
    sakila.film;

SELECT 
    *
FROM
    sakila.store;

SELECT 
    *
FROM
    sakila.inventory;
    
SELECT 
    f.title, i.store_id
FROM
    sakila.film f
        JOIN
    sakila.inventory i USING (film_id)
        JOIN
    sakila.store s USING (store_id)
WHERE
    f.title like 'Academy Dinosaur'
        AND s.store_id = 1;