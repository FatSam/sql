SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[server_availability_status] AS
SELECT
	ags.name 'group', 
	ar.replica_server_name 'server', 
	ars.role_desc 'role',
	db_name(rs.database_id) 'database', 
	rs.synchronization_state_desc 'status',
	rs.last_hardened_lsn, 
	rs.end_of_log_lsn, 
	rs.last_redone_lsn, 
	rs.last_hardened_time,
	rs.last_redone_time,
	rs.log_send_queue_size, 
	rs.redo_queue_size,
	rs.last_commit_time
FROM
	sys.dm_hadr_database_replica_states rs 
LEFT JOIN 
	sys.availability_replicas ar on rs.replica_id = ar.replica_id 
LEFT JOIN 
	sys.availability_groups ags on ar.group_id = ags.group_id 
LEFT JOIN 
	sys.dm_hadr_availability_replica_states ars on ar.group_id = rs.group_id	
	and ar.replica_id = ars.replica_id 

GO


