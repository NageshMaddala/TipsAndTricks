--Example 1: generate number series with recursive CTE

WITH NumberSeries AS
(
SELECT
 1 AS MyNumber

UNION  ALL

SELECT 
MyNumber + 1
FROM NumberSeries
WHERE MyNumber < 100 
)

SELECT
MyNumber
FROM NumberSeries



--Example 2: generate date series with recursive CTE

WITH Dates AS
(
SELECT
 CAST('01-01-2021' AS DATE) AS MyDate

UNION ALL

SELECT
DATEADD(DAY, 1, MyDate)
FROM Dates
WHERE MyDate < CAST('12-31-2021' AS DATE)
)

SELECT
MyDate

FROM Dates
OPTION (MAXRECURSION 365)

--Exercise 1 Solution:


WITH Odds AS
(
SELECT
 1 AS MyOddNumber

UNION  ALL

SELECT 
MyOddNumber + 2
FROM Odds
WHERE MyOddNumber < 99
)

SELECT
MyOddNumber
FROM Odds

-- Excercise 2
/*
Use a recursive CTE to generate a date series of all FIRST days of the month (1/1/2021, 2/1/2021, etc.)

from 1/1/2020 to 12/1/2029.
*/

--Exercise 2 Solution:


WITH Dates AS
(
SELECT
 CAST('01-01-2020' AS DATE) AS MyDate

UNION ALL

SELECT
DATEADD(MONTH, 1, MyDate)
FROM Dates
WHERE MyDate < CAST('12-01-2029' AS DATE)
)

SELECT
MyDate

FROM Dates
OPTION (MAXRECURSION 120)