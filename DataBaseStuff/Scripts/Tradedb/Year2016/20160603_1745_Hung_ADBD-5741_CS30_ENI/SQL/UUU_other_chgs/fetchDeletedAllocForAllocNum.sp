if object_id('dbo.fetchDeletedAllocForAllocNum','P') is null
   exec('create procedure dbo.fetchDeletedAllocForAllocNum as select getdate()')
go  

alter procedure dbo.fetchDeletedAllocForAllocNum 
(       
   @alloc_num      int
) 
as     
set nocount on    
declare @errcode       int
          
   select @errcode = 0                    
   select 
	aud.alloc_base_price,
	aud.alloc_begin_date,
	aud.alloc_cmdty_code,
	aud.alloc_disc_rate,
	aud.alloc_end_date,
	aud.alloc_load_loc_code,
	aud.alloc_loc_code,
	aud.alloc_match_ind,
	aud.alloc_num,
	aud.alloc_pay_date,
	aud.alloc_short_cmnt,
	aud.alloc_status,
	aud.alloc_type_code,
	aud.base_port_num,
	aud.book_net_price_ind,
	aud.bookout_brkr_num,
	aud.bookout_pay_date,
	aud.bookout_rec_date,
	aud.cmnt_num,
	aud.compr_trade_num,
	aud.creation_date,
	aud.creation_type,
	aud.deemed_bl_date,
	aud.initiator_acct_num,
	aud.max_alloc_item_num,
	aud.mot_code,
	aud.multiple_cmdty_ind,
	aud.netout_gross_qty,
	aud.netout_net_qty,
	aud.netout_parcel_num,
	aud.netout_qty_uom_code,
	aud.pay_for_del,
	aud.pay_for_weight,
	aud.ppl_batch_given_date,
	aud.ppl_batch_num,
	aud.ppl_batch_received_date,
	aud.ppl_comp_cont_num,
	aud.ppl_comp_num,
	aud.ppl_origin_given_date,
	aud.ppl_origin_received_date,
	aud.ppl_pump_date,
	aud.ppl_split_cycle_opt,
	aud.ppl_timing_cycle_num,
	aud.price_precision,
	aud.release_doc_num,
	aud.resp_trans_id,
	aud.sch_init,
	aud.sch_prd,
	aud.trans_id,
	aud.transfer_price,
	aud.transfer_price_curr_code,
	aud.transfer_price_curr_code_to,
	aud.transfer_price_currency_rate,
	aud.transfer_price_uom_code,
	aud.transportation,
	aud.voyage_code
   from dbo.aud_allocation aud
   where aud.alloc_num = @alloc_num and
         resp_trans_id = (select max(resp_trans_id)
                          from dbo.aud_allocation alloc
                          where alloc_num = @alloc_num and
                                not exists (select 1
                                            from dbo.allocation a
                                            where alloc.alloc_num = a.alloc_num))  
   select @errcode = @@error
   if @errcode > 0
   begin
      print '=> Failed to fetch and return aud_allocation records'
      goto endofsp
   end      

endofsp: 
if @errcode > 0
   return 1
return 0
GO

IF OBJECT_ID('dbo.fetchDeletedAllocForAllocNum') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.fetchDeletedAllocForAllocNum >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.fetchDeletedAllocForAllocNum >>>'
GO

GRANT EXECUTE ON dbo.fetchDeletedAllocForAllocNum TO next_usr
GO


