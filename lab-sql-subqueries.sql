-- lab-sql-subqueries

use sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

# inventory - film #

SELECT 
    film_id, COUNT(*) AS n_copies
FROM
    sakila.inventory
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            sakila.film
        WHERE
            title LIKE 'Hunchback Impossible')
GROUP BY film_id;

-- 2. List all films whose length is longer than the average of all the films.

SELECT 
    title, length
FROM
    sakila.film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            sakila.film);
            
-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

# actor - film_actor - film #

SELECT 
    CONCAT(first_name, ' ', last_name) AS actor
FROM
    sakila.actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            sakila.film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    sakila.film
                WHERE
                    title LIKE 'Alone Trip'));
                    
-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

# film - film_category - category #

SELECT 
    title
FROM
    sakila.film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            sakila.film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    sakila.category
                WHERE
                    name = 'Family'));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys 
-- and foreign keys, that will help you get the relevant information.

# customer - address - city - country #

SELECT 
    CONCAT(first_name, ' ', last_name) AS customer,
    email
FROM
    sakila.customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            sakila.address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    sakila.city
                WHERE
                    country_id IN (SELECT 
                            country_id
                        FROM
                            sakila.country
                        WHERE
                            country = 'Canada')));

-- with join
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    c.email,
    co.country
FROM
    sakila.customer c
        JOIN
    sakila.address a USING (address_id)
        JOIN
    sakila.city ci USING (city_id)
        JOIN
    sakila.country co USING (country_id)
WHERE
    co.country = 'Canada';
    
-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor 
-- that has acted in the most number of films. First you will have to find the most prolific actor 
-- and then use that actor_id to find the different films that he/she starred.

-- find the prolific actor (actor_id)

SELECT 
    actor_id, COUNT(*) AS n_films
FROM
    sakila.film_actor
GROUP BY actor_id
ORDER BY n_films DESC
LIMIT 1;

-- find the films

# film_actor - film #

SELECT 
    film_id, title
FROM
    sakila.film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            sakila.film_actor
        WHERE
            actor_id IN (SELECT 
                    actor_id
                FROM
                    (SELECT 
                        actor_id, COUNT(*) AS n_films
                    FROM
                        sakila.film_actor
                    GROUP BY actor_id
                    ORDER BY n_films DESC
                    LIMIT 1) id));
                    
-- 7. Films rented by most profitable customer. You can use the customer table and payment 
-- table to find the most profitable customer ie the customer that has made the largest sum of payments.
            
-- find the customer (customer_id)
SELECT 
    customer_id, sum(amount) AS total_payments
FROM
    sakila.payment
GROUP BY customer_id
ORDER BY total_payments DESC
LIMIT 1;

-- find the films rented

# film - inventory - rental - payment #

SELECT 
    film_id, title
FROM
    sakila.film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            sakila.inventory
        WHERE
            inventory_id IN (SELECT 
                    inventory_id
                FROM
                    sakila.rental
                WHERE
                    customer_id IN (SELECT 
                            customer_id
                        FROM
                            (SELECT 
                                customer_id, SUM(amount) AS total_payments
                            FROM
                                sakila.payment
                            GROUP BY customer_id
                            ORDER BY total_payments DESC
                            LIMIT 1) id)));

-- 8. Customers who spent more than the average payments.

-- find the average amount
SELECT 
    AVG(sum)
FROM
    (SELECT 
        customer_id, SUM(amount) AS sum
    FROM
        sakila.payment
    GROUP BY customer_id) sub;
    
-- find the customers

# customer - payment #

SELECT 
    customer_id, CONCAT(first_name, ' ', last_name) AS customer
FROM
    sakila.customer
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            (SELECT 
                customer_id, SUM(amount) AS sum
            FROM
                sakila.payment
            GROUP BY customer_id
            HAVING sum > (SELECT 
                    AVG(sum)
                FROM
                    (SELECT 
                    customer_id, SUM(amount) AS sum
                FROM
                    sakila.payment
                GROUP BY customer_id) sub1)) sub2);


