-- 1. All rows

Select
*
From [Sales].[SalesOrderHeader]

Select
*
From [Sales].[SalesPerson]

-- 2. Count of all rows

Select
SUM(TotalDue)
From [Sales].[SalesOrderHeader]

Select 
SUM(SalesYTD)
From [Sales].[SalesPerson]

-- 3. Adding new fields to aggregate query
Select
TotalSales = Sum(TotalDue), SalesPersonId
From [Sales].[SalesOrderHeader]
Group by
SalesPersonID

-- Window Functions
-- Over() keyword is window function
-- 4. Sales Person YTD sales along with all records
-- no need of grouping or other things
Select
*, [Total YTD Sales] = Sum(SalesYTD) Over(), 
[Max YTD Sales] = MAX(SalesYTD) Over(),
[% of Best Performer] = [SalesYTD]/MAX([SalesYTD]) Over()
From [Sales].[SalesPerson]

-- using aggregate function
Select
Max(SalesYTD)
From [Sales].[SalesPerson]

/* 
Notes:
1. Window functions allow you to include aggregate calculations in your queries, without changing the output in any way.
2. The aggregate calcuation is simple tacked on to the query as an additional column
3. It is also possible to group these calculations, just like we can with aggregate queries, using partition
*/