<p align="center">
    <img src="./../images/sql-masterclas-banner.png" alt="sql-masterclass-banner">
</p>

[![forthebadge](./../images/badges/version-1.0.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/powered-by-coffee.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/ctrl-c-ctrl-v.svg)]()

# Step 3 - Daily Prices

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step2.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step4.md)

Our next dataset to explore will be the `trading.prices` table which contains the daily price and volume data for the 2 cryptocurrency tickers: `ETH` and `BTC` (Ethereum and Bitcoin!)

## View The Data

Before we try to solve our next set of questions below - you can try viewing a few rows from the `trading.prices` dataset:

Example Bitcoin price data:

```sql
SELECT * FROM trading.prices WHERE ticker = 'BTC' LIMIT 5;
```

| ticker | market_date |  price  |  open   |  high   |   low   | volume | change |
| ------ | ----------- | ------- | ------- | ------- | ------- | ------ | ------ |
| BTC    | 2021-08-29  | 48255.0 | 48899.7 | 49621.7 | 48101.9 | 40.96K | -1.31% |
| BTC    | 2021-08-28  | 48897.1 | 49062.8 | 49289.4 | 48428.5 | 36.73K | -0.34% |
| BTC    | 2021-08-27  | 49064.3 | 46830.2 | 49142.0 | 46371.5 | 62.47K | 4.77%  |
| BTC    | 2021-08-26  | 46831.6 | 48994.4 | 49347.8 | 46360.4 | 73.79K | -4.41% |
| BTC    | 2021-08-25  | 48994.5 | 47707.4 | 49230.2 | 47163.3 | 63.54K | 2.68%  |
<br>

Example Ethereum price data:

```sql
SELECT * FROM trading.prices WHERE ticker = 'ETH' LIMIT 5;
```

| ticker | market_date |  price  |  open   |  high   |   low   | volume  | change |
| ------ | ----------- | ------- | ------- | ------- | ------- | ------- | ------ |
| ETH    | 2021-08-29  | 3177.84 | 3243.96 | 3282.21 | 3162.79 | 582.04K | -2.04% |
| ETH    | 2021-08-28  | 3243.90 | 3273.78 | 3284.58 | 3212.24 | 466.21K | -0.91% |
| ETH    | 2021-08-27  | 3273.58 | 3093.78 | 3279.93 | 3063.37 | 839.54K | 5.82%  |
| ETH    | 2021-08-26  | 3093.54 | 3228.03 | 3249.62 | 3057.48 | 118.44K | -4.17% |
| ETH    | 2021-08-25  | 3228.15 | 3172.12 | 3247.43 | 3080.70 | 923.13K | 1.73%  |
<br>

## Data Dictionary

| Column Name | Description                     |
| ----------- | ------------------------------- |
| ticker      | one of either BTC or ETH        |
| market_date | the date for each record        |
| price       | closing price at end of day     |
| open        | the opening price               |
| high        | the highest price for that day  |
| low         | the lowest price for that day   |
| volume      | the total volume traded         |
| change      | % change price in price         |
<br>
 
## Data Exploration Questions

Let's answer a few simple questions to help us better understand the `trading.prices` table.

> Remember to clear all previous SQL queries from SQLPad before running each new SQL query!

### Question 1

> How many total records do we have in the `trading.prices` table?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  COUNT(*) AS total_records
FROM trading.prices;
```

</details>
<br>

| total_records |
| ------------- |
|          3404 |
<br>

### Question 2

> How many records are there per `ticker` value?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  ticker,
  COUNT(*) AS record_count
FROM trading.prices
GROUP BY ticker;
```

</details>
<br>

| ticker | record_count |
| ------ | ------------ |
| BTC    |         1702 |
| ETH    |         1702 |
<br>

### Question 3

> What is the minimum and maximum `market_date` values?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  MIN(market_date) AS min_date,
  MAX(market_date) AS max_date
FROM trading.prices;
```

</details>
<br>

|  min_date  |  max_date  |
| ---------- | ---------- |
| 2017-01-01 | 2021-08-29 |
<br>

### Question 4

> Are there differences in the minimum and maximum `market_date` values for each ticker?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  ticker,
  MIN(market_date) AS min_date,
  MAX(market_date) AS max_date
FROM trading.prices
GROUP BY ticker;
```

