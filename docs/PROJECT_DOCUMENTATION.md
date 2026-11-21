# Project Documentation

## 1. Project Title

**E-Commerce Revenue Quality and Fulfilment Risk Analytics**

## 2. Objective

The objective of this project is to build an end-to-end analytics workflow that converts raw e-commerce transactions into reliable business insights. Instead of connecting an unvalidated CSV directly to Power BI, the project applies a Medallion-style architecture so that raw ingestion, data cleaning, business logic, and reporting remain clearly separated and auditable.

The analysis focuses on five business areas: profitability, discount effectiveness, fulfilment/revenue risk, customer segment performance, and customer experience.

## 3. Technology Stack

- **Python / Pandas** — profiling, preprocessing, validation, deduplication, and ingestion logic
- **MySQL** — Bronze, Silver, and Gold analytical storage
- **SQL** — validation and business-ready Gold views
- **Power BI** — interactive reporting and business presentation
- **Git / GitHub** — version control and project collaboration
- **Jupyter Notebook** — reproducible data-preparation workflow

## 4. End-to-End Architecture

```text
Source CSV
   ↓
Python ingestion + audit metadata
   ↓
ecommerce_bronze
   ↓
Python cleaning + SQL validation
   ↓
ecommerce_silver
   ↓
SQL business marts/views
   ↓
ecommerce_gold
   ↓
Power BI
```

This design was chosen to preserve the original source, isolate data-quality changes, and keep dashboard business logic reusable outside Power BI.

## 5. Bronze Layer

The source contained **3,055 rows**. Bronze preserves the source records and adds ingestion metadata such as batch ID, source file, and load time. An ingestion log is used to support repeatability and source-file auditing.

Bronze intentionally avoids heavy transformation because its purpose is source preservation.

## 6. Data Profiling and Deduplication

Profiling identified **3,000 unique Order IDs**, meaning 55 additional order rows were present.

- 50 were exact duplicate extras.
- 5 Order IDs contained conflicting order-status values.

For conflicting duplicate Order IDs, the final occurrence in the source file was retained as a deterministic rule. This should not be described as a chronological latest-status rule because a reliable event-history timestamp was not available.

Final Silver row count: **3,000**.

## 7. Silver-Layer Processing

### Numerical validation

Rules were applied to identify or nullify invalid values, including:

- Customer age outside the accepted range of 13–100
- Negative Quantity values
- Discount percentages below 0 or above 100
- Negative Shipping Days
- Customer Rating outside 1–5
- Negative Estimated Cost

Financially sensitive values were not blindly imputed because fabricated values could distort Net Sales, Profit, or Profit Margin.

### Formula validation

The following formulas were checked:

- Gross Amount = Quantity × Unit Price
- Discount Amount = Gross Amount × Discount % / 100
- Net Sales = Gross Amount − Discount Amount
- Profit = Net Sales − Estimated Cost
- Profit Margin % = Profit / Net Sales × 100

Remaining complete records passed these financial consistency checks.

### Categorical cleaning

Labels were standardized for dimensions including Region, Customer Segment, Sales Channel, Marketing Source, City, and Payment Method.

Missing City and Payment Method values were only recovered when customer history provided a safe deterministic value. Remaining unresolved values were preserved as missing rather than mode-filled.

### Product/category issue

Product and Category did not form a trustworthy one-to-one or many-to-one hierarchy. The same products appeared across multiple categories. The project therefore treats Product and Category as independent analytical dimensions instead of forcing a misleading hierarchy.

### Return-status issue

The source contained cases where an order had `Order_Status = Returned` but `Return_Status = No`. These records were flagged using a return-status data-quality indicator rather than overwritten. Therefore, reporting uses the term **Return Flag Rate**.

## 8. Quality Flags

The Silver layer includes dedicated data-quality fields, including:

- `Financial_Data_Quality`
- `Customer_Experience_Data_Quality`
- `Record_Data_Quality`
- `Age_Data_Quality`
- `City_Data_Quality`
- `Payment_Method_Data_Quality`
- `Return_Status_Data_Quality`

Overall record quality after processing:

- Complete: **2,429**
- Partial: **571**

