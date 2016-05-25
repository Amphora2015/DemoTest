IF EXISTS(SELECT name FROM sys.objects WHERE name = 'riskmgr_win_pivot_def_instrg')
DROP TRIGGER riskmgr_win_pivot_def_instrg 
GO

CREATE TRIGGER dbo.riskmgr_win_pivot_def_instrg
ON dbo.riskmgr_win_pivot_def
FOR INSERT

AS
DECLARE 
@rows_number	int,
@error_msg		nvarchar(1000),
@transid		int

		
		
		
		BEGIN
			INSERT dbo.transaction_touch
				SELECT 'INSERT',
					'RiskmgrWinPivotDef',
					'DIRECT',
					convert(varchar(40), i.owner_win_id),
					null,
					null,
					null,
					null,
					null,
					null,
					null,
					i.trans_id,
					it.sequence
				FROM inserted i, dbo.icts_transaction it
				WHERE i.trans_id = it.trans_id
				AND it.type != 'E'

		END



