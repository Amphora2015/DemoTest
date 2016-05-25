/* **********************************************************************
     riskmgr_win_pivot_def_instrg.trg

       Project      : Integrated Commodity Trading System (ICTS)
       Company      : Amphora, Inc
       Created By   : Javier Montero
	   Modified By 	: 
       Database     : MS SQL Server 2008 or higher

       Modification   :
           Date             Description of Changes
           --------------   ---------------------------------------------
       
   ********************************************************************** */

IF OBJECT_ID('dbo.riskmgr_win_pivot_def_instrg','TR') is not null
EXEC ('DROP TRIGGER dbo.riskmgr_win_pivot_def_instrg')
GO

CREATE trigger dbo.riskmgr_win_pivot_def_instrg
on dbo.riskmgr_win_pivot_def
for insert
as
declare @num_rows       int,
        @count_num_rows int,
        @errmsg         varchar(255)

select @num_rows = @@rowcount
if @num_rows = 0
   return

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

return
GO
