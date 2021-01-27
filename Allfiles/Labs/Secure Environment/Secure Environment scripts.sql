--Go back to SQL Server Management Studio on your VM. Launch a new query window from the AdventureWorks database and execute the following query. 

SELECT o.name AS [Table Name] 
     ,ac.name AS [Column Name] 
     ,sc.label 
     ,sc.information_type 
FROM sys.sensitivity_classifications sc 
INNER JOIN sys.objects o ON o.object_id = sc.major_id 
INNER JOIN sys.all_columns ac ON ac.column_id = sc.minor_id 
WHERE ac.object_id = o.object_id; 

--In this task you will manage access to the database and its objects. The first thing you will do is create two users in the AdventureWorks database. Open a new query window and copy and paste the below T-SQL into it. Execute the query to create the two users. 

CREATE USER [DP300User1] WITH PASSWORD = 'Azur3Pa$$' 
GO 
CREATE USER [DP300User2] WITH PASSWORD = 'Azur3Pa$$' 
GO

--Next you will create a custom role, and add the users to it. Execute the following T-SQL in the same query window as in step 1. 

CREATE ROLE [SalesReader] 
GO 
ALTER ROLE [SalesReader] ADD MEMBER [DP300User1] 
GO 
ALTER ROLE [SalesReader] ADD MEMBER [DP300User2] 
GO 

--Next you will grant permissions to the role. In this case you are assigning SELECT and EXECUTE on the Sales schema. Execute the below T-SQL to grant the permissions to the role. 

GRANT SELECT, EXECUTE ON SCHEMA::Sales TO [SalesReader] 
GO 

--Next you will create a new stored procedure in the Sales schema. You will note this procedure access a table in the Product schema. Execute the below T-SQL in your query window. 

CREATE OR ALTER PROCEDURE Sales.DemoProc 
AS 
SELECT P.Name, Sum(SOD.LineTotal) as TotalSales ,SOH.OrderDate  
FROM Production.Product P 
INNER JOIN Sales.SalesOrderDetail SOD on SOD.ProductID = P.ProductID 
INNER JOIN Sales.SalesOrderHeader SOH on SOH.SalesOrderID = SOD.SalesOrderID 
GROUP BY P.Name, SOH.OrderDate 
ORDER BY TotalSales DESC 
GO 

--Next you will use the EXECUTE AS USER syntax test out the security you just create. This allows the database engine to execute a query in the context of your user. Execute the below query in your query window. 

EXECUTE AS USER  = 'DP300User1' 

SELECT P.Name, Sum(SOD.LineTotal) as TotalSales ,SOH.OrderDate  
FROM Production.Product P 
INNER JOIN Sales.SalesOrderDetail SOD on SOD.ProductID = P.ProductID 
INNER JOIN Sales.SalesOrderHeader SOH on SOH.SalesOrderID = SOD.SalesOrderID 
GROUP BY P.Name, SOH.OrderDate 
ORDER BY TotalSales DESC 
--This query will fail, with an error message saying the SELECT permission was denied on the Production.Product table.  The role that user DP300User1 is a member of has SELECT permission in the Sales schema, but not in the Production schema.  
--However, if you execute the stored procedure in that same context, the query will complete. Execute the following T-SQL. 

EXECUTE AS USER  = 'DP300User1' 
EXECUTE Sales.DemoProc 

