SELECT COUNT(*) AS total_rows
FROM credit_card_transaction_flow;

SHOW COLUMNS FROM credit_card_transaction_flow;

SELECT * FROM credit_card_transaction_flow
LIMIT 20;

SELECT COUNT(*) AS total_rows,
	SUM('Customer ID' IS NULL) AS missing_customer_id,
    SUM('Surname' IS NULL) AS missing_surname,
    SUM('NAME' IS NULL) AS missing_name,
    SUM('Gender' IS NULL) AS missing_gender,
    SUM('Birthdate' IS NULL) AS missing_birthdate,
     SUM('Transaction Amount' IS NULL) AS missing_Transaction,
    SUM('Date' IS NULL) AS missing_date,
     SUM('Merchant Name' IS NULL) AS missing_merchant,
    SUM('Category' IS NULL) AS missing_category, 
    SUM('Transaction_Date' IS NULL) AS missing_transaction_date
FROM credit_card_transaction_flow;

SELECT
	SUM(TRIM('Surname') = '') AS blank_surname,
    	SUM(TRIM('Gender') = '') AS blank_Gender,
        	SUM(TRIM('Merchant Name') = '') AS blank_merchant,
            	SUM(TRIM('Category') = '') AS blank_category
	FROM credit_card_transaction_flow;
    
    SELECT 
		MIN('Customer ID') AS mininum_customer_id,
        MAX('Customer ID') AS maximum_customer_id
        COUNT(*) AS total_rows,
        COUNT(DISTINCT 'Customer ID') as unique_customers
        FROM credit_card_transaction_flow;
        
        SELECT
    `Customer ID`,
    COUNT(*) AS transaction_count
FROM credit_card_transaction_flow
GROUP BY `Customer ID`
ORDER BY transaction_count DESC;

SELECT
    `Customer ID`,
    COUNT(*) AS transaction_count
FROM credit_card_transaction_flow
GROUP BY `Customer ID`
ORDER BY transaction_count DESC;

SELECT
    `Customer ID`,
    `Transaction Amount`,
    `Transaction_Date`,

    ROW_NUMBER() OVER (
        PARTITION BY `Customer ID`
        ORDER BY `Transaction_Date`
    ) AS row_num

FROM credit_card_transaction_flow;

WITH duplicate_check AS (

    SELECT
        `Customer ID`,
        `Transaction Amount`,
        `Merchant Name`,
        `Category`,
        `Transaction_Date`,

        ROW_NUMBER() OVER (
            PARTITION BY
                `Customer ID`,
                `Transaction Amount`,
                `Merchant Name`,
                `Category`,
                `Transaction_Date`

            ORDER BY `Customer ID`
        ) AS row_num

    FROM credit_card_transaction_flow
)
SELECT *
FROM duplicate_check
WHERE row_num > 1;

WITH duplicate_check AS (

    SELECT
        `Customer ID`,
        `Transaction Amount`,
        `Merchant Name`,
        `Category`,
        `Transaction_Date`,

        ROW_NUMBER() OVER (
            PARTITION BY
                `Customer ID`,
                `Transaction Amount`,
                `Merchant Name`,
                `Category`,
                `Transaction_Date`
            ORDER BY `Customer ID`
        ) AS row_num

    FROM credit_card_transaction_flow
)

SELECT
    COUNT(*) AS possible_duplicate_rows
FROM duplicate_check
WHERE row_num > 1;

SELECT
    `Gender`,
    COUNT(*) AS record_count
FROM credit_card_transaction_flow
GROUP BY `Gender`
ORDER BY record_count DESC;

WITH cleaned_gender AS (

    SELECT
        `Customer ID`,
        `Gender`,

        CASE
            WHEN UPPER(TRIM(`Gender`)) IN ('M', 'MALE')
                THEN 'Male'

            WHEN UPPER(TRIM(`Gender`)) IN ('F', 'FEMALE')
                THEN 'Female'

            WHEN `Gender` IS NULL
                OR TRIM(`Gender`) = ''
                THEN 'Missing'

            ELSE 'Unknown'
        END AS gender_clean

    FROM credit_card_transaction_flow
)

SELECT
    gender_clean,
    COUNT(*) AS record_count
FROM cleaned_gender
GROUP BY gender_clean;

