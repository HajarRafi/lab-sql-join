-- lab-sql-advanced-queries

use sakila;

-- 1. List each pair of actors that have worked together.

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

-- 2. For each film, list actor that has acted in more films.

-- create a view with number of films acted
CREATE VIEW actor_n_films AS
    (SELECT 
        actor_id, COUNT(*) AS n_films
    FROM
        film_actor
    GROUP BY actor_id);

-- join together with ranking and then with film (title) and actor (name)
WITH cte_rank AS (SELECT actor_id, film_id, n_films,
				RANK() OVER (PARTITION BY film_id ORDER BY n_films DESC) as rank_
				FROM film_actor
				JOIN actor_n_films USING (actor_id))
SELECT 
    title,
    CONCAT(a.first_name, ' ', a.last_name) AS actor,
    n_films
FROM
    cte_rank
        JOIN
    sakila.actor a USING (actor_id)
        JOIN
    sakila.film f USING (film_id)
WHERE
    rank_ = 1;  -- find the most acted