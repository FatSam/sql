/*
CheckForUnusedDBs - April 6 2016
(C) 2016, Daniel Keys Moran
danmoran909@outlook.com

To request or suggest changes email me.

This is known to work on SQL Server 2012; it's been tested on no other versions.

It's dependent on the view database_index_stats, available elsewhere in this repository.

Permissions required: sa.
*/

SELECT create_date AS restartDate FROM sys.databases where name = 'tempdb'
SELECT GETDATE() AS rundate

SET NOCOUNT ON
DECLARE @SQL VARCHAR(MAX)
DECLARE @databaseName VARCHAR(256)
DECLARE @X INT = 1
DECLARE @DBs TABLE
	(
	dbID INT IDENTITY(1,1),
	databaseName VARCHAR(256)
	)

INSERT @DBs (databaseName)
SELECT NAME FROM sys.databases
WHERE NAME NOT IN ('master','model','msdb','tempdb','test')
AND state_desc = 'ONLINE'

SELECT @SQL = 
	'
	DECLARE @Results TABLE
	(
	resultID INT IDENTITY(1,1),
	databaseName VARCHAR(256),
	sumAccesses DECIMAL(18,9)
	)
'

WHILE @X <= (select COUNT(*) FROM @dbs)
BEGIN

SELECT @databaseName = databaseName
FROM 
@DBs WHERE dbID = @X

SELECT @SQL = @SQL + '

INSERT @Results 
	(
	databaseName,
	sumAccesses
	)
SELECT ''' + QUOTENAME(@databaseName) + ''', SUM(user_scans + user_seeks + user_lookups + user_updates) FROM ' + QUOTENAME(@databaseName) + '.dbo.database_index_stats
where is_ms_shipped = 0
'

SELECT @X = @X + 1
END

SELECT @SQL = @SQL + '

select * from @results
order by databaseName'

EXEC (@SQL)
