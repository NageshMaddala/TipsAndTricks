/*
CTE
1. Make complex multi stage queries more managable, it stores data in a virtual table
2. It helps in simply the complex query
3. Breaks complex code into simple sequential queries
*/

select top 1 * from Sales.SalesOrderHeader

--Select *
--From (
--select
--OrderDate, 
--TotalDue,
--OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1),
--OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue Desc)
--from Sales.SalesOrderHeader) x
--where OrderRank <= 10

/*
For the attached CTE problem statement, here is the solution using the SubQuery
*/

Select A.OrderMonth, A.Top10Total, PreviousTop10Total = B.Top10Total
From
(
Select
OrderMonth,
Top10Total = Sum(TotalDue)
From (
select
OrderDate, 
TotalDue,
OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1),
OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue Desc)
from Sales.SalesOrderHeader) x
where OrderRank <= 10
Group By OrderMonth) A
Left Join
(
Select
OrderMonth,
Top10Total = Sum(TotalDue)
From (
select
OrderDate, 
TotalDue,
OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1),
OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue Desc)
from Sales.SalesOrderHeader) x
where OrderRank <= 10
Group By OrderMonth) B on A.OrderMonth = DateAdd(Month, 1, B.OrderMonth)
Order by OrderMonth

-- practice
/* 
WITH Sales As
(
SELECT 
	OrderDate,
	TotalDue,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1),
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC)
From Sales.SalesOrderHeader
)
Select * from Sales where OrderRank <= 10 */


WITH Sales As
(
SELECT 
	OrderDate,
	TotalDue,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1),
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC)
From Sales.SalesOrderHeader
),
Top10 As (
SELECT
OrderMonth,
Top10Total = Sum(TotalDue)
From Sales where OrderRank <= 10
Group By OrderMonth
)

Select
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total
From Top10 A
	LEFT JOIN Top10 B
		ON A.OrderMonth = DATEADD(MONTH, 1, B.OrderMonth)


/*
Solution with the CTE
1. All CTE's with begin start WITH
2. It's a virtual table to access data
*/


--Refactored using CTE:

WITH Sales AS
(
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
)

,Top10Sales AS
(
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM Sales
WHERE OrderRank <= 10
GROUP BY OrderMonth
)


SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total

FROM Top10Sales A
	LEFT JOIN Top10Sales B
		ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)

ORDER BY 1
