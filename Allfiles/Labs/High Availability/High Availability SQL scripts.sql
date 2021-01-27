--Create the credential that will be used to access storage in Azure with the following Transact-SQL. 
--Fill in the appropriate values for you storage account name, and the sas_token created in the last step.

IF NOT EXISTS   
(SELECT * FROM sys.credentials    
WHERE name = 'https://dp300storage.blob.core.windows.net/backups')   
BEGIN 
CREATE CREDENTIAL [https://dp300storage.blob.core.windows.net/backups] 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE', 
SECRET = 'sas_token' 
END; 
GO   

--Back up the database WideWorldImporters to Azure with the following command in Transact-SQL: 
--Replace dp300storage with the name of your storage account

BACKUP DATABASE WideWorldImporters    
TO URL = ' https://dp300storage.blob.core.windows.net/backups/WideWorldImporters.bak'; 
GO   

--Process to create an error to restore from

USE WideWorldImporters; 
GO 

--Now execute the statement below to return the very first row of the Customers table which has a CustomerID of 1. Note the name of the customer. 

SELECT TOP 1 * FROM Sales.Customers; 
GO 

--Run this command to change the name of that customer. 

UPDATE Sales.Customers 
SET CustomerName = 'This is a human error' 
WHERE CustomerID = 1; 
GO 

--To restore the database to get it back to where it was before the change you made in Step 3, 
--execute the below command, replacing dp300_storage with the name of your storage account

USE master; 
GO 

RESTORE DATABASE WideWorldImporters  
FROM URL = 'https://dp300storage.blob.core.windows.net/backups/WideWorldImporters.bak'; 
GO 