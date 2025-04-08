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

--Restoring the database with error handling ---->
BEGIN TRY
    PRINT 'Starting database restoration...';
    RESTORE DATABASE WideWorldImporters FROM DISK = 'C:\backups\WideWorldImporters.bak'
    WITH REPLACE;  -- Use REPLACE if you want to overwrite the existing database
    PRINT 'Database restoration completed successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error restoring the database.';
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
