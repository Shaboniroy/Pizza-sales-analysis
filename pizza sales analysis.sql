SELECT * FROM pizza.order_details;
SELECT * FROM pizza.orders;
SELECT * FROM pizza.pizza_types;
SELECT * FROM pizza.pizzas;

-- Q1) Retrieve the total number of orders placed
SELECT count(distinct order_id) as 'Total orders' FROM pizza.orders;
-- Ans 1) 21338

-- Q2)Calculate the total revenue generated from pizza sales
SELECT (
ROUND(SUM(pizza.order_details.quantity * pizza.pizzas.price) ,2)) as 'Total Revenue'
FROM pizza.pizzas
JOIN pizza.order_details on pizza.pizzas.pizza_id = pizza.order_details.pizza_id;
-- ANS2) TOtal revenue = 817860.05

-- Q3) Identify the highest priced pizza
SELECT pizza.pizza_types.name as p_name, pizza.pizzas.price AS highest_priced
FROM pizza.pizza_types
JOIN pizza.pizzas on pizza.pizzas.pizza_type_id = pizza.pizza_types.pizza_type_id
ORDER BY highest_priced DESC
LIMIT 1;
-- Ans 3) The highest priced pizza is The Greek Pizza with price of 35.95.

-- Q4) Identify the most common pizza size ordered
SELECT pizza.pizzas.size, COUNT(distinct pizza.order_details.order_id) as 'no of orders', SUM(pizza.order_details.quantity) as 'Total quantity'
FROM pizza.order_details
JOIN
pizza.pizzas on pizza.pizzas.pizza_id = pizza.order_details.pizza_id
GROUP BY pizza.pizzas.size
ORDER BY 'no of orders' DESC;
-- Ans4) The most common pizza size ordered is L with number of orders = 12736 and Total quantity = 18956.

-- Q5) List the top 5 best selling pizzas.
SELECT pizza.pizza_types.name, SUM(pizza.order_details.quantity*pizza.pizzas.price) as Max_revenue
FROM pizza.pizza_types
JOIN
pizza.pizzas ON pizza.pizzas.pizza_type_id = pizza.pizza_types.pizza_type_id
JOIN
pizza.order_details ON pizza.order_details.pizza_id = pizza.pizzas.pizza_id
GROUP BY pizza.pizza_types.name
ORDER BY Max_revenue DESC
LIMIT 5;
-- Ans5) The top 5 best selling pizzas are :
-- a) The Thai Chicken Pizza,
-- b) The Barbeque Chicken Pizza,
-- c) The California Chicken Pizza ,
-- d) The Classic Deluxe Pizza ,
-- e) The Spicy Italian Pizza.


-- Q6) Join the necessary tables to find the total quantity of each pizza category ordered
SELECT pizza.pizza_types.category, SUM(pizza.order_details.quantity) as Total_quantity
FROM pizza.pizza_types
JOIN 
pizza.pizzas ON pizza.pizza_types.pizza_type_id = pizza.pizzas.pizza_type_id
JOIN
pizza.order_details ON pizza.order_details.pizza_id = pizza.pizzas.pizza_id
GROUP BY pizza.pizza_types.category; 
-- Ans6) The total quantity of each pizza category ordered are as follows :
-- a) Classic = 14888
-- b) Veggie = 11649
-- c) Supreme = 11987
-- d) Chicken = 11050.

-- Q7) Determine the distribution of orders by hour of the day
SELECT HOUR(pizza.orders.time) AS 'hour', COUNT(distinct pizza.orders.order_id) AS 'order_count'
FROM pizza.orders
GROUP BY HOUR(pizza.orders.time)
ORDER BY (order_count) DESC;
-- Ans 7) Distribution of orders by hour of the day are :
--   hour          order_count
--    12                2520
--    13                2455
--    18                2399
--    17                2336
--    19                2009
--    16                1920
--    20                1642
--    14                1472
--    15                1468
--    11                1231
--    21                1198
--    22                663
--    23                28
--    10                8
--    9                 1
-- Also the most peak hour of the day is 12 with order_count of 2520.

-- Q8) Join relevant tables to find the category wise distribution of pizzas
SELECT pizza.pizza_types.category AS pz_category, COUNT(pizza.pizza_types.name) AS pz_name
FROM pizza.pizza_types
GROUP BY pz_category;
-- Ans8) The category wise distribution of pizzas are :
-- pz_category                pz_name
-- Chicken                       6
-- Classic                       8
-- Supreme                       9
-- Veggie                        9

-- Q9) Group the orders by date and calculate the average number of pizzas ordered per day
SELECT ROUND(AVG(daily_total), 0) as average_pizzas_order_per_day
FROM (
SELECT
pizza.orders.date, SUM(pizza.order_details.quantity) AS daily_total
FROM pizza.order_details
JOIN
pizza.orders ON pizza.order_details.order_id = pizza.orders.order_id
GROUP BY pizza.orders.date) AS daily_totals;
-- Ans 9) The average pizzas ordered per day = 139

