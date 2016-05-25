/* **********************************************************************
     riskmgr_win_pivot_def_deltrg.trg

       Project        : Integrated Commodity Trading System (ICTS)
       Company        : Amphora, Inc

       Created By     : Javier Montero
       Database       : MS SQL Server 2008 or higher

         Modified By  : Surender
           Date             Description of Changes
           --------------   ---------------------------------------------
           04/05/2016			Added new column 'asof_date'
   ********************************************************************** */

IF OBJECT_ID('dbo.riskmgr_win_pivot_def_deltrg','TR') IS NOT NULL
EXEC ('DROP TRIGGER dbo.riskmgr_win_pivot_def_deltrg')
GO

CREATE trigger dbo.riskmgr_win_pivot_def_deltrg
on dbo.riskmgr_win_pivot_def
for delete
as
declare @num_rows    int,
        @errmsg      varchar(255),
        @atrans_id   int

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
   select @errmsg = '(riskmgr_win_pivot_def) Failed to obtain a valid responsible trans_id.'
   if exists (select 1
              from master.dbo.sysprocesses (nolock)
              where spid = @@spid and
                    (rtrim(program_name) IN ('ISQL-32', 'OSQL-32', 'SQL Query Analyzer', 'SQLCMD') OR
                     program_name like 'Microsoft SQL Server Management Studio%') )
      select @errmsg = @errmsg + char(10) + 'You must use the gen_new_transaction procedure to obtain a new trans_id before executing delete statement.'
   raiserror (@errmsg,10,1)
   if @@trancount > 0 rollback tran

   return
end


/* BEGIN_TRANSACTION_TOUCH */
 
insert dbo.transaction_touch
select 'DELETE',
       'riskmgr_win_pivot_def',
       'DIRECT',
       convert(varchar(40), d.owner_win_id),
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       @atrans_id,
       it.sequence
from deleted d, dbo.icts_transaction it
where it.trans_id = @atrans_id and
      it.type != 'E'
 
/* END_TRANSACTION_TOUCH */

/* AUDIT_CODE_BEGIN */
   
 insert into dbo.aud_riskmgr_win_pivot_def
	(
	 owner_win_id,
	 piv_def_id,
	 tab_index,
	 tab_name,
	 trans_id,
	 uom,
	 num_of_decimals,
	 show_future_equiv, 
	 pivot_layout,
	 show_zero,
	 lower_split_pos,
	 port_split_pos,
	 pnl_split_pos,
	 window_frame,
	 port_path,
	 asof_date,
	 resp_trans_id
	)
select 
	 d.owner_win_id,
	 d.piv_def_id,
	 d.tab_index,
	 d.tab_name,
	 d.trans_id,
	 d.uom,
	 d.num_of_decimals,
	 d.show_future_equiv,
	 d.pivot_layout,
	 d.show_zero,
	 d.lower_split_pos,
	 d.port_split_pos,
	 d.pnl_split_pos,
	 d.window_frame,
	 d.port_path,
	 d.asof_date,
	 @atrans_id
from deleted d

/* AUDIT_CODE_END*/

return

go