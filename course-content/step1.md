<p align="center">
    <img src="./../images/sql-masterclas-banner.png" alt="sql-masterclass-banner">
</p>

[![forthebadge](./../images/badges/version-1.0.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/powered-by-coffee.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/ctrl-c-ctrl-v.svg)]()

# Step 1 - Introduction

## Our Database

All of our data lives within a PostgreSQL database and contains a single schema called `trading`.

In PostgreSQL, a database can contain multiple schemas, and a schema is a collection of tables and other database objects.

## Copy and Run a SQL Query

To run our first query together - you can click on the right hand corner of the following code snippet below to copy a basic `SELECT` query to your clipboard.

You can then paste it into your SQLPad interface and click on the `Run` button in the top right corner or hit `cmd` + `enter` on Mac or `control` + `enter` on Windows to run the query.

```sql
SELECT * FROM trading.members;
```

This `SELECT` query above will return all of the records from the `members` table inside the `trading` schema.

# Our Crypto Case Study

For this entire SQL Simplified course we will focus on our Cryptocurrency Trading SQL Case Study!

## Setting the Context

In our fictitious (but realistic) case study - my team of trusted data mentors from the Data With Danny team have been dabbling in the crypto markets since 2017.

Our main purpose for this case study is to analyse the performance of the DWD mentors over time and to "slice and dice" the data in various ways to investigate other questions we might want answers to!

## Our Datasets

All of our data for this case study exists within the `trading` schema as we mentioned in the previous tutorial.

There are 3 data tables available to us in this schema which we can use to run our SQL queries with:

1. `members`
2. `prices`
3. `transactions`

You can inspect each dataset by copying the following code snippet below and running it directly in the SQLPad GUI - please make sure to overwrite any previous queries which are already in the SQL interface!

```sql
SELECT * FROM trading.members;
```

| member_id | first_name |    region     |
| --------- | ---------- | ------------- |
| c4ca42    | Danny      | Australia     |
| c81e72    | Vipul      | United States |
| eccbc8    | Charlie    | United States |
| a87ff6    | Nandita    | United States |
| e4da3b    | Rowan      | United States |
| 167909    | Ayush      | United States |
| 8f14e4    | Alex       | United States |
| c9f0f8    | Abe        | United States |
| 45c48c    | Ben        | Australia     |
| d3d944    | Enoch      | Africa        |
| 6512bd    | Vikram     | India         |
| c20ad4    | Leah       | Asia          |
| c51ce4    | Pavan      | Australia     |
| aab323    | Sonia      | Australia     |
<br>

```sql
SELECT * FROM trading.prices LIMIT 5;
```

| ticker | market_date |  price  |  open   |  high   |   low   | volume  | change |
| ------ | ----------- | ------- | ------- | ------- | ------- | ------- | ------ |
| ETH    | 2021-08-29  | 3177.84 | 3243.96 | 3282.21 | 3162.79 | 582.04K | -2.04% |
| ETH    | 2021-08-28  | 3243.90 | 3273.78 | 3284.58 | 3212.24 | 466.21K | -0.91% |
| ETH    | 2021-08-27  | 3273.58 | 3093.78 | 3279.93 | 3063.37 | 839.54K | 5.82%  |
| ETH    | 2021-08-26  | 3093.54 | 3228.03 | 3249.62 | 3057.48 | 118.44K | -4.17% |
| ETH    | 2021-08-25  | 3228.15 | 3172.12 | 3247.43 | 3080.70 | 923.13K | 1.73%  |
<br>

```sql
SELECT * FROM trading.transactions LIMIT 5;
```

| txn_id | member_id | ticker |  txn_date  | txn_type | quantity | percentage_fee |      txn_time       |
| ------ | --------- | ------ | ---------- | -------- | -------- | -------------- | ------------------- |
|      1 | c81e72    | BTC    | 2017-01-01 | BUY      |       50 |           0.30 | 2017-01-01 00:00:00 |
|      2 | eccbc8    | BTC    | 2017-01-01 | BUY      |       50 |           0.30 | 2017-01-01 00:00:00 |
|      3 | a87ff6    | BTC    | 2017-01-01 | BUY      |       50 |           0.00 | 2017-01-01 00:00:00 |
|      4 | e4da3b    | BTC    | 2017-01-01 | BUY      |       50 |           0.30 | 2017-01-01 00:00:00 |
|      5 | 167909    | BTC    | 2017-01-01 | BUY      |       50 |           0.30 | 2017-01-01 00:00:00 |


Note: the `LIMIT 5` in the above queries will return us only the first 5 rows from each dataset.

It is a good practice to always `LIMIT` your queries just in case the tables are huge - you don't want to be trying to return all 5 million rows from a huge table when you are just inspecting the data for the first time!

## A Note on Schemas

Notice above how the "`trading.`" is included before each of our available tables.

If we were to remove this - our database will be unable to find our tables.

This query below will return you an error when ran:

```sql
SELECT * FROM members;
```

> relation "members" does not exist

In realistic scenarios - physical tables will almost always live within a schema and we'll need to reference the schema name to run our queries properly!

[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step2.md)