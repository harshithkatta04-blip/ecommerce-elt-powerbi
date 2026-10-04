CREATE OR REPLACE VIEW gold_risk_concentration AS

SELECT
    Region,
    Category,
    Sales_Channel,
    Order_Status,

    COUNT(DISTINCT Order_ID) AS total_orders,

    ROUND(SUM(Net_Sales), 2) AS at_risk_net_sales

FROM silver_ecommerce_customer

WHERE Financial_Data_Quality = 'Complete'
  AND Order_Status IN (
      'Pending',
      'Delayed',
      'Returned',
      'Cancelled'
  )

GROUP BY
    Region,
    Category,
    Sales_Channel,
    Order_Status;