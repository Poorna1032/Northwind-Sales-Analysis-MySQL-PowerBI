#1. What is the average number of orders per customer? Are there high-value repeat customers?
-- Calculates the average number of distinct orders placed per customer
WITH CustomerOrderCount AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT OrderID) AS TotalOrders
    FROM
        orders
    GROUP BY
        CustomerID
)
SELECT
    AVG(TotalOrders) AS Average_Orders_Per_Customer
FROM
    CustomerOrderCount;
    
    
-- High-Valued repeat customers
-- Calculates total revenue and total orders for the top 5 customers
SELECT
    C.CompanyName AS CustomerName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalRevenue
FROM
    customers AS C
JOIN
    orders AS O ON C.CustomerID = O.CustomerID
JOIN
    order_details AS OD ON O.OrderID = OD.OrderID
GROUP BY
    C.CompanyName
ORDER BY
    TotalRevenue DESC
LIMIT 5;              
                                           
-- Justification for LIMIT 5:
-- Limiting the result to the top 5 high-value customers is a strategic decision.
-- Providing the full list of all 89 customers wouldn't be insightful; showcasing the top tier
-- directly addresses the strategic intent of the question (identifying critical accounts)
-- and allows management to focus resources (e.g., Platinum Account Program) on the segment
-- that poses the highest revenue concentration risk.

##2.How do customer order patterns vary by city or country?

-- Focus on top cities for analysis
SELECT
		T1.Shipcity,
    T1.ShipCountry,
    COUNT(DISTINCT T1.OrderID) AS TotalOrders,
   ROUND(SUM(T2.UnitPrice * T2.Quantity * (1 - T2.Discount)),2)AS TotalRevenue,
   ROUND( SUM(T2.UnitPrice * T2.Quantity * (1 - T2.Discount)) / COUNT(DISTINCT T1.OrderID),2)AS Average_Order_Value,
   ROUND(CAST(COUNT(DISTINCT T1.OrderID) AS REAL) / COUNT(DISTINCT T1.CustomerID),2)AS Avg_Orders_Per_Customer
FROM
    orders AS T1
JOIN
    order_details AS T2 ON T1.OrderID = T2.OrderID
GROUP BY
    T1.ShipCity, T1.ShipCountry  -- Groups by both City and Country
ORDER BY
    TotalRevenue DESC
LIMIT 10;
-- JUSTIFICATION: CITY-LEVEL ANALYSIS (ACTIONABLE KPIs)
-- This granular aggregation identifies the top-performing city markets, providing highly actionable operational KPIs.
-- This level of detail pinpoints specific geographic concentrations of high revenue and AOV, which is crucial for
-- effective sales territory management and optimizing location-specific marketing campaigns.

-- Focus on top countries for analysis
SELECT
    T1.ShipCountry,
    COUNT(DISTINCT T1.OrderID) AS TotalOrders,
    SUM(T2.UnitPrice * T2.Quantity * (1 - T2.Discount)) AS TotalRevenue,
    SUM(T2.UnitPrice * T2.Quantity * (1 - T2.Discount)) / COUNT(DISTINCT T1.OrderID) AS AverageOrderValue
FROM
    orders AS T1
JOIN
    order_details AS T2 ON T1.OrderID = T2.OrderID
GROUP BY
    T1.ShipCountry  -- Groups by Country only
ORDER BY
    TotalRevenue DESC
LIMIT 10;
-- JUSTIFICATION: COUNTRY-LEVEL ANALYSIS (EXECUTIVE KPIs)
-- This macro-level aggregation identifies the Top 10 core national markets by Total Revenue.
-- This view informs executive strategic planning, assesses overall market share, and dictates
-- regional budget allocation, providing a clear picture of the company's geopolitical sales foundation.


###3.Can we cluster customers based on total spend, order count, and preferred categories?

WITH CustomerSpend AS (
    -- 1. Calculate Total Spend and Total Orders for each customer
    SELECT
        O.CustomerID,
        COUNT(DISTINCT O.OrderID) AS TotalOrderCount,
        SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalSpend
    FROM
        orders AS O
    JOIN
        order_details OD ON O.OrderID = OD.OrderID
    GROUP BY
        O.CustomerID
),
CustomerCategoryPreference AS (
    -- 2. Calculate the total quantity purchased AND total spend per category for each customer
    SELECT
        O.CustomerID,
        CAT.CategoryName,
        SUM(OD.Quantity) AS TotalQuantityPurchased,
        SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS CategorySpend, 
        RANK() OVER (
            PARTITION BY O.CustomerID
            ORDER BY
                SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) DESC, -- Primary rank by highest SPEND
                SUM(OD.Quantity) DESC -- Secondary rank by quantity (for ties)
        ) AS CategoryRank
    FROM
        orders AS O
    JOIN
        order_details OD ON O.OrderID = OD.OrderID
    JOIN
        products P ON OD.ProductID = P.ProductID
    JOIN
        categories CAT ON P.CategoryID = CAT.CategoryID
    GROUP BY
        O.CustomerID, CAT.CategoryName
)
-- 3. Combine the metrics and filter for the preferred category (Rank 1)
SELECT
    C.CustomerID,
    C.CompanyName,
    CS.TotalSpend,
    CS.TotalOrderCount,
    CCP.CategoryName AS PreferredCategory
