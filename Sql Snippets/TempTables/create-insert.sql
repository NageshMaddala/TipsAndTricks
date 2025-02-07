CREATE TABLE #Sales
(
	OrderDate Date,
	OrderMonth Date,
	TotalDue Money,
	OrderRank Int
)

INSERT INTO #Sales
(
	OrderDate,
	OrderMonth,
	TotalDue,
	OrderRank
)
SELECT 
	OrderDate,
	OrderMonth = DATEFROMPARTS(Year(OrderDate), Month(OrderDate), 1),
	TotalDue,
	OrderRank =  ROW_NUMBER() OVER(Partition By DATEFROMPARTS(Year(OrderDate), Month(OrderDate), 1) ORDER BY TotalDue Desc) 
	From Sales.SalesOrderHeader

Select * from #Sales
DROP TABLE #Sales