/* Notes:
1. Lead and Lag let us grab values from subsequent or previous records relative to the position of the current record in our data
2. They can be useful anytime we want to compare a value in a give column to the next or previous value in the same column -
but side by side, in the same row
3. This is a very common problem in real-world analytics scenarios
*/

SELECT
SalesOrderID,
OrderDate,
CustomerID,
TotalDue,
NextTotalDue = Lead(TotalDue , 1) Over(Order by SalesOrderId),
PrevTotalDue = Lag(TotalDue , 1) Over(Order by SalesOrderId)
From Sales.SalesOrderHeader
Order by SalesOrderID

SELECT
SalesOrderID,
OrderDate,
CustomerID,
TotalDue,
NextTotalDue = Lead(TotalDue , 2) Over(Order by SalesOrderId),
PrevTotalDue = Lag(TotalDue , 2) Over(Order by SalesOrderId)
From Sales.SalesOrderHeader
Order by SalesOrderID

-- With partition group
SELECT
SalesOrderID,
OrderDate,
CustomerID,
TotalDue,
NextTotalDue = Lead(TotalDue , 1) Over(Partition by CustomerId Order by SalesOrderId),
PrevTotalDue = Lag(TotalDue , 1) Over(Partition by CustomerId Order by SalesOrderId)
From Sales.SalesOrderHeader
Order by CustomerID, SalesOrderID