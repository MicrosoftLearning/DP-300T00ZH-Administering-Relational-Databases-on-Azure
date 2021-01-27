
-- Back Up WideWorldImporters - Step 4
-- ======

IF NOT EXISTS  
(SELECT * FROM sys.credentials   
WHERE name = 'https://dp300storage.blob.core.windows.net/backups')  
BEGIN
CREATE CREDENTIAL [https://dp300storage.blob.core.windows.net/backups]
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = 'sas_token'
END;
GO  

-- Step 6
-- ======

BACKUP DATABASE WideWorldImporters   
TO URL = 'https://dp300storage.blob.core.windows.net/backups/WideWorldImporters.bak';
GO 

-- Restore WideWorldImporters - Step 1
-- ======

USE WideWorldImporters;
GO

-- Step 2
-- ======

SELECT TOP 1 * FROM Sales.Customers;
GO

-- Step 3
-- ======

UPDATE Sales.Customers
SET CustomerName = 'This is a human error'
WHERE CustomerID = 1;
GO

-- Step 5
-- ======

USE master;
GO

RESTORE DATABASE WideWorldImporters 
FROM URL = 'https://dp300storage.blob.core.windows.net/backups/WideWorldImporters.bak';
GO
