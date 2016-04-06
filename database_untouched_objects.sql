/****** Object:  View [dbo].[database_untouched_objects]    Script Date: 3/17/2016 2:36:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[database_untouched_objects] AS
SELECT
	(SELECT sqlserver_start_time FROM sys.dm_os_sys_info) AS serviceRestartDate,
	NU.schemaName,
	NU.objectName,
	(SUM(NU.reserved_page_count) * 8) AS KB,
	(SELECT MAX(row_count) FROM database_stats
		WHERE schemaName = NU.schemaName
			AND objectName = NU.objectName) AS row_count
FROM
	database_index_stats_nf NU
LEFT JOIN
	(
	SELECT DISTINCT
		schemaName,
		objectName
	FROM
		database_index_stats_nf
	WHERE
		is_ms_shipped = 0 AND 
		(
		user_seeks <> 0 OR user_scans <> 0 OR user_lookups <> 0 OR user_updates <> 0
		)
	) U ON NU.schemaName = U.schemaName
		AND NU.objectName = U.objectName
WHERE
	U.schemaName IS NULL AND 
	U.objectName IS NULL AND
	NU.is_ms_shipped = 0 AND 
	(
	NU.user_seeks = 0 AND NU.user_scans = 0 AND NU.user_lookups = 0 AND NU.user_updates = 0
	)
GROUP BY
	NU.schemaName,
	NU.objectName

GO