FROM
    customers AS C
JOIN
    CustomerSpend AS CS ON C.CustomerID = CS.CustomerID
JOIN
    CustomerCategoryPreference AS CCP ON C.CustomerID = CCP.CustomerID
WHERE
    CCP.CategoryRank = 1
ORDER BY
    CS.TotalSpend DESC;
    
####4.Which product categories or products contribute most to order revenue? Are there any correlations between orders and customer location or product category?

-- product categories or products contribute most to order revenue
SELECT
    P.ProductName,
    CAT.Category_Name,
    SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS Total_Revenue
FROM
    order_details OD
JOIN
    products P ON OD.ProductID = P.ProductID
JOIN
    categories CAT ON P.CategoryID = CAT.CategoryID
GROUP BY
    P.ProductName, CAT.Category_Name
ORDER BY
    Total_Revenue DESC
LIMIT 10; -- Show the top 10 products

-- A.Orders vs. Customer Location (Country)

SELECT
    O.ShipCountry AS CustomerLocation,
    COUNT(O.OrderID) AS TotalOrderCount
FROM
    orders O
GROUP BY
    O.ShipCountry
ORDER BY
    TotalOrderCount DESC
    LIMIT 10;
    
    
-- B.Orders vs. Product Category
SELECT
    CAT.CategoryName,
    COUNT(OD.ProductID) AS Category_Frequency -- "Category_Frequency" is the clearest way to state that the figure is the total number of times a product from that category was added to any order, reflecting its overall popularity as an individual item choice. 
FROM
   order_details OD
JOIN
    products P ON OD.ProductID = P.ProductID
JOIN
    categories CAT ON P.CategoryID = CAT.CategoryID
GROUP BY
    CAT.CategoryName
ORDER BY
    Category_Frequency DESC;
    
#####5.How frequently do different customer segments place orders?

-- Total Orders Per Customer (We Can Use this Frequency for Customer Segmentation)
SELECT
    CustomerID,
    COUNT(OrderID) AS Total_Orders_Count
FROM
    orders
GROUP BY
    CustomerID
ORDER BY
    Total_Orders_Count DESC;
    
-- top 20%(more than or = 15) are ' Highly Frequent' the next 50%(more than or =7) are 'Frequent' and the rest are 'Occasional/New'

WITH Customer_Order_Counts AS (         --  Calculating the total number of orders for each customer
    SELECT
        CustomerID,
        COUNT(OrderID) AS Total_Orders
    FROM
        orders
    GROUP BY
        CustomerID
),
Customer_Segments AS (                    -- Assigning a segment based on Total_Orders_Count 
    SELECT
        CustomerID,
        Total_Orders,
        CASE
            WHEN Total_Orders >= 15 THEN 'Highly Frequent' -- Top Tier
            WHEN Total_Orders >= 7 THEN 'Frequent'         -- Middle Tier
            ELSE 'Occasional/New'                         -- Bottom Tier
        END AS Order_Segment
    FROM
        Customer_Order_Counts
)
                                                                                                  
											               -- Calculating how many orders were placed "by" customers in each segment
SELECT
    s.Order_Segment,
    COUNT(c.CustomerID) AS Number_Of_Customers_In_Segment,
    SUM(s.Total_Orders) AS Total_Orders_Placed_By_Segment,
	ROUND(CAST(SUM(s.Total_Orders) AS REAL) / COUNT(c.CustomerID),2) AS Avg_Orders_Per_Customer_In_Segment  -- The average order frequency (orders per customer) for that segment
FROM
    Customer_Segments s
JOIN
    customers c ON s.CustomerID = c.CustomerID
GROUP BY
    s.Order_Segment
ORDER BY
    Total_Orders_Placed_By_Segment DESC;


######6.What is the geographic and title-wise distribution of employees? 

SELECT
    Country,
    City,
    Title,
    COUNT(EmployeeID) AS Employee_Count
