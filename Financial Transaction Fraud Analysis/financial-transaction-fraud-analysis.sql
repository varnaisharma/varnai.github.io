# Creating table 
CREATE TABLE paysim_transactions (
    step INT,
    type VARCHAR(20),
    amount DECIMAL(20,2),
    nameOrig VARCHAR(50),
    oldbalanceOrg DECIMAL(20,2),
    newbalanceOrig DECIMAL(20,2),
    nameDest VARCHAR(50),
    oldbalanceDest DECIMAL(20,2),
    newbalanceDest DECIMAL(20,2),
    isFraud TINYINT,
    isFlaggedFraud TINYINT
);

# Uploading data into the table
SET GLOBAL local_infile = ON;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

USE sqlpractice_schema;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/paysim_transactions.csv'
INTO TABLE paysim_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

## Data Quality Check

# Total number of transactions
SELECT COUNT(*) AS total_transactions
FROM paysim_transactions;

# Checking transaction type
SELECT
    type,
    COUNT(*) AS transaction_count
FROM paysim_transactions
GROUP BY type
ORDER BY transaction_count DESC;

# Checking null values
SELECT
   SUM(step IS NULL) AS null_step,
   SUM(type IS NULL) AS null_type,
   SUM(amount IS NULL) AS null_amount,
   SUM(nameOrig IS NULL) AS null_nameOrig,
   SUM(oldbalanceOrg IS NULL) AS null_oldbalanceOrg,
   SUM(newbalanceOrig IS NULL) AS null_newbalanceOrg,
   SUM(isFraud IS NULL) AS null_isFraud,
   SUM(isFlaggedFraud) AS null_isFlaggedFraud
FROM paysim_transactions;

# Found 32 null values in null_isFlaggedFraud

SELECT
   COUNT(*) AS total_transactions,
   SUM(isFlaggedFraud IS NULL) AS null_flagged,
   ROUND(
		100.0 * SUM(isFlaggedFraud IS NULL) / COUNT(*),
        4
	) AS null_percentage
FROM paysim_transactions;

## Overall Fraud Exposure

SELECT
   COUNT(*) AS total_transactions,
   SUM(isFraud = 1) AS fraudulent_transactions,
   SUM(isFraud = 0) AS non_fradulent_transactions
FROM paysim_transactions;

# Fraud Rate
SELECT
   COUNT(*) AS total_transactions,
   SUM(isFraud = 1) AS fraudulent_transactions,
   ROUND(
      100.0 * SUM(isFraud = 1) / COUNT(*),
      4
	) AS fraud_rate_percentage
FROM paysim_transactions;

#Financial Exposure
SELECT
    ROUND(SUM(amount),2) AS total_transaction_value,
    ROUND(SUM(CASE WHEN isFRAUD = 1 THEN amount ELSE 0 END), 2) AS total_fraud_value,
    ROUND(AVG(CASE WHEN isFraud = 1 THEN amount END), 2) AS average_fraud_amount
FROM paysim_transactions;

#Fraud value as a percentage of transaction value
SELECT
   ROUND(
       100.0 *
       SUM(CASE WHEN isFraud = 1 THEN amount ELSE 0 END)
       / SUM(amount),
       4
	) AS fraud_value_percentage
FROM paysim_transactions;

# Fraud by Transaction Type

SELECT
   type,
   COUNT(*) AS total_transactions,
   SUM(isFraud = 1) AS fraudulent_transactions,
   ROUND(
       100.0 * SUM(isFraud = 1) / COUNT(*),
       4
	) AS fraud_rate_percentage
FROM paysim_transactions
GROUP BY type
ORDER BY fraud_rate_percentage DESC;

#Fraud contribution
SELECT
   type,
   SUM(isFraud = 1) AS fraudulent_transactions,
   ROUND(
	  100.0 * SUM(isFraud = 1) /
      (SELECT SUM(isFraud = 1) FROM paysim_transactions),
      2
	) AS percentage_of_all_fraud
FROM paysim_transactions
GROUP BY type
ORDER BY percentage_of_all_fraud DESC;

## Fraud by Transaction Amount

# Comparing fraud VS non-fraud transaction amounts

SELECT
   CASE
      WHEN isFraud = 1 THEN 'Fraud'
      ELSE 'Non Fraud'
	END AS transaction_status,
    COUNT(*) AS transactions,
    ROUND(AVG(amount), 2) AS avg_transaction_amount,
    ROUND(MIN(amount), 2) AS min_transaction_amount,
    ROUND(MAX(amount), 2) AS max_transaction_amount
FROM paysim_transactions
GROUP BY isFraud;

