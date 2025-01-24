/*
1. Correlated subqueries are subqueries that run once for each record in the main/outer query
2. They then return a scalar output (i.e., a single value) for each of those records
3. Correlated subqueries can be used in either the select or where clauses
*/

SELECT 
       SalesOrderID
      ,OrderDate
      ,SubTotal
      ,TaxAmt
      ,Freight
      ,TotalDue
	  ,MultiOrderCount = --correlated subquery
	  (
		  SELECT
		  COUNT(*)
		  FROM AdventureWorks2019.Sales.SalesOrderDetail B
		  WHERE A.SalesOrderID = B.SalesOrderID
		  AND B.OrderQty > 1
	  )

  FROM AdventureWorks2019.Sales.SalesOrderHeader A

SELECT 
       A.SalesOrderID
      ,OrderDate
      ,SubTotal
      ,TaxAmt
      ,Freight
      ,TotalDue
  FROM AdventureWorks2019.Sales.SalesOrderHeader A inner join Sales.SalesOrderDetail B
  on A.SalesOrderID = B.SalesOrderID and A.SalesOrderID = 43659 and B.OrderQty > 1

  --Exercise 1 Solution

SELECT 
	   PurchaseOrderID
      ,VendorID
      ,OrderDate
      ,TotalDue
	  ,NonRejectedItems = 
	  (
		  SELECT
			COUNT(*)
		  FROM Purchasing.PurchaseOrderDetail B
		  WHERE A.PurchaseOrderID = B.PurchaseOrderID
		  AND B.RejectedQty = 0
	  )

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A





--Exercise 2 Solution

SELECT 
	   PurchaseOrderID
      ,VendorID
      ,OrderDate
      ,TotalDue
	  ,NonRejectedItems = 
	  (
		  SELECT
			COUNT(*)
		  FROM Purchasing.PurchaseOrderDetail B
		  WHERE A.PurchaseOrderID = B.PurchaseOrderID
		  AND B.RejectedQty = 0
	  )
	  ,MostExpensiveItem = 
	  (
		  SELECT
			MAX(B.UnitPrice)
		  FROM Purchasing.PurchaseOrderDetail B
		  WHERE A.PurchaseOrderID = B.PurchaseOrderID
	  )

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A

