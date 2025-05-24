/* Notes:
1. Thus far, we have utilized window functions as a more advanced alternative to aggregate queries
2. However, they also give us something entirely new: the ability to rank records within our data
3. These rankings can either be applied accross the entire query output, or to the partitioned groups within it
*/

-- Ranking all records within each group of sales order IDs

Select
SalesOrderID,
SalesOrderDetailID,
LineTotal,
ProductIDLineTotal = Sum(LineTotal) Over(Partition by SalesOrderId),
Ranking = ROW_NUMBER() Over(Partition by SalesOrderId order by linetotal desc)
From Sales.SalesOrderDetail

Select
SalesOrderID,
SalesOrderDetailID,
LineTotal,
ProductIDLineTotal = Sum(LineTotal) Over(Partition by SalesOrderId),
Ranking = ROW_NUMBER() Over(Partition by SalesOrderId  order by linetotal desc)
From Sales.SalesOrderDetail

-- Ranking on the whole data set
Select
SalesOrderID,
SalesOrderDetailID,
LineTotal,
ProductIDLineTotal = Sum(LineTotal) Over(Partition by SalesOrderId),
Ranking = ROW_NUMBER() Over(order by linetotal desc)
From Sales.SalesOrderDetail

Select 
[ProductName] = PP.Name,
[ListPrice] = PP.ListPrice,
[ProductSubCategory] = PPS.Name,
[ProductCategory] = PPC.Name,
[Price Rank] = ROW_NUMBER() Over(order by PP.ListPrice desc),
[Category Price Rank] = ROW_NUMBER() Over(partition by PPC.Name order by PP.ListPrice desc),
[Top 5 Price In Category] =
	CASE
		WHEN ROW_NUMBER() Over(partition by PPC.Name order by PP.ListPrice desc) <= 5 THEN 'Yes'
		ELSE 'No'
	END
FROM Production.Product PP
INNER JOIN Production.ProductSubcategory PPS 
	ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
INNER JOIN Production.ProductCategory PPC 
	ON PPS.ProductCategoryID = PPC.ProductCategoryID