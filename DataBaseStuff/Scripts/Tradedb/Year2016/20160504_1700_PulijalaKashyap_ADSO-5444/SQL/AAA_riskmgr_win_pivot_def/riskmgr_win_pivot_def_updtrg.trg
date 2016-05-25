/* **********************************************************************
     riskmgr_win_pivot_def_updtrg.trg

       Project       : Integrated Commodity Trading System (ICTS)
       Company       : Amphora, Inc

       Created By    : Javier Montero
       Database      : MS SQL Server 2008 or higher

       Modified By   : Surender
           Date             Description of Changes
           --------------   ---------------------------------------------
           04/05/2016			Added new column 'asof_date'
   ********************************************************************** */

IF OBJECT_ID('dbo.riskmgr_win_pivot_def_updtrg','TR') IS NOT NULL
EXEC ('DROP TRIGGER dbo.riskmgr_win_pivot_def_updtrg')
GO

CREATE TRIGGER riskmgr_win_pivot_def_updtrg
ON dbo.riskmgr_win_pivot_def
FOR update
AS

declare @num_rows         int,
        @count_num_rows   int,
        @dummy_update     int,
        @errmsg           varchar(255)

select @num_rows = @@rowcount
if @num_rows = 0
   return

select @dummy_update = 0

/* RECORD_STAMP_BEGIN */
if not update(trans_id) 
begin
   raiserror ('(riskmgr_win_pivot_def) The change needs to be attached with a new trans_id.',10,1)
   if @@trancount > 0 rollback tran

   return
end

/* added by Peter Lo  Sep-4-2002 */
if exists (select 1
           from master.dbo.sysprocesses
           where spid = @@spid and
                (rtrim(program_name) IN ('ISQL-32', 'OSQL-32', 'SQL Query Analyzer', 'SQLCMD') OR
                 program_name like 'Microsoft SQL Server Management Studio%') )
begin
   if (select count(*) from inserted, deleted where inserted.trans_id <= deleted.trans_id) > 0
   begin
      select @errmsg = '(riskmgr_win_pivot_def) New trans_id must be larger than original trans_id.'
      select @errmsg = @errmsg + char(10) + 'You can use the the gen_new_transaction procedure to obtain a new trans_id.'
      raiserror (@errmsg,10,1)
      if @@trancount > 0 rollback tran

      return
   end
end

if exists (select * from inserted i, deleted d
           where i.trans_id < d.trans_id and
                 i.piv_def_id = d.piv_def_id)
begin
   select @errmsg = '(riskmgr_win_pivot_def) new trans_id must not be older than current trans_id.'   
   if @num_rows = 1 
   begin
      select @errmsg = @errmsg + ' (' + convert(varchar, i.piv_def_id) + ')'
      from inserted i
   end
   if @@trancount > 0 rollback tran

   raiserror (@errmsg,10,1)
   return
end

/* RECORD_STAMP_END */

if update(piv_def_id)
begin
   select @count_num_rows = (select count(*) from inserted i, deleted d
                             where i.piv_def_id = d.piv_def_id)
   if (@count_num_rows = @num_rows)
   begin
      select @dummy_update = 1
   end
   else
   begin
      raiserror ('(riskmgr_win_pivot_def) primary key can not be changed.',10,1)
      if @@trancount > 0 rollback tran

      return
   end
end

 /* BEGIN_TRANSACTION_TOUCH */
 
   insert dbo.transaction_touch
   select 'INSERT',
          'riskmgr_win_pivot_def',
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
   from inserted i, dbo.icts_transaction it
   where i.trans_id = it.trans_id and
         it.type != 'E'
 
   /* END_TRANSACTION_TOUCH */
   
   /* AUDIT_CODE_BEGIN */
   if @dummy_update = 0
   
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
	 i.trans_id
from deleted d, inserted i where d.owner_win_id = i.owner_win_id

/* AUDIT_CODE_END*/
return 

GO