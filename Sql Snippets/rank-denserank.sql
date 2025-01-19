/* Notes
1. If you are trying to pick exactly one record from each partition group - either the first or last - Use Row_Numer
2. This is probably the most common scenario
3. Rank and Dense_Rank are helpful in rarer, more specialized cases
4. It ultimately depends on what you are trying to get out of your data
*/
--ROW_NUMBER, RANK, AND DENSE_RANK, compared

SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	Ranking = ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC),
	RankingWithRank = RANK() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC),
	RankingWithDenseRank = DENSE_RANK() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC)

FROM AdventureWorks2019.Sales.SalesOrderDetail
WHERE SalesOrderID = 43659
ORDER BY SalesOrderID, LineTotal DESC

--Update Sales.SalesOrderDetail 
--Set OrderQty = 1
--where SalesOrderID = 43659 and SalesOrderDetailID = 7

--select * from Sales.SalesOrderDetail where SalesOrderID = 43659 and SalesOrderDetailID = 7