# Creating transaction amount bands
SELECT
   CASE
      WHEN amount < 1000 THEN '< 1K'
      WHEN amount < 10000 THEN '1K - 10K'
      WHEN amount < 50000 THEN '10K - 50k'
      WHEN amount < 100000 THEN '50k - 100k'
      WHEN amount < 200000 THEN '100k - 200k'
      ELSE '200K+'
	END AS amount_band,
    
    COUNT(*) AS total_transactions,
    SUM(isFraud = 1) AS fradulent_transactions,
    
    ROUND(
        100.0 * SUM(isFraud = 1) / COUNT(*),
        4
	  ) AS fraud_rate_percentage
FROM paysim_transactions

GROUP BY
    CASE
    WHEN amount < 1000 THEN '< 1K'
    WHEN amount < 10000 THEN '1K - 10K'
    WHEN amount < 50000 THEN '10K - 50K'
    WHEN amount < 100000 THEN '50K - 100K'
    WHEN amount < 200000 THEN '100K - 200K'
    ELSE '200K+'
  END

ORDER BY MIN(amount);

# Measure financial exposure by amount band

SELECT
   CASE
      WHEN amount < 1000 THEN '< 1K'
      WHEN amount < 10000 THEN '1K - 10K'
      WHEN amount < 50000 THEN '10K - 50K'
      WHEN amount < 100000 THEN '50K - 100K'
      WHEN amount < 200000 THEN '100K - 200K'
      ELSE '200K+'
	END AS amount_band,
    
    SUM(isFraud = 1) AS fraudulent_transactions,
    ROUND(
        SUM(CASE WHEN isFraud = 1 THEN amount ELSE 0 END),
        2
	) AS fraud_value,
    
    ROUND(
        AVG(CASE WHEN isFraud = 1 THEN amount END),
        2
	) AS avg_fraud_amount
    
FROM paysim_transactions

GROUP BY
     CASE
        WHEN amount <1000 THEN '< 1K'
        WHEN amount < 10000 THEN '1K - 10K'
        WHEN amount < 50000 THEN '10K - 50K'
        WHEN amount < 100000 THEN '50K - 100K'
        WHEN amount < 200000 THEN '100K - 200K'
        ELSE '200K+'
	END
ORDER BY fraud_value DESC;

## Fraud by Time

#Transactions by hour
SELECT
   MOD(step - 1, 24) AS transaction_hour,
   COUNT(*) AS transaction_count,
   SUM(isFraud = 1) AS fraud_count,
   ROUND(
       100 * SUM(isFraud = 1) / COUNT(*),
       4
	) AS fraud_rate
FROM paysim_transactions
GROUP BY transaction_hour
ORDER BY fraud_rate DESC;

#Fraud amount by hour
SELECT
   MOD(step - 1, 24) AS transaction_hour,
   SUM(isFraud = 1) AS fraud_count,
   ROUND(
       SUM(CASE WHEN isFraud = 1 THEN amount ELSE 0 END),
       2
	) AS fraud_value,
    ROUND(
         AVG(CASE WHEN isFraud = 1 THEN amount END),
         2
	) AS avg_fraud_amount
FROM paysim_transactions
GROUP BY transaction_hour
ORDER BY fraud_count DESC;

#Fraud by day
SELECT
    FLOOR((step - 1) / 24) + 1 AS day_number,
    COUNT(*) AS transaction_count,
    SUM(isFraud = 1) AS fraud_count,
    ROUND(
         100 * SUM(isFraud = 1) / COUNT(*),
         4
	) AS fraud_rate
FROM paysim_transactions
GROUP BY day_number
ORDER BY fraud_rate DESC;

# Fraud by time period
SELECT
    CASE
       WHEN MOD(step - 1, 24) < 6 THEN 'Night'
       WHEN MOD(step - 1, 24) < 12 THEN 'Morning'
       WHEN MOD(step - 1, 24) < 18 THEN 'Afternoon'
       ELSE 'Evening'
	END AS time_period,
    COUNT(*) AS transaction_count,
    SUM(isFraud = 1) AS fraud_count,
    ROUND(
        100 * SUM(isFraud = 1) / COUNT(*),
        4
	) AS fraud_rate
FROM paysim_transactions
GROUP BY time_period
ORDER BY fraud_rate DESC;

# Fraud VS Monitoring flag
SELECT
   isFraud,
   isFlaggedFraud,
   COUNT(*) AS transaction_count
FROM paysim_transactions
GROUP BY isFraud, isFlaggedFraud
ORDER BY isFraud DESC, isFlaggedFraud DESC;

