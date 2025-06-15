USE [AdventureWorks2019]
GO

Select * from Person.Person

Update Person.Person
SET FirstName='John', LastName='Maddala'
Where BusinessEntityID = 1


select * from Person.EmailAddress where BusinessEntityID = 1

Delete from Person.EmailAddress where BusinessEntityID = 1