</details>
<br>

| ticker |  min_date  |  max_date  |
| ------ | ---------- | ---------- |
| BTC    | 2017-01-01 | 2021-08-29 |
| ETH    | 2017-01-01 | 2021-08-29 |
<br>

### Question 5

> What is the average of the `price` column for Bitcoin records during the year 2020?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  AVG(price)
FROM trading.prices
WHERE ticker = 'BTC'
  AND market_date BETWEEN '2020-01-01' AND '2020-12-31';
```

</details>
<br>

|        avg         |
| ------------------ |
| 11111.631147540984 |
<br>

### Question 6

> What is the monthly average of the `price` column for Ethereum in 2020? Sort the output in chronological order and also round the average price value to 2 decimal places

<details><summary>Click here to reveal the solution!</summary><br>

```sql
SELECT
  DATE_TRUNC('MON', market_date) AS month_start,
  -- need to cast approx. floats to exact numeric types for round!
  ROUND(AVG(price)::NUMERIC, 2) AS average_eth_price
FROM trading.prices
WHERE EXTRACT(YEAR FROM market_date) = 2020
  AND ticker = 'ETH'
GROUP BY month_start
ORDER BY month_start;
```

</details>
<br>

|      month_start       | average_eth_price |
| ---------------------- | ----------------- |
| 2020-01-01 00:00:00+00 |	156.65           |
| 2020-02-01 00:00:00+00 |	238.76           |
| 2020-03-01 00:00:00+00 |	160.18           |
| 2020-04-01 00:00:00+00 |	171.29           |
| 2020-05-01 00:00:00+00 |	207.45           |
| 2020-06-01 00:00:00+00 |	235.92           |
| 2020-07-01 00:00:00+00 |	259.57           |
| 2020-08-01 00:00:00+00 |	401.73           |
| 2020-09-01 00:00:00+00 |	367.77           |
| 2020-10-01 00:00:00+00 |	375.79           |
| 2020-11-01 00:00:00+00 |	486.73           |
| 2020-12-01 00:00:00+00 |	622.35           |
<br>



### Question 7

> Are there any duplicate `market_date` values for any `ticker` value in our table?

As you inspect the output from the following SQL query - what is your final answer?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  ticker,
  COUNT(market_date) AS total_count,
  COUNT(DISTINCT market_date) AS unique_count
FROM trading.prices
GROUP BY ticker;
```

</details>
<br>

| ticker | total_count | unique_count |
| ------ | ----------- | ------------ |
| BTC    |        1702 |         1702 |
| ETH    |        1702 |         1702 |
<br>

### Question 8

> How many days from the `trading.prices` table exist where the `high` price of Bitcoin is over $30,000?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  COUNT(*) AS row_count
FROM trading.prices
WHERE ticker = 'BTC'
  AND high > 30000;
```

</details>
<br>

| row_count |
| --------- |
|       240 |
<br>

### Question 9

> How many "breakout" days were there in 2020 where the `price` column is greater than the `open` column for each `ticker`?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  ticker,
  SUM(CASE WHEN price > open THEN 1 ELSE 0 END) AS breakout_days
FROM trading.prices
WHERE DATE_TRUNC('YEAR', market_date) = '2020-01-01'
GROUP BY ticker;
```

</details>
<br>

| ticker | breakout_days |
| ------ | ------------- |
| BTC    |           207 |
| ETH    |           200 |
<br>

### Question 10

> How many "non_breakout" days were there in 2020 where the `price` column is less than the `open` column for each `ticker`?

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  ticker,
  SUM(CASE WHEN price < open THEN 1 ELSE 0 END) AS non_breakout_days
FROM trading.prices
-- this another way to specify the year
WHERE market_date >= '2020-01-01' AND market_date <= '2020-12-31'
GROUP BY ticker;
```

</details>
<br>

| ticker | non_breakout_days |
| ------ | ----------------- |
| BTC    |               159 |
| ETH    |               166 |
<br>

### Question 11

> What percentage of days in 2020 were breakout days vs non-breakout days? Round the percentages to 2 decimal places

<details>
  <summary>Click here to reveal the solution!</summary>
<br>

```sql
SELECT
  ticker,
  ROUND(
    SUM(CASE WHEN price > open THEN 1 ELSE 0 END)
      / COUNT(*)::NUMERIC,
    2
  ) AS breakout_percentage,
  ROUND(
    SUM(CASE WHEN price < open THEN 1 ELSE 0 END)
      / COUNT(*)::NUMERIC,
    2
  ) AS non_breakout_percentage
