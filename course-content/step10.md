<p align="center">
    <img src="./../images/sql-masterclas-banner.png" alt="sql-masterclass-banner">
</p>

[![forthebadge](./../images/badges/version-1.0.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/powered-by-coffee.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/ctrl-c-ctrl-v.svg)]()

# Step 10 - The Bull Strategy

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step9.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step11.md)

![bull](assets/bull.jpeg)

Vikram is also similar to Leah but purchases Bitcoin frequently because he believes the price will go up in the future!

## Vikram's Transaction History

* Vikram also purchases 50 units of both ETH and BTC just like Leah on Jan 1st 2017
* He continues to purchase more throughout the entire 4 year period
* He does not sell any of his crypto - he's in it for the long run

## Vikram's Data

Because this is also a simplified version of our dataset - we will create another temp table called `vikram_bull_strategy` with our data for these questions.

```sql
CREATE TEMP TABLE vikram_bull_strategy AS
SELECT * FROM trading.transactions
WHERE member_id = '6512bd'
AND txn_type = 'BUY';
```

Again, we can inspect the data by running the following query after creating the temp table above:

```sql
SELECT * FROM vikram_bull_strategy LIMIT 10;
```

| txn_id | member_id | ticker |  txn_date  | txn_type |     quantity     | percentage_fee |          txn_time          |
| ------ | --------- | ------ | ---------- | -------- | ---------------- | -------------- | -------------------------- |
|     11 | 6512bd    | BTC    | 2017-01-01 | BUY      |               50 |           0.30 | 2017-01-01 00:00:00        |
|     25 | 6512bd    | ETH    | 2017-01-01 | BUY      |               50 |           0.30 | 2017-01-01 00:00:00        |
|     30 | 6512bd    | ETH    | 2017-01-01 | BUY      | 8.84298701787532 |           0.30 | 2017-01-01 06:22:20.202995 |
|     31 | 6512bd    | BTC    | 2017-01-01 | BUY      | 2.27106258645779 |           0.21 | 2017-01-01 06:40:48.691577 |
|     35 | 6512bd    | BTC    | 2017-01-01 | BUY      | 6.73841780964583 |           0.30 | 2017-01-01 11:00:14.002519 |
|     36 | 6512bd    | BTC    | 2017-01-01 | BUY      | 9.37875791241961 |           0.30 | 2017-01-01 12:03:33.017453 |
|     55 | 6512bd    | BTC    | 2017-01-02 | BUY      | 5.54383811940401 |           0.30 | 2017-01-02 11:12:42.895079 |
|     63 | 6512bd    | ETH    | 2017-01-02 | BUY      | 5.04372609654009 |           0.07 | 2017-01-02 20:48:13.480413 |
|     65 | 6512bd    | BTC    | 2017-01-02 | BUY      | 3.01276029896716 |           0.30 | 2017-01-02 21:00:49.341793 |
|     99 | 6512bd    | ETH    | 2017-01-04 | BUY      | 1.83100404691078 |           0.30 | 2017-01-04 22:04:12.689306 |
<br>

## Required Metrics

To assess Vikram's performance we also need to regularly match the prices for his trades throughout the 4 years and not just at the start of the entire dataset, like in the case of Leah's HODL strategy.

We will need to calculate the following metrics:

* Total investment amount in dollars for all of his purchases
* The dollar amount of fees paid
* The dollar cost average per unit of BTC and ETH purchased by Vikram
* The final investment value of his portfolio on August 29th 2021
* Profitability can be measured by final portfolio value divided by the investment amount
* Profitability split by BTC and ETH

## Solutions

### Question 1 & 2

> Calculate the total investment amount in dollars for all of Vikram's purchases and his dollar amount of fees paid

<details><summary>Click here to reveal the solution!</summary><br>

```sql
SELECT
  SUM(transactions.quantity * prices.price) AS initial_investment,
  SUM(transactions.quantity * prices.price * transactions.percentage_fee / 100) AS fees
FROM vikram_bull_strategy AS transactions
INNER JOIN trading.prices
  ON transactions.ticker = prices.ticker
  AND transactions.txn_date = prices.market_date;
```

</details><br>

|     initial_investment      |            fees             |
| --------------------------- | --------------------------- |
| 50730451.023400136384298882 | 128821.14163246531801672694 |
<br>

### Question 3

> What is the average cost per unit of BTC and ETH purchased by Vikram

<details><summary>Click here to reveal the solution!</summary><br>

```sql
WITH cte_portfolio AS (
  SELECT
    transactions.ticker,
    SUM(transactions.quantity) AS total_quantity,
    SUM(transactions.quantity * prices.price) AS initial_investment
  FROM vikram_bull_strategy AS transactions
  INNER JOIN trading.prices
    ON transactions.ticker = prices.ticker
    AND transactions.txn_date = prices.market_date
  GROUP BY transactions.ticker
)
SELECT
  ticker,
  initial_investment / total_quantity AS dollar_cost_average
FROM cte_portfolio;
```

</details><br>

| ticker |   dollar_cost_average   |
| ------ | ----------------------- |
| BTC    | 12190.13846337579877423 |
| ETH    |  538.402092304626902638 |
<br>

### Question 4

> Calculate profitability by using final portfolio value divided by the investment amount

<details><summary>Click here to reveal the solution!</summary><br>

```sql
WITH cte_portfolio_values AS (
  SELECT
    SUM(transactions.quantity * prices.price) AS initial_investment,
    SUM(transactions.quantity * final.price) AS final_value
  FROM vikram_bull_strategy AS transactions
  INNER JOIN trading.prices
    ON transactions.ticker = prices.ticker
    AND transactions.txn_date = prices.market_date
  INNER JOIN trading.prices AS final
    ON transactions.ticker = final.ticker
  WHERE final.market_date = '2021-08-29'
)
SELECT
  final_value / initial_investment AS profitability
FROM cte_portfolio_values;
```

</details><br>

|    profitability     |
| -------------------- |
| 4.019204544489789883 |

### Question 5

> Calculate Vikram's profitability split by BTC and ETH

<details><summary>Click here to reveal the solution!</summary><br>

```sql
WITH cte_ticker_portfolio_values AS (
  SELECT
    transactions.ticker,
    SUM(transactions.quantity * prices.price) AS initial_investment,
    SUM(transactions.quantity * final.price) AS final_value
  FROM vikram_bull_strategy AS transactions
  INNER JOIN trading.prices
    ON transactions.ticker = prices.ticker
    AND transactions.txn_date = prices.market_date
  INNER JOIN trading.prices AS final
    ON transactions.ticker = final.ticker
  WHERE final.market_date = '2021-08-29'
  GROUP BY transactions.ticker
)
SELECT
  ticker,
  final_value / initial_investment AS profitability
FROM cte_ticker_portfolio_values;
```

</details><br>

| ticker |    profitability     |
| ------ | -------------------- |
| BTC    |  3.95852763649714995 |
| ETH    | 5.902354477110731653 |
<br>

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step9.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step11.md)