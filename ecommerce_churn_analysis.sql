SELECT churn_id, COUNT(*) AS duplicate_count
FROM ecommerce_churn_rate_raw
GROUP BY churn_id
HAVING COUNT(*) > 1;

WITH Duplicatecheck AS (
    SELECT 
        customer_id,
        churn_reason,
        churn_category,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id, churn_reason, churn_category
            ORDER BY (SELECT NULL)
        ) AS row_num
    FROM ecommerce_churn_rate_raw
)
SELECT * 
FROM Duplicatecheck 
WHERE row_num > 1;


WITH Duplicatecheck AS (
    SELECT 
        customer_id,
        churn_reason,
        churn_category,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id, churn_reason, churn_category
            ORDER BY (SELECT NULL)
        ) AS row_num
    FROM ecommerce_churn_rate_raw
)
DELETE FROM Duplicatecheck 
WHERE row_num > 1;

SELECT customer_id, COUNT(*) AS duplicate_count
FROM ecommerce_churn_rate_raw
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT customer_id, churn_reason, churn_date, COUNT(*) AS duplicate_count
FROM ecommerce_churn_rate_raw
GROUP BY customer_id, churn_reason, churn_date
HAVING COUNT(*) > 1;

WITH Duplicatecheck AS (
    SELECT 
        customer_id,
        churn_reason,
        churn_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id, churn_reason, churn_date
            ORDER BY (SELECT NULL)
        ) AS row_num
    FROM ecommerce_churn_rate_raw
)
DELETE FROM Duplicatecheck 
WHERE row_num > 1;


SELECT COUNT(*) AS total_clean_rows
FROM ecommerce_churn_rate_raw;

WITH Duplicatecheck AS (
    SELECT 
        customer_id,
        churn_reason,
        churn_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id, churn_reason, churn_date
            ORDER BY (SELECT NULL)
        ) AS row_num
    FROM ecommerce_churn_rate_raw
)
SELECT * 
FROM Duplicatecheck 
WHERE row_num > 1;

SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ecommerce_churn_rate_raw';

ALTER TABLE ecommerce_churn_rate_raw
ALTER COLUMN avg_order_value_usd FLOAT;

ALTER TABLE ecommerce_churn_rate_raw
ALTER COLUMN customer_age_months INT;

ALTER TABLE ecommerce_churn_rate_raw
ALTER COLUMN days_since_churn INT;


ALTER TABLE ecommerce_churn_rate_raw
ALTER COLUMN churn_risk_score FLOAT;

ALTER TABLE ecommerce_churn_rate_raw
ALTER COLUMN churn_probability FLOAT;

ALTER TABLE ecommerce_churn_rate_raw
ALTER COLUMN churn_risk_score FLOAT;

ALTER TABLE ecommerce_churn_rate_raw
ALTER COLUMN churn_probability FLOAT;

ALTER TABLE ecommerce_churn_rate_raw
ALTER COLUMN churn_date NVARCHAR(50) NULL;


UPDATE ecommerce_churn_rate_raw
SET churn_date = NULL
WHERE churn_date = 'Not Applicable';

ALTER TABLE ecommerce_churn_rate_raw
ALTER COLUMN churn_date DATE;

ALTER TABLE ecommerce_churn_rate_raw ALTER COLUMN days_since_churn NVARCHAR(50) NULL;
UPDATE ecommerce_churn_rate_raw SET days_since_churn = NULL WHERE days_since_churn = 'Not Applicable';

ALTER TABLE ecommerce_churn_rate_raw ALTER COLUMN churn_risk_score NVARCHAR(50) NULL;
UPDATE ecommerce_churn_rate_raw SET churn_risk_score = NULL WHERE churn_risk_score = 'Not Applicable';

ALTER TABLE ecommerce_churn_rate_raw ALTER COLUMN churn_probability NVARCHAR(50) NULL;
UPDATE ecommerce_churn_rate_raw SET churn_probability = NULL WHERE churn_probability = 'Not Applicable';

ALTER TABLE ecommerce_churn_rate_raw ALTER COLUMN num_purchases NVARCHAR(50) NULL;
UPDATE ecommerce_churn_rate_raw SET num_purchases = NULL WHERE num_purchases = 'Not Applicable';

ALTER TABLE ecommerce_churn_rate_raw ALTER COLUMN days_since_churn INT;
ALTER TABLE ecommerce_churn_rate_raw ALTER COLUMN churn_risk_score FLOAT;
ALTER TABLE ecommerce_churn_rate_raw ALTER COLUMN churn_probability FLOAT;
ALTER TABLE ecommerce_churn_rate_raw ALTER COLUMN num_purchases INT;

SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ecommerce_churn_rate_raw';

SELECT *
FROM ecommerce_churn_rate_raw;

SELECT churn_category, COUNT(*) AS row_count
FROM ecommerce_churn_rate_raw
GROUP BY churn_category;