## 9. Gold Layer and Business Problems

Gold contains aggregated SQL views designed around the five business questions.

### Business Problem 1 — Profitability Analysis

Views:
- `gold_category_profitability`
- `gold_product_profitability`
- `gold_channel_region_marketing`

Purpose: identify strong and weak profit contributors by category, product, sales channel, region, and marketing source.

### Business Problem 2 — Discount Impact

View:
- `gold_discount_profitability`

Purpose: compare profit margins across discount bands and identify whether aggressive discounting is associated with weaker margins.

### Business Problem 3 — Fulfilment & Revenue Risk

Views:
- `gold_fulfilment_risk`
- `gold_risk_concentration`

Purpose: quantify Net Sales associated with non-delivered orders and identify where risk is concentrated.

### Business Problem 4 — Customer Segment Performance

View:
- `gold_customer_segment_performance`

Purpose: compare customer segments on profitability, previous orders, loyalty points, and satisfaction.

### Business Problem 5 — Customer Experience vs Fulfilment

View:
- `gold_fulfilment_experience`

Purpose: compare order status with shipping days, delivery rating, customer satisfaction, and return flags.

## 10. Power BI Dashboard

### Page 1 — Executive Performance Overview

Business question: **How is delivered business performing overall?**

Key KPIs:
- Delivered Orders ≈ 1,995
- Net Sales ≈ ₹8.78M
- Total Profit ≈ ₹2.44M
- Profit Margin ≈ 27.78%

Visuals include category profit, product profit, and sales-versus-profit performance across channel/marketing combinations. A Region slicer is included for the relevant Gold view.

### Page 2 — Revenue & Fulfilment Risk

Business question: **How much revenue is exposed to non-delivered statuses, and what factors are associated with that risk?**

Key KPIs:
- At-Risk Net Sales ≈ ₹3.44M
- At-Risk Sales Share ≈ 28.16%

Visuals include margin by discount band, Net Sales exposure by order status, and at-risk sales concentration by Region and Order Status. An Order Status slicer is included for the relevant fulfilment-risk view.

The 20%+ discount band showed the weakest observed margin at approximately 26.18%, although the relationship across discount bands was not perfectly monotonic.

### Page 3 — Customer & Experience Insights

Business question: **Which customer segments create value, and how does fulfilment relate to customer experience?**

Visuals include profit by Customer Segment, satisfaction by segment, customer satisfaction versus delivery rating by Order Status, and Return Flag Rate by Order Status. A Customer Segment slicer is included for the segment-performance visuals.

Regular customers generated the highest absolute segment profit. Satisfaction differences across segments were comparatively narrow.

## 11. Interpretation Notes

- Non-delivered sales are described as **at-risk**, not automatically lost revenue.
- Positive dataset-calculated profit associated with returned or cancelled statuses should not automatically be interpreted as realized profit.
- Return Status is treated as a separate source signal from Order Status because the two fields contain inconsistencies.
- Gold views have different analytical grains, so slicers should only be expected to affect visuals backed by compatible tables or relationships.

## 12. Team Collaboration

The project was completed collaboratively by **Harshith Katta** and **Keerthi Priya**.

Harshith primarily handled data profiling, preprocessing, quality validation, deduplication, and Silver-layer preparation. For the five business problems represented in Power BI, Harshith took primary ownership of two: profitability analysis and fulfilment/revenue risk.

Keerthi Priya took primary Power BI ownership of three business problems: discount impact, customer segment performance, and customer experience versus fulfilment. Her work emphasized visual design, business interpretation, and presentation of the corresponding Gold outputs.

Both team members participated in review, integration, and final dashboard validation. A detailed contribution matrix is provided in `TEAM_CONTRIBUTIONS.md`.

## 13. Future Improvements

- Introduce an order-level fact table with conformed dimensions for stronger cross-filtering across dashboard pages.
- Add formal orchestration for Bronze → Silver → Gold refreshes.
- Add automated data-quality tests and pipeline monitoring.
- Reconcile Order Status and Return Status through a stronger source-system business rule.
- Add time-based trend analysis if reliable order/event timestamps become available.
- Deploy the dashboard and data pipeline to a shared cloud environment.
