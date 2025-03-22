-- B. Runner and Customer Experience
--- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01) 
SELECT
    WEEK(registration_date, 1) + 1 AS registration_week,
    COUNT(runner_id) AS runner_signup
FROM
    runners
WHERE
    registration_date >= '2021-01-01'
GROUP BY
    registration_week
ORDER BY
    registration_week;

--- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order?
SELECT
    r.runner_id,
    AVG(CAST(REPLACE(ro.duration, 'minutes', '') AS UNSIGNED)) AS average_pickup_time_minutes
FROM
    runners r
JOIN
    runner_orders ro ON r.runner_id = ro.runner_id
WHERE
    ro.duration != '' -- Filter out empty durations
GROUP BY
    r.runner_id;

--- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
--- CÁCH 1
SELECT 
    co.order_id,
    COUNT(co.pizza_id) AS num_pizzas,
    CAST(ro.duration AS UNSIGNED) AS prep_duration
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.duration IS NOT NULL AND ro.duration != ''
GROUP BY co.order_id
ORDER BY num_pizzas DESC;

--- CÁCH 2

SELECT 
    num_pizzas,
    AVG(prep_duration) AS avg_prep_duration
FROM (
    SELECT 
        co.order_id,
        COUNT(co.pizza_id) AS num_pizzas,
        CAST(ro.duration AS UNSIGNED) AS prep_duration
    FROM customer_orders co
    JOIN runner_orders ro ON co.order_id = ro.order_id
    WHERE ro.duration IS NOT NULL AND ro.duration != ''
    GROUP BY co.order_id
) AS order_summary
GROUP BY num_pizzas
ORDER BY num_pizzas DESC;

--- 4. What was the average distance travelled for each customer?
SELECT 
  CUSTOMER_ID, 
  AVG(CAST(REPLACE(DISTANCE, 'KM', '') AS DECIMAL(3, 1))) AS AVG_DISTANCE_TRAVELLED 
FROM 
  RUNNER_ORDERS AS RO 
  INNER JOIN CUSTOMER_ORDERS AS CO ON RO.ORDER_ID = CO.ORDER_ID 
WHERE 
  DISTANCE <> 'NULL' 
GROUP BY 
  CUSTOMER_ID;


--- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(DURATION) - MIN(DURATION) AS DILIVERY_TIME_DIFFERENCES
FROM RUNNER_ORDERS
WHERE DURATION IS NOT NULL 


--- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
WITH CTE AS (
    SELECT RUNNER_ID, ORDER_ID, ROUND(DISTANCE * 60 /DURATION, 1) AS SPEEDKMH,
    ROUND(SUM(DISTANCE), 2) AS KMS
    FROM RUNNER_ORDERS
    WHERE DISTANCE != 0
    GROUP BY RUNNER_ID, ORDER_ID
)
SELECT * FROM CTE
ORDER BY RUNNER_ID;

--- 7. What is the successful delivery percentage for each runner?
WITH ORDER_STATS AS (
SELECT RUNNER_ID, COUNT(ORDER_ID) AS TOTAL_ORDERS,
SUM(CASE
	WHEN DISTANCE != 0
    THEN 1 ELSE 0
    END) AS ORDER_DELIVERED
FROM RUNNER_ORDERS
GROUP BY RUNNER_ID
)

SELECT RUNNER_ID,
ROUND((ORDER_DELIVERED)/(TOTAL_ORDERS)*100) AS SUCCESSFUL_DELIVERY
FROM ORDER_STATS

