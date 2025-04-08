
CREATE TABLE ddl_log (PostTime DATETIME, DB_User NVARCHAR(100), Event NVARCHAR(100), TSQL NVARCHAR(2000));  
GO

CREATE TRIGGER log   
ON DATABASE   
FOR DDL_DATABASE_LEVEL_EVENTS   
AS  
DECLARE @data XML  
SET @data = EVENTDATA()  
INSERT ddl_log   
   (PostTime, DB_User, Event, TSQL)   
   VALUES   
   (GETDATE(),   
   CONVERT(NVARCHAR(100), CURRENT_USER),   
   @data.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)'),   
   @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(2000)') ) ;

  
CREATE TABLE TestTable (a INT);  
DROP TABLE TestTable ;  

SELECT * FROM ddl_log ;    
GO

DENY DELETE ON OBJECT::[Sales].[Orders] TO db_datawriter
GO

CREATE TRIGGER PreventDeleteOnOrders
ON [Warehouse].[VehicleTemperatures]
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('DELETE operation is not allowed on Orders table.', 16, 1);
	ROLLBACK
END;
GO
