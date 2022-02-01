-- lab-sql-rolling-calculations

use sakila;

-- 1. Get number of monthly active customers.

-- create a view with active customers by month and year
CREATE OR REPLACE VIEW customer_activity AS
    SELECT 
        customer_id,
        DATE_FORMAT(rental_date, '%m') AS activity_month,
        DATE_FORMAT(rental_date, '%Y') AS activity_year
    FROM
        sakila.rental;

-- check
SELECT * FROM customer_activity;

-- create a view with the count of active customers by month
CREATE OR REPLACE VIEW monthly_active AS
    SELECT 
        COUNT(DISTINCT customer_id) AS active_customer,
        activity_month,
        activity_year
    FROM
        customer_activity
    GROUP BY activity_year, activity_month
    ORDER BY activity_year, activity_month;
  
  -- check
  SELECT * FROM monthly_active;  

-- 2. Active users in the previous month.

WITH cte_activity AS (SELECT active_customer, 
						LAG(active_customer, 1) OVER (PARTITION BY activity_year) AS last_month,
                        activity_month, activity_year
						FROM monthly_active)
SELECT 
    *
FROM
    cte_activity 
WHERE last_month IS NOT NULL;

-- 3. Percentage change in the number of active customers.

-- with cte find the difference with previous month
WITH cte_diff AS (SELECT 
    active_customer, activity_month, activity_year,
    (active_customer - LAG(active_customer, 1) OVER (PARTITION BY activity_year)) AS diff
FROM monthly_active)
SELECT  -- convert to percentage
	active_customer, 
    ROUND(diff * 100 / LAG(active_customer, 1) OVER (PARTITION BY activity_year), 2) AS diff_percentage,
    activity_month, 
    activity_year
FROM cte_diff;

-- 4. Retained customers every month.

WITH distinct_customer AS (SELECT 
	DISTINCT customer_id, activity_month, activity_year 
    FROM customer_activity)
SELECT 
    COUNT(DISTINCT d1.customer_id) AS retained_customers,
    d1.activity_month,
    d1.activity_year
FROM
    distinct_customer d1
        JOIN
    distinct_customer d2 ON d1.customer_id = d2.customer_id
        AND d1.activity_month = d2.activity_month + 1  -- to see the customers from the previous month
GROUP BY d1.activity_year, d1.activity_month
ORDER BY d1.activity_year, d1.activity_month;



