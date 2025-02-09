/*
Views - Making complex queries accessible, it helps in encapsulating (hiding)
It is a virtual table, contains result of the sql query. It contains rows and columns just like a real table
Views cannot have order by clause
Advantages -
- Simplification
- Consistent logic
- Query Abstraction
*/

--Creating the view:

CREATE VIEW Sales.vw_SalesRolling3Days AS

SELECT
    OrderDate,
    TotalDue,
	SalesLast3Days = SUM(TotalDue) OVER(ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
FROM (
	SELECT
		OrderDate,
		TotalDue = SUM(TotalDue)
	FROM
		Sales.SalesOrderHeader

	WHERE YEAR(OrderDate) = 2014

	GROUP BY
		OrderDate
) X


--Querying against the view:

SELECT
	OrderDate
   ,TotalDue
   ,SalesLast3Days
   ,[% Rolling 3 Days Sales] = FORMAT(TotalDue / SalesLast3Days, 'p')

FROM AdventureWorks2019.Sales.vw_SalesRolling3Days