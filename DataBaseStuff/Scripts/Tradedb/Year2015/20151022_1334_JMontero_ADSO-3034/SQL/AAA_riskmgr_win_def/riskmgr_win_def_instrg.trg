IF object_id('dbo.riskmgr_win_def_instrg', 'TR') is not null
   drop trigger dbo.riskmgr_win_def_instrg 
go

create trigger dbo.riskmgr_win_def_instrg
ON dbo.riskmgr_win_def
for insert
as
declare @num_rows           int,
        @the_entity_name    varchar(30)

select @num_rows = @@rowcount
if @num_rows = 0
   return        

set @the_entity_name = 'RiskmgrWinDef'	
	
/* BEGIN_TRANSACTION_TOUCH */
insert dbo.transaction_touch
select 'INSERT',
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
