IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'riskmgr_win_def')
BEGIN
	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_def' and cl.name = 'lower_split_pos' )
		ALTER TABLE dbo.riskmgr_win_def ADD lower_split_pos int NOT NULL DEFAULT -1;
	ELSE
		PRINT 'lower_split_pos COLUMN EXISTS';

	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_def' and cl.name = 'port_split_pos' )
		ALTER TABLE dbo.riskmgr_win_def ADD port_split_pos int NOT NULL DEFAULT -1
	ELSE
		PRINT 'port_split_pos COLUMN EXISTS';

	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_def' and cl.name = 'pnl_split_pos' )
		ALTER TABLE dbo.riskmgr_win_def ADD pnl_split_pos int NOT NULL DEFAULT -1;
	ELSE
		PRINT 'pnl_split_pos COLUMN EXISTS';

	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_def' and cl.name = 'window_frame' )
		ALTER TABLE dbo.riskmgr_win_def ADD window_frame varchar(255) NOT NULL DEFAULT '';
	ELSE
		PRINT 'window_frame COLUMN EXISTS';

	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_def' and cl.name = 'port_path' )
		ALTER TABLE dbo.riskmgr_win_def ADD port_path varchar(255) NOT NULL DEFAULT '';
	ELSE
		PRINT 'port_path COLUMN EXISTS';

END

GO


