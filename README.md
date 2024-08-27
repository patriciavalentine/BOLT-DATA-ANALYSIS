# BOLT RIDE ANALYSIS

### Project Overview

*This is a project focused on analyzing the operations of a Bolt Ride, over a period of two months.*

![yellow-black-sign-taxi-placed-top-car-night](https://github.com/user-attachments/assets/883c4474-1304-42bf-b0d8-a7841e6d3763)

### Source of Data
- Kaggle

### Tools Used
- **MySQL** - for data cleaning, formatting, and basic analysis.
- **Tableau** - for visualizing key metrics like revenue, peak hours, and payment preferences.

### Key Inquiry Questions
The key questions the project sought to answer regarding the specific bolt ride operations are:
1. What are the peak and off-peak hours for Bolt rides?
2. Which pickup locations are the most popular?
3. How does revenue vary across different days, and what trends can be observed over time?

## Table of Content
- [Data Processing](#data-processing)
- [Data Cleaning](#data-cleaning)
- [Basic Data Analysis](#basic-data-analysis)
- [Tableau Visualizations](#tableau-visualizations)

### Data Processing
- Sample Data:

I started by viewing the first 10 rows of data from both the January and February 2023 tables to get a quick look at what I was working with.

```sql
SELECT * FROM `bolt operations dataset`.january_2023 LIMIT 10;
SELECT * FROM `bolt operations dataset`.february_2023 LIMIT 10;
```

- Structure Overview:

I used the DESCRIBE command to view the column names, data types, and other details for each table.

```sql
DESCRIBE `bolt operations dataset`.january_2023;
DESCRIBE `bolt operations dataset`.february_2023;
```
- Rename Columns:

I identified and corrected a misnamed column (Order time) in both tables to ensure consistency and avoid issues in subsequent queries.

```sql
ALTER TABLE `bolt operations dataset`.january_2023
RENAME COLUMN  `ï»¿"Order time"` TO `Order time`;

ALTER TABLE `bolt operations dataset`.february_2023
RENAME COLUMN  `ï»¿"Order time"` TO `Order time`;
```
- Row Counts:

I counted the number of rows in each table to understand the size of the datasets.

```sql
SELECT COUNT(*) FROM `bolt operations dataset`.january_2023;
SELECT COUNT(*) FROM `bolt operations dataset`.february_2023;
```

- Missing Values:

I checked for missing values in key columns like Pickup address, tip, state, and distance for both January and February data. No missing values were found.

```sql
-- For January 2023 table
SELECT COUNT(*) FROM `bolt operations dataset`.january_2023 WHERE `Pickup address` IS NULL;
SELECT COUNT(*) FROM `bolt operations dataset`.january_2023 WHERE tip IS NULL;

-- For February 2023 table
SELECT COUNT(*) FROM `bolt operations dataset`.february_2023 WHERE state IS NULL;
SELECT COUNT(*) FROM `bolt operations dataset`.february_2023 WHERE distance IS NULL;
```

- Duplicate Values:

I searched for duplicate rows based on key identifiers (Pickup address and Payment time). No duplicates were found.

```sql
# For February 2023 table:
SELECT `Pickup address`,  `Payment time`, COUNT(*)
FROM `bolt operations dataset`.january_2023
GROUP BY 1, 2
HAVING COUNT(*) > 1;

# For February 2023 table:
SELECT `Pickup address`,  `Payment time`, COUNT(*)
FROM `bolt operations dataset`.february_2023
GROUP BY 1, 2
HAVING COUNT(*) > 1;
```

### Data Cleaning:
- Removing Irrelevant Columns:

I removed columns like Cancellation fee, currency, toll fee, and state from both tables as they were not necessary for my analysis.

```sql
-- For January 2023 table:
ALTER TABLE `bolt operations dataset`.january_2023
DROP COLUMN `Cancellation fee`,
DROP COLUMN currency,
DROP COLUMN `toll fee`,
DROP COLUMN state;

-- For February 2023 table:
ALTER TABLE `bolt operations dataset`.february_2023
DROP COLUMN `Cancellation fee`,
DROP COLUMN currency,
DROP COLUMN `toll fee`,
DROP COLUMN state;
```

- Formatting Dates and Times:

I split the Order time and Payment time columns into separate Order date, Time of Order, Payment date, and Time of Payment columns for easier analysis.
After extracting the dates and times, I dropped the original combined columns.

```sql
ALTER TABLE `bolt operations dataset`.january_2023
ADD COLUMN `Order date` DATE,
ADD COLUMN `Time of Order` TIME;

-- To temporarily disable the safe update mode (to enable several updates at once):
SET SQL_SAFE_UPDATES = 0;

UPDATE `bolt operations dataset`.january_2023
SET `Order date` = STR_TO_DATE(SUBSTRING(`Order time`, 1, 10), '%d.%m.%Y'),
    `Time of Order` = STR_TO_DATE(SUBSTRING(`Order time`, 12, 5), '%H:%i');

-- Deleting the former Order Date & Time column
ALTER TABLE `bolt operations dataset`.january_2023
DROP COLUMN `Order time`;

ALTER TABLE `bolt operations dataset`.january_2023
ADD COLUMN `Payment date` DATE,
ADD COLUMN `Time of Payment` TIME;

UPDATE `bolt operations dataset`.january_2023
SET `Payment date` = STR_TO_DATE(SUBSTRING(`Payment time`, 1, 10), '%d.%m.%Y'),
    `Time of Payment` = STR_TO_DATE(SUBSTRING(`Payment time`, 12, 5), '%H:%i');

-- Deleting the former Payment Date & Time column
ALTER TABLE `bolt operations dataset`.january_2023
DROP COLUMN `Payment time`;

# Repeating the same for February:
ALTER TABLE `bolt operations dataset`.February_2023
ADD COLUMN `Order date` DATE,
ADD COLUMN `Time of Order` TIME;

-- To temporarily disable the safe update mode (to enable several updates at once):
SET SQL_SAFE_UPDATES = 0;

UPDATE `bolt operations dataset`.february_2023
SET `Order date` = STR_TO_DATE(SUBSTRING(`Order time`, 1, 10), '%d.%m.%Y'),
    `Time of Order` = STR_TO_DATE(SUBSTRING(`Order time`, 12, 5), '%H:%i');

-- Deleting the former Order Date & Time column
ALTER TABLE `bolt operations dataset`.february_2023
DROP COLUMN `Order time`;

ALTER TABLE `bolt operations dataset`.february_2023
ADD COLUMN `Payment date` DATE,
ADD COLUMN `Time of Payment` TIME;

UPDATE `bolt operations dataset`.february_2023
SET `Payment date` = STR_TO_DATE(SUBSTRING(`Payment time`, 1, 10), '%d.%m.%Y'),
    `Time of Payment` = STR_TO_DATE(SUBSTRING(`Payment time`, 12, 5), '%H:%i');

-- Deleting the former Payment Date & Time column
ALTER TABLE `bolt operations dataset`.february_2023
DROP COLUMN `Payment time`;

-- To re-enable Safe Update Mode (that I disabled earlier):
SET SQL_SAFE_UPDATES = 1;
```

### Basic Data Analysis:
- Revenue Analysis:

I calculated the total revenue by payment method for each month, as well as the total revenue per day.

```sql
-- Total Revenue by payment method for January:
SELECT `Payment method`, SUM(`Ride price`) AS `Total Revenue`
FROM `bolt operations dataset`.january_2023
GROUP BY 1;

-- Total Revenue by payment method for February:
SELECT `Payment method`, SUM(`Ride price`) AS `Total Revenue`
FROM `bolt operations dataset`.february_2023
GROUP BY 1;


-- Total revenue per day in January:
SELECT DATE(`Order date`) AS `Day`, SUM(`Ride price`) AS `Total revenue`
FROM `bolt operations dataset`.january_2023
GROUP BY `Day`
ORDER BY `Total revenue` DESC;

-- Total revenue per day in February:
SELECT DATE(`Order date`) AS `Day`, SUM(`Ride price`) AS `Total revenue`
FROM `bolt operations dataset`.february_2023
GROUP BY `Day`
ORDER BY `Total revenue` DESC
LIMIT 5;
```

- Peak Order Times:

I determined the most common hours for ride orders in both January and February.

```sql
-- January
SELECT HOUR(`Time of Order`) AS `Hour`, COUNT(*) AS `Order count`
FROM `bolt operations dataset`.january_2023
GROUP BY `Hour`
ORDER BY `Order count` DESC;

-- February
SELECT HOUR(`Time of Order`) AS `Hour`, COUNT(*) AS `Order count`
FROM `bolt operations dataset`.february_2023
GROUP BY `Hour`
ORDER BY `Order count` DESC;
```

- Popular Pickup Locations:

I identified the top 5 most common pickup locations for each month.

```sql
# January:
SELECT `Pickup address`, COUNT(*) AS `Pickup count`
FROM `bolt operations dataset`.january_2023
GROUP BY `Pickup address`
ORDER BY `Pickup count` DESC
LIMIT 5;

# February:
SELECT `Pickup address`, COUNT(*) AS `Pickup count`
FROM `bolt operations dataset`.february_2023
GROUP BY `Pickup address`
ORDER BY `Pickup count` DESC
LIMIT 5;
```

- Ride Price Analysis:

I calculated the average, minimum, and maximum ride prices for each month.

```sql
-- January:
SELECT 
    AVG(`Ride price`) AS `Avg price`, 
    MIN(`Ride price`) AS `Min price`, 
    MAX(`Ride price`) AS `Max price`
FROM `bolt operations dataset`.january_2023;

-- February:
SELECT 
    AVG(`Ride price`) AS `Avg price`, 
    MIN(`Ride price`) AS `Min price`, 
    MAX(`Ride price`) AS `Max price`
FROM `bolt operations dataset`.february_2023;
```

I also grouped the ride prices into ranges (e.g., under 200, 200-500, etc.) to understand the distribution of ride costs.

```sql
-- January
SELECT 
    CASE
        WHEN `Ride price` < 200 THEN 'Under 200'
        WHEN `Ride price` BETWEEN 200 AND 500 THEN '200-500'
        WHEN `Ride price` BETWEEN 500 AND 1000 THEN '500-1000'
        ELSE 'Over 1000'
    END AS `Price range`,
    COUNT(*) AS `Ride count`
FROM `bolt operations dataset`.january_2023
GROUP BY `Price range`
ORDER BY `Ride count` DESC;

-- February
SELECT 
    CASE
        WHEN `Ride price` < 200 THEN 'Under 200'
        WHEN `Ride price` BETWEEN 200 AND 500 THEN '200-500'
        WHEN `Ride price` BETWEEN 500 AND 1000 THEN '500-1000'
        ELSE 'Over 1000'
    END AS `Price range`,
    COUNT(*) AS `Ride count`
FROM `bolt operations dataset`.february_2023
GROUP BY `Price range`
ORDER BY `Ride count` DESC;
```

- Payment Method Preferences:

I examined the frequency of different payment methods used by customers in each month.

```sql
-- January:
SELECT `Payment method`, COUNT(*) AS Paymentmethod_count
FROM `bolt operations dataset`.january_2023
GROUP BY `Payment method`
ORDER BY paymentmethod_count DESC;

-- February:
SELECT `Payment method`, COUNT(*) AS Paymentmethod_count
FROM `bolt operations dataset`.february_2023
GROUP BY `Payment method`
ORDER BY paymentmethod_count DESC;
```

- Distance Analysis:

I computed the average, minimum, and maximum distances traveled by riders.

```sql
-- January:
SELECT 
    AVG(distance) AS avg_distance, 
    MIN(distance) AS min_distance, 
    MAX(distance) AS max_distance
FROM `bolt operations dataset`.january_2023;

-- February:
SELECT 
    AVG(distance) AS avg_distance, 
    MIN(distance) AS min_distance, 
    MAX(distance) AS max_distance
FROM `bolt operations dataset`.february_2023;
```

- Union of Tables:

I used a UNION ALL to combine the data from January and February into a single view.

```sql
SELECT * FROM `bolt operations dataset`.january_2023
UNION ALL
SELECT * FROM `bolt operations dataset`.february_2023;
```

- Creating a New Table:

I then created a new table called combined_data to permanently store the combined dataset for future analysis.

```sql
CREATE TABLE `bolt operations dataset`.combined_data AS
SELECT * FROM `bolt operations dataset`.january_2023
UNION ALL
SELECT * FROM `bolt operations dataset`.february_2023;

-- CONFIRMING THE NEW TABLE:
SELECT * FROM `bolt operations dataset`.combined_data;
```

### TABLEAU VISUALIZATIONS

You can view all the Tableau Visualizations [here!](https://public.tableau.com/views/BoltRideAnalytics/DASHBOARD?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

In the Tableau dashboard,
*I selected a combination of KPIs and charts that provide a comprehensive view of the key performance indicators and critical operational metrics.*

![Tableau Dashboard Capture](https://github.com/user-attachments/assets/dd449550-da29-4285-9d6f-188f6d3248a0)

The KPIs — *total revenue, total distance covered, total rides, total days, and total amount of tips received* — serve as fundamental metrics that give an immediate understanding of overall performance. These KPIs are crucial for quickly assessing the effectiveness of operations and revenue generation.

For the visualizations, I used:

- Horizontal bar graphs to display the top 5 peak and off-peak hours, which are critical for understanding demand patterns and optimizing resource allocation.

- A histogram of revenue by payment method that offered insights into customer preferences, aiding in strategic decision-making related to payment processing.

- A treemap showing the top 5 popular pickup locations highlights key areas of demand, which is essential for targeted marketing and operational focus.

- Line graphs for revenue growth over time that provided a clear view of financial performance trends, which is invaluable for forecasting and strategic planning.

**Together, these steps forms a cohesive process demonstrating my ability to transform raw data into meaningful, actionable insights.**

## Thank You 😄 !

