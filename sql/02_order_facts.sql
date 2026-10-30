-- Stage 1: delivered orders with a delivery date, Jan 2017 to Aug 2018
SELECT COUNT(*) AS n
FROM ORDERS
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date <> ''
  AND order_purchase_timestamp >= '2017-01-01'
  AND order_purchase_timestamp < '2018-09-01';
-- Stage 2: days late (positive = late, negative = early)
SELECT order_id,
       order_estimated_delivery_date,
       order_delivered_customer_date,
       julianday(date(order_delivered_customer_date))
         - julianday(date(order_estimated_delivery_date)) AS days_late
FROM ORDERS
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date <> ''
LIMIT 10;
-- Stage 3: latest review per order (rule from note 4)
SELECT order_id, review_score
FROM (
  SELECT order_id, review_score,
         ROW_NUMBER() OVER (
           PARTITION BY order_id
           ORDER BY review_answer_timestamp DESC
         ) AS rn
  FROM REVIEWS
)
WHERE rn = 1;
-- Stage 4: revenue per order (aggregate first to avoid duplication)
SELECT order_id,
       SUM(price) AS item_revenue,
       SUM(freight_value) AS freight
FROM ORDERITEMS
GROUP BY order_id;
-- Stage 5: the order facts view
-- Stage 5: the order facts view
CREATE VIEW order_facts AS
WITH latest_review AS (
  SELECT order_id, review_score
  FROM (
    SELECT order_id, review_score,
           ROW_NUMBER() OVER (
             PARTITION BY order_id
             ORDER BY review_answer_timestamp DESC
           ) AS rn
    FROM REVIEWS
  )
  WHERE rn = 1
),
order_value AS (
  SELECT order_id,
         SUM(price) AS item_revenue,
         SUM(freight_value) AS freight
  FROM ORDERITEMS
  GROUP BY order_id
)
SELECT o.order_id,
       c.customer_unique_id,
       c.customer_state,
       SUBSTR(o.order_purchase_timestamp, 1, 7) AS purchase_month,
       date(o.order_estimated_delivery_date) AS estimated_date,
       date(o.order_delivered_customer_date) AS delivered_date,
       julianday(date(o.order_delivered_customer_date))
         - julianday(date(o.order_estimated_delivery_date)) AS days_late,
       CASE WHEN date(o.order_delivered_customer_date)
                 > date(o.order_estimated_delivery_date)
            THEN 1 ELSE 0 END AS is_late,
       r.review_score,
       v.item_revenue,
       v.freight
FROM ORDERS o
JOIN CUSTOMERS c ON c.customer_id = o.customer_id
LEFT JOIN latest_review r ON r.order_id = o.order_id
LEFT JOIN order_value v ON v.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_delivered_customer_date <> ''
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01';
-- Check: one row per order (these two numbers must be equal)
SELECT COUNT(*) AS rows_total,
       COUNT(DISTINCT order_id) AS distinct_orders
FROM order_facts;
-- Late vs on-time orders: average review score
SELECT is_late,
       COUNT(*) AS orders,
       ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_facts
GROUP BY is_late;