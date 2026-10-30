-- Late rate by seller (sellers with 50+ orders)
WITH order_seller AS (
  SELECT DISTINCT order_id, seller_id
  FROM ORDERITEMS
)
SELECT s.seller_id,
       COUNT(*) AS orders,
       SUM(f.is_late) AS late_orders,
       ROUND(100.0 * SUM(f.is_late) / COUNT(*), 1) AS late_pct,
       ROUND(AVG(f.review_score), 2) AS avg_review_score
FROM order_facts f
JOIN order_seller s ON s.order_id = f.order_id
GROUP BY s.seller_id
HAVING COUNT(*) >= 50
ORDER BY late_pct DESC
LIMIT 15;
-- Sellers with the most late orders
WITH order_seller AS (
  SELECT DISTINCT order_id, seller_id
  FROM ORDERITEMS
)
SELECT s.seller_id,
       COUNT(*) AS orders,
       SUM(f.is_late) AS late_orders,
       ROUND(100.0 * SUM(f.is_late) / COUNT(*), 1) AS late_pct,
       ROUND(AVG(f.review_score), 2) AS avg_review_score
FROM order_facts f
JOIN order_seller s ON s.order_id = f.order_id
GROUP BY s.seller_id
ORDER BY late_orders DESC
LIMIT 15;