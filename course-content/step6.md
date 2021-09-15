<p align="center">
    <img src="./../images/sql-masterclas-banner.png" alt="sql-masterclass-banner">
</p>

[![forthebadge](./../images/badges/version-1.0.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/powered-by-coffee.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/ctrl-c-ctrl-v.svg)]()

# Step 6 - Planning Ahead for Data Analysis

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step5.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step7.md)

# Planning Ahead

Sometimes when creating SQL queries - we can jump to the initial problem at hand, but what happens when we stop and plan through our approach to a multi-part problem?

## Further Portfolio Questions

Let's take this next series of questions and methodically break down our approach before we reveal the answers.

**Questions 1-4**

> What is the total portfolio value for each mentor at the end of 2020?

> What is the total portfolio value for each region at the end of 2019?

> What percentage of regional portfolio values does each mentor contribute at the end of 2018?

> Does this region contribution percentage change when we look across both Bitcoin and Ethereum portfolios independently at the end of 2017?

We can see that most questions are based off total portfolio value apart from the final question - which requires both tickers to be separated.

Additionally, the `region` value for each mentor is going to be important also for both questions 3 and 4.

We also need to factor in the timing aspect for these questions - it's not going to be as straightforward as our previous questions which required only the final portfolio value.

For these questions - let's first create a base table which we can refer to later to solve our problems!

## Create a Base Table

We can make use of a `TEMP` table which is stored in a temporary schema which will disappear once the SQL session is closed down - this is very useful in practice because you don't always have write access to production databases all the time!

First let's create a portfolio quantity base table which summarizes our data with the required data first.

### Step 1

> Create a base table that has each mentor's name, `region` and end of year total quantity for each ticker

**You must run the query below in order to run all following queries in this tutorial!**

<details><summary>Click here to reveal the solution!</summary><br>


```sql
DROP TABLE IF EXISTS temp_portfolio_base;
CREATE TEMP TABLE temp_portfolio_base AS
WITH cte_joined_data AS (
  SELECT
    members.first_name,
    members.region,
    transactions.txn_date,
    transactions.ticker,
    CASE
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
      ELSE transactions.quantity
    END AS adjusted_quantity
  FROM trading.transactions
  INNER JOIN trading.members
    ON transactions.member_id = members.member_id
  WHERE transactions.txn_date <= '2020-12-31'
)
SELECT
  first_name,
  region,
  (DATE_TRUNC('YEAR', txn_date) + INTERVAL '12 MONTHS' - INTERVAL '1 DAY')::DATE AS year_end,
  ticker,
  SUM(adjusted_quantity) AS yearly_quantity
FROM cte_joined_data
GROUP BY first_name, region, year_end, ticker;
```

</details><br>

### Step 2

Let's take a look at our base table now to see what data we have to play with - to keep things simple, let's take a look at Abe's data from our new temp table `temp_portfolio_base`

> Inspect the `year_end`, `ticker` and `yearly_quantity` values from our new temp table `temp_portfolio_base` for Mentor Abe only. Sort the output with ordered BTC values followed by ETH values

<details><summary>Click here to reveal the solution!</summary><br>


```sql
SELECT
  year_end,
  ticker,
  yearly_quantity
FROM temp_portfolio_base
WHERE first_name = 'Abe'
ORDER BY ticker, year_end;
```

</details><br>

|  year_end  | ticker |   yearly_quantity    |
| ---------- | ------ | -------------------- |
| 2017-12-31 | BTC    | 861.0106371411443039 |
| 2018-12-31 | BTC    | 755.1495855476883388 |
| 2019-12-31 | BTC    |  765.655338171040942 |
| 2020-12-31 | BTC    | 859.3718776810842491 |
| 2017-12-31 | ETH    | 543.2120486925716504 |
| 2018-12-31 | ETH    |  350.000100283493089 |
| 2019-12-31 | ETH    |  464.317705594980087 |
| 2020-12-31 | ETH    | 508.4673343549910666 |
<br>

