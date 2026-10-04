CREATE OR REPLACE VIEW gold_category_profitability AS
SELECT
    Category,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Net_Sales), 2) AS total_net_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Net_Sales), 0) * 100,
        2
    ) AS profit_margin_pct,
    ROUND(AVG(Discount_Pct), 2) AS avg_discount_pct
FROM silver_ecommerce_customer
WHERE Order_Status = 'Delivered'
  AND Financial_Data_Quality = 'Complete'
GROUP BY Category;


CREATE OR REPLACE VIEW gold_product_profitability AS
SELECT
    Product_Name,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Net_Sales), 2) AS total_net_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Net_Sales), 0) * 100,
        2
    ) AS profit_margin_pct,
    ROUND(AVG(Discount_Pct), 2) AS avg_discount_pct
FROM silver_ecommerce_customer
WHERE Order_Status = 'Delivered'
  AND Financial_Data_Quality = 'Complete'
GROUP BY Product_Name;


CREATE OR REPLACE VIEW gold_channel_region_marketing AS
SELECT
    Sales_Channel,
    Region,
    Marketing_Source,
    COUNT(DISTINCT Order_ID) AS total_orders,
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
    Sales_Channel,
    Region,
    Marketing_Source;