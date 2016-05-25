IF object_id('dbo.riskmgr_win_def_updtrg', 'TR') is not null
   drop trigger dbo.riskmgr_win_def_updtrg 
go

create trigger dbo.riskmgr_win_def_updtrg
ON dbo.riskmgr_win_def
for update
as
declare @num_rows           int,
        @errmsg             varchar(255),
        @the_entity_name    varchar(30)

select @num_rows = @@rowcount
if @num_rows = 0
   return

if not update(trans_id)
begin
   raiserror ('(riskmgr_win_def) The change needs to be attached with a new trans_id', 10, 1)
   if @@trancount > 0 rollback tran

   return
end

if exists (select 1
           from master.dbo.sysprocesses
           where spid = @@spid and
                (rtrim(program_name) IN ('ISQL-32', 'OSQL-32', 'SQL Query Analyzer', 'SQLCMD') OR
                 program_name like 'Microsoft SQL Server Management Studio%') )
begin
   if (select count(*) from inserted, deleted where inserted.trans_id <= deleted.trans_id) > 0
   begin
      select @errmsg = '(riskmgr_win_def) New trans_id must be larger than original trans_id.'
      select @errmsg = @errmsg + char(10) + 'You can use the the gen_new_transaction procedure to obtain a new trans_id.'
      raiserror (@errmsg,10,1)
      if @@trancount > 0 rollback tran

      return
   end
end

if exists (select * from inserted i, deleted d
           where i.trans_id < d.trans_id and
                 i.win_id = d.win_id)
begin
   raiserror ('(riskmgr_win_def) new trans_id must not be older than current trans_id.', 10, 1)
   if @@trancount > 0 rollback tran

   return
end

/* BEGIN_TRANSACTION_TOUCH */
set @the_entity_name = 'RiskmgrWinDef'

insert dbo.transaction_touch
select 'UPDATE',
		   @the_entity_name,
		   'DIRECT',
		   convert(varchar(40), i.win_id),
		   null,
		   null,
		   null,
		   null,
		   null,
		   null,
		   null,
		   i.trans_id,
		   it.sequence
from dbo.icts_transaction it WITH (NOLOCK),
     inserted i
where i.trans_id = it.trans_id and
      it.type != 'E'

/* END_TRANSACTION_TOUCH */

return
go
