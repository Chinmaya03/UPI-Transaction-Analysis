-- =====================================================================
-- Prepared by: Chinmaya Panigrahi
-- Registration ID: 24CRD05066
-- UPI TRANSACTION ANALYSIS CAPSTONE PROJECT
-- Step 4: Data Ingestion into MySQL + Post-Load Validation
-- Prepared for: Adda247 Capstone Submission
-- Target DBMS: MySQL 8+ / MySQL Workbench
--
-- Purpose:
--   1. Load all seven validated CSV datasets into upi_capstone_db.
--   2. Standardize dates, booleans, categories and contextual NULL values.
--   3. Validate row counts and field mappings after ingestion.
--   4. Confirm referential integrity after loading.
--
-- IMPORTANT EXECUTION NOTES:
-- CSV paths below reflect the local development environment used
-- during project execution.
--   - Keep FOREIGN_KEY_CHECKS enabled throughout the load.
--   - Import tables in the order shown below.
--   - Validate each table's row count before proceeding.
--   - If LOCAL INFILE is disabled, an administrator may enable it with:
--         SET GLOBAL local_infile = 1;
--     and the client connection may also need LOCAL INFILE enabled.
--   - Do NOT hard-code passwords or credentials in this script.
-- =====================================================================


-- =====================================================================
-- 0. DATABASE / SESSION CHECKS
-- =====================================================================

USE upi_capstone_db;

-- Confirm that LOCAL INFILE is available.
SHOW VARIABLES LIKE 'local_infile';

-- Optional administrative command if LOCAL INFILE is disabled.
-- Uncomment only if you have the required privileges.
-- SET GLOBAL local_infile = 1;


-- =====================================================================
-- 1. CUSTOMER MASTER
-- Expected rows: 10,000
-- =====================================================================

LOAD DATA LOCAL INFILE '/Users/chinmayapanigrahi/Downloads/Career247_Data_Analytics_With_IBM/Capstone Project/UPI Transaction Analysis/Datasets_-_UPI_Transactions_Data_Analysis/customer_master.csv'
INTO TABLE customer_master
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @customer_id,
    @full_name,
    @mobile_number,
    @age,
    @gender,
    @region,
    @date_joined,
    @is_business_user,
    @risk_score
)
SET
    customer_id      = TRIM(@customer_id),
    full_name        = @full_name,
    mobile_number    = TRIM(@mobile_number),
    age              = CAST(@age AS UNSIGNED),
    gender           = LOWER(TRIM(@gender)),
    region           = LOWER(TRIM(@region)),
    date_joined      = STR_TO_DATE(TRIM(@date_joined), '%Y-%m-%d'),
    is_business_user = CASE
                           WHEN LOWER(TRIM(@is_business_user)) = 'true'  THEN 1
                           WHEN LOWER(TRIM(@is_business_user)) = 'false' THEN 0
                           ELSE NULL
                       END,
    risk_score       = CAST(@risk_score AS DECIMAL(5,4));

SELECT COUNT(*) AS customer_master_rows
FROM customer_master;


-- =====================================================================
-- 2. MERCHANT INFO
-- Expected rows: 500
-- =====================================================================

LOAD DATA LOCAL INFILE '/Users/chinmayapanigrahi/Downloads/Career247_Data_Analytics_With_IBM/Capstone Project/UPI Transaction Analysis/Datasets_-_UPI_Transactions_Data_Analysis/merchant_info.csv'
INTO TABLE merchant_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @merchant_id,
    @merchant_name,
    @merchant_type,
    @region,
    @onboard_date,
    @risk_score
)
SET
    merchant_id   = TRIM(@merchant_id),
    merchant_name = @merchant_name,
    merchant_type = LOWER(TRIM(@merchant_type)),
    region        = LOWER(TRIM(@region)),
    onboard_date  = STR_TO_DATE(TRIM(@onboard_date), '%Y-%m-%d'),
    risk_score    = CAST(@risk_score AS DECIMAL(5,4));

SELECT COUNT(*) AS merchant_info_rows
FROM merchant_info;


-- =====================================================================
-- 3. DEVICE INFO
-- Expected rows: 12,000
-- =====================================================================

LOAD DATA LOCAL INFILE '/Users/chinmayapanigrahi/Downloads/Career247_Data_Analytics_With_IBM/Capstone Project/UPI Transaction Analysis/Datasets_-_UPI_Transactions_Data_Analysis/device_info.csv'
INTO TABLE device_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @device_id,
    @customer_id,
    @device_type,
    @app_version,
    @is_rooted,
    @last_active
)
SET
    device_id   = TRIM(@device_id),
    customer_id = TRIM(@customer_id),
    device_type = LOWER(TRIM(@device_type)),
    app_version = TRIM(@app_version),
    is_rooted   = CASE
                      WHEN LOWER(TRIM(@is_rooted)) = 'true'  THEN 1
                      WHEN LOWER(TRIM(@is_rooted)) = 'false' THEN 0
                      ELSE NULL
                  END,
    last_active = STR_TO_DATE(TRIM(@last_active), '%Y-%m-%d %H:%i:%s.%f');

