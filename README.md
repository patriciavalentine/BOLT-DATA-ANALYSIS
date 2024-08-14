# BOLT-DATA-ANALYSIS

## Step-by-Step Explanation of Data Processing and Analysis

### Viewing Sample Data and Understanding Structure:
- Sample Data: I started by viewing the first 10 rows of data from both the January and February 2023 tables to get a quick look at what I was working with.
- Structure Overview: I used the DESCRIBE command to view the column names, data types, and other details for each table.

#### Correcting Column Names:
- Rename Columns: I identified and corrected a misnamed column (Order time) in both tables to ensure consistency and avoid issues in subsequent queries.

### Row Count and Data Integrity Checks:
- Row Counts: I counted the number of rows in each table to understand the size of the datasets.
- Missing Values: I checked for missing values in key columns like Pickup address, tip, state, and distance for both January and February data. No missing values were found.
- Duplicate Values: I searched for duplicate rows based on key identifiers (Pickup address and Payment time). No duplicates were found.

### Cleaning the Data:
- Removing Irrelevant Columns: I removed columns like Cancellation fee, currency, toll fee, and state from both tables as they were not necessary for my analysis.
- Formatting Dates and Times:
I split the Order time and Payment time columns into separate Order date, Time of Order, Payment date, and Time of Payment columns for easier analysis.
After extracting the dates and times, I dropped the original combined columns.

### Basic Data Analysis:
- Revenue Analysis: I calculated the total revenue by payment method for each month, as well as the total revenue per day.
- Peak Order Times: I determined the most common hours for ride orders in both January and February.
- Popular Pickup Locations: I identified the top 5 most common pickup locations for each month.
- Ride Price Analysis:
I calculated the average, minimum, and maximum ride prices for each month.

I also grouped the ride prices into ranges (e.g., under 200, 200-500, etc.) to understand the distribution of ride costs.
- Payment Method Preferences: I examined the frequency of different payment methods used by customers in each month.
- Distance Analysis: I computed the average, minimum, and maximum distances traveled by riders.

### Combining Data from Both Months:
- Union of Tables: I used a UNION ALL to combine the data from January and February into a single view.
- Creating a New Table: I then created a new table called combined_data to permanently store the combined dataset for future analysis.