SELECT churn_reason, COUNT(*) AS row_count
FROM ecommerce_churn_rate_raw
GROUP BY churn_reason;

ALTER TABLE ecommerce_churn_rate_raw ALTER COLUMN churn_category NVARCHAR(50) NULL;
ALTER TABLE ecommerce_churn_rate_raw ALTER COLUMN churn_reason NVARCHAR(50) NULL;

UPDATE ecommerce_churn_rate_raw SET churn_category = NULL WHERE churn_category = 'Not Applicable';
UPDATE ecommerce_churn_rate_raw SET churn_reason = NULL WHERE churn_reason = 'Not Applicable';

SELECT customer_segment, subscription_type, COUNT(*) AS row_count
FROM ecommerce_churn_rate_raw
GROUP BY customer_segment, subscription_type;

SELECT customer_country, COUNT(*) AS row_count
FROM ecommerce_churn_rate_raw
GROUP BY customer_country;

SELECT 
    is_churned, 
    churn_flag, 
    COUNT(*) AS total_customers
FROM ecommerce_churn_rate_raw
GROUP BY is_churned, churn_flag;

----Finding out which churn reasons are driving the highest volume of customer loss.--

SELECT 
    churn_reason, 
    COUNT(*) AS churned_customer_count
FROM ecommerce_churn_rate_raw
WHERE is_churned = 'Yes'
GROUP BY churn_reason
ORDER BY churned_customer_count DESC;

---Which customer segments (Consumer, Small Business, Premium, Enterprise) have highest churn?--


SELECT 
    customer_segment,
    subscription_type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_churned = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        CAST(SUM(CASE WHEN is_churned = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100, 
        2
    ) AS churn_rate_pct
FROM ecommerce_churn_rate_raw
GROUP BY customer_segment, subscription_type
ORDER BY churn_rate_pct DESC;

-----. Which countries exhibit the highest churn rates?--
SELECT 
    customer_country,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_churned = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        CAST(SUM(CASE WHEN is_churned = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100, 
        2
    ) AS churn_rate_pct
FROM ecommerce_churn_rate_raw
GROUP BY customer_country
ORDER BY churn_rate_pct DESC;

---Which subscription types (None, Basic, Premium, Enterprise) churn most?--

SELECT 
    Subscription_type,
    COUNT(Customer_id) AS TotalCustomers,
    SUM(CASE WHEN is_churned = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(CAST(SUM(CASE WHEN is_churned = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(Customer_id) * 100, 2) AS ChurnRatePercentage
FROM 
    ecommerce_churn_rate_raw
GROUP BY 
    Subscription_type
ORDER BY 
    ChurnRatePercentage DESC;
---What are the top churn reasons, and how much revenue does each cost?

SELECT 
    churn_reason,
    COUNT(*) AS churned_customer_count,
    ROUND(SUM(total_spend_usd), 2) AS total_revenue_lost,
    ROUND(AVG(total_spend_usd), 2) AS avg_spend_per_customer
FROM ecommerce_churn_rate_raw
WHERE is_churned = 'Yes'
GROUP BY churn_reason
ORDER BY total_revenue_lost DESC;

----How do voluntary, involuntary, and competitive churn compare?
SELECT 
    CASE 
        WHEN churn_reason IN ('Better Price Elsewhere', 'Found Alternative', 'Too Expensive') 
            THEN 'Competitive Churn'
        WHEN churn_reason IN ('Payment Problems', 'No Longer Need Service') 
            THEN 'Involuntary Churn'
        ELSE 'Voluntary (Service/Product) Churn'
    END AS churn_category,
    COUNT(*) AS churned_customer_count,
    ROUND(SUM(total_spend_usd), 2) AS total_revenue_lost,
    ROUND(AVG(total_spend_usd), 2) AS avg_spend_per_customer
FROM ecommerce_churn_rate_raw
WHERE is_churned = 'Yes'
GROUP BY 
    CASE 
        WHEN churn_reason IN ('Better Price Elsewhere', 'Found Alternative', 'Too Expensive') 
            THEN 'Competitive Churn'
        WHEN churn_reason IN ('Payment Problems', 'No Longer Need Service') 
            THEN 'Involuntary Churn'
        ELSE 'Voluntary (Service/Product) Churn'
    END
ORDER BY total_revenue_lost DESC;

---cross-reference customer feedback levels (Very Dissatisfied, Neutral, Satisfied) with actual churn status

SELECT 
    satisfaction_level,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_churned = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN is_churned = 'No' THEN 1 ELSE 0 END) AS retained_customers,
    ROUND(
        CAST(SUM(CASE WHEN is_churned = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100, 
        2
    ) AS churn_rate_pct
FROM ecommerce_churn_rate_raw
GROUP BY satisfaction_level
ORDER BY churn_rate_pct DESC;