SELECT COUNT(*) AS device_info_rows
FROM device_info;


-- =====================================================================
-- 4. UPI ACCOUNT DETAILS
-- Expected rows: 12,000
-- =====================================================================

LOAD DATA LOCAL INFILE '/Users/chinmayapanigrahi/Downloads/Career247_Data_Analytics_With_IBM/Capstone Project/UPI Transaction Analysis/Datasets_-_UPI_Transactions_Data_Analysis/upi_account_details.csv'
INTO TABLE upi_account_details
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @upi_id,
    @customer_id,
    @bank_name,
    @account_type,
    @date_added,
    @status
)
SET
    upi_id       = TRIM(@upi_id),
    customer_id  = TRIM(@customer_id),
    bank_name    = LOWER(TRIM(@bank_name)),
    account_type = LOWER(TRIM(@account_type)),
    date_added   = STR_TO_DATE(TRIM(@date_added), '%Y-%m-%d'),
    status       = LOWER(TRIM(@status));

SELECT COUNT(*) AS upi_account_details_rows
FROM upi_account_details;


-- =====================================================================
-- 5. UPI TRANSACTION HISTORY
-- Expected rows: 100,000
--
-- Context-aware NULL treatment:
--   merchant_id     -> NULL when not applicable to the transaction type.
--   failure_reason  -> NULL when the transaction did not fail.
-- =====================================================================

LOAD DATA LOCAL INFILE '/Users/chinmayapanigrahi/Downloads/Career247_Data_Analytics_With_IBM/Capstone Project/UPI Transaction Analysis/Datasets_-_UPI_Transactions_Data_Analysis/upi_transaction_history.csv'
INTO TABLE upi_transaction_history
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @transaction_id,
    @upi_id,
    @customer_id,
    @timestamp,
    @amount,
    @transaction_type,
    @merchant_id,
    @counterparty_upi,
    @status,
    @device_id,
    @device_type,
    @channel,
    @fraud_flag,
    @reversal_flag,
    @failure_reason
)
SET
    transaction_id  = TRIM(@transaction_id),
    upi_id           = TRIM(@upi_id),
    customer_id      = TRIM(@customer_id),
    `timestamp`      = STR_TO_DATE(TRIM(@timestamp), '%Y-%m-%d %H:%i:%s.%f'),
    amount           = CAST(@amount AS DECIMAL(12,2)),
    transaction_type = LOWER(TRIM(@transaction_type)),
    merchant_id      = NULLIF(TRIM(@merchant_id), ''),
    counterparty_upi = TRIM(@counterparty_upi),
    status           = LOWER(TRIM(@status)),
    device_id        = TRIM(@device_id),
    device_type      = LOWER(TRIM(@device_type)),
    channel          = LOWER(TRIM(@channel)),
    fraud_flag       = CASE
                           WHEN LOWER(TRIM(@fraud_flag)) = 'true'  THEN 1
                           WHEN LOWER(TRIM(@fraud_flag)) = 'false' THEN 0
                           ELSE NULL
                       END,
    reversal_flag    = CASE
                           WHEN LOWER(TRIM(@reversal_flag)) = 'true'  THEN 1
                           WHEN LOWER(TRIM(@reversal_flag)) = 'false' THEN 0
                           ELSE NULL
                       END,
    failure_reason   = NULLIF(TRIM(@failure_reason), '');

SELECT COUNT(*) AS upi_transaction_history_rows
FROM upi_transaction_history;


-- =====================================================================
-- 6. CUSTOMER FEEDBACK SURVEYS
-- Expected rows: 4,000
-- =====================================================================

LOAD DATA LOCAL INFILE '/Users/chinmayapanigrahi/Downloads/Career247_Data_Analytics_With_IBM/Capstone Project/UPI Transaction Analysis/Datasets_-_UPI_Transactions_Data_Analysis/customer_feedback_surveys.csv'
INTO TABLE customer_feedback_surveys
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @feedback_id,
    @customer_id,
    @date_submitted,
    @feedback_text,
    @satisfaction_score,
    @issue_type,
    @resolved
)
SET
    feedback_id        = TRIM(@feedback_id),
    customer_id        = TRIM(@customer_id),
    date_submitted     = STR_TO_DATE(TRIM(@date_submitted), '%Y-%m-%d'),
    feedback_text      = NULLIF(@feedback_text, ''),
    satisfaction_score = CAST(@satisfaction_score AS UNSIGNED),
    issue_type         = LOWER(TRIM(@issue_type)),
    resolved           = CASE
                             WHEN LOWER(TRIM(@resolved)) = 'true'  THEN 1
                             WHEN LOWER(TRIM(@resolved)) = 'false' THEN 0
                             ELSE NULL
                         END;

