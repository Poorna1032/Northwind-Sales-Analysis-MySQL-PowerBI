# Northwind-Sales-Analysis-MySQL-PowerBI
Comprehensive Sales &amp; Operations EDA for Northwind Traders. Leveraged MySQL (SQL) for data profiling and Power BI (DAX) for dynamic visualization and strategic insights.

🎯 Project Overview:
This project executes a comprehensive Exploratory Data Analysis (EDA) of the Northwind Traders historical dataset. The workflow showcases end-to-end data analysis skills, transitioning from raw data querying in MySQL to sophisticated data modeling and interactive business intelligence using Power BI.

 The primary goal was to provide strategic, evidence-based insights across core business pillars: Sales Performance, Customer Behavior, Organizational Structure, and Supply Chain efficiency.

🛠️ Technology Stack:
Component	Technology	Purpose in Project
Data Exploration & Metrics	MySQL (SQL)	Used for initial data profiling, complex multi-table joins, feature engineering, and calculating raw metrics (e.g., Net Revenue, AOV).
Data Modeling & Logic	Power BI Desktop (DAX)	Used to build a dimensional model (Star Schema), create sophisticated measures (AOV, Tenure), and define hierarchies (PATH function).
Visualization & Reporting	Power BI Desktop	Created interactive dashboards to translate analytical findings into clear, actionable business insights.
Version Control	Git / GitHub	For documentation, file management, and transparent version control.

📁 Repository Contents
File/Folder	Description
01_SQL_EDA/Northwind Sales Project (EDA SQL Queries).sql	The source of truth for the raw analysis. Contains all 14+ specific SQL queries used for data exploration, cleaning, metric calculation, and anomaly detection.
02_PowerBI_Visualizations/Northwinds Sales Analysis Project.pbix	The final reporting solution. Contains the completed dimensional model, all DAX measures, and the finalized interactive report pages.

💡 Key Findings & Strategic Insights
The following insights are a result of transforming the initial SQL queries into final Power BI visualizations:

1. Sales & Customer Performance
Analysis Focus	Power BI Visual Used	Strategic Insight
Order Value Distribution	Card Visuals (Min, Median, Max)	Comparison of Average vs. Median Order Value revealed a positive skew, confirming that a few extremely large transactions are inflating the mean AOV.
Customer Risk	Table / Bar Chart (Top Customers)	Identified the Top N customers responsible for the majority of revenue, highlighting significant revenue concentration risk that warrants account prioritization (Pareto Principle).
Revenue Trend	Line Chart	Confirmed year-over-year growth and established a predictable Q4/Q1 seasonal peak, which should guide inventory and marketing budgets.

2. Employee Structure & Operations
Analysis Focus	Power BI Visual Used	Key DAX / Modeling Technique
Reporting Structure	Matrix Visual	Used the PATH and LOOKUPVALUE DAX functions to define the Manager → Subordinate hierarchy and measure the Span of Control.
Tenure Distribution	Clustered Column Chart	Calculated employee experience using DATEDIFF and grouped the results into 1-year bins to assess workforce stability and turnover risk.
Span of Control	Matrix Count(EmployeeID)	Confirmed the organization operates with a flat structure due to the wide span of control (high count of direct reports) seen under top managers.

3. Product & Supply Chain Analysis
Analysis Focus	Power BI Visual Used	Operational Insight
Product Pricing	Clustered Column Chart (Histogram)	Grouped product prices into $20 bins to define the core competitive price tier where the majority of inventory is clustered, and identify premium outliers.
Supplier Risk	Bar/Pie Chart (Product Count)	Identified suppliers responsible for the majority of the product catalogue, confirming supplier concentration risk and dependency on a few key vendors.
Pricing Volatility	Table (Min/Median/Max Price per Supplier)	Evaluated the price spread (Min to Max) for each supplier to identify partners with high price volatility, informing procurement negotiation strategy.

⚙️ Key Technical Techniques
The following are examples of specific technical solutions implemented within the project:

DAX (Power BI)
Employee Hierarchy: Creation of the Employee Path column using PATH(EmployeeID, ReportsTo) and subsequent extraction of names using PATHITEM and LOOKUPVALUE.

Time Intelligence: Use of DATEDIFF to calculate employee tenure and shipping duration days.

AOV Measure: DIVIDE([Total Revenue], [Total Orders])

SQL (MySQL/EDA Queries)
Net Revenue: Calculation of revenue at the line-item level using the formula: SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)).

Customer Tiering: Use of Common Table Expressions (CTEs/WITH clause) to calculate the total number of orders per customer, followed by an aggregation to find the Average Orders Per Customer.

Cross-Domain Joins: Complex JOIN operations across Customers, Orders, Order Details, Products, and Suppliers to connect financial metrics with supplier and product dimensions.
