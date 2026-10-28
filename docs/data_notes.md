# Data notes

Findings from exploring the Olist database (see sql/01_data_exploration.sql).

1. **Order statuses:** 96,478 of 99,441 orders (~97%) are delivered. For the delivery analysis I will only use delivered orders, since almost all of the others have no delivery date (see note 3).

2. **Date range:** 2016-09-04 to 2018-10-17. Sept-Dec 2016 has very few orders (none in Nov 2016), and Sept-Oct 2018 is cut off (16 and 4 orders). I will restrict the analysis to Jan 2017 - Aug 2018 (20 full months). Volume grows fast during 2017, so early-2017 rates may be noisy.

3. **Missing delivery dates:** 2,965 orders (~3%), nearly all with non-delivered statuses. 8 orders are marked "delivered" but have no delivery date, so they will be excluded. Filter rule: order_status = 'delivered' AND delivery date is not null/empty.

4. **Reviews:**
   - 547 orders have more than one review. Scores sometimes differ (e.g. 3 then 1), and some pairs share the same creation date. Rule: keep one review per order, the one with the latest review_answer_timestamp.
   - 768 orders (~0.8%) have no review. Use a LEFT JOIN so they are not silently dropped from order counts.

5. **Customer IDs:** customer_id is created per order (99,441 values), while customer_unique_id identifies the actual person (96,096 customers). Use customer_unique_id only when counting people.
