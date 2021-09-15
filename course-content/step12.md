<p align="center">
    <img src="./../images/sql-masterclas-banner.png" alt="sql-masterclass-banner">
</p>

[![forthebadge](./../images/badges/version-1.0.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/powered-by-coffee.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/ctrl-c-ctrl-v.svg)]()

# Step 12 - Final Case Study Questions

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step11.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step13.md)

To finish up our entire cryptocurrency case study - let's now calculate exactly the same query that we just created for Nandita's data with our entire dataset with all mentors included!

## Create The Base Table

> Create a summary table `mentor_performance` which includes the following metrics for each member and ticker:

* Count of purchase transactions
* Initial investment
* Purchase fees
* Dollar cost average of purchases
* Count of sales transactions
* Gross revenue amount
* Sales fees
* Average selling price
* Actual Profitability (final portfolio value + gross sales revenue - purchase fees - sales fees) / initial investment amount
* Theoretical Profitability (final portfolio value with no sales - purchase fees) / initial investment amount

<details><summary>Click here to reveal the solution!</summary><br>

```sql
CREATE TEMP TABLE mentor_performance AS
WITH cte_portfolio AS (
  SELECT
    members.first_name,
    members.region,
    transactions.ticker,
    transactions.txn_type,
    COUNT(*) AS transaction_count,
    SUM(transactions.quantity) AS total_quantity,
    SUM(transactions.quantity * prices.price) AS gross_values,
    SUM(transactions.quantity * prices.price * transactions.percentage_fee / 100) AS fees 
  FROM trading.transactions
  INNER JOIN trading.members
    ON transactions.member_id = members.member_id
  INNER JOIN trading.prices
    ON transactions.ticker = prices.ticker
    AND transactions.txn_date = prices.market_date
  GROUP BY
    members.first_name,
    members.region,
    transactions.ticker,
    transactions.txn_type
),
cte_summary AS (
  SELECT
    first_name,
    region,
    ticker,
    SUM(
      CASE
        WHEN txn_type = 'BUY' THEN total_quantity
        WHEN txn_type = 'SELL' THEN -total_quantity
      END
    ) AS final_quantity,
    SUM(CASE WHEN txn_type = 'BUY' THEN gross_values ELSE 0 END) AS initial_investment,
    SUM(CASE WHEN txn_type = 'SELL' THEN gross_values ELSE 0 END) AS sales_revenue,
    SUM(CASE WHEN txn_type = 'BUY' THEN fees ELSE 0 END) AS purchase_fees,
    SUM(CASE WHEN txn_type = 'SELL' THEN fees ELSE 0 END) AS sales_fees,
    SUM(CASE WHEN txn_type = 'BUY' THEN total_quantity ELSE 0 END) AS purchase_quantity,
    SUM(CASE WHEN txn_type = 'SELL' THEN total_quantity ELSE 0 END) AS sales_quantity,
    SUM(CASE WHEN txn_type = 'BUY' THEN transaction_count ELSE 0 END) AS purchase_transactions,
    SUM(CASE WHEN txn_type = 'SELL' THEN transaction_count ELSE 0 END) AS sales_transactions
  FROM cte_portfolio
  GROUP BY
    first_name,
    region,
    ticker
),
cte_metrics AS (
  SELECT
    summary.first_name,
    summary.region,
    summary.ticker,
    summary.final_quantity * final.price AS actual_final_value,
    summary.purchase_quantity * final.price AS theoretical_final_value,
    summary.sales_revenue,
    summary.purchase_fees,
    summary.sales_fees,
    summary.initial_investment,
    summary.purchase_quantity,
    summary.sales_quantity,
    summary.purchase_transactions,
    summary.sales_transactions,
    summary.initial_investment / purchase_quantity AS dollar_cost_average,
    summary.sales_revenue / sales_quantity AS average_selling_price
  FROM cte_summary AS summary
  INNER JOIN trading.prices AS final
    ON summary.ticker = final.ticker
  WHERE final.market_date = '2021-08-29'
)
SELECT
  first_name,
  region,
  ticker,
  actual_final_value AS final_portfolio_value,
  ( actual_final_value + sales_revenue - purchase_fees - sales_fees ) / initial_investment AS actual_profitability,
  ( theoretical_final_value - purchase_fees ) / initial_investment AS theoretical_profitability,
  dollar_cost_average,
  average_selling_price,
  sales_revenue,
  purchase_fees,
  sales_fees,
  initial_investment,
  purchase_quantity,
  sales_quantity,
  purchase_transactions,
  sales_transactions
FROM cte_metrics;
```

</details><br>

Make sure to checkout the results from the temp table by running a `SELECT` query before tackling the following questions!

```sql
SELECT * FROM mentor_performance;
```

## Question 1

> Which mentors have the greatest actual profitability for each ticker?

<details><summary>Click here to reveal the solution!</summary><br>

```sql
WITH cte_ranks AS (
SELECT
  first_name,
  ticker,
  actual_profitability,
  RANK() OVER (PARTITION BY ticker ORDER BY actual_profitability DESC) AS profitability_rank
FROM mentor_performance
)
SELECT * FROM cte_ranks
WHERE profitability_rank = 1;
```

</details><br>

## Question 2

> Which mentors have the greatest difference in actual vs theoretical profitability for each ticker?

<details><summary>Click here to reveal the solution!</summary><br>

```sql
WITH cte_ranks AS (
SELECT
  first_name,
  ticker,
  ABS(actual_profitability - theoretical_profitability) AS difference,
  RANK() OVER (
    PARTITION BY ticker
    ORDER BY ABS(actual_profitability - theoretical_profitability) DESC
  ) AS difference_rank
FROM mentor_performance
)
SELECT * FROM cte_ranks
WHERE difference_rank = 1;
```

</details><br>

## Question 3

> What is the total amount of sales revenue made by all mentors for each region? (combined BTC and ETH)

<details><summary>Click here to reveal the solution!</summary><br>

```sql
SELECT
  region,
  SUM(sales_revenue) AS total_sales
FROM mentor_performance
GROUP BY region
ORDER BY total_sales DESC;
```

</details><br>

## Question 4

> What is the average actual profitability for each region for each ticker?

<details><summary>Click here to reveal the solution!</summary><br>

```sql
SELECT
  region,
  ticker,
  AVG(actual_profitability) AS avg_profitability
FROM mentor_performance
GROUP BY region, ticker
ORDER BY ticker, avg_profitability DESC;
```

</details><br>

## Question 5

> Which mentors have the largest initial investment in each ticker?

<details><summary>Click here to reveal the solution!</summary><br>

```sql
WITH cte_rank AS (
SELECT
  first_name,
  ticker,
  initial_investment,
  RANK() OVER (PARTITION BY ticker ORDER BY initial_investment DESC) AS investment_rank
FROM mentor_performance
)
SELECT * FROM cte_rank
WHERE investment_rank = 1;
```

</details><br>

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step11.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step13.md)