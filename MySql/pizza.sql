create table pizza_sales(
pizza_id int primary key, order_id int,	pizza_name_id varchar(50),	quantity int,
order_date varchar(50),order_time varchar(50),
unit_price int, total_price int, pizza_size varchar(50),pizza_category varchar(50),
pizza_ingredients varchar(50),	pizza_name varchar(50)
);
set sql_safe_updates = 0;
UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');
UPDATE pizza_sales
SET order_time = STR_TO_DATE(order_time, '%H:%i:%s');

-- total Revenue
SELECT SUM(total_price) AS Total_Revenue FROM pizza_sales;
-- Average Order Value
SELECT round((SUM(total_price) / COUNT(DISTINCT order_id)),1) AS Avg_order_Value FROM pizza_sales;

--  Total Pizzas Sold
select sum(quantity) as Total_pizzas_sold  from pizza_sales;

-- Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales;

-- Average Pizzas Per Order
SELECT round(SUM(quantity) / COUNT(DISTINCT order_id),2) AS average_pizzas_per_order
FROM pizza_sales;

-- 
SELECT order_date, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY order_date
ORDER BY order_date;

-- daily trends
select dayname(order_date) AS order_day ,count(distinct order_id) as total_orders
from pizza_sales
group by order_day
ORDER BY FIELD(order_day, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- Hourly Trend for Orders
SELECT HOUR(order_time) AS order_hour, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY order_hour
ORDER BY order_hour;

--  % of Sales by Pizza Category
SELECT pizza_category, SUM(total_price) AS total_sales,
    round((SUM(total_price) / (SELECT SUM(total_price) FROM pizza_sales) * 100),2) AS percentage_of_sales
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_sales DESC;
    
-- % of Sales by Pizza Size
SELECT pizza_size,SUM(total_price) AS total_sales,
    round((SUM(total_price) / (SELECT SUM(total_price) FROM pizza_sales) * 100),2) AS percentage_of_sales
FROM pizza_sales
GROUP BY pizza_size
ORDER BY total_sales DESC;

-- . Total Pizzas Sold by Pizza Category
SELECT pizza_category,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_pizzas_sold DESC;
    
-- . Top 5 Best Sellers by Total Pizzas Sold
SELECT pizza_name,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_pizzas_sold DESC
LIMIT 5;

-- Bottom 5 Best Sellers by Total Pizzas Sold
SELECT 
    pizza_name,
    SUM(quantity) AS total_pizzas_sold
FROM 
    pizza_sales
GROUP BY 
    pizza_name
ORDER BY 
    total_pizzas_sold ASC
LIMIT 5;

