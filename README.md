# Credit Card Transaction Data Quality Analysis

## Project Overview

This project focuses on checking and improving the quality of a credit card transaction dataset using MySQL.

The goal is to identify data-quality issues, clean inconsistent data, validate the results, and prepare reliable data for analysis and reporting.

## Tools Used

* MySQL
* MySQL Workbench
* SQL

## SQL Skills Demonstrated

* Common Table Expressions (CTEs)
* Window Functions
* `ROW_NUMBER()`
* `CASE` statements
* `GROUP BY`
* Aggregate functions
* Filtering with `WHERE`
* Data validation
* Duplicate detection
* Data cleaning
* Data profiling

## Data Quality Checks

The analysis examines several areas of data quality, including:

* Missing customer information
* Missing names and surnames
* Missing or inconsistent gender values
* Duplicate records
* Transaction data validation
* Date and birthdate validation
* Merchant information
* Transaction categories
* Potential data inconsistencies

## Data Cleaning

The project uses SQL transformations to prepare cleaner data for analysis.

Examples include:

* Removing unnecessary spaces with `TRIM()`
* Standardizing text values
* Standardizing gender values
* Identifying missing and blank values
* Detecting duplicate records
* Validating transaction information
* Creating a cleaned transaction table

## Window Functions and ROW_NUMBER()

`ROW_NUMBER()` is used to identify potential duplicate records and examine repeated transactions.

Example:

```sql
ROW_NUMBER() OVER (
    PARTITION BY
        `Customer ID`,
        `Name`,
        `Surname`,
        `Transaction Amount`,
        `Merchant Name`,
        `Category`,
        `Transaction_Date`
    ORDER BY `Customer ID`
) AS row_num
```

Records where `row_num > 1` can then be investigated as potential duplicates.

## Data Quality Workflow

The project follows a basic data analyst workflow:

1. Explore the source data
2. Check the structure and columns
3. Check missing values
4. Check inconsistent values
5. Identify potential duplicates
6. Clean the data
7. Validate the cleaned data
8. Prepare the data for analysis and reporting

## Project Files

```text
credit card analysis/
│
├── customer_transaction_data_quality.sql
├── README.md
└── .gitignore
```

## Objective

The objective of this project is to demonstrate practical SQL skills for data analysis and data quality. The project shows how SQL can be used to identify problems in transactional data, apply cleaning rules, validate results, and prepare reliable data for business reporting.

## Key Skills

* SQL
* Data Cleaning
* Data Quality
* Data Validation
* CTEs
* Window Functions
* `ROW_NUMBER()`
* Data Analysis
* MySQL
* MySQL Workbench
