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


