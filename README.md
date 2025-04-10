### **WWI360-End-to-End-Migration-Analytics**

This project was an exploratory initiative aimed at understanding how to integrate various enterprise tools and technologies within an end-to-end data pipeline. The goal was to simulate and analyze how data flows through different systems, from extraction to reporting, and how it can be effectively managed in real-world projects that involve ETL, dashboards, and SQL management.

#### **Key Learnings:**
- **ETL Process**: Using **SSIS**, I gained practical experience in managing data extraction, transformation, and loading (ETL) from SQL Server into **SAP HANA**.
- **Data Analytics**: **SSAS** was used for analyzing data and generating insights, which were then presented via interactive and customized reports.
- **Reporting and Dashboards**: Explored the integration of **SAP Crystal Reports** and **SSRS** for creating and deploying robust reporting solutions.
- **SQL Management**: The project emphasized the importance of SQL for data management, performance tuning, and ensuring smooth data operations across the pipeline.

This project helped me better understand how each tool contributes to the larger picture of data management and reporting in complex environments, providing valuable insights into best practices for handling data-driven tasks in real-world projects.

## Data Integration, Analysis, and Reporting Tools

In this project, various tools were integrated for data management, analysis, and reporting. **SAP HANA** was used as the central data storage and processing platform, where data from different sources was loaded, transformed, and stored for real-time analysis. **SSAS (SQL Server Analysis Services)** played a key role in data analysis by creating multidimensional models and cubes, which were then used by reporting tools. **SAP Crystal Reports** was employed to generate detailed, interactive reports based on the data models in SSAS, allowing for customizable reports with tables and graphics. **SSRS (SQL Server Reporting Services)** was used for creating scalable, web-based reports that can be accessed and distributed across the organization, utilizing SSAS models for more in-depth reporting. **SSIS (SQL Server Integration Services)** was used for the ETL process, extracting, transforming, and loading data from SQL Server and other sources into SAP HANA, ensuring the data was prepared for analysis. Together, these tools formed an integrated workflow that enabled seamless data extraction, transformation, analysis, and reporting, ensuring that decision-makers had timely access to the information needed for data-driven strategies.

- **SAP HANA**: Used as the final destination for data, where it's processed for real-time analytics.

