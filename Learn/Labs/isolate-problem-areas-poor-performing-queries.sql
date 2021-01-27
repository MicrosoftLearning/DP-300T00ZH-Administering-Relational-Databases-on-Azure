-- Run a query to generate actual execution plan - Step 5
-- ======

USE AdventureWorks2017;
GO

SET SHOWPLAN_ALL ON;
GO

SELECT BusinessEntityID
FROM HumanResources.Employee
WHERE NationalIDNumber = '14417807';
GO

SET SHOWPLAN_ALL OFF;
GO

-- Resolve a Performance Problem from an Execution Plan - Step 1
-- ======

SET STATISTICS IO, TIME ON;

SELECT [SalesOrderID] ,[CarrierTrackingNumber] ,[OrderQty] ,[ProductID], [UnitPrice] ,[ModifiedDate]
FROM [AdventureWorks2017].[Sales].[SalesOrderDetail]
WHERE [ModifiedDate] > '2012/01/01' AND [ProductID] = 772;

-- Step 2
-- ======

CREATE NONCLUSTERED INDEX [IX_SalesOrderDetail_ProductID]
ON [Sales].[SalesOrderDetail] ([ProductID],[ModifiedDate])
INCLUDE ([CarrierTrackingNumber],[OrderQty],[UnitPrice])
WITH (DROP_EXISTING = on);
GO

-- Run a workload to generate query stats for Query Store - Step 1
-- ======

USE master;
GO

ALTER DATABASE AdventureWorks2017 SET QUERY_STORE = ON;
GO

ALTER DATABASE AdventureWorks2017 SET QUERY_STORE (OPERATION_MODE = READ_WRITE);
GO

ALTER DATABASE AdventureWorks2017 SET COMPATIBILITY_LEVEL = 100;
GO

-- Step 8
-- ======

USE master;
GO

ALTER DATABASE AdventureWorks2017 SET COMPATIBILITY_LEVEL = 150;
GO

-- Run a workload - Step 2
-- ======

USE AdventureWorks2017;
GO

SELECT SalesOrderId, OrderDate
FROM Sales.SalesOrderHeader
WHERE SalesPersonID=288;

-- Step 3
-- ======

USE AdventureWorks2017;
GO

SELECT SalesOrderId, OrderDate
FROM Sales.SalesOrderHeader
WHERE SalesPersonID=277;

-- Change the query to use a parameter and use a Query Hint - Step 2
-- ======

USE AdventureWorks2017;
GO

SET STATISTICS IO, TIME ON;

DECLARE @SalesPersonID INT;

SELECT @SalesPersonID = 288;

SELECT SalesOrderId, OrderDate
FROM Sales.SalesOrderHeader
WHERE SalesPersonID= @SalesPersonID;

-- Step 3
-- ======

USE AdventureWorks2017
GO

SET STATISTICS IO, TIME ON;

DECLARE @SalesPersonID INT;

SELECT @SalesPersonID = 288;

SELECT SalesOrderId, OrderDate
FROM Sales.SalesOrderHeader
WHERE SalesPersonID= @SalesPersonID
OPTION (RECOMPILE);