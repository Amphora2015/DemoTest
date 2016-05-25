IF EXISTS(SELECT name FROM sys.objects WHERE name = 'riskmgr_win_pivot_def_deltrg')
DROP TRIGGER riskmgr_win_pivot_def_deltrg 
GO
CREATE TRIGGER riskmgr_win_pivot_def_deltrg
ON dbo.riskmgr_win_pivot_def
FOR DELETE

AS
DECLARE 
@rows_number	int,
@error_msg		nvarchar(1000),
@transid		int


		
		SET @rows_number = @@ROWCOUNT
		IF @rows_number = 0
		RETURN
			
		SELECT @transid = max(trans_id)
	    FROM dbo.icts_transaction WITH (INDEX=icts_transaction_idx4)
		WHERE spid = @@spid
		AND tran_date >= (select top 1 login_time from master.dbo.sysprocesses (nolock) where spid = @@spid)
		
		IF @transid IS NOT NULL
		BEGIN
			INSERT dbo.transaction_touch
				SELECT 'DELETE',
					'RiskmgrWinPivotDef',
					'DIRECT',
					convert(varchar(40), d.owner_win_id),
					null,
					null,
					null,
					null,
					null,
					null,
					null,
					@transid,
					it.sequence
				FROM deleted d, dbo.icts_transaction it
				WHERE it.trans_id = @transid
				AND it.type != 'E'
				
		END
		ELSE
		BEGIN
			SELECT @error_msg ='OPERATION FAILED, PLEASE PROVIDE A VALID ID_TRANSACTION YOU NUST BE USE A PROCEDURE gen_new_transaction TO GET A VALID TRANSACTION ID'
			raiserror(@error_msg, 10,1)
			IF @@TRANCOUNT > 0 rollback tran
			RETURN
		END

