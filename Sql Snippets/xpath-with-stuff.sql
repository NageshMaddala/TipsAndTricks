--Step 1

		  SELECT
		  COUNT(*)
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659



--Step 2:

		  SELECT
		  *
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659

--Step 3:

		  SELECT
		  LineTotal
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659


--Step 4:

		  SELECT
		  LineTotal
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659
		  FOR XML PATH('')

--Step 5:

		  SELECT
		  ',' + CAST(CAST(LineTotal AS MONEY) AS VARCHAR)
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659
		  FOR XML PATH('')

--Step 6:

SELECT
	STUFF(
		  (
			  SELECT
			  ',' + CAST(CAST(LineTotal AS MONEY) AS VARCHAR)
			  FROM AdventureWorks2019.Sales.SalesOrderDetail A
			  WHERE A.SalesOrderID = 43659
			  FOR XML PATH('')
		  ),
		  1,1,'I''m stuffed!')



--Step 7:

SELECT 
       SalesOrderID
      ,OrderDate
      ,SubTotal
      ,TaxAmt
      ,Freight
      ,TotalDue
	  ,LineTotals = 
		STUFF(
			  (
				  SELECT
				  ',' + CAST(CAST(LineTotal AS MONEY) AS VARCHAR)
				  FROM AdventureWorks2019.Sales.SalesOrderDetail B
				  WHERE A.SalesOrderID = B.SalesOrderID 
				  FOR XML PATH('')
			  ),
			  1,1,''
		  )

FROM AdventureWorks2019.Sales.SalesOrderHeader A

--Exercise 1

SELECT 
       SubcategoryName = A.[Name]
	  ,Products =
		STUFF(
			(
				SELECT
					';' + B.Name

				FROM AdventureWorks2019.Production.Product B

				WHERE A.ProductSubcategoryID = B.ProductSubcategoryID

				FOR XML PATH('')

			),1,1,''
		)

  FROM AdventureWorks2019.Production.ProductSubcategory A



--Exercise 2

SELECT 
       SubcategoryName = A.[Name]
	  ,Products =
		STUFF(
			(
				SELECT
					';' + B.Name

				FROM AdventureWorks2019.Production.Product B

				WHERE A.ProductSubcategoryID = B.ProductSubcategoryID
					AND B.ListPrice > 50

				FOR XML PATH('')

			),1,1,''
		)

 FROM AdventureWorks2019.Production.ProductSubcategory A
