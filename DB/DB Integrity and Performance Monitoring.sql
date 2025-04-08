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


-- ---------------------------------------------------------------------

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


