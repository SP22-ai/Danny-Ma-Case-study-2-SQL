--How many pizzas were ordered ?--
SELECT
		COUNT(1) AS total_pizza_ordered
FROM customer_orders1

--How many unique customer orders were made?--
SELECT COUNT(DISTINCT(order_id)) AS unique_customer_orders
  FROM customer_orders1

--How many successful orders were delivered by each runner?--
SELECT
		runner_id,
		COUNT(order_id) AS successful_orders_delivered
 FROM runner_orders
 WHERE cancellation = ' '
 GROUP BY runner_id 

 --How many of each type of pizza was delivered?--
 WITH table1 AS
(
SELECT
		r.order_id,
		c.pizza_id,
		r.cancellation
FROM runner_orders r
INNER JOIN customer_orders1 c ON (c.order_id = r.order_id)
WHERE cancellation = ' '
)
SELECT
		t.pizza_id,
		COUNT(order_id) AS pizza_delivered
FROM  table1 t
GROUP BY t.pizza_id 


--How many Vegetarian and Meatlovers were ordered by each customer?--
SELECT
		c.customer_id,
		p.pizza_id,
		COUNT(1) AS pizza_ordered
FROM customer_orders1 c
INNER JOIN pizza_names p ON (c.pizza_id = p.pizza_id)
GROUP BY p.pizza_id,c.customer_id
ORDER BY c.customer_id;

--What was the maximum number of pizzas delivered in a single order?--
WITH table1 AS
(
SELECT
		c.order_id,
		COUNT(1) AS order_count
FROM customer_orders1 c
GROUP BY c.order_id
)
SELECT
		MAX(t.order_count) AS max_order
FROM table1 t

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?--
--this includes whether any customer took any exclusion or extra--
WITH table1 AS
(
SELECT
		c.customer_id,
		c.exclusions,
		c.extras,
		r.cancellation
FROM customer_orders1 c
INNER JOIN runner_orders r ON (r.order_id = c.order_id)
WHERE r.cancellation = ' ')
SELECT
		t.customer_id,
		SUM(CASE WHEN (t.exclusions = ' ' AND t.extras = ' ') THEN 1 ELSE 0 END) AS no_change,
		SUM(CASE WHEN (t.exclusions <> ' ' OR t.extras <> ' ') THEN 1 ELSE 0 END) AS  some_change
FROM table1 t
GROUP BY t.customer_id


--How many pizzas were delivered that had both exclusions and extras?--
WITH table1 AS
(
SELECT
		c.*,
		r.cancellation
FROM customer_orders1 c
LEFT OUTER JOIN runner_orders r ON (c.order_id= r.order_id)
WHERE r.cancellation = ' '
)
SELECT
		COUNT(1) AS pizza_count
FROM table1 t
WHERE t.exclusions != ' ' AND t.extras != ' '

--What was the total volume of pizzas ordered for each hour of the day?--
SELECT
		DATEPART(HOUR, c.order_time) AS hour_of_the_day,
		COUNT(1) AS pizza_count
FROM customer_orders1 c
GROUP BY DATEPART(HOUR, c.order_time);

--What was the volume of orders for each day of the week?--
SELECT
		DATENAME(WEEKDAY, c.order_time) AS day_of_the_week,
		COUNT(1) AS pizza_count
FROM customer_orders1 c
GROUP BY DATENAME(WEEKDAY, c.order_time)
ORDER BY pizza_count DESC; 
