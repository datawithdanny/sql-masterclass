<p align="center">
    <img src="./../images/sql-masterclas-banner.png" alt="sql-masterclass-banner">
</p>

[![forthebadge](./../images/badges/version-1.0.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/powered-by-coffee.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/ctrl-c-ctrl-v.svg)]()

# Step 4 - Transactions Table

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step3.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step5.md)

In our third `trading.transactions` database table we have each `BUY` or `SELL` transaction for a specific `ticker` performed by each `member`

## View The Data

You can inspect the most recent 10 transactions by `member_id = 'c4ca42'` (do you remember who that is?)

```sql
SELECT * FROM trading.transactions
WHERE member_id = 'c4ca42'
ORDER BY txn_time DESC
LIMIT 10;
```

## Data Dictionary

| Column Name    | Description                       |
| -------------- | --------------------------------- |
| txn_id         | unique ID for each transaction    |
| member_id      | member identifier for each trade  |
| ticker         | the ticker for each trade         |
| txn_date       | the date for each transaction     |
| txn_type       | either BUY or SELL                |
| quantity       | the total quantity for each trade |
| percentage_fee | % of total amount charged as fees |
| txn_time       | the timestamp for each trade      |
<br>

## Transactions Questions

Let's finish our initial data exploration with a few more questions for the `trading.transactions` table!

### Question 1

> How many records are there in the `trading.transactions` table?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT COUNT(*) FROM trading.transactions;
```

</details>
<br>

### Question 2

> How many unique transactions are there?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT COUNT(DISTINCT txn_id) FROM trading.transactions;
```

</details>
<br>

### Question 3

> How many buy and sell transactions are there for Bitcoin?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  txn_type,
  COUNT(*) AS transaction_count
FROM trading.transactions
WHERE ticker = 'BTC'
GROUP BY txn_type;
```

</details>
<br>

### Question 3

> For each year, calculate the following buy and sell metrics for Bitcoin:

* total transaction count
* total quantity
* average quantity per transaction

Also round the quantity columns to 2 decimal places.

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  EXTRACT(YEAR FROM txn_date) AS txn_year,
  txn_type,
  COUNT(*) AS transaction_count,
  ROUND(SUM(quantity)::NUMERIC, 2) AS total_quantity,
  ROUND(AVG(quantity)::NUMERIC, 2) AS average_quantity
FROM trading.transactions
GROUP BY txn_year, txn_type
ORDER BY txn_year, txn_type;
```

</details>
<br>

### Question 4

> What was the monthly total quantity purchased and sold for Ethereum in 2020?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  DATE_TRUNC('MON', txn_date)::DATE AS calendar_month,
  SUM(CASE WHEN txn_type = 'BUY' THEN quantity ELSE 0 END) AS buy_quantity,
  SUM(CASE WHEN txn_type = 'SELL' THEN quantity ELSE 0 END) AS sell_quantity
FROM trading.transactions
WHERE txn_date BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY calendar_month
ORDER BY calendar_month;
```

</details>
<br>

### Question 5

> Summarise all buy and sell transactions for each `member_id` by generating 1 row for each member with the following additional columns:

* Bitcoin buy quantity
* Bitcoin sell quantity
* Ethereum buy quantity
* Ethereum sell quantity

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  member_id,
  SUM(
    CASE
      WHEN ticker = 'BTC' AND txn_type = 'BUY' THEN quantity
      ELSE 0
    END
  ) AS btc_buy_qty,
  SUM(
    CASE
      WHEN ticker = 'BTC' AND txn_type = 'SELL' THEN quantity
      ELSE 0
    END
  ) AS btc_sell_qty,
  SUM(
    CASE
      WHEN ticker = 'ETH' AND txn_type = 'BUY' THEN quantity
      ELSE 0
    END
  ) AS eth_buy_qty,
  SUM(
    CASE
      WHEN ticker = 'BTC' AND txn_type = 'SELL' THEN quantity
      ELSE 0
    END
  ) AS eth_sell_qty
FROM trading.transactions
GROUP BY member_id
```