FROM
    employees
GROUP BY
    Country,
    City,
    Title
ORDER BY
    Country ASC,
    City ASC,
    Employee_Count DESC;

#######7.What trends can we observe in hire dates across employee titles? 

SELECT
    Title,
    MIN(HireDate) AS Earliest_HireDate,
    MAX(HireDate) AS MostRecent_HireDate,
    COUNT(EmployeeID) AS Employee_Count
FROM
    employees
GROUP BY
    Title
ORDER BY
    Earliest_HireDate ASC; 
    
########8.What patterns exist in employee title and courtesy title distributions? 
SELECT
    Title,
    TitleOfCourtesy,
    COUNT(EmployeeID) AS Employee_Count
FROM
    employees
GROUP BY
    Title,
    TitleOfCourtesy
ORDER BY
    Title ASC,
    Employee_Count DESC; 
    
#########9.Are there correlations between product pricing, stock levels, and sales performance? 

SELECT
    P.ProductID,
    P.ProductName,
    P.UnitPrice AS Product_Price,
    P.UnitsInStock AS Current_Stock_Level,
    SUM(OD.Quantity) AS Total_Quantity_Sold,
    SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) AS Total_Revenue
FROM
    products P
JOIN
    order_details OD ON P.ProductID = OD.ProductID
GROUP BY
    P.ProductID, P.ProductName, P.UnitPrice, P.UnitsInStock
ORDER BY
    Total_Quantity_Sold DESC;
    
##########10.How does product demand change over months or seasons? 
SELECT
	DATE_FORMAT(o.OrderDate, '%m-%Y') AS Order_Month_Year,        -- Extract the year and month to group by
    SUM(od.Quantity) AS Total_Products_Sold                       -- Calculate the total quantity of products sold 
FROM
    orders o
JOIN
    order_details OD ON o.OrderID = OD.OrderID
GROUP BY
    Order_Month_Year
ORDER BY
    Order_Month_Year;
    
###########11.Can we identify anomalies in product sales or revenue performance? 

-- Highest and Lowest Performer Can be Identified 
SELECT
    P.ProductID,
    P.ProductName,
    SUM(OD.Quantity) AS Total_Quantity_Sold,                                          -- Total units sold
   ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)),2)AS Total_Revenue       -- Total net revenue (accounting for discount)
FROM
    products P
JOIN
    order_details OD ON P.ProductID = OD.ProductID
GROUP BY
    P.ProductID, P.ProductName
ORDER BY
    Total_Revenue DESC;

-- Products with Zero Sales(Zero Performer) if exists
SELECT
    P.ProductID,
    P.ProductName, 
    P.UnitsInStock
FROM
    products P
LEFT JOIN
    order_details OD ON P.ProductID = OD.ProductID
WHERE
    OD.ProductID IS NULL;                              -- Product has no matching records in Order Details 
    

############12. Are there any regional trends in supplier distribution and pricing? 

SELECT
    s.Country AS Supplier_Country,                       
    COUNT(DISTINCT s.SupplierID) AS Number_Of_Suppliers,      -- Regional Distribution: Count of distinct suppliers
   ROUND(AVG(p.UnitPrice),2)AS Average_Product_Price                 -- Pricing Trend: Average Unit Price of all products supplied from that country
FROM
    suppliers s
JOIN
    products p ON s.SupplierID = p.SupplierID
GROUP BY
    s.Country
ORDER BY
    Number_Of_Suppliers DESC, Average_Product_Price DESC;   
    
    
#############13. How are suppliers distributed across different product categories?

-- This Query reveals that which categories have the most diverse supply chains.
SELECT
    c.CategoryName,
    COUNT(DISTINCT s.SupplierID) AS Number_Of_Unique_Suppliers
FROM
    suppliers s
JOIN
    products p ON s.SupplierID = p.SupplierID
JOIN
    categories c ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryName
ORDER BY
    Number_Of_Unique_Suppliers DESC;  

##############14. How do supplier pricing and categories relate across different regions? 

-- This query groups the products by the supplier's country and the product's category, 
-- then calculates the average price of products supplied from that country within that category.

SELECT
    s.Country AS Supplier_Country,
    c.CategoryName,
   ROUND(AVG(p.UnitPrice),2) AS Average_Category_Price     -- -- Calculating the average price of products in that category from that country
FROM
    suppliers s
JOIN
    products p ON s.SupplierID = p.SupplierID
JOIN
    categories c ON p.CategoryID = c.CategoryID
GROUP BY
    s.Country, c.CategoryName
ORDER BY
    s.Country, Average_Category_Price DESC; 
    
    




















