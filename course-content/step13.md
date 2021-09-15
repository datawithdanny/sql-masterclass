<p align="center">
    <img src="./../images/sql-masterclas-banner.png" alt="sql-masterclass-banner">
</p>

[![forthebadge](./../images/badges/version-1.0.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/powered-by-coffee.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/ctrl-c-ctrl-v.svg)]()

# SQL Masterclass Summary

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step12.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/the-end.md)

Congratulations you have reached the end of this SQL Masterclass!

Here are some of the topics which you covered in this short but sweet SQL Masterclass course:

> Step 2: Inspecting the `trading.members` table

* Selecting rows and columns from database tables with `SELECT`
* Use `LIMIT` to only return a set number of rows from a query
* Counting the number of records using `COUNT(*)`
* Counting the number of unique column and table records using `COUNT(DISTINCT)
* Filtering data using a `WHERE` filter
* Selecting `DATE` ranges using `BETWEEN`, `>`, `>=`, `<`, `<=`
* Using the `IN` and `NOT IN` filter conditions to remove and keep records
* Use `CASE WHEN` to apply simple if-else logic to an existing column

> Step 3: Analyzing daily BTC and ETH prices in the `trading.prices` table

* Finding the `MIN` and `MAX` dates
* Use `GROUP BY` to aggregate data at different levels for analysis
* Extracting information from dates using `DATE_TRUNC` and `EXTRACT`
* Using `DATE_TRUNC` to obtain the begining date of month for a `DATE`
* Using `AVG` to find the average price
* Casting float data types to an exact `NUMERIC` to use with the `ROUND` function
* Using `AND` conditions to apply multiple logical rules for `WHERE` filters
* Using `SUM CASE WHEN` to aggregate logical values similar to a COUNTIF in Excel
* Casting `INTEGER` data types to a `NUMERIC` to avoid integer floor division errors

> Step 4: View all transaction histories in the `trading.transactions` table

* More advanced usage of `SUM CASE WHEN` to replicate SUMIF functionality in Excel
* How to filter records from a `GROUP BY` result using the `HAVING` clause
* Using CTEs and subqueries to perform the same filtering of results
* Use a `RANK` window function to perform custom ordering for a results set

> Step 5: Starting data analysis

* Interpreting entity relationship diagrams (ERDs) to visualize table joins
* Analyzing ranges of data to make sure the analysis periods are aligned
* Perform an `INNER JOIN` to combine datasets to select columns from both tables
* Combining CTEs and joins for step-wise queries
* Combining multiple aggregation functions to generate larger table outputs

> Steps 6-7: Planning ahead and using base tables for data analysis

* Drop and create a temporary table to re-use in future SQL queries
* Add time `INTERVAL` to a date
* Use `ALTER` and `UPDATE` statements to manipulate an existing temporary table
* Use a custom `WINDOW FRAME` clause to specify a sliding window for cumulative metrics
* Use a `SUM` window function to calculate a denominator value for percentage calculations
* Use `MAX CASE WHEN` to pivot data from long to wide

> Steps 8-12: Final Case Study Scenarios

* Creating simplified data scenarios to better understand each question
* Implementing a `SUM PRODUCT` aggregation to calculate initial investments
* Performing multiple joins to the same tables with different joining conditions
* Multiplying many columns to generate fees based off percentages
* Calculating hypothetical scenarios and implementing complex logic using SQL
* Creating a complete CTE workflow to generate a reporting dataset
* Aggregating data at multiple levels to generate multiple insights

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step12.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/the-end.md)