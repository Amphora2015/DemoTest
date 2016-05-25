IF OBJECT_ID('riskmgr_win_pivot_def_updtrg','TR') IS NOT NULL
DROP TRIGGER riskmgr_win_pivot_def_updtrg
GO

CREATE TRIGGER dbo.riskmgr_win_pivot_def_updtrg
ON dbo.riskmgr_win_pivot_def
FOR UPDATE 

AS
DECLARE 
@rows_number	int,
@error_msg		nvarchar(1000),
@transid		int


if not update(trans_id) 
begin
   raiserror ('(RiskmgrWinPivotDef) The change needs to be attached with a new trans_id',10,1)
   if @@trancount > 0 rollback tran

   return
end


if exists (select * from inserted i, deleted d
           where i.trans_id < d.trans_id and
                 i.owner_win_id = d.owner_win_id )
begin
   raiserror ('(RiskmgrWinPivotDef) new trans_id must not be older than current trans_id.',10,1)
   if @@trancount > 0 rollback tran

   return
end

BEGIN
INSERT dbo.transaction_touch
		SELECT 'UPDATE',
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
RETURN