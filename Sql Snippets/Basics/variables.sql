/*
Variables
*/
Declare @MyVar INT;
SET @MyVar = 10;
Select @MyVar;

Declare @MyVar1 INT = 10;
Select @MyVar1;

Declare @MinPrice Money = 1000;
Select
*
From Production.Product
WHere ListPrice >= @MinPrice;

--Embedded scalar subquery example
SELECT 
	   ProductID
      ,[Name]
      ,StandardCost
      ,ListPrice
	  ,AvgListPrice = (SELECT AVG(ListPrice) FROM AdventureWorks2019.Production.Product)
	  ,AvgListPriceDiff = ListPrice - (SELECT AVG(ListPrice) FROM AdventureWorks2019.Production.Product)

FROM AdventureWorks2019.Production.Product

WHERE ListPrice > (SELECT AVG(ListPrice) FROM AdventureWorks2019.Production.Product)

ORDER BY ListPrice ASC

--Rewritten with variables:

DECLARE @AvgPrice MONEY = (SELECT AVG(ListPrice) FROM AdventureWorks2019.Production.Product)

SELECT 
	   ProductID
      ,[Name]
      ,StandardCost
      ,ListPrice
	  ,AvgListPrice = @AvgPrice
	  ,AvgListPriceDiff = ListPrice - @AvgPrice

FROM AdventureWorks2019.Production.Product

WHERE ListPrice > @AvgPrice

ORDER BY ListPrice ASC

--Scalar subquery code:

SELECT
	   BusinessEntityID
      ,JobTitle
      ,VacationHours
	  ,MaxVacationHours = (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)
	  ,PercentOfMaxVacationHours = (VacationHours * 1.0) / (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)

FROM AdventureWorks2019.HumanResources.Employee

WHERE (VacationHours * 1.0) / (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee) >= 0.8



--Refactored Solution

DECLARE @MaxVacation FLOAT = (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)

SELECT
	   [BusinessEntityID]
      ,[JobTitle]
      ,[VacationHours]
	  ,MaxVacationHours = @MaxVacation
	  ,PercentOfMaxVacationHours = VacationHours / @MaxVacation

FROM AdventureWorks2019.HumanResources.Employee

WHERE VacationHours / @MaxVacation >= 0.8

--Variables for complex date math:
/*
Select GETDATE()

DECLARE @Today DATE = CAST(GETDATE() AS DATE)
SELECT @Today

DECLARE @BOM DATE = DATEFROMPARTS(YEAR(@Today),MONTH(@Today),1)
SELECT @BOM 

DECLARE @PrevEOM DATE = DATEADD(DAY,-1,@BOM)
SELECT @PrevEOM

DECLARE @PrevBOM DATE = DATEADD(MONTH,-1,@BOM)
SELECT @PrevBOM

SELECT
*
FROM AdventureWorks2019.dbo.Calendar
WHERE DateValue BETWEEN @PrevBOM AND @PrevEOM

*/

DECLARE @Today DATE = CAST(GETDATE() AS DATE)

SELECT @Today

DECLARE @Current14 DATE = DATEFROMPARTS(YEAR(@Today),MONTH(@Today),14)

DECLARE @PayPeriodEnd DATE = 
	CASE
		WHEN DAY(@Today) < 15 THEN DATEADD(MONTH,-1,@Current14)
		ELSE @Current14
	END

DECLARE @PayPeriodStart DATE = DATEADD(DAY,1,DATEADD(MONTH,-1,@PayPeriodEnd))


SELECT @PayPeriodStart
SELECT @PayPeriodEnd

