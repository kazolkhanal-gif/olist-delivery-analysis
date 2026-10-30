# Data notes

Findings from exploring the Olist database (see sql/01_data_exploration.sql).

1. **Order statuses:** 96,478 of 99,441 orders (~97%) are delivered. For the delivery analysis I will only use delivered orders, since almost all of the others have no delivery date.

2. **Date range:** 2016-09-04 to 2018-10-17. Sept-Dec 2016 has very few orders (none in Nov 2016), and Sept-Oct 2018 is cut off (16 and 4 orders). I will restrict the analysis to Jan 2017 - Aug 2018 (20 full months). Volume grows fast during 2017, so early-2017 rates may be noisy.

3. **Missing delivery dates:** 2,965 orders (~3%), nearly all with non-delivered statuses. 8 orders are marked "delivered" but have no delivery date, so they will be excluded. Filter rule: order_status = 'delivered' AND delivery date is not null/empty.

4. **Reviews:**
   - 547 orders have more than one review. Scores sometimes differ (e.g. 3 then 1), and some pairs share the same creation date. Rule: keep one review per order, the one with the latest review_answer_timestamp.
   - 768 orders (~0.8%) have no review. Use a LEFT JOIN so they are not silently dropped from order counts.

5. **Customer IDs:** customer_id is created per order (99,441 values), while customer_unique_id identifies the actual person (96,096 customers). Use customer_unique_id only when counting people.
 
6. **Late vs on-time (order_facts view, delivered orders, Jan 2017 - Aug 2018):** 96,203 orders, of which 6,531 (6.8%) arrived after the estimated delivery date. Late orders average a review score of 2.27 vs 4.29 for on-time orders, a gap of about 2 points. This is an association, not proof of causation. Scores exclude orders with no review.
Validation: the order_facts view has 96,203 rows and 96,203 distinct order_ids, so joins did not create duplicates (one review per order, items aggregated before joining).

7. **Late rate by customer state (states with 500+ orders):** highest are MA (17.5%), CE (13.8%), BA (12.2%), RJ (12.1%) and PA (11.3%), against a national rate of 6.8%. RJ has by far the most late orders (1,495, about 23% of all late orders) because of its volume. States with a high late rate also tend to have lower average review scores (3.8-4.0 vs about 4.2 for lower-late states). States with fewer than 500 orders were excluded because their rates are unstable. Note: state is the customer's (destination) state; distance from sellers is a possible but untested explanation.

8. **Where late orders are concentrated:** SP (1,817, 27.8%) and RJ (1,495, 22.9%) account for about half of all 6,531 late orders; the top 10 states cover about 85%. SP's share reflects its volume; RJ combines high volume with a high late rate (12.1% vs 6.8% nationally). If RJ matched the national late rate, it would have roughly 660 fewer late orders over the 20 months (illustrative estimate). Small states with very high rates (e.g. MA, 17.5%) contribute little to the total.

9. **Late rate by purchase month (Jan 2017 - Aug 2018):** no steady trend; the rate is about 3-4% in most months with three spikes: Nov 2017 (12.4%, coinciding with a ~63% jump in order volume around Black Friday), Feb 2018 (14.1%) and Mar 2018 (19.0%, with no volume surge). These three months account for roughly half of all late orders. The other 17 months average about 4.5%; if the three spike months had matched that, there would have been roughly 2,200 fewer late orders (illustrative estimate from rounded rates). The cause of the Feb-Mar 2018 spike is not identifiable from this data; possible follow-up is to check whether it concentrates in particular states or sellers.

10. **Sellers with the highest late rate:** I looked at sellers with at least 50 orders. The worst 15 are late 16% to 30% of the time, while the overall average is 6.8%. But these sellers have few orders, so together they cause only about 4.5% of all late orders. Fixing them would help only a little (about 190 fewer late orders). Limits: an order with more than one seller is counted for each seller, and sellers with fewer than 50 orders are left out.

11. **Sellers with the most late orders:** the 15 biggest sources of late orders are big sellers. Together they have about 1,360 late orders (about 21% of all late orders), but their late rate is only about 8%, close to the 6.8% average. They have many late orders mostly because they have many orders. Two sellers appear in both lists, so they are worth a closer look: 06a2c3af... (74 late orders, 19% late) and 7d13fca1... (64 late orders, 11.5% late). Limits: we cannot tell if lateness is the seller's fault or caused by distance or the delivery company.
