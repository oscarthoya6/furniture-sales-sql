Select*
FROM sales_data

SELECT COUNT(*) NO_of_Entries
FROM [Furniture Sales]

--Starting and Ending Dates*/
SELECT MIN(order_date) Start_Date, MAX(order_date) End_Date
FROM [Furniture Sales]

-- Total sales, total quantity, and total profit for the entire year:
SELECT YEAR(order_date) Year_Start,
       CAST(SUM(total_sales) as decimal (10,2)) Total_Sales,
	   SUM(quantity) Total_Quantity,
	   CAST(SUM(profit) as decimal (10,2)) Total_Profit
FROM sales_data
GROUP BY YEAR(order_date)

-- Summary table showing total sales by month:
SELECT
      YEAR(order_date) Order_Year,
	  MONTH(order_date) Order_Month,
	  CAST(SUM(total_sales) as decimal (10,2)) Total_Sales
FROM sales_data
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)

-- Breakdown of total sales by product category and sub-category:
SELECT
      category,sub_category,CAST(SUM(total_sales) as decimal (10,2)) Total_Sales
FROM sales_data
GROUP BY category,sub_category
Order BY category,sub_category

-- CUSTOMER SEGMENTATION
-- Customer profiles summarizing total sales and profit per customer:
SELECT customer_id,customer_name,
       CAST(SUM(total_sales) as decimal (10,2)) Total_Sales
FROM sales_data
GROUP BY customer_id,customer_name
ORDER BY Total_Sales DESC

--Group customers by market segment:
SELECT market_segment,
       COUNT(DISTINCT customer_id) Total_Customers,
	   CAST(AVG(total_sales) as decimal (10,2)) Avg_Sales_Per_Customers,
	   CAST(SUM(profit) as decimal (10,2))Total_Profit 
FROM sales_data
GROUP BY market_segment

--Top 10 customers by total sales and their regions:
SELECT 
       TOP 10 customer_id,customer_name,region, 
       CAST(SUM(total_sales) as decimal (10,2)) Total_Sales
FROM sales_data
GROUP BY customer_id,customer_name,region
ORDER BY Total_Sales desc

--Most popular products in each market segment:
SELECT market_segment,product_name,
      COUNT(order_id) Product_ID
FROM sales_data
GROUP BY market_segment,product_name,Product_ID
ORDER BY Product_ID DESC

--Customer purchasing frequency (e.g., more than 3 purchases):
SELECT customer_id,customer_name,
      COUNT(order_id) AS Order_Count
FROM sales_data
GROUP BY customer_id,customer_name
HAVING COUNT(order_id)>3

-- Sales Performance Dashboard
--Total sales, profit, and quantity sold for the current month compared to the previous month:
SELECT YEAR(order_date) Year_Date,
       MONTH(order_date) Month_Date,
	   CAST(SUM(total_sales) as decimal (10,2)) Total_Sales,
	   CAST(SUM(profit)  as decimal (10,2)) Total_Profit,
	   CAST(SUM(quantity) as decimal (10,2)) Total_Quantity
FROM sales_data
--WHERE order_date BETWEEN DATEADD(MONTH,1,GETDATE()) AND GETDATE()
GROUP BY YEAR(order_date),MONTH(order_date)

--Breakdown of sales by region and market segment:
SELECT region,market_segment,
       CAST(SUM(total_sales) as decimal (10,2)) Total_Sales
FROM sales_data
GROUP BY region,market_segment

--KPIs for AOV, CLV, and profit margin:
--AOV

SELECT CAST(AVG(total_sales) AS decimal (10,2)) Average_Order_Value
FROM sales_data

---  CLV
SELECT customer_id,customer_name,
       CAST(SUM(profit) as decimal (10,2)) Total_Profit
FROM dbo.sales_data
GROUP BY customer_id,customer_name
ORDER BY Total_Profit DESC

-- Profit Margin
SELECT CAST(SUM(profit)/SUM(total_sales) as decimal (10,2)) Profit_Margin
FROM sales_data

--Track sales growth month-over-month:
SELECT
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
CAST(SUM(total_sales) AS DECIMAL (10,2)) total_sales,
LAG(SUM(total_sales)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)) AS
previous_month_sales,
(SUM(total_sales) - LAG(SUM(total_sales)) OVER (ORDER BY YEAR(order_date),
MONTH(order_date))) / LAG(SUM(total_sales)) OVER (ORDER BY YEAR(order_date),
MONTH(order_date)) AS month_over_month_growth
FROM sales_data
GROUP BY YEAR(order_date), MONTH(order_date)