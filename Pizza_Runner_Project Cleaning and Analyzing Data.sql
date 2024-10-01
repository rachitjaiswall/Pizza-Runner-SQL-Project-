-- Credits https://8weeksqlchallenge.com/case-study-2/

-- * Cleaning customer_orders table *

SELECT *
FROM customer_orders;

-- Replacing blank spaces and character nulls with NULL 
UPDATE customer_orders 
SET exclusions = NULL
WHERE exclusions = '' OR exclusions = 'null';

UPDATE customer_orders 
SET extras = NULL
WHERE extras = '' OR extras = 'null';

-- * Cleaning runner_orders table * 

SELECT *
FROM runner_orders;

-- Replacing none valid values with NULL

UPDATE runner_orders 
SET pickup_time = NULL
WHERE pickup_time = 'null';

UPDATE runner_orders 
SET distance = NULL
WHERE distance = 'null';

UPDATE runner_orders 
SET duration = NULL
WHERE duration = 'null';

UPDATE runner_orders 
SET cancellation = NULL
WHERE cancellation = 'null' OR cancellation = '';

-- Standardizing the columns 

SELECT *, RTRIM(SUBSTRING_INDEX(distance, 'k', 1)) AS Distance2,
	SUBSTRING(duration, 1, 2) AS Duration2
FROM runner_orders;

UPDATE runner_orders
SET distance = RTRIM(SUBSTRING_INDEX(distance, 'k', 1));

UPDATE runner_orders 
SET duration = SUBSTRING(duration, 1, 2);

-- Changing column datatypes to match values 

ALTER TABLE runner_orders
MODIFY COLUMN pickup_time DATETIME,
MODIFY COLUMN distance FLOAT,
MODIFY COLUMN duration INT; 

					-- * Pizza Metrics * 
-- 1.) How many pizzas were ordered?
SELECT COUNT(*) AS Num_Pizza
FROM customer_orders;

-- 2.) How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS Num_Orders 
FROM customer_orders;

-- 3.) How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(pickup_time) AS Num_Delivered 
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

-- 4.) How many of each type of pizza was delivered?
SELECT pizza_name, COUNT(cust.pizza_id) AS Delivered 
FROM runner_orders runn 
JOIN customer_orders cust 
	ON runn.order_id = cust.order_id
JOIN pizza_names nam
	ON cust.pizza_id = nam.pizza_id
WHERE cancellation IS NULL
GROUP BY pizza_name;

-- 5.) How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_id, 
COUNT(CASE WHEN pizza_id = 1 THEN 1 END) AS Meatlover_Count,
COUNT(CASE WHEN pizza_id = 2 THEN 1 END) AS Vegitarian_Count
FROM customer_orders
GROUP BY customer_id;

-- 6.) What was the maximum number of pizzas delivered in a single order?
SELECT MAX(Num_Pizza) AS Max_Order
FROM ( 
SELECT cust.order_id, COUNT(pizza_id) AS Num_Pizza
FROM runner_orders runn 
JOIN customer_orders cust 
	ON runn.order_id = cust.order_id
WHERE cancellation IS NULL
GROUP BY cust.order_id) AS Pizza_Count;


-- 7.) For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT customer_id,
COUNT(CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1 END) AS Changes_Count,
COUNT(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1 END) AS No_Changes_Count
FROM runner_orders runn 
JOIN customer_orders cust 
	ON runn.order_id = cust.order_id
WHERE cancellation IS NULL
GROUP BY customer_id;

-- 8.) How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(pizza_id) AS Pizza_Count
FROM runner_orders runn 
JOIN customer_orders cust 
	ON runn.order_id = cust.order_id
WHERE cancellation IS NULL AND exclusions IS NOT NULL AND extras IS NOT NULL;

-- 9.) What was the total volume of pizzas ordered for each hour of the day?
SELECT HOUR(order_time) AS `Hour`,
COUNT(pizza_id) AS Pizza_Count_Hour
FROM customer_orders
GROUP BY `Hour`
ORDER BY `Hour`;

-- 10.) What was the volume of orders for each day of the week?
SELECT DAYNAME(order_time) AS `Day`,
COUNT(pizza_id) AS Pizza_Count_Hour
FROM customer_orders
GROUP BY `Day`
ORDER BY `Day`;

				-- * Runner and Customer Experience * 
-- 1.) How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT Week_signedup, COUNT(runner_id) AS Num_Hired 
FROM (
SELECT runner_id,
registration_date - ((registration_date - DATE('2021-01-01')) % 7) AS Week_signedup
FROM runners) AS Week_count
GROUP BY Week_signedup;

-- 2.) What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT runner_id, FLOOR(AVG(MINUTE(order_to_pickup_time))) AS Avg_Time
FROM (
SELECT cust.order_id,
runner_id,
cust.order_time,
run.pickup_time,
ABS((TIME(order_time) - TIME(pickup_time))) AS order_to_pickup_time
FROM customer_orders cust 
JOIN runner_orders run
	ON cust.order_id = run.order_id 
WHERE cancellation IS NULL) AS Time_Finder
GROUP BY runner_id;
    
