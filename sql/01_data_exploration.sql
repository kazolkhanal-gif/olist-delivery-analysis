-- 1. Orders per status
SELECT order_status, COUNT(*) AS n
FROM ORDERS
GROUP BY order_status
ORDER BY n DESC;
-- 2. Date range of orders
SELECT MIN(order_purchase_timestamp) AS first_order,
       MAX(order_purchase_timestamp) AS last_order
FROM ORDERS;
-- 2b. Orders per month
SELECT SUBSTR(order_purchase_timestamp, 1, 7) AS month, COUNT(*) AS n
FROM ORDERS
GROUP BY month
ORDER BY month;
-- 3. Orders with no delivery date, by status
SELECT order_status, COUNT(*) AS n
FROM ORDERS
WHERE order_delivered_customer_date IS NULL
   OR order_delivered_customer_date = ''
GROUP BY order_status
ORDER BY n DESC;
-- 4. Orders with more than one review
SELECT COUNT(*) AS orders_with_multiple_reviews
FROM (
  SELECT order_id
  FROM REVIEWS
  GROUP BY order_id
  HAVING COUNT(*) > 1
);
-- 4b. Examples of orders with multiple reviews
SELECT order_id, review_score, review_creation_date, review_answer_timestamp
FROM REVIEWS
WHERE order_id IN (
  SELECT order_id FROM REVIEWS GROUP BY order_id HAVING COUNT(*) > 1
)
ORDER BY order_id, review_creation_date
LIMIT 20;
-- 4c. Orders with no review
SELECT COUNT(*) AS orders_without_review
FROM ORDERS
WHERE order_id NOT IN (SELECT order_id FROM REVIEWS);
-- 5. Distinct customer ids
SELECT COUNT(DISTINCT customer_id) AS customer_ids,
       COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM CUSTOMERS;