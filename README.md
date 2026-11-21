# E-Commerce Revenue Quality & Fulfilment Risk Analytics

An end-to-end analytics project that transforms raw e-commerce order data into trusted business insights using a Medallion-style pipeline and Power BI.

## Project Goal

The project focuses on improving the reliability of e-commerce reporting by separating raw ingestion, data-quality processing, business-ready analytics, and dashboard reporting. It answers five business questions around profitability, discount effectiveness, fulfilment risk, customer segments, and customer experience.

## Architecture

```text
Raw CSV
   ↓
Python ingestion
   ↓
MySQL Bronze
   ↓
Python + SQL validation / cleaning
   ↓
MySQL Silver
   ↓
SQL Gold views
   ↓
Power BI dashboard
```

### Medallion Layers

- **Bronze:** preserves the raw source data and ingestion metadata.
- **Silver:** contains cleaned, validated, deduplicated, and quality-flagged records.
- **Gold:** exposes reusable SQL views aligned to the business questions.
- **Power BI:** presents executive, risk, customer, and experience insights.

## Dataset & Data Quality

- Source rows: **3,055**
- Unique orders after deduplication: **3,000**
- Exact duplicate extras identified: **50**
- Conflicting duplicate Order IDs identified: **5**
- Final Silver records: **3,000**
- Record quality: **2,429 Complete**, **571 Partial**

Key validation included invalid ages, negative quantities, invalid discount percentages, negative shipping days, out-of-range customer ratings, negative estimated cost, missing financial fields, categorical standardization, and return-status consistency checks.

Financial formulas were revalidated for Gross Amount, Discount Amount, Net Sales, Profit, and Profit Margin. Financially sensitive missing values were intentionally not blindly imputed.

## Business Problems

1. **Profitability Analysis** — Which categories, products, channels, regions, and marketing sources generate the strongest profit and margin?
2. **Discount Impact** — How do discount bands relate to profit margin?
3. **Fulfilment & Revenue Risk** — How much sales value is associated with Pending, Delayed, Cancelled, or Returned orders, and where is that risk concentrated?
4. **Customer Segment Performance** — Which customer segments contribute the most profit and how do they compare on loyalty, previous orders, and satisfaction?
5. **Customer Experience vs Fulfilment** — How do order status, delivery rating, satisfaction, shipping, and return flags relate?

## Gold Views

- `gold_category_profitability`
- `gold_product_profitability`
- `gold_channel_region_marketing`
- `gold_discount_profitability`
- `gold_fulfilment_risk`
- `gold_risk_concentration`
- `gold_customer_segment_performance`
- `gold_fulfilment_experience`

## Power BI Dashboard

### Page 1 — Executive Performance Overview
Explains overall delivered-business performance through Delivered Orders, Net Sales, Total Profit, Profit Margin, category profitability, product profitability, and sales-versus-profit performance.

### Page 2 — Revenue & Fulfilment Risk
Explains revenue exposure from non-delivered orders, discount-band profitability, sales exposure by order status, and regional/status risk concentration.

### Page 3 — Customer & Experience Insights
Explains customer-segment profitability and satisfaction, customer/delivery experience by order status, and return-flag behaviour.

The dashboard uses dropdown slicers for Region, Order Status, and Customer Segment where appropriate to the underlying Gold view. Monetary values are displayed as INR (₹) for presentation consistency.

## Key Findings

- Delivered orders analysed: **1,995**
- Delivered Net Sales: approximately **₹8.78M**
- Delivered Profit: approximately **₹2.44M**
- Delivered Profit Margin: approximately **27.78%**
- At-risk Net Sales associated with non-delivered statuses: approximately **₹3.44M**
- At-risk sales share: approximately **28.16%**
- The **20%+ discount band** had the weakest observed margin at approximately **26.18%**.
- Regular customers contributed the largest absolute profit among customer segments.

> Note: `Return_Status` and `Order_Status` contained source-level inconsistencies, so the dashboard uses the term **Return Flag Rate** rather than treating the field as a fully reconciled return rate.

## Team Contribution Summary

### Harshith Katta
- Primary responsibility for data profiling, preprocessing, validation, deduplication, quality rules, and Silver-layer preparation.
- Contributed to Medallion pipeline design and SQL validation.
- Power BI ownership for **2 of the 5 business problems**:
  - Profitability Analysis
  - Fulfilment & Revenue Risk
- Supported dashboard integration, KPI verification, and final project packaging.

### Keerthi Priya
- Primary Power BI contributor for **3 of the 5 business problems**:
  - Discount Impact
  - Customer Segment Performance
  - Customer Experience vs Fulfilment
- Contributed to dashboard visual selection, business interpretation, layout, and presentation of Gold-layer outputs.
- Supported final dashboard review and business-insight communication.

See [`docs/TEAM_CONTRIBUTIONS.md`](docs/TEAM_CONTRIBUTIONS.md) for a more detailed contribution breakdown.

## Repository Structure

```text
ecommerce-elt-powerbi/
├── data/
│   └── raw/
│       └── ecommerce_customer (1).csv
├── docs/
│   ├── PROJECT_DOCUMENTATION.md
│   └── TEAM_CONTRIBUTIONS.md
├── notebooks/
│   └── ecommerce_powerbi.ipynb
├── powerbi/
│   └── ecommerce_dashboard.pbix
├── sql/
│   ├── bronze/
│   ├── silver/
│   └── gold/
├── .gitignore
├── README.md
└── requirements.txt
```

## How to Run

1. Install the packages in `requirements.txt`.
2. Configure MySQL locally.
3. Run the notebook to ingest and prepare the Bronze/Silver data. The notebook requests the MySQL password securely using `getpass()`.
4. Run the Bronze and Silver SQL validation scripts.
5. Run the Gold SQL files in numeric order.
6. Open `powerbi/ecommerce_dashboard.pbix` and refresh the MySQL connection if required.

## Authors

**Harshith Katta**  
**Keerthi Priya**