SELECT COUNT(*) AS customer_feedback_surveys_rows
FROM customer_feedback_surveys;


-- =====================================================================
-- 7. FRAUD ALERT HISTORY
-- Expected rows: 2,000
--
-- Context-aware NULL treatment:
--   resolution_date -> NULL when the alert is unresolved.
-- =====================================================================

LOAD DATA LOCAL INFILE '/Users/chinmayapanigrahi/Downloads/Career247_Data_Analytics_With_IBM/Capstone Project/UPI Transaction Analysis/Datasets_-_UPI_Transactions_Data_Analysis/fraud_alert_history.csv'
INTO TABLE fraud_alert_history
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @alert_id,
    @transaction_id,
    @alert_type,
    @alert_date,
    @resolved,
    @resolution_date,
    @remarks
)
SET
    alert_id        = TRIM(@alert_id),
    transaction_id  = TRIM(@transaction_id),
    alert_type      = LOWER(TRIM(@alert_type)),
    alert_date      = STR_TO_DATE(TRIM(@alert_date), '%Y-%m-%d %H:%i:%s.%f'),
    resolved        = CASE
                          WHEN LOWER(TRIM(@resolved)) = 'true'  THEN 1
                          WHEN LOWER(TRIM(@resolved)) = 'false' THEN 0
                          ELSE NULL
                      END,
    resolution_date = STR_TO_DATE(
                          NULLIF(TRIM(@resolution_date), ''),
                          '%Y-%m-%d %H:%i:%s.%f'
                      ),
    remarks         = NULLIF(@remarks, '');

SELECT COUNT(*) AS fraud_alert_history_rows
FROM fraud_alert_history;


-- =====================================================================
-- 8. FINAL ROW COUNT VALIDATION
-- Expected total across all seven tables: 140,500
-- =====================================================================

SELECT 'customer_master' AS table_name, COUNT(*) AS row_count
FROM customer_master
UNION ALL
SELECT 'merchant_info', COUNT(*)
FROM merchant_info
UNION ALL
SELECT 'device_info', COUNT(*)
FROM device_info
UNION ALL
SELECT 'upi_account_details', COUNT(*)
FROM upi_account_details
UNION ALL
SELECT 'upi_transaction_history', COUNT(*)
FROM upi_transaction_history
UNION ALL
SELECT 'customer_feedback_surveys', COUNT(*)
FROM customer_feedback_surveys
UNION ALL
SELECT 'fraud_alert_history', COUNT(*)
FROM fraud_alert_history;


-- Optional total-record validation.
SELECT
    (SELECT COUNT(*) FROM customer_master)
  + (SELECT COUNT(*) FROM merchant_info)
  + (SELECT COUNT(*) FROM device_info)
  + (SELECT COUNT(*) FROM upi_account_details)
  + (SELECT COUNT(*) FROM upi_transaction_history)
  + (SELECT COUNT(*) FROM customer_feedback_surveys)
  + (SELECT COUNT(*) FROM fraud_alert_history)
    AS total_project_rows;

-- Expected result: 140500


-- =====================================================================
-- 9. SAMPLE / FIELD-MAPPING SPOT CHECKS
-- =====================================================================

SELECT * FROM customer_master
ORDER BY customer_id
LIMIT 5;

SELECT * FROM merchant_info
ORDER BY merchant_id
LIMIT 5;

SELECT * FROM device_info
ORDER BY device_id
LIMIT 5;

SELECT * FROM upi_account_details
ORDER BY upi_id
LIMIT 5;

SELECT * FROM upi_transaction_history
ORDER BY transaction_id
LIMIT 5;

SELECT * FROM customer_feedback_surveys
ORDER BY feedback_id
LIMIT 5;

SELECT * FROM fraud_alert_history
ORDER BY alert_id
LIMIT 5;


-- =====================================================================
-- 10. DATA-TYPE / TRANSFORMATION VALIDATION
-- =====================================================================

-- 10.1 Confirm leading-zero mobile numbers were preserved as text.
SELECT
    customer_id,
    mobile_number
FROM customer_master
WHERE mobile_number LIKE '0%'
LIMIT 10;


