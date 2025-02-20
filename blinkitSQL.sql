	-- Data Processing
	SELECT  *
	FROM blinkit_data

	SELECT  COUNT(*)
	FROM blinkit_data

	-- Data Cleaning

	--Cleans inconsistent data in "Item_Fat_Content" by standardizing similar values.
	UPDATE blinkit_data
	SET Item_Fat_Content = 
	CASE 
	WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
	WHEN Item_Fat_Content = 'reg' THEN 'Regular'
	ELSE Item_Fat_Content END;

	SELECT DISTINCT Item_Fat_Content
	FROM blinkit_data
--KPIS 

	SELECT ROUND(SUM(Total_Sales) / 1000000, 2) AS Total_sales 
	FROM blinkit_data

	SELECT ROUND(SUM(Total_Sales) / 1000000, 2) AS Sales_LowFat
	FROM blinkit_data
	WHERE Item_Fat_Content ='Low Fat'

	SELECT CAST(AVG(Total_Sales)AS decimal(10,0)) AS Avg_Sales
	FROM blinkit_data

	SELECT COUNT(*) AS No_Of_Items
	FROM blinkit_data 

	SELECT ROUND(AVG(Rating),1) AS Avg_Rating
	FROM blinkit_data

-- Sales by item fat content
SELECT Item_Fat_Content,
		ROUND(SUM(Total_Sales),2) AS Total_Sales,
		CAST(AVG(Total_Sales)AS decimal(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		ROUND(AVG(Rating),2) AS Avg_Rating
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2020
GROUP BY Item_Fat_Content 
ORDER BY Total_Sales DESC

--Sales by item type

SELECT  Item_Type,
		ROUND(SUM(Total_Sales)/10, 2) AS Total_Sales_Thousands,
		CAST(AVG(Total_Sales) AS DECIMAL(10, 0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		ROUND(AVG(Rating), 2) AS Avg_Rating,
		ROW_NUMBER() OVER (ORDER BY Sum(Total_Sales) DESC) AS Sales_Rank 
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2020
GROUP BY Item_Type 
ORDER BY Total_Sales_Thousands DESC

-- Sales By Outlet_Location_Type

SELECT  Outlet_Location_Type,Item_Fat_Content,
		ROUND(SUM(Total_Sales)/10, 2) AS Total_Sales_Thousands
FROM blinkit_data
GROUP BY Outlet_Location_Type,Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC

--

SELECT Outlet_Location_Type,
		ISNULL([Low Fat], 0) AS Low_Fat,
		ISNULL([Regular], 0) AS Regular
FROM
(
SELECT Outlet_Location_Type,Item_Fat_Content,
	ROUND(SUM(Total_Sales),2) AS Total_Sales
	FROM blinkit_data
	GROUP BY Outlet_Location_Type,Item_Fat_Content
) AS SourceTable
PIVOT
(
	SUM(Total_Sales)
	FOR Item_Fat_Content IN ([Low Fat],[Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type

-- Sales By Outlet_Establishment_Year
SELECT Outlet_Establishment_Year,
	ROUND(SUM(Total_Sales),2) AS Total_Sales,
	CAST(AVG(Total_Sales) AS DECIMAL(10, 0)) AS Avg_Sales,
	COUNT(*) AS No_Of_Items,
	ROUND(AVG(Rating), 2) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year ASC

--Sales By Outlet Size
SELECT Outlet_Size,
    ROUND(SUM(Total_Sales), 2) AS Total_Sales,
    ROUND(SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER (), 2) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;