SELECT
    MIN(`Transaction Amount`) AS minimum_amount,
    MAX(`Transaction Amount`) AS maximum_amount,
    AVG(`Transaction Amount`) AS average_amount,
    SUM(`Transaction Amount`) AS total_amount
FROM credit_card_transaction_flow;

SELECT *
FROM credit_card_transaction_flow
WHERE `Transaction Amount` < 0;

SELECT *
FROM credit_card_transaction_flow
WHERE `Transaction Amount` = 0;


SELECT
    AVG(`Transaction Amount`) AS average_amount,
    STDDEV(`Transaction Amount`) AS standard_deviation
FROM credit_card_transaction_flow;


WITH transaction_stats AS (

    SELECT
        AVG(`Transaction Amount`) AS avg_amount,
        STDDEV(`Transaction Amount`) AS std_amount
    FROM credit_card_transaction_flow

),

transaction_check AS (

    SELECT
        t.*,
        s.avg_amount,
        s.std_amount,

        CASE
            WHEN t.`Transaction Amount`
                 > s.avg_amount + (3 * s.std_amount)
                THEN 'Potential Outlier'

            ELSE 'Normal'
        END AS amount_status

    FROM credit_card_transaction_flow t
    CROSS JOIN transaction_stats s
)

SELECT *
FROM transaction_check
WHERE amount_status = 'Potential Outlier';

SELECT
    MIN(`Transaction_Date`) AS earliest_transaction,
    MAX(`Transaction_Date`) AS latest_transaction
FROM credit_card_transaction_flow;

SELECT *
FROM credit_card_transaction_flow
WHERE `Transaction_Date` IS NULL;

SELECT *
FROM credit_card_transaction_flow
WHERE `Transaction_Date` > CURRENT_DATE();

SELECT
    `Birthdate`,
    `Birthdate_Date`
FROM credit_card_transaction_flow
WHERE `Birthdate` IS NOT NULL
LIMIT 20;

SELECT COUNT(*) AS invalid_birthdates
FROM credit_card_transaction_flow
WHERE `Birthdate` IS NOT NULL
  AND `Birthdate_Date` IS NULL;
  
  SELECT *
FROM credit_card_transaction_flow
WHERE `Birthdate_Date` > CURRENT_DATE();

SELECT
    `Customer ID`,
    `Birthdate_Date`,
    TIMESTAMPDIFF(
        YEAR,
        `Birthdate_Date`,
        CURRENT_DATE()
    ) AS age
FROM credit_card_transaction_flow
LIMIT 20;


WITH age_check AS (

    SELECT
        `Customer ID`,
        `Birthdate_Date`,

        TIMESTAMPDIFF(
            YEAR,
            `Birthdate_Date`,
            CURRENT_DATE()
        ) AS age

    FROM credit_card_transaction_flow
)

SELECT *
FROM age_check
WHERE age < 18
   OR age > 100;
   
   SELECT
    `Category`,
    COUNT(*) AS transaction_count
FROM credit_card_transaction_flow
GROUP BY `Category`
ORDER BY transaction_count DESC;


WITH cleaned_category AS (

    SELECT
        `Category`,

        CASE
            WHEN `Category` IS NULL
                 OR TRIM(`Category`) = ''
                THEN 'Missing'

            ELSE UPPER(TRIM(`Category`))
        END AS category_clean

    FROM credit_card_transaction_flow
)

SELECT
    category_clean,
    COUNT(*) AS transaction_count
FROM cleaned_category
GROUP BY category_clean
ORDER BY transaction_count DESC;


WITH customer_transactions AS (

    SELECT
        `Customer ID`,
        `Transaction Amount`,
        `Merchant Name`,
        `Transaction_Date`,

        ROW_NUMBER() OVER (
            PARTITION BY `Customer ID`
            ORDER BY `Transaction_Date` DESC
        ) AS row_num

    FROM credit_card_transaction_flow
)

SELECT *
FROM customer_transactions
WHERE row_num = 1;

WITH customer_transactions AS (

    SELECT
        `Customer ID`,
        `Transaction Amount`,
        `Merchant Name`,
        `Transaction_Date`,

        ROW_NUMBER() OVER (
            PARTITION BY `Customer ID`
            ORDER BY `Transaction_Date` ASC
        ) AS row_num

    FROM credit_card_transaction_flow
)

SELECT *
FROM customer_transactions
WHERE row_num = 1;

