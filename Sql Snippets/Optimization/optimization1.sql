/*
1. What slows down queries the most?
Generally speaking, joins against or between very large tables (millions or 100's of millions of records)

What can we do about it?
a. Define a filtered dataset as early as possible in our process, so we can join additional
   tables to a smaller core population
b. Avoid several joins in a single select query, especially those involving large tables
c. Instead, use Update statements to populate fields in a temp table, one source table at a time
d. Apply indexes to fields that will be used in JOINS
*/

-- Here is the sample query, please see if you can optimize

Select 
	A.SalesOrderID, A.OrderDate, B.ProductID, B.LineTotal,
	C.[Name] As ProductName,
	D.[Name] As ProductSubCategory,
	E.[Name] As ProductCategory
From Sales.SalesOrderHeader A
	JOIN Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID
	JOIN Production.Product C
		ON B.ProductID = C.ProductID
	JOIN Production.ProductSubcategory D
		ON C.ProductSubcategoryID = D.ProductSubcategoryID
	JOIN Production.ProductCategory E
		ON D.ProductCategoryID = E.ProductCategoryID
WHERE YEAR(A.OrderDate) = 2012

-- Here is the solution, add the data into temp table using the filter
-- this will eliminate the need to filter more records from source table
-- compared to the records available in the temp table. This will help in
-- the performance specially when the record set is high

Create Table #Sales2012
(
	SalesOrderID int,
	OrderDate Date
)

Insert into #Sales2012
(
	SalesOrderID,
	OrderDate
)

Select
	SalesOrderID,
	OrderDate
From Sales.SalesOrderHeader
Where YEAR(OrderDate) = 2012

-- Create master temp table with all the required fields and populate the records we are interested
-- And then use series of update statements we are interested in

Create Table #ProductsSold2012
(
	SalesOrderId int,
	OrderDate date,
	LineTotal money,
	ProductId int,
	ProductName varchar(64),
	ProductSubCategoryId int,
	ProductSubCategory varchar(64),
	ProductCategoryId int,
	ProductCategory varchar(64)
)

Insert into #ProductsSold2012
(
	SalesOrderId,
	OrderDate,
	LineTotal,
	ProductId
)

Select 
	A.SalesOrderID,
	A.OrderDate,
	B.LineTotal,
	B.ProductID
From #Sales2012 A
	Join Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID

--select * from #ProductsSold2012
-- Now, populate remaining fields

Update #ProductsSold2012
SET 
	ProductName = B.[Name],
	ProductSubCategoryId = B.ProductSubcategoryID
From #ProductsSold2012 A
	JOIN Production.Product B
		ON A.ProductId = B.ProductID
		
Update A
SET 
	ProductSubCategory = B.[Name],
	ProductCategoryId = B.ProductCategoryID
From #ProductsSold2012 A
	JOIN Production.ProductSubcategory B
		ON A.ProductSubCategoryId = B.ProductSubcategoryID

Update A
SET 
	ProductCategory = B.[Name]	
From #ProductsSold2012 A
	JOIN Production.ProductCategory B
		ON A.ProductCategoryId = B.ProductCategoryID
