# Olist Delivery Analysis: Are late deliveries hurting customer satisfaction?

An analysis of 96,203 delivered e-commerce orders from Brazil (Jan 2017 - Aug 2018), using SQL and Power BI.

## Business question
Are late deliveries hurting customer satisfaction, where is the problem concentrated, and what would fixing it be worth?

## Key findings
- **Late orders get much lower reviews.** 6.8% of delivered orders (6,531) arrived after the estimated date. They average a review score of 2.27, against 4.29 for on-time orders.
- **Place:** São Paulo (SP) and Rio de Janeiro (RJ) account for about half of all late orders (1,817 and 1,495). RJ also has a high late rate (12.1% vs 6.8% overall).
- **Time:** Three months (Nov 2017, Feb 2018, Mar 2018) have late rates of 12.4%, 14.1% and 19.0% and account for roughly half of all late orders.
- **Sellers:** Lateness is not driven by a few bad sellers. The 15 sellers with the worst late rates caused only about 4.5% of late orders.

## Dashboard
![Overview](dashboard/01_overview.png)
![States](dashboard/02_states.png)
![Sellers](dashboard/03_sellers.png)

## Recommendations
See [docs/recommendations_memo.md](docs/recommendations_memo.md) for the one-page memo to operations.

## Method
1. **Explored the data in SQL** (SQLite): checked order statuses, date ranges, missing values, duplicate reviews and customer IDs. Findings are in [docs/data_notes.md](docs/data_notes.md).
2. **Built a clean "order facts" view** applying these rules: delivered orders only, Jan 2017 - Aug 2018, one review per order (the latest), items aggregated before joining, and lateness measured against the estimated delivery date.
3. **Validated it:** 96,203 rows and 96,203 distinct orders, so joins created no duplicates.
4. **Analyzed** late rates by state, month and seller using SQL (see `sql/`).
5. **Built a 3-page Power BI dashboard** with DAX measures (Late %, On-Time %, Avg Review Score, Share of Late Orders), checked against the SQL results.

## Repository structure
- `sql/` : exploration and analysis queries
- `docs/` : project brief, data notes, recommendations memo
- `dashboard/` : dashboard screenshots

## Limitations
- The data shows association, not proof of cause.
- Lateness is measured against the estimated delivery date.
- Orders with several sellers are counted for each seller.
- Distance, carriers and the cause of the Feb-Mar 2018 spike are not in the data.
- 768 orders (~0.8%) have no review and are left out of score averages.
- States with fewer than 500 orders and sellers with fewer than 50 orders are excluded from rate rankings because their rates are unstable.

## Data source
Brazilian E-Commerce Public Dataset by Olist, via Kaggle: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
License: (copy the license name from the Kaggle page)
The raw data files are not included in this repository.

## Tools
SQLite (DB Browser for SQLite), SQL, Power BI, DAX