-- 10.2 Confirm Boolean conversions resulted in 0/1 values.
SELECT
    MIN(is_business_user) AS min_business_flag,
    MAX(is_business_user) AS max_business_flag
FROM customer_master;

SELECT
    MIN(is_rooted) AS min_rooted_flag,
    MAX(is_rooted) AS max_rooted_flag
FROM device_info;

SELECT
    MIN(fraud_flag) AS min_fraud_flag,
    MAX(fraud_flag) AS max_fraud_flag,
    MIN(reversal_flag) AS min_reversal_flag,
    MAX(reversal_flag) AS max_reversal_flag
FROM upi_transaction_history;


-- =====================================================================
-- 11. CONTEXTUAL NULL VALIDATION
-- Expected from the validated source data:
--   transaction merchant_id NULLs:      69,851
--   transaction failure_reason NULLs:   94,129
--   fraud alert resolution_date NULLs:     248
-- =====================================================================

SELECT
    SUM(merchant_id IS NULL) AS null_merchant_id,
    SUM(failure_reason IS NULL) AS null_failure_reason
FROM upi_transaction_history;

SELECT
    SUM(resolution_date IS NULL) AS null_resolution_date
FROM fraud_alert_history;


-- Optional context checks.
SELECT
    transaction_type,
    SUM(merchant_id IS NULL) AS null_merchant_ids,
    COUNT(*) AS total_transactions
FROM upi_transaction_history
GROUP BY transaction_type
ORDER BY transaction_type;

SELECT
    status,
    SUM(failure_reason IS NULL) AS null_failure_reasons,
    COUNT(*) AS total_transactions
FROM upi_transaction_history
GROUP BY status
ORDER BY status;

SELECT
    resolved,
    SUM(resolution_date IS NULL) AS null_resolution_dates,
    COUNT(*) AS total_alerts
FROM fraud_alert_history
GROUP BY resolved
ORDER BY resolved;


-- =====================================================================
-- 12. POST-LOAD FOREIGN-KEY CONSISTENCY CHECKS
-- Every query below should return 0.
-- =====================================================================

-- device_info.customer_id -> customer_master.customer_id
SELECT COUNT(*) AS orphan_device_customer
FROM device_info d
LEFT JOIN customer_master c
    ON d.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- upi_account_details.customer_id -> customer_master.customer_id
SELECT COUNT(*) AS orphan_upi_customer
FROM upi_account_details u
LEFT JOIN customer_master c
    ON u.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- upi_transaction_history.customer_id -> customer_master.customer_id
SELECT COUNT(*) AS orphan_transaction_customer
FROM upi_transaction_history t
LEFT JOIN customer_master c
    ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- customer_feedback_surveys.customer_id -> customer_master.customer_id
SELECT COUNT(*) AS orphan_feedback_customer
FROM customer_feedback_surveys f
LEFT JOIN customer_master c
    ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- upi_transaction_history.merchant_id -> merchant_info.merchant_id
-- merchant_id is nullable; NULL rows are not treated as orphans.
SELECT COUNT(*) AS orphan_transaction_merchant
FROM upi_transaction_history t
LEFT JOIN merchant_info m
    ON t.merchant_id = m.merchant_id
WHERE t.merchant_id IS NOT NULL
  AND m.merchant_id IS NULL;


-- upi_transaction_history.upi_id -> upi_account_details.upi_id
SELECT COUNT(*) AS orphan_transaction_upi
FROM upi_transaction_history t
LEFT JOIN upi_account_details u
    ON t.upi_id = u.upi_id
WHERE u.upi_id IS NULL;


-- upi_transaction_history.device_id -> device_info.device_id
SELECT COUNT(*) AS orphan_transaction_device
FROM upi_transaction_history t
LEFT JOIN device_info d
    ON t.device_id = d.device_id
WHERE d.device_id IS NULL;


-- fraud_alert_history.transaction_id -> upi_transaction_history.transaction_id
SELECT COUNT(*) AS orphan_alert_transaction
FROM fraud_alert_history a
LEFT JOIN upi_transaction_history t
    ON a.transaction_id = t.transaction_id
WHERE t.transaction_id IS NULL;


-- =====================================================================
-- EXPECTED POST-LOAD SUMMARY
--   customer_master:              10,000
--   merchant_info:                   500
--   device_info:                  12,000
--   upi_account_details:          12,000
--   upi_transaction_history:     100,000
--   customer_feedback_surveys:     4,000
--   fraud_alert_history:            2,000
--   ---------------------------------------------------------------
--   Total:                       140,500
--
--   Expected orphan counts: 0 for all eight FK checks.
-- =====================================================================
