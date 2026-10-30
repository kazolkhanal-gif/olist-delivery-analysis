-- Late rate and avg score by state
SELECT customer_state,
       COUNT(*) AS orders,
       SUM(is_late) AS late_orders,
       ROUND(100.0 * SUM(is_late) / COUNT(*), 1) AS late_pct,
       ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_facts
GROUP BY customer_state
HAVING COUNT(*) >= 500
ORDER BY late_pct DESC;
-- Share of all late orders by state
SELECT customer_state,
       SUM(is_late) AS late_orders,
       ROUND(100.0 * SUM(is_late) / (SELECT SUM(is_late) FROM order_facts), 1) AS share_of_late_pct
FROM order_facts
GROUP BY customer_state
ORDER BY late_orders DESC
LIMIT 10;
-- Late rate by month
SELECT purchase_month,
       COUNT(*) AS orders,
       ROUND(100.0 * SUM(is_late) / COUNT(*), 1) AS late_pct
FROM order_facts
GROUP BY purchase_month
ORDER BY purchase_month;