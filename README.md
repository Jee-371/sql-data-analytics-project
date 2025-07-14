# 🧠 Advanced Data Analytics

This project delivers a full-stack **data analytics solution** using SQL to perform **Exploratory Data Analysis (EDA)**, **Advanced Trend & KPI Analysis**, and **Insightful Reporting** on a fictional sales dataset.

It is structured for modular development, enabling seamless database initialization, analytical processing, and report generation using clean SQL workflows.

---

## 📦 Dataset Overview

The dataset is structured into a **star schema**:

- `gold.dim_customers.csv` – Customer details (demographics, IDs)
- `gold.dim_products.csv` – Product details (categories, pricing)
- `gold.fact_sales.csv` – Sales transactions (orders, dates, revenue)

---

## ⚙️ Setup Instructions

> Ensure you are running these in **SQL Server** or a compatible T-SQL engine.

### Initialize Database

Run `init_database.sql` to:
- Create the `DataAnalytics` database and `gold` schema
- Define and populate tables (`dim_customers`, `dim_products`, `fact_sales`) from a `DataWarehouse` source

```sql
scripts/init_database.sql
```
---
### 🔍 Exploratory Data Analysis (EDA)

Run: `scripts/exploratory_data_analysis.sql`
This file aggregates all base-level analysis scripts under one file.

Key Modules:

- date_analysis.sql – Order timelines and customer birthdate ranges

- dimension_analysis.sql – Countries, categories, product groups

- magnitude_analysis.sql – Total sales, quantities, customer counts

- measure_analysis.sql – Averages, percentages, price metrics

- ranking_analysis.sql – Top-performing customers & products

---

### 📈 Advanced Analytics
Run: `scripts/advanced_data_analytics.sql`
Includes in-depth business performance breakdowns.

Key Modules:

- change_over_time_analysis.sql – Monthly & yearly sales trends

- cumulative_analysis.sql – Rolling totals and moving averages

- perfomance_analysis.sql – Year-over-year comparisons

- part_to_whole_analysis.sql – Category contribution to total sales

- data_segmentation.sql – Cost-based product segmentation, customer lifecycle grouping

---

## 📋 Reports


### 🧑 Customer Report (customer_report.sql)
Creates the view: gold.report_customers

Metrics & KPIs:

- Age, age group, customer segment (VIP, Regular, New)

- Total orders, sales, quantity, lifespan, recency

- Avg. order value and monthly spend

---

### 📦 Product Report (product_report.sql)
Creates the view: gold.report_products

Metrics & KPIs:

- Category, subcategory, segment (High/Mid/Low performer)

- Total orders, quantity, customers

- Avg. selling price, avg. order revenue, monthly revenue

---

## 📊 Business Insights Enabled

✔️ Track customer and product performance over time  
✔️ Identify high-value customers and products  
✔️ Segment customers by behavior and value  
✔️ Detect seasonal sales patterns  
✔️ Benchmark performance against historical trends

---

## Repository Structure
```
.sql-data-analytics-project
├── dataset/
│   ├── gold.dim_customers.csv
│   ├── gold.dim_products.csv
│   └── gold.fact_sales.csv
│
├── docs/
│   └── placeholder/
│
├── scripts/
│   ├── advanced-data-analytics/
│   │   ├── change_over_time_analysis.sql
│   │   ├── cumulative_analysis.sql
│   │   ├── data_segmentation.sql
│   │   ├── part_to_whole_analysis.sql
│   │   └── perfomance_analysis.sql
│   │
│   ├── exploratory-data-analysis/
│   │   ├── date_analysis.sql
│   │   ├── dimension_analysis.sql
│   │   ├── magnitude_analysis.sql
│   │   ├── measure_analysis.sql
│   │   └── ranking_analysis.sql
│   │
│   ├── reports/
│   │   ├── customer_report.sql
│   │   └── product_report.sql
│   │
│   ├── init_database.sql
│   ├── exploratory_data_analysis.sql
│   └── advanced_data_analytics.sql
│
└── README.md
```