SELECT
    `Customer ID`,
    `Transaction Amount`,
    `Transaction_Date`,

    ROW_NUMBER() OVER (
        PARTITION BY `Customer ID`
        ORDER BY `Transaction_Date`
    ) AS row_num,

    RANK() OVER (
        PARTITION BY `Customer ID`
        ORDER BY `Transaction Amount` DESC
    ) AS amount_rank,

    SUM(`Transaction Amount`) OVER (
        PARTITION BY `Customer ID`
    ) AS customer_total,

    AVG(`Transaction Amount`) OVER (
        PARTITION BY `Customer ID`
    ) AS customer_average

FROM credit_card_transaction_flow;

WITH quality_check AS (

    SELECT

        `Customer ID`,
        `Surname`,
        `Gender`,
        `Birthdate`,
        `Transaction Amount`,
        `Merchant Name`,
        `Category`,
        `Birthdate_Date`,
        `Transaction_Date`,

        ROW_NUMBER() OVER (
            PARTITION BY
                `Customer ID`,
                `Transaction Amount`,
                `Merchant Name`,
                `Category`,
                `Transaction_Date`
            ORDER BY `Customer ID`
        ) AS row_num,

        CASE
            WHEN `Customer ID` IS NULL
                THEN 'Missing Customer ID'

            WHEN `Transaction Amount` IS NULL
                THEN 'Missing Amount'

            WHEN `Transaction Amount` < 0
                THEN 'Negative Amount'

            WHEN `Transaction_Date` IS NULL
                THEN 'Missing Transaction Date'

            WHEN `Transaction_Date` > CURRENT_DATE()
                THEN 'Future Transaction Date'

            WHEN `Gender` IS NULL
                 OR TRIM(`Gender`) = ''
                THEN 'Missing Gender'

            ELSE 'OK'
        END AS quality_status

    FROM credit_card_transaction_flow
)

SELECT *
FROM quality_check
WHERE quality_status <> 'OK'
   OR row_num > 1;
   
   WITH quality_check AS (

    SELECT

        `Customer ID`,
        `Transaction Amount`,
        `Gender`,
        `Transaction_Date`,

        ROW_NUMBER() OVER (
            PARTITION BY
                `Customer ID`,
                `Transaction Amount`,
                `Merchant Name`,
                `Category`,
                `Transaction_Date`
            ORDER BY `Customer ID`
        ) AS row_num,

        CASE
            WHEN `Customer ID` IS NULL
                THEN 'Missing Customer ID'

            WHEN `Transaction Amount` IS NULL
                THEN 'Missing Amount'

            WHEN `Transaction Amount` < 0
                THEN 'Negative Amount'

            WHEN `Transaction_Date` IS NULL
                THEN 'Missing Transaction Date'

            WHEN `Transaction_Date` > CURRENT_DATE()
                THEN 'Future Transaction Date'

            WHEN `Gender` IS NULL
                 OR TRIM(`Gender`) = ''
                THEN 'Missing Gender'

            ELSE 'OK'
        END AS quality_status

    FROM credit_card_transaction_flow
)

SELECT
    quality_status,
    COUNT(*) AS record_count
FROM quality_check
GROUP BY quality_status
ORDER BY record_count DESC;


CREATE TABLE credit_card_transaction_clean AS

WITH cleaned_data AS (

    SELECT

        `Customer ID`,

        TRIM(`Name`) AS Name,

        TRIM(`Surname`) AS Surname,

        CASE
            WHEN UPPER(TRIM(`Gender`)) IN ('M', 'MALE')
                THEN 'Male'

            WHEN UPPER(TRIM(`Gender`)) IN ('F', 'FEMALE')
                THEN 'Female'

            WHEN `Gender` IS NULL
                 OR TRIM(`Gender`) = ''
                THEN 'Missing'

            ELSE 'Unknown'
        END AS Gender,

        `Birthdate`,

        `Birthdate_Date`,

        `Transaction Amount`,

        TRIM(`Merchant Name`) AS `Merchant Name`,

        UPPER(TRIM(`Category`)) AS Category,

        `gender_status`,

        `Transaction_Date`

    FROM credit_card_transaction_flow
)

SELECT *
FROM cleaned_data;

SELECT *
FROM credit_card_transaction_clean
LIMIT 20;

DROP TABLE IF EXISTS credit_card_transaction_clean;