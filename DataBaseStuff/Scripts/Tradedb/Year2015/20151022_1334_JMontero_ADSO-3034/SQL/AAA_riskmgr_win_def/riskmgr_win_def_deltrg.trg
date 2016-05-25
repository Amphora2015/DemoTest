IF object_id('dbo.riskmgr_win_def_deltrg', 'TR') is not null
   drop trigger dbo.riskmgr_win_def_deltrg 
go

create trigger dbo.riskmgr_win_def_deltrg
ON dbo.riskmgr_win_def
FOR DELETE
as
declare @num_rows           int,
        @errmsg             varchar(255),
        @atrans_id          int,
        @the_entity_name    varchar(80)

select @num_rows = @@rowcount
if @num_rows = 0
   return

/* AUDIT_CODE_BEGIN */
select @atrans_id = max(trans_id)
from dbo.icts_transaction WITH (INDEX=icts_transaction_idx4)
where spid = @@spid and
      tran_date >= (select top 1 login_time
                    from master.dbo.sysprocesses (nolock)
                    where spid = @@spid)

if @atrans_id is null
begin
   select @errmsg = '(riskmgr_win_def) Failed to obtain a valid responsible trans_id.'
   if exists (select 1
              from master.dbo.sysprocesses (nolock)
              where spid = @@spid and
                    (rtrim(program_name) IN ('ISQL-32', 'OSQL-32', 'SQL Query Analyzer', 'SQLCMD') OR
                     program_name like 'Microsoft SQL Server Management Studio%') )
      select @errmsg = @errmsg + char(10) + 'You must use the gen_new_transaction procedure to obtain a new trans_id before executing delete statement.'
   raiserror(@errmsg, 10, 1)
   rollback tran
   return
end

set @the_entity_name = 'RiskmgrWinDef'

/* BEGIN_TRANSACTION_TOUCH */

insert dbo.transaction_touch
select 'DELETE',
       @the_entity_name,
       'DIRECT',
    convert(varchar(40), d.win_id),
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       @atrans_id,
       it.sequence
from dbo.icts_transaction it WITH (NOLOCK),
     deleted d
where it.trans_id = @atrans_id and
      it.type != 'E'

/* END_TRANSACTION_TOUCH */

return
go