We can see from the output above that the yearly quantity is exactly the total portfolio quantity values that we need - we will need to create a cumulative sum of the `yearly_quantity` column that is separate for each mentor and ticker, using the `year_end` as the ordering column.

We can do exactly this using a SQL window function!

### Step 3

To create the cumulative sum - we'll need to apply a window function!

Although we will only touch on this briefly in this course - the complete Data With Danny [Serious SQL course](https://www.datawithdanny.com/courses/serious-sql) covers this topic and many other SQL concepts in a lot of depth!

> Create a cumulative sum for Abe which has an independent value for each ticker

<details><summary>Click here to reveal the solution!</summary><br>

```sql
SELECT
  year_end,
  ticker,
  yearly_quantity,
  /* this is a multi-line comment!
     for this case we don't actually need first_name
     but we include it anyway to prepare for the next query! */
  SUM(yearly_quantity) OVER (
    PARTITION BY first_name, ticker
    ORDER BY year_end
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_quantity
FROM temp_portfolio_base
WHERE first_name = 'Abe'
ORDER BY ticker, year_end;
```

</details><br>


|  year_end  | ticker |   yearly_quantity    |  cumulative_quantity  |
| ---------- | ------ | -------------------- | --------------------- |
| 2017-12-31 | BTC    | 861.0106371411443039 |  861.0106371411443039 |
| 2018-12-31 | BTC    | 755.1495855476883388 | 1616.1602226888326427 |
| 2019-12-31 | BTC    |  765.655338171040942 | 2381.8155608598735847 |
| 2020-12-31 | BTC    | 859.3718776810842491 | 3241.1874385409578338 |
| 2017-12-31 | ETH    | 543.2120486925716504 |  543.2120486925716504 |
| 2018-12-31 | ETH    |  350.000100283493089 |  893.2121489760647394 |
| 2019-12-31 | ETH    |  464.317705594980087 | 1357.5298545710448264 |
| 2020-12-31 | ETH    | 508.4673343549910666 | 1865.9971889260358930 |
<br>

### Step 4

Now let's apply our same window function to the entire temporary dataset and start answering our questions.

We can actually `ALTER` and `UPDATE` our temp table to add in an extra column with our new calculation

> Generate an additional `cumulative_quantity` column for the `temp_portfolio_base` temp table

<details><summary>Click here to reveal the solution!</summary><br>

```sql
-- add a column called cumulative_quantity
ALTER TABLE temp_portfolio_base
ADD cumulative_quantity NUMERIC;

-- update new column with data
UPDATE temp_portfolio_base
SET (cumulative_quantity) = (
  SELECT
      SUM(yearly_quantity) OVER (
    PARTITION BY first_name, ticker
    ORDER BY year_end
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  )
);
```

</details><br>

Now let's check that our updates to the temp table worked by inspecting Abe's records again!

<details><summary>Click here to reveal the solution!</summary><br>

```sql
-- query the updated table to check rows for Abe
SELECT
  year_end,
  ticker,
  yearly_quantity,
  cumulative_quantity
FROM temp_portfolio_base
WHERE first_name = 'Abe'
ORDER BY ticker, year_end;
```

</details><br>

| year_end   | ticker |   yearly_quantity    | cumulative_quantity  |
| ---------- | ------ | -------------------- | -------------------- |
| 2017-01-01 | BTC    | 861.0106371411443039 | 861.0106371411443039 |
| 2018-01-01 | BTC    | 755.1495855476883388 | 755.1495855476883388 |
| 2019-01-01 | BTC    |  765.655338171040942 |  765.655338171040942 |
| 2020-01-01 | BTC    | 859.3718776810842491 | 859.3718776810842491 |
| 2021-01-01 | BTC    | 479.3287662131302019 | 479.3287662131302019 |
| 2017-01-01 | ETH    | 543.2120486925716504 | 543.2120486925716504 |
| 2018-01-01 | ETH    |  350.000100283493089 |  350.000100283493089 |
| 2019-01-01 | ETH    |  464.317705594980087 |  464.317705594980087 |
| 2020-01-01 | ETH    | 508.4673343549910666 | 508.4673343549910666 |
| 2021-01-01 | ETH    |  223.204709336221616 |  223.204709336221616 |
<br>

Wait a moment....it didn't work - the cumulative and the yearly quantity is exactly the same!

This is because our `UPDATE` step only takes into account a single row at a time, which is exactly what we must not do with our window functions!

We will need to create an additional temp table with our cumulative sum instead!

**You must run this step for all following queries to work!**

<details><summary>Click here to reveal the solution!</summary><br>

```sql
DROP TABLE IF EXISTS temp_cumulative_portfolio_base;
CREATE TEMP TABLE temp_cumulative_portfolio_base AS
SELECT
  first_name,
  region,
  year_end,
  ticker,
  yearly_quantity,
  SUM(yearly_quantity) OVER (
    PARTITION BY first_name, ticker
    ORDER BY year_end
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_quantity
FROM temp_portfolio_base;
```

</details><br>

You can make sure this step is ran by checking the outputs from this query:

```sql
SELECT * FROM temp_cumulative_portfolio_base LIMIT 20;
```

| first_name |    region     |  year_end  | ticker |    yearly_quantity    |  cumulative_quantity   |
| ---------- | ------------- | ---------- | ------ | --------------------- | ---------------------- |
| Abe        | United States | 2017-12-31 | BTC    |  861.0106371411443039 |   861.0106371411443039 |
| Abe        | United States | 2018-12-31 | BTC    |  755.1495855476883388 |  1616.1602226888326427 |
| Abe        | United States | 2019-12-31 | BTC    |   765.655338171040942 |  2381.8155608598735847 |
| Abe        | United States | 2020-12-31 | BTC    |  859.3718776810842491 |  3241.1874385409578338 |
| Abe        | United States | 2017-12-31 | ETH    |  543.2120486925716504 |   543.2120486925716504 |
| Abe        | United States | 2018-12-31 | ETH    |   350.000100283493089 |   893.2121489760647394 |
| Abe        | United States | 2019-12-31 | ETH    |   464.317705594980087 |  1357.5298545710448264 |
| Abe        | United States | 2020-12-31 | ETH    |  508.4673343549910666 |  1865.9971889260358930 |
| Alex       | United States | 2017-12-31 | BTC    |  453.4749593742834454 |   453.4749593742834454 |
| Alex       | United States | 2018-12-31 | BTC    |  447.1910423241274346 |   900.6660016984108800 |
| Alex       | United States | 2019-12-31 | BTC    |   490.959718475924108 |  1391.6257201743349880 |
| Alex       | United States | 2020-12-31 | BTC    |   444.259179847377622 |  1835.8849000217126100 |
| Alex       | United States | 2017-12-31 | ETH    |   678.274023865761511 |    678.274023865761511 |
| Alex       | United States | 2018-12-31 | ETH    | 546.83620089990823574 | 1225.11022476566974674 |
| Alex       | United States | 2019-12-31 | ETH    |  476.8692888907140746 | 1701.97951365638382134 |
| Alex       | United States | 2020-12-31 | ETH    |  621.5582550264365449 | 2323.53776868282036624 |
| Ayush      | United States | 2017-12-31 | BTC    |  794.5344541497821383 |   794.5344541497821383 |
| Ayush      | United States | 2018-12-31 | BTC    |  955.3494738695000753 |  1749.8839280192822136 |
| Ayush      | United States | 2019-12-31 | BTC    |  743.2345666894748266 |  2493.1184947087570402 |
| Ayush      | United States | 2020-12-31 | BTC    | 954.85594846498402504 | 3447.97444317374106524 |


Now that we've obtained our base table properly - let's start answering some of these questions!

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step5.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step7.md)