--Select
--A.BusinessEntityID As ABusinessEntityId,
--A.FirstName,
--A.LastName,
--B.BusinessEntityID BBusinessEntityId,
--B.JobTitle,
--B.VacationHours,
--B.SickLeaveHours,
--C.BusinessEntityID CBusinessEntityId,
--C.EmailAddress
--From Person.Person A
--Left Outer Join HumanResources.Employee B
--On A.BusinessEntityID = B.BusinessEntityID
--Inner Join Person.EmailAddress C
--On B.BusinessEntityID = C.BusinessEntityID
--where A.FirstName = 'John'
--Order by 1

Select
	A.BusinessEntityID AS ABusinessEntityId,
	A.FirstName,
	A.LastName,
	B.BusinessEntityID BBusinessEntityId,
	B.JobTitle,
	B.VacationHours,
	B.SickLeaveHours,
	C.BusinessEntityID CBusinessEntityId,
	C.EmailAddress
FROM Person.Person A
LEFT OUTER JOIN HumanResources.Employee B
ON A.BusinessEntityID = B.BusinessEntityID
	AND B.VacationHours > 50
Left Join Person.EmailAddress C
	ON A.BusinessEntityID = C.BusinessEntityID
WHERE A.FirstName = 'John'
--AND B.VacationHours > 50
ORDER BY 1