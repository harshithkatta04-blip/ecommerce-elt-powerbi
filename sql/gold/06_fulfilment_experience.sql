CREATE OR REPLACE VIEW ecommerce_gold.gold_fulfilment_experience AS

SELECT
    Order_Status,

    COUNT(DISTINCT Order_ID) AS total_orders,

    ROUND(AVG(Shipping_Days), 2) AS avg_shipping_days,

    ROUND(AVG(Delivery_Rating), 2) AS avg_delivery_rating,

    ROUND(AVG(Customer_Satisfaction), 2) AS avg_customer_satisfaction,

    SUM(
        CASE
            WHEN Return_Status = 'Yes' THEN 1
            ELSE 0
        END
    ) AS return_flagged_orders,

    ROUND(
        (
            SUM(
                CASE
                    WHEN Return_Status = 'Yes' THEN 1
                    ELSE 0
                END
            ) * 100.0
        ) / NULLIF(COUNT(DISTINCT Order_ID), 0),
        2
    ) AS return_flag_rate_pct

FROM ecommerce_silver.silver_ecommerce_customer

GROUP BY Order_Status;