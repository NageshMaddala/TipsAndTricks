/* Notes:
1. Operates over a window of rows defined by a partition by clause
2. Returns the first value from the specified column within that window
3. Useful for comparing the values in each row of a window with the first one
*/

Select
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	Ranking = ROW_NUMBER() Over(Partition by SalesOrderId order by LineTotal desc),
	HighestTotal = FIRST_VALUE(LineTotal) Over(Partition by SalesOrderId order by LineTotal desc),
	LowestTotal = FIRST_VALUE(LineTotal) Over(Partition by SalesOrderId order by LineTotal)
From Sales.SalesOrderDetail
Order By
	SalesOrderID, LineTotal Desc

--Customer orders by date

SELECT
	CustomerID,
	OrderDate,
	TotalDue,
	FirstOrderAmt = FIRST_VALUE(TotalDue) Over(Partition By CustomerId Order by OrderDate)
From Sales.SalesOrderHeader
Order by CustomerID, OrderDate

SELECT
	CustomerID,
	OrderDate,
	TotalDue,
	FirstOrderAmt = FIRST_VALUE(TotalDue) Over(Partition By CustomerId Order by OrderDate desc)
From Sales.SalesOrderHeader
Order by CustomerID, OrderDate














