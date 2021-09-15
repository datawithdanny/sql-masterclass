<p align="center">
    <img src="./../images/sql-masterclas-banner.png" alt="sql-masterclass-banner">
</p>

[![forthebadge](./../images/badges/version-1.0.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/powered-by-coffee.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/ctrl-c-ctrl-v.svg)]()

# Step 5 - Let the Data Analysis Begin!

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step4.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step6.md)

Now that we've explored all 3 of our tables - let's try to first visualize how each of the tables are joined onto eachother using an Entity Relationship Diagram or ERD for short!

## What is an ERD?

ERDs are very useful to visualize the relationships between columns in tables - especially when it comes to combining them together using tables joins (something we'll cover in this current tutorial)

Below you will see the ERD for our current case study - the most important thing is to notice how all of the columns relate to one another.

![Crypto Case Study ERD](assets/crypto-erd.png)

# Realistic Analytics

Even though we have been exploring our datasets and exploring a few of the basic SQL concepts required for data analysis - we have yet to combine our SQL queries into a single focused analytical process to solve a larger problem. This is our opportunity to try this now!

Let's say that we wish to analyse our overall portfolio performance and also each member's performance based off all the data we have in our 3 tables.

## Analyse the Ranges

Firstly - let's see what is the range of data we have to play with!

### Question 1

> What is the earliest and latest date of transactions for all members?

<details><summary>Click here to reveal the solution!</summary><br>

```sql
SELECT
  MIN(txn_date) AS earliest_date,
  MAX(txn_date) AS latest_date
FROM trading.transactions;
```

</details><br>

### Question 2

> What is the range of `market_date` values available in the prices data? 

<details><summary>Click here to reveal the solution!</summary><br>

```sql
SELECT
  MIN(market_date) AS earliest_date,
  MAX(market_date) AS latest_date
FROM trading.prices;
```

</details><br>

## Joining our Datasets

Now that we now our date ranges are from January 2017 through to almost the end of August 2021 for both our prices and transactions datasets - we can now get started on joining these two tables together!

Let's make use of our ERD shown above to combine the `trading.transactions` table and the `trading.members` table to answer a few simple questions about our mentors!

### Question 3

> Which top 3 mentors have the most Bitcoin quantity as of the 29th of August? 

<details><summary>Click here to reveal the solution!</summary><br>

```sql
SELECT
  members.first_name,
  SUM(
    CASE
      WHEN transactions.txn_type = 'BUY'  THEN transactions.quantity
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
    END
  ) AS total_quantity
FROM trading.transactions
INNER JOIN trading.members
  ON transactions.member_id = members.member_id
WHERE ticker = 'BTC'
GROUP BY members.first_name
ORDER BY total_quantity DESC
LIMIT 3;
```

</details><br>

## Calculating Portfolio Value

Now let's combine all 3 tables together using only strictly `INNER JOIN` so we can utilise all of our datasets together.

### Question 4

> What is total value of all Ethereum portfolios for each region at the end date of our analysis? Order the output by descending portfolio value 

<details><summary>Click here to reveal the solution!</summary><br>

```sql
WITH cte_latest_price AS (
  SELECT
    ticker,
    price
  FROM trading.prices
  WHERE ticker = 'ETH'
  AND market_date = '2021-08-29'
)
SELECT
  members.region,
  SUM(
    CASE
      WHEN transactions.txn_type = 'BUY'  THEN transactions.quantity
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
    END
  ) * cte_latest_price.price AS ethereum_value,
  AVG(
    CASE
      WHEN transactions.txn_type = 'BUY'  THEN transactions.quantity
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
    END
  ) * cte_latest_price.price AS avg_ethereum_value
FROM trading.transactions
INNER JOIN cte_latest_price
  ON transactions.ticker = cte_latest_price.ticker
INNER JOIN trading.members
  ON transactions.member_id = members.member_id
WHERE transactions.ticker = 'ETH'
GROUP BY members.region, cte_latest_price.price
ORDER BY avg_ethereum_value DESC;
```

</details><br>

### Question 5

> What is the average value of each Ethereum portfolio in each region? Sort this output in descending order

<details><summary>Click here to reveal the solution!</summary><br>

```sql
WITH cte_latest_price AS (
  SELECT
    ticker,
    price
  FROM trading.prices
  WHERE ticker = 'ETH'
  AND market_date = '2021-08-29'
)
SELECT
  members.region,
  AVG(
    CASE
      WHEN transactions.txn_type = 'BUY'  THEN transactions.quantity
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
    END
  ) * cte_latest_price.price AS avg_ethereum_value
FROM trading.transactions
INNER JOIN cte_latest_price
  ON transactions.ticker = cte_latest_price.ticker
INNER JOIN trading.members
  ON transactions.member_id = members.member_id
WHERE transactions.ticker = 'ETH'
GROUP BY members.region, cte_latest_price.price
ORDER BY avg_ethereum_value DESC;
```

</details><br>

Mmm hang on a second...does the output for the above query look correct to you?

Let's try again - this time we will calculate the total sum of portfolio value and then manually divide it by the total number of mentors in each region! 

<details><summary>Click here to reveal the solution!</summary><br>

```sql
WITH cte_latest_price AS (
  SELECT
    ticker,
    price
  FROM trading.prices
  WHERE ticker = 'ETH'
  AND market_date = '2021-08-29'
),
cte_calculations AS (
SELECT
  members.region,
  SUM(
    CASE
      WHEN transactions.txn_type = 'BUY'  THEN transactions.quantity
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
    END
  ) * cte_latest_price.price AS ethereum_value,
  COUNT(DISTINCT members.member_id) AS mentor_count
FROM trading.transactions
INNER JOIN cte_latest_price
  ON transactions.ticker = cte_latest_price.ticker
INNER JOIN trading.members
  ON transactions.member_id = members.member_id
WHERE transactions.ticker = 'ETH'
GROUP BY members.region, cte_latest_price.price
)
-- final output
SELECT
  *,
  ethereum_value / mentor_count AS avg_ethereum_value
FROM cte_calculations
ORDER BY avg_ethereum_value DESC;
```

</details><br>

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step4.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step6.md)