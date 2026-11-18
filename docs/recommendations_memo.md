# Memo: Reducing late deliveries

**To:** Operations Manager
**From:** Kajal Khanal
**Data:** 96,203 delivered orders, Jan 2017 - Aug 2018 (Olist, via Kaggle)

## Summary
6.8% of delivered orders (6,531) arrived after the estimated delivery date. Late orders average a review score of 2.27, against 4.29 for on-time orders. Late deliveries are concentrated in specific places and months, not in a few bad sellers.

## What the data shows
1. **Place:** SP and RJ account for about half of all late orders (1,817 and 1,495). RJ is the main problem area, with a 12.1% late rate against 6.8% overall.
2. **Time:** Three months (Nov 2017, Feb 2018 and Mar 2018, with late rates of 12.4%, 14.1% and 19.0%) account for roughly half of all late orders. The other 17 months average about 4.5%.
3. **Sellers:** The 15 sellers with the worst late rates caused only about 4.5% of late orders. The 15 sellers with the most late orders are the biggest ones, with a late rate of about 8%.

## Recommendations
1. **Investigate delivery in Rio de Janeiro first.** If RJ matched the national late rate, there would have been about 660 fewer late orders over the 20 months (illustrative estimate). Review the carriers and routes serving RJ.
2. **Plan for peak periods.** Nov 2017 followed a ~63% jump in order volume, so add delivery capacity before peaks like Black Friday. The Feb-Mar 2018 spike had no volume surge, so find its cause before planning around it. If those three months had matched the other months' average, there would have been about 2,200 fewer late orders (illustrative).
3. **Do not focus on seller penalties yet.** Seller lateness is spread thin. Watch the two sellers that appear in both lists (06a2c3af... and 7d13fca1...), but expect little impact from seller-level actions.

## Limits
- The data shows association, not proof of cause. Late orders may also have other problems (wrong or damaged items, long distances).
- Lateness is measured against the estimated delivery date, not an absolute time.
- Orders with several sellers are counted for each seller.
- Distance, carriers and the reason for the Feb-Mar 2018 spike are not in this data.
- 768 orders (~0.8%) have no review and are excluded from score averages.
