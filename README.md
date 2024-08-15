# BOLT RIDE ANALYSIS

## Overview

*This is a project focused on analyzing Bolt ride operations data.*

![yellow-black-sign-taxi-placed-top-car-night](https://github.com/user-attachments/assets/883c4474-1304-42bf-b0d8-a7841e6d3763)

I used MySQL for data cleaning, formatting, and basic analysis, followed by Tableau for visualizing key metrics like revenue, peak hours, and payment preferences.

The key questions the project sought to answer regarding the specific bolt ride operations are:
1. What are the peak and off-peak hours for Bolt rides?
2. Which pickup locations are the most popular?
4. How does revenue vary across different days, and what trends can be observed over time?

## Table of Content
- [Data Processing](#data-processing)
- [Data Cleaning](#data-cleaning)
- [Basic Data Analysis](#basic-data-analysis)
- [Tableau Visualizations](#tableau-visualizations)

### Data Processing
- Sample Data:

I started by viewing the first 10 rows of data from both the January and February 2023 tables to get a quick look at what I was working with.

```sql
# Viewing Sample Data:
SELECT * FROM `bolt operations dataset`.january_2023 LIMIT 10;
SELECT * FROM `bolt operations dataset`.february_2023 LIMIT 10;
```

- Structure Overview:

I used the DESCRIBE command to view the column names, data types, and other details for each table.

- Rename Columns:

I identified and corrected a misnamed column (Order time) in both tables to ensure consistency and avoid issues in subsequent queries.

- Row Counts:

I counted the number of rows in each table to understand the size of the datasets.

- Missing Values:

I checked for missing values in key columns like Pickup address, tip, state, and distance for both January and February data. No missing values were found.

- Duplicate Values:

I searched for duplicate rows based on key identifiers (Pickup address and Payment time). No duplicates were found.

![MySQL1Capture](https://github.com/user-attachments/assets/de952b8a-6387-4a87-be5a-5e1fcbaecc1c)
![MySQL2Capture](https://github.com/user-attachments/assets/bbb42cf9-5ef4-4caa-b7aa-51a5eb7dbbf8)

### Data Cleaning:
- Removing Irrelevant Columns:

I removed columns like Cancellation fee, currency, toll fee, and state from both tables as they were not necessary for my analysis.

- Formatting Dates and Times:

I split the Order time and Payment time columns into separate Order date, Time of Order, Payment date, and Time of Payment columns for easier analysis.
After extracting the dates and times, I dropped the original combined columns.

![MySQL3Capture](https://github.com/user-attachments/assets/4e020c01-d844-4aa3-9946-de3f79dd75f0)
![MySQL4Capture](https://github.com/user-attachments/assets/df81846f-4f25-4f57-8b97-cd608ff34139)

### Basic Data Analysis:
- Revenue Analysis:

I calculated the total revenue by payment method for each month, as well as the total revenue per day.

- Peak Order Times:

I determined the most common hours for ride orders in both January and February.

- Popular Pickup Locations:

I identified the top 5 most common pickup locations for each month.

- Ride Price Analysis:

I calculated the average, minimum, and maximum ride prices for each month.

I also grouped the ride prices into ranges (e.g., under 200, 200-500, etc.) to understand the distribution of ride costs.

- Payment Method Preferences:

I examined the frequency of different payment methods used by customers in each month.

- Distance Analysis:

I computed the average, minimum, and maximum distances traveled by riders.

- Union of Tables:

I used a UNION ALL to combine the data from January and February into a single view.

- Creating a New Table:

I then created a new table called combined_data to permanently store the combined dataset for future analysis.

### Tableau Visualizations

You can view all the Tableau Visualizations [here!](https://public.tableau.com/views/BoltRideAnalytics/DASHBOARD?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

![Tableau Dashboard Capture](https://github.com/user-attachments/assets/dd449550-da29-4285-9d6f-188f6d3248a0)

In my Tableau dashboard for the Bolt operations project,

**I selected a combination of KPIs and charts that provide a comprehensive view of the key performance indicators and critical operational metrics.**

The KPIs — *total revenue, total distance covered, total rides, total days, and total amount of tips received* — serve as fundamental metrics that give an immediate understanding of overall performance. These KPIs are crucial for quickly assessing the effectiveness of operations and revenue generation.

For the visualizations, I used:

- Horizontal bar graphs to display the top 5 peak and off-peak hours, which are critical for understanding demand patterns and optimizing resource allocation.

- A histogram of revenue by payment method that offered insights into customer preferences, aiding in strategic decision-making related to payment processing.

- A treemap showing the top 5 popular pickup locations highlights key areas of demand, which is essential for targeted marketing and operational focus.

- Line graphs for revenue growth over time that provided a clear view of financial performance trends, which is invaluable for forecasting and strategic planning.

*These visualizations were chosen to offer both high-level insights and detailed analysis, making it easier to understand and act on the data.*

**Together, these steps formed a cohesive process demonstrating my ability to transform raw data into meaningful, actionable insights.**

*From the initial stages of data cleaning and preparation in MySQL to the advanced analysis and visualization in Tableau, this comprehensive approach highlights my proficiency in handling end-to-end projects, ensuring that every stage contributes to generating valuable insights that can drive informed decision-making.*
💙
