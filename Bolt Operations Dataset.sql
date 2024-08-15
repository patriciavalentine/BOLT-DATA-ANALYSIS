# Viewing Sample Data:
SELECT * FROM `bolt operations dataset`.january_2023 LIMIT 10;
SELECT * FROM `bolt operations dataset`.february_2023 LIMIT 10;

# For a quick look at column names and details:
DESCRIBE `bolt operations dataset`.january_2023;
DESCRIBE `bolt operations dataset`.february_2023;

# Correcting the Wrong Column Names:
ALTER TABLE `bolt operations dataset`.january_2023
RENAME COLUMN  `ï»¿"Order time"` TO `Order time`;
ALTER TABLE `bolt operations dataset`.february_2023
RENAME COLUMN  `ï»¿"Order time"` TO `Order time`;

# Checking Row Count for Each Table
SELECT COUNT(*) FROM `bolt operations dataset`.january_2023;
SELECT COUNT(*) FROM `bolt operations dataset`.february_2023;

# Checking for Missing Values
-- For January 2023 table
SELECT COUNT(*) FROM `bolt operations dataset`.january_2023 WHERE `Pickup address` IS NULL;
SELECT COUNT(*) FROM `bolt operations dataset`.january_2023 WHERE tip IS NULL;

-- For February 2023 table
SELECT COUNT(*) FROM `bolt operations dataset`.february_2023 WHERE state IS NULL;
SELECT COUNT(*) FROM `bolt operations dataset`.february_2023 WHERE distance IS NULL;

-- RESULT: None found!

# Checking for Duplicate Values
-- For February 2023 table:
SELECT `Pickup address`,  `Payment time`, COUNT(*)
FROM `bolt operations dataset`.january_2023
GROUP BY 1, 2
HAVING COUNT(*) > 1;

-- For February 2023 table:
SELECT `Pickup address`,  `Payment time`, COUNT(*)
FROM `bolt operations dataset`.february_2023
GROUP BY 1, 2
HAVING COUNT(*) > 1;

-- RESULT: None found!

# Removing Irrelevant columns:
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

# Formatting the Dates & Time values:
-- Having the Order Dates & Times in different columns:
ALTER TABLE `bolt operations dataset`.january_2023
ADD COLUMN `Order date` DATE,
ADD COLUMN `Time of Order` TIME;

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


# BASIC DATA ANALYSIS:


-- Total Revenue by payment method for January 2023
SELECT `Payment method`, SUM(`Ride price`) AS `Total Revenue`
FROM `bolt operations dataset`.january_2023
GROUP BY 1;

-- Total Revenue by payment method for February 2023
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


-- Peak order times (by hour) for January 2023
SELECT HOUR(`Time of Order`) AS `Hour`, COUNT(*) AS `Order count`
FROM `bolt operations dataset`.january_2023
GROUP BY `Hour`
ORDER BY `Order count` DESC;

-- Peak order times (by hour) for February 2023
SELECT HOUR(`Time of Order`) AS `Hour`, COUNT(*) AS `Order count`
FROM `bolt operations dataset`.february_2023
GROUP BY `Hour`
ORDER BY `Order count` DESC;


-- Most common Pickup Locations in January 2023
SELECT `Pickup address`, COUNT(*) AS `Pickup count`
FROM `bolt operations dataset`.january_2023
GROUP BY `Pickup address`
ORDER BY `Pickup count` DESC
LIMIT 5;

-- Most common Pickup Locations in February 2023
SELECT `Pickup address`, COUNT(*) AS `Pickup count`
FROM `bolt operations dataset`.february_2023
GROUP BY `Pickup address`
ORDER BY `Pickup count` DESC
LIMIT 5;


# Ride Price Analysis
-- Average, minimum, and maximum Ride Prices in January:
SELECT 
    AVG(`Ride price`) AS `Avg price`, 
    MIN(`Ride price`) AS `Min price`, 
    MAX(`Ride price`) AS `Max price`
FROM `bolt operations dataset`.january_2023;

-- Average, minimum, and maximum Ride Prices in February:
SELECT 
    AVG(`Ride price`) AS `Avg price`, 
    MIN(`Ride price`) AS `Min price`, 
    MAX(`Ride price`) AS `Max price`
FROM `bolt operations dataset`.february_2023;


-- Ride Price distribution in January (grouped by price ranges)
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

-- Ride Price distribution in February (grouped by price ranges)
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


-- Payment method preferences in January:
SELECT `Payment method`, COUNT(*) AS Paymentmethod_count
FROM `bolt operations dataset`.january_2023
GROUP BY `Payment method`
ORDER BY paymentmethod_count DESC;

-- Payment method preferences in February:
SELECT `Payment method`, COUNT(*) AS Paymentmethod_count
FROM `bolt operations dataset`.february_2023
GROUP BY `Payment method`
ORDER BY paymentmethod_count DESC;

-- Average, minimum, and maximum distance traveled in January:
SELECT 
    AVG(distance) AS avg_distance, 
    MIN(distance) AS min_distance, 
    MAX(distance) AS max_distance
FROM `bolt operations dataset`.january_2023;

-- Average, minimum, and maximum distance traveled in February:
SELECT 
    AVG(distance) AS avg_distance, 
    MIN(distance) AS min_distance, 
    MAX(distance) AS max_distance
FROM `bolt operations dataset`.february_2023;


# COMBINING THE TWO TABLES:
SELECT * FROM `bolt operations dataset`.january_2023
UNION ALL
SELECT * FROM `bolt operations dataset`.february_2023;

-- CREATING A NEW TABLE TO HOLD THE COMBINED DATA:
CREATE TABLE `bolt operations dataset`.combined_data AS
SELECT * FROM `bolt operations dataset`.january_2023
UNION ALL
SELECT * FROM `bolt operations dataset`.february_2023;

-- CONFIRMING THE NEW TABLE:
SELECT * FROM `bolt operations dataset`.combined_data;