</details>
<br>

### Question 6

> What was the final quantity holding of Bitcoin for each member? Sort the output from the highest BTC holding to lowest

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  member_id,
  SUM(
    CASE
      WHEN txn_type = 'BUY' quantity
      WHEN txn_type = 'SELL' THEN -quantity
      ELSE 0
    END
  ) AS final_btc_holding
FROM trading.transactions
WHERE ticker = 'BTC'
GROUP BY member_id
ORDER BY final_btc_holding DESC;
```

</details>
<br>

### Question 7

> Which members have sold less than 500 Bitcoin? Sort the output from the most BTC sold to least 

We can actually do this in 3 different ways!

<details>
  <summary>Click here to reveal the `HAVING` solution!</summary>
<br>

```sql
SELECT
  member_id,
  SUM(quantity) AS btc_sold_quantity
FROM trading.transactions
WHERE ticker = 'BTC'
  AND txn_type = 'SELL'
GROUP BY member_id
HAVING SUM(quantity) < 500
ORDER BY btc_sold_quantity DESC;
```

</details>
<br>

<details>
  <summary>Click here to reveal the `CTE` solution!</summary>
<br>

```sql
WITH cte AS (
SELECT
  member_id,
  SUM(quantity) AS btc_sold_quantity
FROM trading.transactions
WHERE ticker = 'BTC'
  AND txn_type = 'SELL'
GROUP BY member_id
)
SELECT * FROM cte
WHERE btc_sold_quantity < 500
ORDER BY btc_sold_quantity DESC;
```

</details>
<br>

<details>
  <summary>Click here to reveal the `subquery` solution!</summary>
<br>

```sql
SELECT * FROM (
  SELECT
    member_id,
    SUM(quantity) AS btc_sold_quantity
  FROM trading.transactions
  WHERE ticker = 'BTC'
    AND txn_type = 'SELL'
  GROUP BY member_id
) AS subquery
WHERE btc_sold_quantity < 500
ORDER BY btc_sold_quantity DESC;
```

</details>
<br>

### Question 8

 > What is the total Bitcoin quantity for each `member_id` owns after adding all of the BUY and SELL transactions from the `transactions` table? Sort the output by descending total quantity

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  member_id,
  SUM(
    CASE
      WHEN txn_type = 'BUY'  THEN quantity
      WHEN txn_type = 'SELL' THEN -quantity
    END
  ) AS total_quantity
FROM trading.transactions
WHERE ticker = 'BTC'
GROUP BY member_id
ORDER BY total_quantity DESC;
```

</details>
<br>

### Question 9

> Which `member_id` has the highest buy to sell ratio by quantity?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  member_id,
  SUM(CASE WHEN txn_type = 'BUY' THEN quantity ELSE 0 END) /
    SUM(CASE WHEN txn_type = 'SELL' THEN quantity ELSE 0 END) AS buy_to_sell_ratio
FROM trading.transactions
GROUP BY member_id
ORDER BY buy_to_sell_ratio DESC;
```

</details>
<br>

### Question 10

> For each `member_id` - which month had the highest total Ethereum quantity sold`?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
WITH cte_ranked AS (
SELECT
  member_id,
  DATE_TRUNC('MON', txn_date)::DATE AS calendar_month,
  SUM(quantity) AS sold_eth_quantity,
  RANK() OVER (PARTITION BY member_id ORDER BY SUM(quantity) DESC) AS month_rank
FROM trading.transactions
WHERE ticker = 'ETH' AND txn_type = 'SELL'
GROUP BY member_id, calendar_month
)
SELECT
  member_id,
  calendar_month,
  sold_eth_quantity
FROM cte_ranked
WHERE month_rank = 1
ORDER BY sold_eth_quantity DESC;
```

</details>
<br>

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step3.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step5.md)