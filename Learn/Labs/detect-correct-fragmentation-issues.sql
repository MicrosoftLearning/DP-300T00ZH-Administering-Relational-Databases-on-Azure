-- Step 4

USE AdventureWorks2017
GO

SELECT i.name Index_Name
 , avg_fragmentation_in_percent
 , db_name(database_id)
 , i.object_id
 , i.index_id
 , index_type_desc
FROM sys.dm_db_index_physical_stats(db_id('AdventureWorks2017'),object_id('person.address'),NULL,NULL,'DETAILED') ps
 INNER JOIN sys.indexes i ON ps.object_id = i.object_id 
 AND ps.index_id = i.index_id
WHERE avg_fragmentation_in_percent > 50 -- find indexes where fragmentation is greater than 50%

-- Step 5

USE AdventureWorks2017
GO

INSERT INTO [Person].[Address]
 ([AddressLine1]
 ,[AddressLine2]
 ,[City]
 ,[StateProvinceID]
 ,[PostalCode]
 ,[SpatialLocation]
 ,[rowguid]
 ,[ModifiedDate])
SELECT AddressLine1,
 AddressLine2, 
 'Amsterdam',
 StateProvinceID, 
 PostalCode, 
 SpatialLocation, 
 newid(), 
 getdate()
from Person.Address;

GO

-- Step 7

SET STATISTICS IO,TIME ON
GO

USE AdventureWorks2017
GO

SELECT DISTINCT (StateProvinceID)
 ,count(StateProvinceID) AS CustomerCount
FROM person.Address
GROUP BY StateProvinceID
ORDER BY count(StateProvinceID) DESC;

GO

-- Rebuild indexes - Step 2

USE AdventureWorks2017
GO

ALTER INDEX [IX_Address_StateProvinceID] ON [Person].[Address] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

-- Step 3

USE AdventureWorks2017
GO

SELECT i.name Index_Name
 , avg_fragmentation_in_percent
 , db_name(database_id)
 , i.object_id
 , i.index_id
 , index_type_desc
FROM sys.dm_db_index_physical_stats(db_id('AdventureWorks2017'),object_id('person.address'),NULL,NULL,'DETAILED') ps
 INNER JOIN sys.indexes i ON ps.object_id = i.object_id 
 AND ps.index_id = i.index_id
WHERE avg_fragmentation_in_percent > 50 -- find indexes where fragmentation is greater than 50%

-- Step 4

SET STATISTICS IO,TIME ON
GO

USE AdventureWorks2017
GO

SELECT DISTINCT (StateProvinceID)
 ,count(StateProvinceID) AS CustomerCount
FROM person.Address
GROUP BY StateProvinceID
ORDER BY count(StateProvinceID) DESC;

GO
