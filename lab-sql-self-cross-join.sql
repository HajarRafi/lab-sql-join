-- lab-sql-self-cross-join

use sakila;

-- 1. Get all pairs of actors that worked together.

SELECT 
    CONCAT(a1.first_name, ' ', a1.last_name) AS actor1,
    CONCAT(a2.first_name, ' ', a2.last_name) AS actor2,
    f1.film_id
FROM
    sakila.film_actor f1
        JOIN
    sakila.film_actor f2 ON f1.film_id = f2.film_id
        AND f1.actor_id < f2.actor_id  -- to avoid repetition
        JOIN
    sakila.actor a1 ON f1.actor_id = a1.actor_id
        JOIN
    sakila.actor a2 ON f2.actor_id = a2.actor_id
ORDER BY f1.film_id;
        
-- 2. Get all pairs of customers that have rented the same film more than 3 times.

SELECT 
    CONCAT(c1.first_name, ' ', c1.last_name) as customer1,
    CONCAT(c2.first_name, ' ', c2.last_name) as customer2,
    i1.film_id,
    COUNT(*) AS n_rentals
FROM
    sakila.rental r1
        JOIN
    sakila.rental r2 ON r1.inventory_id = r2.inventory_id
        AND r1.customer_id < r2.customer_id
        JOIN
    sakila.customer c1 ON r1.customer_id = c1.customer_id
        JOIN
    sakila.customer c2 ON r2.customer_id = c2.customer_id
        JOIN
    sakila.inventory i1 ON r1.inventory_id = i1.inventory_id
        JOIN
    sakila.inventory i2 ON i1.film_id = i2.film_id
GROUP BY i1.film_id , r1.customer_id , r2.customer_id
HAVING n_rentals > 3
ORDER BY film_id;

-- 3. Get all possible pairs of actors and films.

SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actor,
    f.title AS film
FROM
    sakila.actor a
        CROSS JOIN
    sakila.film f;

