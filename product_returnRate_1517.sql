-- UNION SALE IN 2015, 2016, 2017 BY DESCENDING ORDER
SELECT *  
FROM (SELECT * FROM AdventureWorks_Sales_2015
UNION (SELECT * FROM AdventureWorks_Sales_2016)
UNION (SELECT * FROM AdventureWorks_Sales_2017)) as total_1517sale
ORDER BY total_1517sale.OrderDate DESC;

-- FIND TOTAL ORDER QUANTITY AND TOTAL RETURN QUANTITY BASED ON ProductKey AND TerritoryKey
SELECT sl.ProductKey, sl.TerritoryKey, 
       SUM(sl.OrderQuantity) as total_order,
	   --case when to get rid of null value
       CASE WHEN SUM(rt.ReturnQuantity) IS NULL THEN 0 ELSE SUM(rt.ReturnQuantity) END AS total_return
FROM (SELECT * FROM AdventureWorks_Sales_2015
      UNION SELECT * FROM AdventureWorks_Sales_2016
      UNION SELECT * FROM AdventureWorks_Sales_2017) as sl 
LEFT JOIN AdventureWorks_Returns rt ON rt.ProductKey = sl.ProductKey AND rt.TerritoryKey = sl.TerritoryKey
GROUP BY sl.ProductKey, sl.TerritoryKey, rt.ProductKey, rt.TerritoryKey
ORDER BY ProductKey ASC;

/*JOIN TABLE CONTAINING SUM OF ORDER AND SUM OF RETURN
WITH AdventureWorks_Products TO GET FINAL RESULT*/
SELECT pd.ProductKey, total_OR.total_order, total_OR.total_return, 
       total_OR.total_return/total_OR.total_order as ReturnRate, 
       pd.ProductSKU, pd.ProductName, pd.ModelName, pd.ProductCost, pd.ProductPrice
FROM (SELECT sl.ProductKey, sl.TerritoryKey, 
             SUM(sl.OrderQuantity) as total_order, 
             CASE WHEN SUM(rt.ReturnQuantity) IS NULL THEN 0 ELSE SUM(rt.ReturnQuantity) END AS total_return
      FROM (SELECT * FROM AdventureWorks_Sales_2015
            UNION SELECT * FROM AdventureWorks_Sales_2016
            UNION SELECT * FROM AdventureWorks_Sales_2017) as sl
LEFT JOIN AdventureWorks_Returns rt ON rt.ProductKey = sl.ProductKey AND rt.TerritoryKey = sl.TerritoryKey
GROUP BY sl.ProductKey, sl.TerritoryKey, rt.ProductKey, rt.TerritoryKey) as total_OR
LEFT JOIN AdventureWorks_Products pd ON pd.ProductKey = total_OR.ProductKey
ORDER BY ProductKey;
