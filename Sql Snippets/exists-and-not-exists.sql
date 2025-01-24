/*
1. We use joins to add fields from different tables to our select queries
2. We sometimes also apply criteria to those fields in our where clause
3. But what if we only need to bring in a field to use it in our where, and don't need to see it in our query or output
But if we can accomplish the same thing with a join, why do we even need exists?
For one-to-one relationships, there really isn't much of an advantage to using exists
However, exists offers some powerful advantages when dealing with one-to-many relationships

Use Exists when
1. You want to apply criteria to fields from secondary table, but don't need to include those fields in your output
2. You want to apply criteria to fields from seconday table, while ensuring that multiple matches in the secondary table
won't duplicate data from the primary table in your output
3. You need to check a secondary table to make sure a match of some type does not exist
*/

--Example 1

SELECT * FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesOrderID = 43683

SELECT * FROM AdventureWorks2019.Sales.SalesOrderDetail WHERE SalesOrderID = 43683

--Example 2: One to many join with criteria

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2019.Sales.SalesOrderHeader A
	INNER JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID

WHERE EXISTS(
	SELECT
		1

	FROM AdventureWorks2019.Sales.SalesOrderDetail B
	
	WHERE B.LineTotal > 10000
		AND A.SalesOrderID = B.SalesOrderID
	)

ORDER BY 1





--Example 3: Using EXISTS to pick only the records we need

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2019.Sales.SalesOrderHeader A

WHERE EXISTS (
	SELECT
	1
	FROM AdventureWorks2019.Sales.SalesOrderDetail B
	WHERE A.SalesOrderID = B.SalesOrderID
		AND B.LineTotal > 10000
)

ORDER BY 1



--Example 4: exclusionary one to many join

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue
	  ,B.SalesOrderDetailID
	  ,B.LineTotal

FROM AdventureWorks2019.Sales.SalesOrderHeader A
	INNER JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID

WHERE B.LineTotal < 10000
	AND A.SalesOrderID = 43683

ORDER BY 1



--Example 5: but this doesn't even do what we want!

SELECT
*
FROM AdventureWorks2019.Sales.SalesOrderDetail

WHERE SalesOrderID = 43683

ORDER BY LineTotal DESC




--Example 6: NOT EXISTS

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2019.Sales.SalesOrderHeader A

WHERE NOT EXISTS (
	SELECT
	1
	FROM AdventureWorks2019.Sales.SalesOrderDetail B
	WHERE A.SalesOrderID = B.SalesOrderID
		AND B.LineTotal > 10000
)
	--AND A.SalesOrderID = 43683

ORDER BY 1