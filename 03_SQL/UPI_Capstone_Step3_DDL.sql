-- =====================================================================
-- Prepared by: Chinmaya Panigrahi
-- Registration ID: 24CRD05066
-- UPI TRANSACTION ANALYSIS CAPSTONE PROJECT
-- Step 3: Database Design and Table Creation (MySQL DDL)

-- Purpose:
--   1. Create the capstone database and seven relational tables.
--   2. Apply primary-key, foreign-key, NOT NULL and CHECK constraints.
--   3. Preserve nullable business-context fields where appropriate.
--   4. Run validation queries to confirm schema structure and integrity.
--

-- =====================================================================

-- =====================================================================
-- 0. DATABASE SETUP
-- =====================================================================

CREATE DATABASE IF NOT EXISTS upi_capstone_db;
USE upi_capstone_db;

-- =====================================================================
-- 1. CUSTOMER MASTER
-- =====================================================================

CREATE TABLE customer_master (
    customer_id        VARCHAR(20)  NOT NULL,
    full_name          VARCHAR(100) NOT NULL,
    age                INT          NOT NULL,
    gender             VARCHAR(10)  NOT NULL,
    region             VARCHAR(20)  NOT NULL,
    date_joined        DATE         NOT NULL,
    is_business_user   BOOLEAN      NOT NULL,
    risk_score         DECIMAL(5,4) NOT NULL,
    mobile_number      VARCHAR(10)  NOT NULL,

    CONSTRAINT pk_customer_master
        PRIMARY KEY (customer_id),

    CONSTRAINT chk_customer_gender
        CHECK (gender IN ('male', 'female', 'other')),

    CONSTRAINT chk_customer_risk_score
        CHECK (risk_score BETWEEN 0 AND 1),

    CONSTRAINT chk_customer_mobile_number
        CHECK (mobile_number REGEXP '^[0-9]{10}$')
);

-- =====================================================================
-- 2. DEVICE INFO
-- =====================================================================

CREATE TABLE device_info (
    device_id      VARCHAR(20) NOT NULL,
    customer_id    VARCHAR(20) NOT NULL,
    device_type    VARCHAR(20) NOT NULL,
    app_version    VARCHAR(20) NOT NULL,
    is_rooted      BOOLEAN     NOT NULL,
    last_active    DATETIME(6) NOT NULL,

    CONSTRAINT pk_device_info
        PRIMARY KEY (device_id),

    CONSTRAINT fk_device_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer_master(customer_id),

    CONSTRAINT chk_device_type
        CHECK (device_type IN ('android', 'ios', 'tablet', 'feature_phone'))
);

-- =====================================================================
-- 3. UPI ACCOUNT DETAILS
-- =====================================================================

CREATE TABLE upi_account_details (
    upi_id          VARCHAR(100) NOT NULL,
    customer_id     VARCHAR(20)  NOT NULL,
    bank_name       VARCHAR(50)  NOT NULL,
    account_type    VARCHAR(30)  NOT NULL,
    date_added      DATE         NOT NULL,
    status          VARCHAR(20)  NOT NULL,

    CONSTRAINT pk_upi_account_details
        PRIMARY KEY (upi_id),

    CONSTRAINT fk_upi_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer_master(customer_id),

    CONSTRAINT chk_upi_account_type
        CHECK (
            account_type IN ('savings', 'current', 'credit_card_linked')
        ),

    CONSTRAINT chk_upi_status
        CHECK (
            status IN ('active', 'blocked', 'suspended')
        )
);

-- =====================================================================
-- 4. MERCHANT INFO
-- =====================================================================

CREATE TABLE merchant_info (
    merchant_id      VARCHAR(20)  NOT NULL,
    merchant_name    VARCHAR(150) NOT NULL,
    merchant_type    VARCHAR(50)  NOT NULL,
    region           VARCHAR(20)  NOT NULL,
    onboard_date     DATE         NOT NULL,
    risk_score       DECIMAL(5,4) NOT NULL,

    CONSTRAINT pk_merchant_info
        PRIMARY KEY (merchant_id),

    CONSTRAINT chk_merchant_risk_score
        CHECK (risk_score BETWEEN 0 AND 1)
);

-- =====================================================================
-- 5. UPI TRANSACTION HISTORY
-- Core fact table
-- =====================================================================

