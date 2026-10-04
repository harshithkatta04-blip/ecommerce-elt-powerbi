CREATE OR REPLACE VIEW gold_discount_profitability AS

SELECT
    CASE
        WHEN Discount_Pct < 5 THEN '0-5%'
        WHEN Discount_Pct < 10 THEN '5-10%'
        WHEN Discount_Pct < 15 THEN '10-15%'
        WHEN Discount_Pct < 20 THEN '15-20%'
        ELSE '20%+'
    END AS discount_band,

    COUNT(DISTINCT Order_ID) AS total_orders,

    ROUND(AVG(Discount_Pct), 2) AS avg_discount_pct,

    ROUND(SUM(Net_Sales), 2) AS total_net_sales,

    ROUND(SUM(Profit), 2) AS total_profit,

    ROUND(
        SUM(Profit) / NULLIF(SUM(Net_Sales), 0) * 100,
        2
    ) AS profit_margin_pct

FROM silver_ecommerce_customer

WHERE Order_Status = 'Delivered'
  AND Financial_Data_Quality = 'Complete'

GROUP BY
    CASE
        WHEN Discount_Pct < 5 THEN '0-5%'
        WHEN Discount_Pct < 10 THEN '5-10%'
        WHEN Discount_Pct < 15 THEN '10-15%'
        WHEN Discount_Pct < 20 THEN '15-20%'
        ELSE '20%+'
    END;