![Sap Hana](https://github.com/user-attachments/assets/da6abdb0-b05d-4b3d-9822-82a80f6cf283)

- **SSAS (SQL Server Analysis Services)**: I utilized SSAS to process and analyze the data, providing insights that would be consumed by the reporting tools.

![SSAS](https://github.com/user-attachments/assets/2594cd22-9d7c-48fa-93e3-c37a8eb7ceb3)

- **SAP Crystal Reports**: Created detailed, interactive, and customized reports to present the analytics processed by SSAS.

![Sap crystal report](https://github.com/user-attachments/assets/95890dca-9722-4c36-b936-6a49c0d36446)

- **SSRS (SQL Server Reporting Services)**: Leveraged SSRS for scalable, web-based reporting, enabling users to access and interact with reports remotely.

![SSRS](https://github.com/user-attachments/assets/76bf4f03-9378-42e1-b8d1-1eefa4137d1b)

- **SSIS (SQL Server Integration Services)**: Managed the ETL process, extracting data from SQL Server, transforming it as needed, and loading it into SAP HANA.
  
![SSIS](https://github.com/user-attachments/assets/7d3f6028-b253-41b5-ad8e-1ad423ea5888)

## Database Maintenance, Backup, and Security Procedures
### Backup the Database with Error Handling
This section focuses on securely backing up the database while handling errors. First, an attempt is made to back up the WideWorldImporters database. If something fails during the backup process, the error is captured, and a message with the error details is printed. This ensures that any issues during the backup process can be quickly identified.

``` sql
-- Backup the database with error handling ---->
BEGIN TRY
    PRINT 'Performing database backup...';
    BACKUP DATABASE WideWorldImporters TO DISK = 'C:\backups\WideWorldImporters.bak';
    PRINT 'Backup completed successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error during backup.';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH
```

### Verifying the Backup File
After performing a backup, it’s crucial to verify that the backup file is valid and can be restored in the future. This section uses RESTORE VERIFYONLY to check the integrity of the backup file without restoring it fully. If the backup file is invalid, the verification process will generate an error, which is also captured.

``` sql
--verifying the backup file after creating the backup --->
BEGIN TRY
    PRINT 'Verifying the backup file...';
    RESTORE VERIFYONLY FROM DISK = 'C:\backups\WideWorldImporters.bak';
    PRINT 'Backup file verification completed successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error verifying the backup file.';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH

-- DBCC command to check database integrity------>
BEGIN TRY
    PRINT 'Running DBCC CHECKDB...';
    DBCC CHECKDB() WITH ALL_ERRORMSGS;
    PRINT 'DBCC CHECKDB completed successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error during DBCC CHECKDB.';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH

-- Backup list info
SELECT 
    b.database_name,
    b.backup_start_date,
    b.backup_finish_date,
    b.type AS BackupType,
    b.backup_size/1024/1024 AS BackupSizeMB,
    m.physical_device_name
FROM msdb.dbo.backupset b
JOIN msdb.dbo.backupmediafamily m ON b.media_set_id = m.media_set_id
WHERE b.database_name = 'WideWorldImporters'
ORDER BY b.backup_finish_date DESC;
```

### Restoring the Database with Error Handling
When it’s necessary to restore a database from a backup file, this section handles it. It first attempts to restore the database from the specified backup file. If any issues occur (e.g., the file can’t be used or a database already exists in that location), the error is captured and details about the failure are provided.
``` sql
--Restoring the database with error handling ---->
BEGIN TRY
    PRINT 'Starting database restoration...';
    RESTORE DATABASE WideWorldImporters FROM DISK = 'C:\backups\WideWorldImporters.bak'  
    PRINT 'Database restoration completed successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error restoring the database.';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH

```

### DBCC Command to Check Database Integrity
The DBCC CHECKDB command is a tool used to verify the integrity of the database by detecting errors in its internal structures, ensuring that the data has not been corrupted. This command is often used alongside DBCC CHECKALLOC, DBCC CHECKCATALOG, and DBCC CHECKCONSTRAINTS to perform comprehensive integrity checks. Additionally, the option WITH ALL_ERRORMSGS ensures that all error messages are reported in detail. System variables such as @@ERROR, @@ROWCOUNT, @@TRANCOUNT, and @@IDENTITY provide information about the current state of the database, while HOST_NAME and CONNECTIONPROPERTY functions offer insights into the host and connection details.

```sql
USE [WideWorldImporters]; 

DBCC CHECKDB() WITH ALL_ERRORMSGS;
DBCC CHECKALLOC();
DBCC CHECKCATALOG();
DBCC CHECKCONSTRAINTS();


SELECT 
	@@ERROR AS ErrorCode,
    @@ROWCOUNT AS RowsAffected,
    @@TRANCOUNT AS TranCount,
    @@IDENTITY AS UltimoID,
    BINARY_CHECKSUM('test') AS BinaryChecksum,
    CHECKSUM('test') AS Checksum;

SELECT 
	HOST_NAME() AS HostName,
    HOST_ID() AS HostID,
    CONNECTIONPROPERTY('net_transport') AS Transport,
    CURRENT_REQUEST_ID() AS CurrentRequest,
    CURRENT_TRANSACTION_ID() AS CurrentTransaction;

```

### Performance Checks
The performance process includes several checks, such as verifying open transactions, the status of the transaction log, and transaction log space usage. These actions are essential for identifying performance bottlenecks in the database, such as unfinished transactions or excessive transaction log usage. Checking these aspects contributes to overall performance improvement.
```sql
BEGIN TRY
    PRINT '';
    PRINT '====== STARTING PERFORMANCE ======';
    PRINT '';


    PRINT '====== RUNNING: DBCC OPENTRAN ======';
    DBCC OPENTRAN();
    IF @@ROWCOUNT = 0
	PRINT 'No open transactions found.';
    ELSE
	PRINT 'Open transaction check completed.';
    PRINT '';

    PRINT '====== RUNNING: DBCC SQLPERF(LOGSPACE) ======';
    DBCC SQLPERF(LOGSPACE);
    PRINT 'DATABASE AND FILE GROWTH CHECK COMPLETED.';
    PRINT '';
END TRY
BEGIN CATCH
    PRINT '';
    PRINT '====== ERROR DURING PERFORMANCE AND INDEX CHECKS ======';
    PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
    PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
    PRINT 'SEVERITY: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
    PRINT 'STATE: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
	PRINT 'XACT_STATE(): ' + CAST(XACT_STATE() AS NVARCHAR(5));  
    PRINT '@@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR(5)); 
END CATCH;

```

### Audit for Login Events
Establishing an audit system for both successful and failed login attempts is essential for monitoring the security of the database. This involves creating a SERVER AUDIT and an associated audit specification to capture login attempts, which aids in detecting unauthorized access and tracking user activities. Additionally, an event session is configured to log long-running queries, providing further insights into database performance and potential security issues.

``` sql
USE master

CREATE SERVER AUDIT [LoginAudit]
  TO FILE (FILEPATH = 'C:\AuditLogs\')
  WITH (ON_FAILURE = CONTINUE);

CREATE SERVER AUDIT SPECIFICATION [LoginAuditSpec]
  FOR SERVER AUDIT [LoginAudit]
  ADD (SUCCESSFUL_LOGIN_GROUP),
  ADD (FAILED_LOGIN_GROUP)
  WITH (STATE = ON);

USE [WideWorldImporters]

CREATE EVENT SESSION [LongQuerySession] ON SERVER 
  ADD EVENT sqlserver.sql_statement_completed 
    (WHERE (duration > 1000000)) 
  ADD TARGET package0.event_file (SET filename = 'C:\Logs\LongQueries.xel');

ALTER EVENT SESSION [LongQuerySession] ON SERVER STATE = START;

```

### Trigger for DDL Events
Database-level triggers allow tracking of DDL (Data Definition Language) events, such as table creation, schema modification, and object deletions. In this case, a trigger is created that logs DDL events in a table called ddl_log, making it easier to monitor important changes to the database structure.

```sql
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
```

### Database Mirroring and Availability Groups
High availability configuration is handled by creating an availability group and using replication to ensure the database remains available even if one of the database instances fails. In this case, synchronous replicas are set up between two servers to ensure that the data stays in sync, and the system experiences minimal downtime.

``` sql
CREATE ENDPOINT [HADR_WideWorldImporters]
  STATE = STARTED
  AS TCP (LISTENER_PORT = 5022) 
  FOR DATABASE_MIRRORING (
    AUTHENTICATION = WINDOWS NTLM,
    ENCRYPTION = REQUIRED ALGORITHM AES
  );

SELECT * FROM sys.endpoints;

CREATE AVAILABILITY GROUP [AG_WideWorldImporters]
FOR DATABASE [WideWorldImporters], [WideWorldImporters]
REPLICA ON 'Server1' 
	WITH (ENDPOINT_URL = 'TCP://Server1:5022', AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, FAILOVER_MODE = AUTOMATIC),
    'Server2' 
    WITH (ENDPOINT_URL = 'TCP://Server2:5022', AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, FAILOVER_MODE = AUTOMATIC);

ALTER DATABASE [WideWorldImporters] SET HADR AVAILABILITY GROUP = [AG_WideWorldImporters];
GO
```

### Transactional Replication
Transactional replication allows data to be copied from one database to another in real-time. In this case, the WideWorldImporters database is being set up for publication so that changes are replicated to another database called WideWorldImporters2. This ensures both databases stay synchronized, which is useful for redundancy or load distribution.

``` sql
sp_replicationdboption @dbname = 'WideWorldImporters', @optname = 'publish', @value = 'true';


EXEC sp_addpublication 
  @publication = 'WWI_Publication', 
  @description = 'Transactional rep',
  @sync_method = 'native',
  @retention = 0,
  @allow_push = 'true',
  @allow_pull = 'true',
  @allow_anonymous = 'false';

EXEC sp_addsubscription 
  @publication = 'WWI_Publication', 
  @subscriber = 'WideWorldImporters', 
  @destination_db = 'WideWorldImporters2',
  @subscription_type = 'push';
```

## Thanks for reading guys!
##
##
