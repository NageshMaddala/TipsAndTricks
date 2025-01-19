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

