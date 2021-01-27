-- Step 3
-- ======

CREATE USER [DP300User1] WITH PASSWORD = 'Azur3Pa$$';
GO

CREATE USER [DP300User2] WITH PASSWORD = 'Azur3Pa$$';
GO


-- Step 4
-- ======

CREATE ROLE [SalesReader];
GO

ALTER ROLE [SalesReader] ADD MEMBER [DP300User1];
GO

ALTER ROLE [SalesReader] ADD MEMBER [DP300User2];
GO

-- Step 5
-- ======

CREATE OR ALTER PROCEDURE SalesLT.DemoProc
AS
SELECT P.Name, Sum(SOD.LineTotal) as TotalSales ,SOH.OrderDate
FROM SalesLT.Product P
INNER JOIN SalesLT.SalesOrderDetail SOD on SOD.ProductID = P.ProductID
INNER JOIN SalesLT.SalesOrderHeader SOH on SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY P.Name, SOH.OrderDate
ORDER BY TotalSales DESC
GO


-- Step 6
-- ======

EXECUTE AS USER = 'DP300User1'
EXECUTE SalesLT.DemoProc


-- Step 7
-- ======

REVERT;
GRANT EXECUTE ON SCHEMA::SalesLT TO [SalesReader];
GO