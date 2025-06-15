select top 10 * from Sales.SalesOrderHeader where TotalDue between 20000 and 30000

select * from Person.Person where FirstName like '[abc]%' order by FirstName

select * from Person.Person where FirstName like 'al[abe]%' order by FirstName

select * from Person.Person where FirstName like 'al[a-e]%' order by FirstName