--Cleaned out the rows with NULL values in Invoice_Date
DELETE FROM Adidas_Sales
WHERE Invoice_Date IS NULL

--Created a new table called Texas_Sales
SELECT States, City, Product, Price_per_unit, Units_sold, Total_sales, Operating_profit
INTO Texas_Sales
from Adidas_Sales
where States = 'Texas';

--Added a new column margin to Texas_Sales
ALTER TABLE Texas_Sales
ADD margin float NULL
    
-Inputing values into the new column margin
UPDATE Texas_Sales 
SET margin = Operating_profit/Total_sales;

--Created a new table called California_Sales
SELECT States, City, Product, Price_per_unit, Units_sold, Total_sales, Operating_profit
INTO California__Sales
from Adidas_Sales
where States = 'California';

--Add sales column from two tables into a new table-Compare
SELECT Texas_Sales.Total_sales AS TexasSales, California_Sales.Total_sales AS CaliforniaSales
INTO Compare
FROM Texas_Sales
CROSS JOIN California_Sales;

--Add new column(max_value) to table Compare
ALTER TABLE Compare
ADD max_value varchar(50) null
    
--Compare Texas_Sales with California_Sales and return the state with the higher Sales in max_value column
UPDATE Compare
set max_value =
CASE
   WHEN CaliforniaSales > TexasSales THEN 'California'
   WHEN CaliforniaSales < TexasSales THEN 'Texas'
   ELSE 'Equal'
    
--Total sales for both years for each state
SELECT States, sum(Total_sales) as sales_per_state
rank() over( partition by States
order by sales_per_state)
from Adidas_Sales


--Displays total sales for each month in year 2020 and 2021
Select DATENAME(month,Invoice_Date)as 'Month', DATENAME(year, Invoice_Date) as 'Year', sum(Total_sales) as sales_per_month
from Adidas_Sales
group by DATENAME(year, Invoice_Date), DATENAME(month,Invoice_Date)
order by DATENAME(year, Invoice_Date), DATENAME(month,Invoice_Date)

--Displays sales revenue for each retailer in each region.
SELECT Region, Retailer, sum(Total_sales) as sales_per_region
FROM Adidas_Sales
GROUP BY Region, Retailer
ORDER by Region

--Categorizing Profitable Retailers using Operating_margin
SELECT Retailer, Retailer_ID, Region, States, City, Operating_margin,
CASE
    WHEN Operating_margin > 0.15 THEN 'The business is profitable'
    WHEN Operating_margin = 0.15 THEN 'The business is profitable but needs improvement'
    ELSE 'The business is profitable but in a danger zone '
END AS Profitability
FROM Adidas_Sales;
