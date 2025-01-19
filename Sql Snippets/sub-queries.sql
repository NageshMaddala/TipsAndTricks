/* Notes:
1. Multi-step sql queries are extremely common in the real world of data analysis
2. Subqueries are best for straightforward, two-step queries
3. Sql gives us other techniques that are better-suited to complex, many-step analysis
*/ 

Select
*
From
(
Select 
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	LineTotalRanking = ROW_NUMBER() Over(Partition by salesorderId order by linetotal desc)
From Sales.SalesOrderDetail
) A
Where A.LineTotalRanking =  1

-- Rows Between windows function

/* Rolling 3 day total */
Select
	OrderDate,
	TotalDue,
	SalesLast3Days = Sum(TotalDue) Over(Order By OrderDate Rows between 2 preceding and current row)
From (
	Select
		OrderDate,
		TotalDue = Sum(TotalDue)
	From
	Sales.SalesOrderHeader
	Where year(OrderDate) =2014
	Group By
		OrderDate
) A
Order by OrderDate

/* Rolling 3 day total not including current day */
Select
	OrderDate,
	TotalDue,
	SalesLast3Days = Sum(TotalDue) Over(Order By OrderDate Rows between 3 preceding and 1 Preceding)
From (
	Select
		OrderDate,
		TotalDue = Sum(TotalDue)
	From
	Sales.SalesOrderHeader
	Where year(OrderDate) =2014
	Group By
		OrderDate
) A
Order by OrderDate

/* Rolling 3 day total, spanning previous and following row */
/* current row is implied */
Select
	OrderDate,
	TotalDue,
	SalesLast3Days = Sum(TotalDue) Over(Order By OrderDate Rows between 1 preceding and 1 following)
From (
	Select
		OrderDate,
		TotalDue = Sum(TotalDue)
	From
	Sales.SalesOrderHeader
	Where year(OrderDate) =2014
	Group By
		OrderDate
) A
Order by OrderDate


/* Rolling 3 day average - aka, a "moving" average */
Select
	OrderDate,
	TotalDue,
	SalesLast3Days = Avg(TotalDue) Over(Order By OrderDate Rows between 2 preceding and current row)
From (
	Select
		OrderDate,
		TotalDue = Sum(TotalDue)
	From
	Sales.SalesOrderHeader
	Where year(OrderDate) =2014
	Group By
		OrderDate
) A
Order by OrderDate