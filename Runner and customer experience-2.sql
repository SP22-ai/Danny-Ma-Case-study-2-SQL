--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
--As the week started from 2021-01-04 hence we are getting incorrect results so we need to make 2021-01-01 as the starting of the week. For that +3 must be added.
SELECT
		DATEPART(WEEK,date)-1 AS week_of_the_year,
		COUNT(1) AS runners_count
FROM (
SELECT
		*,
		DATEADD(DAY,3, registration_date) AS date
FROM runners) AS subq
GROUP BY DATEPART(WEEK,date)

--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
--Assuming we need to calculate the difference between order time and pickup time
WITH table1 AS
(SELECT
		c.order_time,
		r.runner_id,
		r.pickup_time,
		r.cancellation
FROM customer_orders1 c
LEFT OUTER JOIN runner_orders r on (r.order_id = c.order_id)
WHERE r.cancellation = ' '),
table2 AS
(
SELECT
		t.runner_id,
		AVG(DATEDIFF(MINUTE, t.order_time,t.pickup_time)) AS avg_time_taken
FROM table1 t
GROUP BY t.runner_id)
SELECT
		AVG(t2.avg_time_taken) AS average_time_taken
FROM table2 t2


--Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH table1 AS
(
SELECT
		c.order_id,
		COUNT(c.order_id) AS number_of_pizzas,
		r.cancellation,
		c.order_time,
		r.pickup_time,
		DATEDIFF(MINUTE,c.order_time, r.pickup_time) AS time_for_order_prep
FROM customer_orders1 c
LEFT OUTER JOIN runner_orders r ON (r.order_id = c.order_id)
WHERE r.cancellation = ' '
GROUP BY c.order_id,r.cancellation, c.order_time,r.pickup_time)
SELECT
		t.number_of_pizzas,
		AVG(t.time_for_order_prep) AS average_time_taken_to_prepare_pizza
FROM table1 t
GROUP BY  t.number_of_pizzas
ORDER BY t.number_of_pizzas DESC


--What was the average distance travelled for each customer?
WITH table1 AS
(
SELECT
		c.order_id,
		c.customer_id,
		r.distance,
		r.cancellation
FROM runner_orders r 
LEFT OUTER JOIN customer_orders1 c ON (r.order_id = c.order_id)
WHERE cancellation = ' ')
SELECT
		t.customer_id,
		AVG(t.distance) AS avg_distance_travelled
FROM table1 t
GROUP BY t.customer_id
ORDER BY AVG(t.distance) DESC

--What was the difference between the longest and shortest delivery times for all orders?
WITH table1 AS
(
SELECT
		MAX(r.duration) AS longest_delivery_time,
		MIN(r.duration) AS shortest_delivery_time
FROM runner_orders r
WHERE cancellation = '  ')
SELECT
		(t.longest_delivery_time - t.shortest_delivery_time) AS difference_between
FROM table1 t
--What was the average speed for each runner for each delivery and do you notice any trend for these values?
WITH table1 AS
(
SELECT
		r.runner_id,
		CONVERT(DECIMAL(3,2),(AVG(CONVERT(DECIMAL(3,2),ROUND((r.distance/r.duration),2))))) AS avg_speed
FROM runner_orders r
WHERE r.cancellation = ' ' 
GROUP BY r.runner_id)
SELECT
		t.runner_id,
		60*(t.avg_speed) AS avg_speed_in_km_per_hr
FROM table1 t

--What is the successful delivery percentage for each runner?
WITH table1 AS
(
SELECT
		order_id,
		runner_id,
		cancellation,
		CASE WHEN cancellation = ' ' THEN 1 ELSE 0 END AS delivery_count
FROM runner_orders
GROUP BY order_id,runner_id,cancellation),
table2 AS
(
SELECT
		t.runner_id,
		COUNT(1) AS order_count,
		SUM(t.delivery_count) AS count_of_delivery
FROM table1 t
GROUP BY t.runner_id)
SELECT
		t2.runner_id,
		(CAST (t2.count_of_delivery AS float)/t2.order_count)*100 AS delivery_percentage
FROM table2 t2