# Monitoring Performance
SELECT
    SUM(isFraud = 1 AND isFlaggedFraud = 1) AS true_positive,
    SUM(isFraud = 1 AND isFlaggedFraud = 0) AS false_negative,
    SUM(isFraud = 0 AND isFlaggedFraud = 1) AS false_positive,
    SUM(isFraud = 0 AND isFlaggedFraud = 0) AS true_negative
FROM paysim_transactions;

# Fraud detection rate
SELECT
    ROUND(
        100 * SUM(isFraud = 1 AND isFlaggedFraud = 1)
        / SUM(isFraud = 1),
        2
	) AS fraud_detection_rate
FROM paysim_transactions;

# Missed fraud rate
SELECT
    ROUND(
        100 * SUM(isFraud = 1 AND isFlaggedFraud = 0)
        / SUM(isFraud = 1),
        2
	) AS missed_fraud_rate
FROM paysim_transactions;

## Missed Fraud Analysis

# Missed fraud by transaction type
SELECT
    type,
    COUNT(*) AS missed_fraud_count,
    ROUND(SUM(amount), 2) AS missed_fraud_value,
    ROUND(AVG(amount), 2) AS avg_missed_fraud_amount
FROM paysim_transactions
WHERE isFraud = 1
  AND isFlaggedFraud = 0
GROUP BY type
ORDER BY missed_fraud_count DESC;

# Missed fraud by amount band
SELECT
   CASE
      WHEN amount < 1000 THEN '< 1K'
      WHEN amount < 10000 THEN '1K - 10K'
      WHEN amount < 20000 THEN '10K - 20K'
      WHEN amount < 50000 THEN '20K - 50K'
      WHEN amount < 100000 THEN '50K - 100K'
      WHEN amount < 200000 THEN '100K - 200K'
      ELSE '200K+'
	END AS amount_band,
    COUNT(*) AS missed_fraud_count,
    ROUND(SUM(amount),2) AS missed_fraud_value
FROM paysim_transactions
WHERE isFraud = 1
  AND isFlaggedFraud = 0
GROUP BY amount_band
ORDER BY missed_fraud_value DESC;

# Missed fraud by hour
SELECT
   MOD(step - 1, 24) AS transaction_hour,
   COUNT(*) AS missed_fraud_count,
   ROUND(SUM(amount), 2) AS missed_fraud_value
FROM paysim_transactions
WHERE isFraud = 1
  AND isFlaggedFraud = 0
GROUP BY transaction_hour
ORDER BY missed_fraud_value DESC;

## Fraud Behaviour Analysis

# Fraud by origin account
SELECT
    nameOrig,
    COUNT(*) AS transaction_count,
    SUM(isFraud = 1) AS fraud_count,
    ROUND(SUM(amount), 2) AS total_transaction_value,
    ROUND(
        SUM(CASE WHEN isFraud = 1 THEN amount ELSE 0 END),
        2
	) AS fraud_value
FROM paysim_transactions
GROUP BY nameOrig
HAVING fraud_count > 0
ORDER BY fraud_count DESC;

# Accounts with multiple fradulent transactions
SELECT
   nameOrig,
   COUNT(*) AS fraud_count,
   ROUND(SUM(amount), 2) AS total_fraud_value,
   ROUND(AVG(amount), 2) AS avg_fraud_amount
FROM paysim_transactions
WHERE isFraud = 1
GROUP BY nameOrig
HAVING COUNT(*) > 1
ORDER BY fraud_count DESC;

# Fraud by transaction type + hour
SELECT
   type,
   MOD(step - 1, 24) AS transaction_hour,
   COUNT(*) AS transaction_count,
   SUM(isFraud = 1) AS fraud_count,
   ROUND(
       100 * SUM(isFraud = 1) / COUNT(*),
       4
	) AS fraud_rate
FROM paysim_transactions
GROUP BY type, transaction_hour
HAVING fraud_count > 0
ORDER BY fraud_rate DESC;

## Balance/Transaction Consistency Analysis

# Origin balance change
SELECT
    type,
    ROUND(
         AVG(oldbalanceOrg - newbalanceOrig),
         2
	) AS avg_origin_balance_change,
    ROUND(
         AVG(amount),
         2
	) AS avg_transaction_amount
FROM paysim_transactions
GROUP BY type;

# Origin balance consistency
SELECT
    type,
    COUNT(*) AS transactions,
    SUM(
       ABS((oldbalanceOrg - amount) - newbalanceOrig) > 0.01
	) AS balance_mismatch_count
FROM paysim_transactions
GROUP BY type;
