DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= 10000 )
BEGIN
    SELECT AVG(UnitPrice)
    FROM SalesLT.SalesOrderDetail
    GROUP BY ModifiedDate
    SET @Counter = @Counter + 1
END