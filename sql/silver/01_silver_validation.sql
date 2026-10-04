-- Silver Layer
-- Final cleaned dataset validation

SELECT COUNT(*) AS silver_rows
FROM silver_ecommerce_customer;

-- Financial quality
SELECT
    Financial_Data_Quality,
    COUNT(*) AS row_count
FROM silver_ecommerce_customer
GROUP BY Financial_Data_Quality;

-- Customer experience quality
SELECT
    Customer_Experience_Data_Quality,
    COUNT(*) AS row_count
FROM silver_ecommerce_customer
GROUP BY Customer_Experience_Data_Quality;

-- Overall record quality
SELECT
    Record_Data_Quality,
    COUNT(*) AS row_count
FROM silver_ecommerce_customer
GROUP BY Record_Data_Quality;

-- City recovery quality
SELECT
    City_Data_Quality,
    COUNT(*) AS row_count
FROM silver_ecommerce_customer
GROUP BY City_Data_Quality;

-- Payment method recovery quality
SELECT
    Payment_Method_Data_Quality,
    COUNT(*) AS row_count
FROM silver_ecommerce_customer
GROUP BY Payment_Method_Data_Quality;

-- Return-status consistency
SELECT
    Return_Status_Data_Quality,
    COUNT(*) AS row_count
FROM silver_ecommerce_customer
GROUP BY Return_Status_Data_Quality;