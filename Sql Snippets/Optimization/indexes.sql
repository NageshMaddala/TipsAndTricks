/*
What are indexes?
1. Indexes are database objects that can make queries against your tables faster
2. They do this by sorting the data in the fields they apply to - either in the table itself, or in a separate data structure
3. This sorting allows the database engine to locate records within a table without having to search through the table row-by-row
4. There are 2 types of indexes - clustered and non-clustered
*/

/*
Composite Key is also called Compound Key, it's a combination of 2 keys ex: primary key on a column and some other column within the table
Clustered Indexes:
1. The rows of a table with a clustered index are physically sorted based on the field or fields the index is applied to
2. A table with a primary key is given a clustered index (based on the primary key field) by default
3. Most tables should have at least a clustered index, as queries against tables with a clustered index generally tend to be faster
4. A table may only have one clustered index

Strategies:
1. Apply a clustered index to whatever field - or fields - are most likely to be used in a join against the table 
2. Ideally this field (or combination of fields) should also be the one that most uniquely defines a record in the table
3. Whatever field would be a good candidate for a primary key of a table, is usually also a good candidate for a clustered index
*/

/*
Non-clustered Indexes:
1. A table may have many non-clustered indexes
2. Non-clustered indexes do not physically sort the data in a table like clustered indexes do
3. The sorted order of the field or fields non-clustered indexes apply to is stored in an external data structure, which works like a
   kind of phone book

Strategies:
1. If you will be joining your table on fields besides the one "covered" by the clustered index, consider non-clustered indexes on those fields
2. You can add as many non-clustered indexes as we like, but should be judicious in doin so
3. Fields covered by a non-clustered index should still have a high level of uniqueness
*/

/*
Indexes: General Approach
1. It's how our table utilized in joins that should drive our use and design of indexes
2. You should generally add a clustered index first, and then layer in non-clustered indexes as needed to "cover" additional fields used in joins against our table
3. Indexes take up memory in the database, so only add them when they are really needed
4. They also make inserts to tables take longer, so you should generally add indexes after data has been inserted to the table
*/

CREATE TABLE #Sales2012 
(
SalesOrderID INT,
OrderDate DATE
)

INSERT INTO #Sales2012
(
SalesOrderID,
OrderDate
)

SELECT
SalesOrderID,
OrderDate

FROM AdventureWorks2019.Sales.SalesOrderHeader

WHERE YEAR(OrderDate) = 2012


--1.) Add clustered index to #Sales2012


CREATE CLUSTERED INDEX Sales2012_idx ON #Sales2012(SalesOrderID)


--2.) Add sales order detail ID

CREATE TABLE #ProductsSold2012
(
SalesOrderID INT,
SalesOrderDetailID INT, --Add for clustered index
OrderDate DATE,
LineTotal MONEY,
ProductID INT,
ProductName VARCHAR(64),
ProductSubcategoryID INT,
ProductSubcategory VARCHAR(64),
ProductCategoryID INT,
ProductCategory VARCHAR(64)
)

INSERT INTO #ProductsSold2012
(
SalesOrderID,
SalesOrderDetailID,
OrderDate,
LineTotal,
ProductID
)

SELECT 
	   A.SalesOrderID
	  ,B.SalesOrderDetailID
	  ,A.OrderDate
      ,B.LineTotal
      ,B.ProductID

FROM #Sales2012 A
	JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID


--3.) Add clustered index on SalesOrderDetailID

CREATE CLUSTERED INDEX ProductsSold2012_idx ON #ProductsSold2012(SalesOrderDetailID)


--4.) Add nonclustered index on product Id

CREATE NONCLUSTERED INDEX ProductsSold2012_idx2 ON #ProductsSold2012(ProductID)



--3.) Add product data with UPDATE


UPDATE A
SET
ProductName = B.[Name],
ProductSubcategoryID = B.ProductSubcategoryID

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.Product B
		ON A.ProductID = B.ProductID


--4.) Add nonclustered index on product subcategory ID

CREATE NONCLUSTERED INDEX ProductsSold2012_idx3 ON #ProductsSold2012(ProductSubcategoryID)






UPDATE A
SET
ProductSubcategory= B.[Name],
ProductCategoryID = B.ProductCategoryID

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.ProductSubcategory B
		ON A.ProductSubcategoryID = B.ProductSubcategoryID


--5) Add nonclustered index on category Id

CREATE NONCLUSTERED INDEX ProductsSold2012_idx4 ON #ProductsSold2012(ProductCategoryID)


UPDATE A
SET
ProductCategory= B.[Name]

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.ProductCategory B
		ON A.ProductCategoryID = B.ProductCategoryID


SELECT * FROM #ProductsSold2012

