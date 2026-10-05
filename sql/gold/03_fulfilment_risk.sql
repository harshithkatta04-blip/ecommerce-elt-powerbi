CREATE OR REPLACE VIEW ecommerce_gold.gold_fulfilment_risk AS

SELECT
    Order_Status,

    COUNT(DISTINCT Order_ID) AS total_orders,

    ROUND(SUM(Net_Sales), 2) AS total_net_sales,

    ROUND(SUM(Profit), 2) AS total_profit,

    ROUND(
        SUM(Net_Sales) /
        NULLIF(
            SUM(SUM(Net_Sales)) OVER (),
            0
        ) * 100,
        2
    ) AS net_sales_share_pct

FROM ecommerce_silver.silver_ecommerce_customer

WHERE Financial_Data_Quality = 'Complete'

GROUP BY Order_Status;