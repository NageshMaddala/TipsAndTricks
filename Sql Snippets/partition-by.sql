/*
Notes:
1. Partition By allows us to compute aggregate totals for groups within our data, while still retaining row-level detail
2. Partition By assigns each row of your query output to a group, without collapsing your data into fewer rows as with group by
3. Instead of groups being assigned based on the distinct values ALL the non-aggregate columns of our data, we need to specify
the columns these groups will be based on
4. Along with aggreagated data, we can have access to the whole row level information. We will not loose any information
*/

-- Aggregate Function
Select 
ProductID, OrderQty, [ProductIdLineTotal] = SUM(LineTotal)
From [Sales].[SalesOrderDetail]
Group by
ProductId, OrderQty
Order by 1, 2 desc

-- Window function 
Select 
*,
[ProducIdLineTotal] = Sum(LineTotal) Over(Partition By ProductId, OrderQty)
From Sales.SalesOrderDetail
Order By ProductID, OrderQty desc

--Exercise 1:

SELECT 
  ProductName = A.Name,
  A.ListPrice,
  ProductSubcategory = B.Name,
  ProductCategory = C.Name


FROM AdventureWorks2019.Production.Product A
  JOIN AdventureWorks2019.Production.ProductSubcategory B
    ON A.ProductSubcategoryID = B.ProductSubcategoryID
  JOIN AdventureWorks2019.Production.ProductCategory C
    ON B.ProductCategoryID = C.ProductCategoryID


--Exercise 2:

SELECT 
  ProductName = A.Name,
  A.ListPrice,
  ProductSubcategory = B.Name,
  ProductCategory = C.Name,
  AvgPriceByCategory = AVG(A.ListPrice) OVER(PARTITION BY C.Name)

FROM AdventureWorks2019.Production.Product A
  JOIN AdventureWorks2019.Production.ProductSubcategory B
    ON A.ProductSubcategoryID = B.ProductSubcategoryID
  JOIN AdventureWorks2019.Production.ProductCategory C
    ON B.ProductCategoryID = C.ProductCategoryID


--Exercise 3:

SELECT 
  ProductName = A.Name,
  A.ListPrice,
  ProductSubcategory = B.Name,
  ProductCategory = C.Name,
  AvgPriceByCategory = AVG(A.ListPrice) OVER(PARTITION BY C.Name),
  AvgPriceByCategoryAndSubcategory = AVG(A.ListPrice) OVER(PARTITION BY C.Name, B.Name)

FROM AdventureWorks2019.Production.Product A
  JOIN AdventureWorks2019.Production.ProductSubcategory B
    ON A.ProductSubcategoryID = B.ProductSubcategoryID
  JOIN AdventureWorks2019.Production.ProductCategory C
    ON B.ProductCategoryID = C.ProductCategoryID


--Exercise 4:

SELECT 
  ProductName = A.Name,
  A.ListPrice,
  ProductSubcategory = B.Name,
  ProductCategory = C.Name,
  AvgPriceByCategory = AVG(A.ListPrice) OVER(PARTITION BY C.Name),
  AvgPriceByCategoryAndSubcategory = AVG(A.ListPrice) OVER(PARTITION BY C.Name, B.Name),
  ProductVsCategoryDelta = A.ListPrice - AVG(A.ListPrice) OVER(PARTITION BY C.Name)

FROM AdventureWorks2019.Production.Product A
  JOIN AdventureWorks2019.Production.ProductSubcategory B
    ON A.ProductSubcategoryID = B.ProductSubcategoryID
  JOIN AdventureWorks2019.Production.ProductCategory C
    ON B.ProductCategoryID = C.ProductCategoryID
