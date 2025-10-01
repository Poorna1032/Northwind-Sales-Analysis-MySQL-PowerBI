# 📈 Northwind Traders Sales and Operations Analysis

## 🎯 Project Overview

This project executes a comprehensive **Exploratory Data Analysis (EDA)** of the Northwind Traders historical dataset. The workflow demonstrates end-to-end data analysis skills, transitioning from raw data manipulation using **MySQL (SQL)** to advanced data modeling and interactive business intelligence in **Power BI**.

The primary goal was to move beyond simple reporting to deliver **strategic, evidence-based insights** across core business pillars: Sales, Employee Management, and Supply Chain.

---

## 🛠️ Technical Workflow & Repository Structure

### Technology Stack

| Component | Technology | Primary Function |
| :--- | :--- | :--- |
| **Data Exploration & Metrics** | **MySQL (SQL)** | Used for initial data profiling, complex multi-table joins, and calculating raw metrics (e.g., Net Revenue, AOV). |
| **Data Modeling & Logic** | **Power BI Desktop (DAX)** | Used to build a dimensional model (Star Schema), create sophisticated measures, and define dynamic hierarchies. |
| **Visualization & Reporting** | **Power BI Desktop** | Created interactive dashboards to visually present key findings and support decision-making. |

### Repository Contents

* **`02_SQL_EDA/Northwind Sales Project (EDA SQL Queries).sql`**: Contains **14+ comprehensive SQL queries** used for all initial data exploration, cleaning, and calculating raw metrics before data loading.
* **`03_PowerBI_Visualizations/Northwinds Sales Analysis Project.pbix`**: The final Power BI file, including the completed data model, all DAX logic, and the interactive dashboard reports.

### Key DAX & Modeling Techniques

* **Organizational Hierarchy:** Used the **`PATH` and `LOOKUPVALUE` DAX functions** to dynamically create the Manager $\rightarrow$ Subordinate reporting structure and measure the **Span of Control**.
* **Pricing Distribution:** Created a **calculated column using the "Bin" feature** to generate a histogram of product pricing (e.g., $20 bins) for market analysis.
* **Time Intelligence:** Utilized **`DATEDIFF`** to accurately calculate employee tenure and shipping durations.

---

## 💡 Key Business Insights

The following are the major strategic insights delivered via the final Power BI dashboard:

### 1. Sales & Customer Performance

* **Revenue Trend:** Established a clear **Q4/Q1 seasonal peak**, vital for guiding annual budgeting and inventory stock levels.
* **Customer Risk:** Identified that the **Top 5 customers** account for a disproportionately large share of total revenue, confirming a significant **revenue concentration risk**.
* **Order Value Skew:** Visual comparison of Average vs. Median Order Value confirmed a **positive skew**, driven by a small number of high-value transactions.

### 2. Employee Structure & Operations

* **Management Span of Control:** The Matrix visual proved the company operates with a **flat organizational structure**, evidenced by the high count of direct reports (wide span of control) under key managers.
* **Workforce Stability:** Tenure analysis confirmed the concentration of employees in specific experience brackets, allowing management to forecast potential **future turnover risk**.

### 3. Product & Supply Chain Analysis

* **Core Pricing Tier:** Product pricing analysis identified the **core competitive price tier** where the majority of inventory is clustered, guiding competitive pricing strategy.
* **Demand Prioritization:** Identified the **Top 10 highest-volume products** via the Bar Chart, which is crucial for **inventory prioritization** and minimizing stock-outs.
* **Procurement Strategy:** Cross-analysis of supplier pricing exposed vendors with high **price volatility**, offering clear targets for contract negotiation.

***
*Project completed for Data Analysis Portfolio. Licensed under the MIT License.*
