
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
