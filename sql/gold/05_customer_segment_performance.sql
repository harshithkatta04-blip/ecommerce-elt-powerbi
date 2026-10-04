CREATE OR REPLACE VIEW gold_customer_segment_performance AS

SELECT
    Customer_Segment,

    COUNT(DISTINCT Order_ID) AS total_orders,

    ROUND(AVG(Previous_Orders), 2) AS avg_previous_orders,

    ROUND(AVG(Customer_Loyalty_Points), 2) AS avg_loyalty_points,

    ROUND(AVG(Customer_Satisfaction), 2) AS avg_customer_satisfaction,

    ROUND(SUM(Net_Sales), 2) AS total_net_sales,

    ROUND(SUM(Profit), 2) AS total_profit,

    ROUND(
        SUM(Profit) / NULLIF(SUM(Net_Sales), 0) * 100,
        2
    ) AS profit_margin_pct

FROM silver_ecommerce_customer

WHERE Order_Status = 'Delivered'
  AND Financial_Data_Quality = 'Complete'

GROUP BY Customer_Segment;