if object_id('dbo.fetchAllocItemToAssignTrade','P') is null
   exec('create procedure dbo.fetchAllocItemToAssignTrade as select getdate()')
go  

alter procedure dbo.fetchAllocItemToAssignTrade 
   @alloc_item_num      smallint,  
   @alloc_num           int,
   @asof_trans_id       INT,
   @item_num                                   INT,
   @order_num                                  INT,
   @trade_num                                  INT
as  
set nocount on
      
   select
		acct_num,
		alloc_item_num,
		alloc_num,
		asof_trans_id=@asof_trans_id,
		assign_num,
		covered_amt,
		credit_exposure_oid,
		ct_doc_num,
		ct_doc_type,
		item_num,
		order_num,
		resp_trans_id = NULL,
		trade_num,
		trans_id
                from dbo.assign_trade
                where alloc_num = @alloc_num and
                                  alloc_item_num = @alloc_item_num AND
                                  trade_num = @trade_num AND
                                  order_num = @order_num AND
                                  item_num = @item_num and
                                  trans_id <= @asof_trans_id
   UNION
   select 
		acct_num,
		alloc_item_num,
		alloc_num,
		asof_trans_id=@asof_trans_id,
		assign_num,
		covered_amt,
		credit_exposure_oid,
		ct_doc_num,
		ct_doc_type,
		item_num,
		order_num,
		resp_trans_id,
		trade_num,
		trans_id  
   from dbo.aud_assign_trade
   where alloc_num = @alloc_num and
                                  alloc_item_num = @alloc_item_num and   
                                  trade_num = @trade_num AND
                                  order_num = @order_num AND
                                  item_num = @item_num and
        (trans_id <= @asof_trans_id and   
         resp_trans_id > @asof_trans_id)  
return
GO

IF OBJECT_ID('dbo.fetchAllocItemToAssignTrade') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.fetchAllocItemToAssignTrade >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.fetchAllocItemToAssignTrade >>>'
GO
	
GRANT EXECUTE ON dbo.fetchAllocItemToAssignTrade TO next_usr
GO