-- Q10) Determine the 3 most ordered pizza types based on revenue
SELECT pizza.pizza_types.name AS pizza_name, SUM(pizza.order_details.quantity * pizza.pizzas.price) AS Revenue
FROM pizza.pizza_types
JOIN pizza.pizzas ON pizza.pizzas.pizza_type_id = pizza.pizza_types.pizza_type_id
JOIN pizza.order_details ON pizza.order_details.pizza_id = pizza.pizzas.pizza_id
GROUP BY pizza.pizza_types.name
ORDER BY (Revenue) DESC
LIMIT 3;
-- Ans 10) The 3 most ordered pizza types based on revenue are :
-- a) The Thai Chicken Pizza = 43434.25
-- b) The Barbecue Chicken Pizza = 42768
-- c) The California Chicken Pizza = 41409.5

-- Q11) Calculate the percentage contribution of each pizza category to total revenue
SELECT category, ROUND(SUM(quantity * price), 2) AS Revenue, CONCAT(ROUND(SUM(quantity * price) *100/ (
SELECT SUM(quantity * price)
FROM pizza.pizzas AS P2
JOIN pizza.order_details AS od2 ON pizza.p2.pizza_id = pizza.od2.pizza_id
), 2), '%') AS Percentage_revenue
FROM pizza.pizzas as p
JOIN pizza.pizza_types as pt ON pizza.pt.pizza_type_id = pizza.p.pizza_type_id
JOIN pizza.order_details as od ON pizza.od.pizza_id = pizza.p.pizza_id
GROUP BY category;
-- Ans 11) The percentage contribution of each pizza category to total revenue are :
--   Category           Revenue          Percentage_revenue
-- a)Classic            220053.1               26.91%
-- b)Veggie             193690.45              23.68%
-- c)Supreme            208197                 25.46%
-- d)Chicken            195919.5               23.96%

-- Q12) Calculate the percentage of sales by pizza size
SELECT size, ROUND(SUM(quantity * price), 2) as Revenue, CONCAT(ROUND(SUM(quantity * price) * 100 /
(SELECT SUM(quantity * price)
FROM pizza.pizzas as p2
JOIN pizza.order_details as od2 ON pizza.p2.pizza_id = pizza.od2.pizza_id
), 2), '%') as Percentage_of_sales
FROM pizza.pizzas as p
JOIN pizza.order_details as od ON pizza.od.pizza_id = pizza.p.pizza_id
JOIN pizza.pizza_types as pt ON pizza.pt.pizza_type_id = pizza.p.pizza_type_id     
GROUP BY size 
ORDER BY Percentage_of_sales DESC;
-- Ans 12) The percentage of sales by pizza size are :
--   Size          Revenue        Percentage_of_sales
-- a) L            375318.7            45.89%
-- b) M            249382.25           30.49%
-- c) S            178076.5            21.77%
-- d) XL           14076               1.72%
-- e) XXL          1006.6              0.12%

-- Q13) Identify the bottom 5 worst sellers by total pizzas sold
SELECT pizza.pizza_types.name, SUM(pizza.order_details.quantity) as Min_order 
FROM pizza.pizza_types
JOIN
pizza.pizzas ON pizza.pizzas.pizza_type_id = pizza.pizza_types.pizza_type_id
JOIN
pizza.order_details ON pizza.order_details.pizza_id = pizza.pizzas.pizza_id
GROUP BY pizza.pizza_types.name
ORDER BY Min_order ASC
LIMIT 5;
-- Ans 13) The bottom 5 worst sellers by total pizzas sold are :
--         Name                             Min_order
--  a)The Brie Carre Pizza                    490
--  b)The Mediterranean Pizza                 934
--  c)The Calabrese Pizza                     937
--  d)The Spinach Supreme Pizza               950
--  e)The Soppressata Pizza                   961.

-- Q14) Identify the highest priced pizza
SELECT pizza.pizza_types.name as p_name, pizza.pizzas.price AS highest_priced
FROM pizza.pizza_types
JOIN pizza.pizzas on pizza.pizzas.pizza_type_id = pizza.pizza_types.pizza_type_id
ORDER BY highest_priced DESC
LIMIT 1;
-- Ans 14) The highest priced pizza is The Greek Pizza with value of 35.95.

-- Q15) Calculate the average order value
SELECT ROUND(SUM(quantity * price) / COUNT(DISTINCT order_id), 2) as average_order
FROM pizza.pizzas as p
JOIN pizza.order_details as od ON pizza.p.pizza_id = pizza.od.pizza_id
-- Ans 15) The average order value is 38.31.

-- Q16) Calculate total orders
SELECT COUNT(DISTINCT order_id) AS Total_orders
FROM pizza.order_details as od;
-- Ans 16) The total orders are 21350.

-- Q17) Calculate average number of pizzas per order
SELECT ROUND(SUM(quantity) / COUNT(DISTINCT order_id), 0) AS avg_no_orders
FROM pizza.order_details;
-- Ans 17) The average number of pizzas per order = 2.
