# Pizza Runner Case Study

## Introduction

Welcome to the **Pizza Runner** case study! This project simulates the operations of a budding pizza delivery startup inspired by the "Uberization" trend. By analyzing the provided datasets, you'll gain insights into optimizing delivery operations, enhancing customer and runner experiences, and improving overall business performance.

### About Pizza Runner

Danny Ma, an aspiring entrepreneur and data scientist, launched Pizza Runner with a unique vision: combining the love for pizza with the efficiency of an on-demand delivery model. Starting from his home, Danny recruited runners to deliver freshly made pizzas and developed a mobile app to handle customer orders. With a keen understanding of data's importance in business growth, Danny has compiled various datasets to help optimize Pizza Runner's operations.

## Available Data

The Pizza Runner database schema contains several tables capturing different aspects of the business. Below is an overview of each table:

### 1. `runners`

Tracks the registration dates of each delivery runner.

| runner_id | registration_date |
|-----------|--------------------|
| 1         | 2021-01-01         |
| 2         | 2021-01-03         |
| 3         | 2021-01-08         |
| 4         | 2021-01-15         |

### 2. `customer_orders`

Records individual pizza orders. Each row represents a single pizza within a customer's order, including any ingredient modifications.

| order_id | customer_id | pizza_id | exclusions | extras | order_time          |
|----------|-------------|----------|------------|--------|---------------------|
| 1        | 101         | 1        |            |        | 2021-01-01 18:05:02 |
| ...      | ...         | ...      | ...        | ...    | ...                 |

**Note:** The `exclusions` and `extras` columns may contain `null` or `NaN` values and need cleaning before analysis.

### 3. `runner_orders`

Details the assignment and status of each order to a runner, including pickup times, distances, durations, and cancellations.

| order_id | runner_id | pickup_time          | distance | duration    | cancellation          |
|----------|-----------|----------------------|----------|-------------|-----------------------|
| 1        | 1         | 2021-01-01 18:15:34  | 20km     | 32 minutes  |                       |
| ...      | ...       | ...                  | ...      | ...         | ...                   |

**Data Issues:** Ensure data types are correctly interpreted (e.g., distance and duration formats) and handle `null` or inconsistent entries appropriately.

### 4. `pizza_names`

Lists the available pizza types.

| pizza_id | pizza_name    |
|----------|---------------|
| 1        | Meat Lovers   |
| 2        | Vegetarian    |

### 5. `pizza_recipes`

Defines the standard toppings for each pizza type.

| pizza_id | toppings       |
|----------|----------------|
| 1        | 1, 2, 3, 4, 5, 6, 8, 10 |
| 2        | 4, 6, 7, 9, 11, 12        |

### 6. `pizza_toppings`

Maps topping IDs to their names.

| topping_id | topping_name |
|------------|--------------|
| 1          | Bacon        |
| 2          | BBQ Sauce    |
| ...        | ...          |

## Getting Started

### Interactive SQL Instance

To begin analyzing the data, you can use the embedded [DB Fiddle](https://www.db-fiddle.com/) provided below. This interactive session allows you to write and execute SQL queries against the sample datasets.

- **Edit on DB Fiddle:** Click the "Edit on DB Fiddle" link to access a fully functional SQL editor.
- **SQL Dialect:** The default dialect is PostgreSQL 13, but you can choose any SQL dialect you're comfortable with.
- **Permanent Tables:** For persistent analysis, consider copying the Schema SQL into your local SQL environment or using SQLPad with temporary tables.

### Schema SQL

You can recreate the database schema in your local environment using the following SQL commands. Ensure to include `TEMP` if you wish to keep your workspace clean.

```sql
-- Example for creating the 'runners' table
CREATE TABLE pizza_runner.runners (
    runner_id INT PRIMARY KEY,
    registration_date DATE
);

-- Repeat similar CREATE TABLE statements for other tables
```

## Case Study Questions

This case study is divided into several focus areas, each containing multiple questions that can be addressed with single SQL statements. Below is an overview of the topics covered:

### A. Pizza Metrics

- **Total Pizzas Ordered:** Calculate the total number of pizzas sold.
- **Unique Customer Orders:** Determine the number of distinct customer orders.
- **Successful Deliveries per Runner:** Find out how many orders each runner successfully delivered.
- **Pizza Type Distribution:** Analyze the distribution of different pizza types delivered.
- **Customer-Specific Orders:** Examine how many Vegetarian and Meat Lovers pizzas each customer ordered.
- **Maximum Pizzas per Order:** Identify the highest number of pizzas delivered in a single order.
- **Order Modifications:** For each customer, count delivered pizzas with and without modifications.
- **Pizzas with Both Exclusions and Extras:** Determine how many pizzas had both exclusions and extras.
- **Hourly Order Volume:** Calculate the total number of pizzas ordered each hour.
- **Weekly Order Volume:** Analyze order volumes for each day of the week.

### B. Runner and Customer Experience

- **Runner Sign-Ups:** Track the number of runners who signed up each week starting from 2021-01-01.
- **Average Pickup Time per Runner:** Compute the average time runners take to arrive at headquarters to pick up orders.
- **Order Preparation Time vs. Number of Pizzas:** Explore any correlation between the number of pizzas in an order and the preparation time.
- **Average Distance per Customer:** Calculate the average delivery distance for each customer.
- **Delivery Time Range:** Find the difference between the longest and shortest delivery times across all orders.
- **Runner Delivery Speeds:** Calculate the average speed for each runner per delivery and identify any trends.
- **Successful Delivery Percentage:** Determine the success rate of deliveries for each runner.

### C. Ingredient Optimization

*Questions related to optimizing pizza ingredients based on customer preferences and order modifications.*

### D. Pricing and Ratings

*Questions focused on pricing strategies and customer ratings to enhance business profitability and satisfaction.*

### E. Bonus DML Challenges

*Advanced data manipulation tasks to further refine the Pizza Runner database.*

## Data Cleaning and Preparation

Before diving into the analysis, it's crucial to address the following data quality issues:

- **Handle Null Values:** Replace or remove `null` and `NaN` entries in the `exclusions`, `extras`, and `runner_orders` tables.
- **Standardize Data Formats:** Ensure consistency in data types, especially for `distance` and `duration` fields.
- **Normalize Ingredient Data:** Split and clean the `exclusions` and `extras` columns to facilitate easier querying and analysis.

## Tools and Technologies

- **SQL Dialects:** PostgreSQL 13 (default), but adaptable to other SQL dialects.
- **DB Fiddle:** For interactive SQL querying and testing.
- **SQLPad:** Optional tool for managing and executing SQL queries in a persistent environment.

## Getting Help

If you encounter any issues or have questions about the case study:

- **Review the Data:** Ensure you've correctly interpreted the schema and addressed all data quality issues.
- **Consult SQL Documentation:** Refer to SQL dialect-specific documentation for syntax and function usage.
- **Collaborate:** Reach out to peers or mentors for collaborative problem-solving.

## Conclusion

The Pizza Runner case study offers a comprehensive platform to apply SQL and data analysis skills in a real-world scenario. By systematically addressing the questions and optimizing various aspects of the business, you'll gain valuable insights into data-driven decision-making and operational efficiency.

Happy Analyzing!
