IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'riskmgr_win_pivot_def')
BEGIN
	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_pivot_def' and cl.name = 'uom' )
		ALTER TABLE dbo.riskmgr_win_pivot_def ADD uom char(4) NOT NULL;
	ELSE
		PRINT 'uom COLUMN EXISTS';

	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_pivot_def' and cl.name = 'num_of_decimals' )
		ALTER TABLE dbo.riskmgr_win_pivot_def ADD num_of_decimals tinyint NOT NULL;
	ELSE
		PRINT 'num_of_decimals COLUMN EXISTS';

	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_pivot_def' and cl.name = 'show_future_equiv' )
		ALTER TABLE dbo.riskmgr_win_pivot_def ADD show_future_equiv char(1) NOT NULL DEFAULT 'N' CHECK (show_future_equiv = 'N' or show_future_equiv = 'n' OR show_future_equiv = 'Y' OR show_future_equiv = 'y');
	ELSE
		PRINT 'show_future_equiv COLUMN EXISTS';

	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_pivot_def' and cl.name = 'lower_split_pos' )
		ALTER TABLE dbo.riskmgr_win_pivot_def ADD lower_split_pos int NOT NULL DEFAULT -1;
	ELSE
		PRINT 'lower_split_pos COLUMN EXISTS';

	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_pivot_def' and cl.name = 'port_split_pos' )
		ALTER TABLE dbo.riskmgr_win_pivot_def ADD port_split_pos int NOT NULL DEFAULT -1;
	ELSE
		PRINT 'port_split_pos COLUMN EXISTS';

	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_pivot_def' and cl.name = 'pnl_split_pos' )
		ALTER TABLE dbo.riskmgr_win_pivot_def ADD pnl_split_pos int NOT NULL DEFAULT -1;
	ELSE
		PRINT 'pnl_split_pos COLUMN EXISTS';

	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_pivot_def' and cl.name = 'window_frame' )
		ALTER TABLE dbo.riskmgr_win_pivot_def ADD window_frame varchar(255) NOT NULL DEFAULT '';
	ELSE
		PRINT 'window_frame COLUMN EXISTS';

	IF NOT EXISTS (SELECT 1 FROM sys.tables tbl INNER JOIN sys.columns cl ON tbl.object_id = cl.object_id WHERE tbl.name = 'riskmgr_win_pivot_def' and cl.name = 'port_path' )
		ALTER TABLE dbo.riskmgr_win_pivot_def ADD port_path varchar(255) NOT NULL DEFAULT '';
	ELSE
		PRINT 'port_path COLUMN EXISTS';
END

GO



					

