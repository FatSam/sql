USE [dba]
GO

/****** Object:  View [dbo].[database_storage]    Script Date: 3/17/2016 2:19:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW
[dbo].[database_storage]
AS
SELECT DISTINCT 
	DB_NAME(dovs.database_id) DBName,
	mf.physical_name PhysicalFileLocation,
	dovs.logical_volume_name AS LogicalName,
	dovs.volume_mount_point AS Drive,
CONVERT(INT,dovs.available_bytes/1048576.0/1024.0) AS FreeSpaceInGB,
CONVERT(INT,dovs.total_bytes/1024.0/1024.0/1024.0) AS TotSpaceGB,
CONVERT(INT,dovs.available_bytes/1048576.0) AS FreeSpaceInMB,
CONVERT(INT,dovs.total_bytes/1024.0/1024.0) AS TotalSpaceInMB
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs


GO


