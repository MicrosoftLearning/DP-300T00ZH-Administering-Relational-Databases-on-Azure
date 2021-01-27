--Copy and paste the code below into your query window.  

USE MASTER 
GO 

CREATE EVENT SESSION [Blocking] ON SERVER  
ADD EVENT sqlserver.blocked_process_report( 
ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_id,sqlserver.database_name,sqlserver.nt_username,sqlserver.session_id,sqlserver.sql_text,sqlserver.username)) 
ADD TARGET package0.ring_buffer 
WITH (MAX_MEMORY=4096 KB, EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS, MAX_DISPATCH_LATENCY=30 SECONDS, MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE, TRACK_CAUSALITY=OFF,STARTUP_STATE=ON); 
GO 
-- Start the event session   
ALTER EVENT SESSION [Blocking] ON SERVER   
STATE = start;   
GO 

--Click New Query from SQL Server Management Studio.  Copy and paste the following T-SQL code into the query window.  Click the execute button to execute this query.  

USE AdventureWorks2017 
GO 

BEGIN TRANSACTION 
UPDATE Person.Person SET LastName = LastName; 
GO 

--Open another query window by clicking the New Query button. Copy and paste the following T-SQL code into the query window.  Click the execute button to execute this query.  

USE AdventureWorks2017 
GO 

SELECT TOP (1000) [LastName] 
      ,[FirstName] 
      ,[Title] 
  FROM Person.Person 
  where FirstName = 'David' 

--Copy and paste the following T-SQL code into the query window.  Click the execute button  to execute this query.  

USE master 
GO 

ALTER DATABASE AdventureWorks2017 SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE; 
GO 

--Begin a new query against the AdventureWorks2017 database.  Copy and paste the following T-SQL code into the query window.  Click the execute button or press t to execute this query.  

USE AdventureWorks2017 
GO 

BEGIN TRANSACTION 
UPDATE Person.Person SET LastName = LastName; 
GO 


--Start another new query against the AdventureWorks2017 database. Copy and paste the following T-SQL code into the query window.  Click the execute button  to execute this query.  

USE AdventureWorks2017 
GO 

SELECT TOP (1000) [LastName] 
      ,[FirstName] 
      ,[Title] 
  FROM Person.Person 
  WHERE Firstname = 'David'; 

--From the lab VM Launch SQL Server Management Studio.  Enter the server name DP-300-SQL1, ensure that Windows Authentication is selected, and click connect. Click the New Query button. Copy and paste the following T-SQL code into the query window.  Click the execute button or press the F5 key to execute this query.  

USE [AdventureWorks2017] 
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

--Copy and paste the following T-SQL code into the query window.  Click the execute button or press the F5 key to execute this query.  

USE [AdventureWorks2017] 
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
WHERE avg_fragmentation_in_percent > 50; -- find indexes where fragmentation is greater than 50% 

--Copy and paste the following T-SQL code into the query window.  Click the execute button or press the F5 key to execute this query.  

SET STATISTICS IO,TIME ON 
GO 

USE [AdventureWorks2017] 
GO 

SELECT DISTINCT (StateProvinceID) 
    ,count(StateProvinceID) AS CustomerCount 
FROM person.Address 
GROUP BY StateProvinceID 
ORDER BY count(StateProvinceID) DESC; 
GO 

--Copy and paste the following T-SQL code into the query window.  Click the execute button or press the F5 key to execute this query.  

USE [AdventureWorks2017] 
GO 

ALTER INDEX [IX_Address_StateProvinceID] ON [Person].[Address] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);
GO