CREATE TABLE upi_transaction_history (
    transaction_id     VARCHAR(20)   NOT NULL,
    upi_id             VARCHAR(100)  NOT NULL,
    customer_id        VARCHAR(20)   NOT NULL,
    timestamp           DATETIME(6)   NOT NULL,
    amount              DECIMAL(12,2) NOT NULL,
    transaction_type    VARCHAR(30)   NOT NULL,
    merchant_id         VARCHAR(20)   NULL,
    counterparty_upi    VARCHAR(100)  NOT NULL,
    status              VARCHAR(20)   NOT NULL,
    device_id           VARCHAR(20)   NOT NULL,
    device_type         VARCHAR(20)   NOT NULL,
    channel             VARCHAR(30)   NOT NULL,
    fraud_flag          BOOLEAN       NOT NULL,
    reversal_flag       BOOLEAN       NOT NULL,
    failure_reason      VARCHAR(100)  NULL,

    CONSTRAINT pk_upi_transaction_history
        PRIMARY KEY (transaction_id),

    CONSTRAINT fk_transaction_upi
        FOREIGN KEY (upi_id)
        REFERENCES upi_account_details(upi_id),

    CONSTRAINT fk_transaction_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer_master(customer_id),

    CONSTRAINT fk_transaction_merchant
        FOREIGN KEY (merchant_id)
        REFERENCES merchant_info(merchant_id),

    CONSTRAINT fk_transaction_device
        FOREIGN KEY (device_id)
        REFERENCES device_info(device_id),

    CONSTRAINT chk_transaction_type
        CHECK (
            transaction_type IN ('send', 'receive', 'merchant_payment', 'bill_pay')
        ),

    CONSTRAINT chk_transaction_status
        CHECK (
            status IN ('success', 'failed', 'pending')
        ),

    CONSTRAINT chk_transaction_device_type
        CHECK (
            device_type IN ('android', 'ios', 'tablet', 'feature_phone')
        )
);

-- =====================================================================
-- 6. CUSTOMER FEEDBACK SURVEYS
-- =====================================================================

CREATE TABLE customer_feedback_surveys (
    feedback_id          VARCHAR(20) NOT NULL,
    customer_id          VARCHAR(20) NOT NULL,
    date_submitted       DATE        NOT NULL,
    feedback_text        TEXT        NULL,
    satisfaction_score   TINYINT     NOT NULL,
    issue_type           VARCHAR(50) NOT NULL,
    resolved             BOOLEAN     NOT NULL,

    CONSTRAINT pk_customer_feedback_surveys
        PRIMARY KEY (feedback_id),

    CONSTRAINT fk_feedback_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer_master(customer_id),

    CONSTRAINT chk_satisfaction_score
        CHECK (satisfaction_score BETWEEN 1 AND 5)
);

-- =====================================================================
-- 7. FRAUD ALERT HISTORY
-- =====================================================================

CREATE TABLE fraud_alert_history (
    alert_id          VARCHAR(20) NOT NULL,
    transaction_id    VARCHAR(20) NOT NULL,
    alert_type        VARCHAR(50) NOT NULL,
    alert_date        DATETIME(6) NOT NULL,
    resolved          BOOLEAN     NOT NULL,
    resolution_date   DATETIME(6) NULL,
    remarks           TEXT        NULL,

    CONSTRAINT pk_fraud_alert_history
        PRIMARY KEY (alert_id),

    CONSTRAINT fk_fraud_alert_transaction
        FOREIGN KEY (transaction_id)
        REFERENCES upi_transaction_history(transaction_id)
);

-- =====================================================================
-- 8. STEP 3 VALIDATION QUERIES
-- =====================================================================

-- 8.1 Confirm all project tables were created
SHOW TABLES;

-- 8.2 Review all constraints by table
SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'upi_capstone_db'
ORDER BY
    TABLE_NAME,
    CONSTRAINT_TYPE,
    CONSTRAINT_NAME;

-- 8.3 Review all foreign-key relationships
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'upi_capstone_db'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY
    TABLE_NAME,
    COLUMN_NAME;

-- 8.4 Inspect important table structures
DESCRIBE customer_master;
DESCRIBE upi_transaction_history;
DESCRIBE fraud_alert_history;

-- 8.5 Summarize constraint counts
SELECT
    CONSTRAINT_TYPE,
    COUNT(*) AS constraint_count
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'upi_capstone_db'
GROUP BY CONSTRAINT_TYPE
ORDER BY CONSTRAINT_TYPE;

-- =====================================================================
-- EXPECTED STRUCTURE SUMMARY
--   Tables:        7
--   Primary Keys:  7
--   Foreign Keys:  8
--   CHECKs:       11
--
-- Expected relationships:
--   customer_master 1:M device_info
--   customer_master 1:M upi_account_details
--   customer_master 1:M customer_feedback_surveys
--   customer_master 1:M upi_transaction_history
--   upi_account_details 1:M upi_transaction_history
--   merchant_info 1:M upi_transaction_history
--   device_info 1:M upi_transaction_history
--   upi_transaction_history 1:M fraud_alert_history
-- =====================================================================
