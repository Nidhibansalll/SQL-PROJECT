create database Bike_db;
use Bike_db;
select*from brands;
select*from categories;
select*from customers;
select*from order_items;
select*from orders;
select*from products;
select*from staffs;
select*from stocks;
select*from stores;

# 1. List all product names with their brand and category
SELECT p.product_name, b.brand_name, c.category_name
FROM products p
JOIN brands b ON p.brand_id = b.brand_id
JOIN categories c ON p.category_id = c.category_id;

# 2. Which products are out of stock?
SELECT p.product_name, s.store_id
FROM stocks s
JOIN products p ON s.product_id = p.product_id
WHERE s.quantity = 0;

# 3.Top 5 most ordered products
SELECT p.product_name, SUM(oi.quantity) AS total_quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 5;

# 4.List customers who placed more than 5 orders
SELECT 
    c.first_name, 
    c.last_name, 
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING total_orders >= 1
ORDER BY total_orders DESC;

# 5. Total number of products in each store
SELECT 
    s.store_id,
    st.store_name,
    SUM(s.quantity) AS total_products
FROM stocks s
JOIN stores st ON s.store_id = st.store_id
GROUP BY s.store_id, st.store_name;

# 6.Orders placed in the last 30 days
SELECT *
FROM orders
WHERE order_date BETWEEN '2016-01-01' AND '2016-03-01';

# 7.Total revenue generated per store
SELECT 
    st.store_name,
    SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN stores st ON o.store_id = st.store_id
GROUP BY st.store_name;

# 8. Staff members working in each store
SELECT 
    st.store_name,
    COUNT(s.staff_id) AS staff_count
FROM staffs s
JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_name;

# 9. Average price of products per category
SELECT 
    c.category_name,
    AVG(p.list_price) AS avg_price
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

# 10. Customer who spent the most money
SELECT 
    c.first_name,
    c.last_name,
    SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 1;

# 11. Find duplicate product names
SELECT 
    product_name,
    COUNT(*) AS name_count
FROM products
GROUP BY product_name
HAVING name_count > 1;

# 12. Orders with more than 3 items
SELECT 
    order_id,
    COUNT(*) AS item_count
FROM order_items
GROUP BY order_id
HAVING item_count > 3;

# 13. Monthly revenue report
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

# 14. List products with price above average
SELECT 
    product_name,
    list_price
FROM products
WHERE list_price > (SELECT AVG(list_price) FROM products);

# 15. Orders handled by each staff
SELECT 
    s.first_name,
    s.last_name,
    COUNT(o.order_id) AS handled_orders
FROM staffs s
JOIN orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;