-- 3.) Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT Num_Pizza, MINUTE(Prep_Time) AS Avg_Prep_Time 
FROM ( 
SELECT cust.order_id, COUNT(cust.order_id) Num_Pizza, ABS(TIMEDIFF(order_time, pickup_time)) AS Prep_time
FROM customer_orders cust 
JOIN runner_orders runn 
	ON cust.order_id = runn.order_id
WHERE cancellation IS NULL
GROUP BY cust.order_id, Prep_Time ) AS Prep_Finder
GROUP BY Num_Pizza, Avg_Prep_Time
LIMIT 3;

-- 4.) What was the average distance travelled for each customer?
SELECT runner_id, ROUND(AVG(distance),2) AS Avg_Distance
FROM runner_orders 
GROUP BY runner_id; 

-- 5.) What was the difference between the longest and shortest delivery times for all orders?
SELECT (MAX(MINUTE(Delivery)) - MIN(MINUTE(Delivery))) AS Differance
FROM ( 
SELECT cust.order_id,
TIMEDIFF(order_time, pickup_time) AS Delivery
FROM customer_orders cust 
JOIN runner_orders runn 
	ON cust.order_id = runn.order_id
WHERE cancellation IS NULL ) AS Time_Finder;

-- 6.) What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT order_id, COUNT(pizza_id) AS Num_pizza, runner_id, distance, duration, Speed 
FROM (
SELECT cust.order_id, 
runner_id,
pizza_id,
distance, 
duration, 
ROUND(60 * (distance / duration), 1) AS Speed
FROM customer_orders cust 
JOIN runner_orders runn 
	ON cust.order_id = runn.order_id
WHERE cancellation IS NULL ) AS Speed_Finder
GROUP BY order_id, runner_id, Speed, distance, duration
ORDER BY Speed;

-- 7.) What is the successful delivery percentage for each runner?
SELECT runner_id,
COUNT(pickup_time) AS Deliveries,
COUNT(order_id) AS Num_orders,
FLOOR((COUNT(pickup_time) / COUNT(order_id)) * 100) AS Success_Percentage
FROM runner_orders
GROUP BY runner_id;    
							
							-- * Pricing and Ratings *
-- 1.) If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
SELECT SUM( 
CASE 
	WHEN pizza_id = 1 THEN 12 
    WHEN pizza_id = 2 THEN 10
    END)  AS Total_Cost 
FROM customer_orders cust 
	JOIN runner_orders runn 
		ON cust.order_id = runn.order_id
WHERE cancellation IS NULL;
    
-- 2.) What if there was an additional $1 charge for any pizza extras?
	-- 	Add cheese is $1 extra
SELECT SUM(	
CASE 
	WHEN pizza_id = 1 AND extras IS NOT NULL THEN 13
    WHEN pizza_id = 2 AND extras IS NOT NULL THEN 11
	WHEN pizza_id = 1 THEN 12 
    WHEN pizza_id = 2 THEN 10
    END )  AS Total_Cost 
FROM customer_orders cust 
	JOIN runner_orders runn 
		ON cust.order_id = runn.order_id
WHERE cancellation IS NULL;
    
-- 3.) The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
CREATE TABLE Runner_Rating (
order_id int,
customer_id int,
runner_id int,
Rating int );

SELECT DISTINCT cust.order_id, customer_id, runner_id
FROM customer_orders cust 
	JOIN runner_orders runn 
		ON cust.order_id = runn.order_id;
        
INSERT INTO Runner_Rating(order_id, customer_id, runner_id)
(SELECT DISTINCT cust.order_id, customer_id, runner_id
FROM customer_orders cust 
	JOIN runner_orders runn 
		ON cust.order_id = runn.order_id);

-- Adding values to Rating column, constantly change order_id 
UPDATE runner_rating
SET Rating = 3
WHERE order_id = 10;

-- 4.) Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
	-- 	customer_id
	-- 	order_id
	-- 	runner_id
	-- 	rating
	-- 	order_time
	-- 	pickup_time
	-- 	Time between order and pickup
	-- 	Delivery duration
	-- 	Average speed
	-- 	Total number of pizzas
    
    SELECT rat.customer_id, rat.order_id, rat.runner_id, Rating, order_time, pickup_time, 
    ABS(TIMEDIFF(order_time, pickup_time)) AS order_to_pickup_time, 
    duration,
    ROUND(60 * (distance / duration), 1) AS Speed,
    COUNT(pizza_id) AS Total_Num_Pizza 
    FROM customer_orders cust 
    JOIN runner_orders runn 
		ON cust.order_id = runn.order_id
	JOIN runner_rating rat 
		ON runn.order_id = rat.order_id
	WHERE cancellation IS NULL
	GROUP BY rat.customer_id, rat.order_id, rat.runner_id, Rating, order_time, pickup_time, order_to_pickup_time, duration, Speed;
    
-- 5.) If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries? 
SELECT ROUND(SUM( 
CASE 
	WHEN pizza_id = 1 THEN 12 
    WHEN pizza_id = 2 THEN 10
    END)  - (SUM(distance) * 0.3), 0) AS Total_Price
FROM customer_orders cust 
	JOIN runner_orders runn 
		ON cust.order_id = runn.order_id
WHERE cancellation IS NULL;