FROM trading.prices
WHERE market_date >= '2020-01-01' AND market_date <= '2020-12-31'
GROUP BY ticker;
```

</details>
<br>

| ticker | breakout_percentage | non_breakout_percentage |
| ------ | ------------------- | ----------------------- |
| BTC    |                0.57 |                    0.43 |
| ETH    |                0.55 |                    0.45 |
<br>

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step2.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step4.md)

# Appendix

> Date Manipulations

We use a variety of date manipulations in questions [5](#question-5), [6](#question-6), [9](#question-9) and [11](#question-11) to filter the `trading.prices` for 2020 values only.

These are all valid methods to qualify `DATE` or `TIMESTAMP` values within a range using a `WHERE` filter:

* `market_date BETWEEN '2020-01-01' AND '2020-12-31'`
* `EXTRACT(YEAR FROM market_date) = 2020`
* `DATE_TRUNC('YEAR', market_date) = '2020-01-01'`
* `market_date >= '2020-01-01' AND market_date <= '2020-12-31'`

The only additional thing to note is that `DATE_TRUNC` returns a `TIMESTAMP` data type which can be cast back to a regular `DATE` using the `::DATE` notation when used in a `SELECT` query.

> `BETWEEN` Boundaries

An additional note for [question 5](#question-5) - the boundaries for the `BETWEEN` clause must be `earlier-date-first` AND `later-date-second`

See what happens when you reverse the order of the `DATE` boundaries using the query below - does it match your expectation?

<details>
  <summary>Click here to see the "wrong" code!</summary>
<br>

```sql
SELECT
  AVG(price)
FROM trading.prices
WHERE ticker = 'BTC'
  AND market_date BETWEEN '2020-12-31' AND '2020-01-01';
```

</details>
<br>

> Rounding Floats/Doubles

In PostgreSQL - we cannot apply the `ROUND` function directly to approximate `FLOAT` or `DOUBLE PRECISION` data types.

Instead we will need to cast any outputs from functions such as `AVG` to an exact `NUMERIC` data type before we can use it with other approximation functions such as `ROUND`

In [question 6](#question-6) - if we were to remove our `::NUMERIC` from our query - we would run into this error:

```
ERROR:  function round(double precision, integer) does not exist
LINE 3:   ROUND(AVG(price), 2) AS average_eth_price
          ^
HINT:  No function matches the given name and argument types. You might need to add explicit type casts.
```

You can try this yourself by running the below code snippet with the `::NUMERIC` removed:

<details>
  <summary>Click here to see the "wrong" code!</summary>
<br>

```sql
SELECT
  DATE_TRUNC('MON', market_date) AS month_start,
  ROUND(AVG(price), 2) AS average_eth_price
FROM trading.prices
WHERE EXTRACT(YEAR FROM market_date) = 2020
GROUP BY month_start
ORDER BY month_start;
```

</details>
<br>

> Integer Floor Division

In [question 5](#question-5) - when dividing values in SQL it is very important to consider the data types of the numerator (the number on top) and the denominator (the number on the bottom)

When there is an `INTEGER` / `INTEGER` as there is in this case - SQL will default to `FLOOR` division in this case!

You can try running the same query as the solution to question 5 above - but this time remove the 2 instances of `::NUMERIC` and the decimal place rounding to see what happens!

This is a super common error found in SQL queries and we usually recommend casting either the numerator or the denominator as a `NUMERIC` type using the shorthand `::NUMERIC` syntax to ensure that you will avoid the dreaded integer floor division!

<details>
  <summary>Click here to see the "wrong" code!</summary>
<br>

```sql
SELECT
  ticker,
  SUM(CASE WHEN price > open THEN 1 ELSE 0 END) / COUNT(*) AS breakout_percentage,
  SUM(CASE WHEN price < open THEN 1 ELSE 0 END) / COUNT(*) AS non_breakout_percentage
FROM trading.prices
WHERE market_date >= '2019-01-01' AND market_date <= '2019-12-31'
GROUP BY ticker;
```

</details>
<br>