use pizza;

----welcome to pizza sales analysis------

-------Question no 1---------------
-------The total number of order place-----------

 SELECT COUNT(order_id) AS total_orders
FROM orders;

-------Question no 2---------------  
-------The total revenue generated from pizza sales-----------

SELECT ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_sales
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id;

-------Question no 3---------------  
-------The highest priced pizza--------------

SELECT TOP 1 pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC;

-------Question no 4---------------  
-------- The most common pizza size ordered-----------

select top 1 count (order_details.order_id) as total_orders,pizzas.size
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
group by pizzas.size order by total_orders desc

-------Question no 5---------------  
-----The top 5 most ordered pizza types along their quantities.

SELECT top 5 pizza_types.name, SUM(order_details.quantity) AS quantity
FROM pizza_types
JOIN  pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity desc;

-------Question no 6---------------
-----The quantity of each pizza categories ordered.------


SELECT pizza_types.category, SUM(order_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity desc;

-------Question no 7---------------
------The distribution of orders by hours of the day------

select hour(time) as hour,
COUNT(order_id) as order_count 
from orders
group by hour(time);

-------Question no 8---------------
----The category-wise distribution of pizzas

SELECT  category, COUNT(name)
FROM pizza_types
GROUP BY category;


-------Question no 9---------------
----- The average number of pizzas ordered per day---


SELECT  ROUND(AVG(quantity), 0) as avg_number_pizzas
FROM
    (SELECT 
        orders.date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON order_details.order_id = orders.order_id
    GROUP BY orders.date) AS order_quantity;


	-------Question no 10--------------
	-----Top 3 most ordered pizza type base on revenue.

SELECT top 3 pizza_types.name,
SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN  pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC ;

-------Question no 11--------------
---The percentage contribution of each pizza type to revenue.


SELECT pizza_types.category,
 ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
 ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_sales
 FROM order_details
 JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,2) AS Total_Revenue
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY Total_Revenue DESC;

-------Question no 12--------------
-----The cumulative revenue generated over time.

select date,
sum(revenue) over(order by date) as cum_revenue
from
(select orders.date, sum(order_details.quantity * pizzas.price) as revenue
from order_details 
join pizzas on order_details.pizza_id = pizzas.pizza_id
join orders on orders.order_id = order_details.order_id
group by orders.date) as sales;

-------Question no 13--------------
---The top 3 most ordered pizza type based on revenue for each pizza category.

select top 3 name, revenue from
(select category, name, revenue,
rank() over(partition by category order by revenue desc ) as rn
from
(select pizza_types.category, pizza_types.name,
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn <= 3;

-------thank you-----