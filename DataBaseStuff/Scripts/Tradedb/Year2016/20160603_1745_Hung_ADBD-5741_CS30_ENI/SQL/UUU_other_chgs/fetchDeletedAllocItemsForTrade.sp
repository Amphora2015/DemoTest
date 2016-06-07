if object_id('dbo.fetchDeletedAllocItemsForTrade','P') is null
   exec ('create procedure dbo.fetchDeletedAllocItemsForTrade as select getdate()')
go  

alter procedure dbo.fetchDeletedAllocItemsForTrade 
(       
   @trade_num        int,
   @trade_num1       int,
   @trade_num2       int
) 
as
set nocount on
declare @errcode       int
                         
   select @errcode = 0                
   select
		aud.acct_num,
		aud.acct_ref_num,
		aud.actual_gross_qty,
		aud.actual_gross_uom_code,
		aud.alloc_item_confirm,
		aud.alloc_item_num,
		aud.alloc_item_short_cmnt,
		aud.alloc_item_status,
		aud.alloc_item_type,
		aud.alloc_item_verify,
		aud.alloc_num,
		aud.ar_alloc_item_num,
		aud.ar_alloc_num,
		aud.auto_receipt_actual_ind,
		aud.auto_receipt_ind,
		aud.auto_sampling_comp_num,
		aud.auto_sampling_ind,
		aud.cmdty_code,
		aud.cmnt_num,
		aud.confirmation_date,
		aud.cr_anly_init,
		aud.cr_clear_ind,
		aud.credit_term_code,
		aud.del_term_code,
		aud.dest_loc_code,
		aud.estimate_event_date,
		aud.final_dest_loc_code,
		aud.finance_bank_num,
		aud.fully_actualized,
		aud.imp_rec_ind,
		aud.imp_rec_reason_oid,
		aud.insp_acct_num,
		aud.inspection_date,
		aud.inspector_percent,
		aud.inv_num,
		aud.item_num,
		aud.lc_num,
		aud.load_port_loc_code,
		aud.max_ai_est_actual_num,
		aud.net_nom_num,
		aud.nomin_date_from,
		aud.nomin_date_to,
		aud.nomin_qty_max,
		aud.nomin_qty_max_uom_code,
		aud.nomin_qty_min,
		aud.nomin_qty_min_uom_code,
		aud.order_num,
		aud.origin_loc_code,
		aud.pay_days,
		aud.pay_term_code,
		aud.purchasing_group,
		aud.recap_item_num,
		aud.reporting_date,
		aud.resp_trans_id,
		aud.sap_delivery_line_item_num,
		aud.sap_delivery_num,
		aud.sch_qty,
		aud.sch_qty_periodicity,
		aud.sch_qty_uom_code,
		aud.sec_actual_uom_code,
		aud.secondary_actual_qty,
		aud.ship_agent_comp_num,
		aud.ship_broker_comp_num,
		aud.sub_alloc_num,
		aud.title_tran_date,
		aud.title_tran_loc_code,
		aud.trade_num,
		aud.trans_id,
		aud.transfer_price,
		aud.transfer_price_curr_code,
		aud.transfer_price_curr_code_to,
		aud.transfer_price_currency_rate,
		aud.transfer_price_uom_code,
		aud.vat_ind     
   from dbo.aud_allocation_item aud,
        (select alloc_num,
                alloc_item_num,
                max(resp_trans_id) as resp_trans_id
         from dbo.aud_allocation_item b  
         where trade_num = @trade_num and 
               not exists (select 1 
                           from dbo.allocation_item a 
                           where b.trade_num = a.trade_num and
                                 b.order_num = a.order_num and
                                 b.item_num = a.item_num)  
         group by alloc_num, alloc_item_num) d 
   where aud.alloc_num = d.alloc_num and 
         aud.alloc_item_num = d.alloc_item_num and
         aud.resp_trans_id = d.resp_trans_id 
   UNION
   select 
		aud.acct_num,
		aud.acct_ref_num,
		aud.actual_gross_qty,
		aud.actual_gross_uom_code,
		aud.alloc_item_confirm,
		aud.alloc_item_num,
		aud.alloc_item_short_cmnt,
		aud.alloc_item_status,
		aud.alloc_item_type,
		aud.alloc_item_verify,
		aud.alloc_num,
		aud.ar_alloc_item_num,
		aud.ar_alloc_num,
		aud.auto_receipt_actual_ind,
		aud.auto_receipt_ind,
		aud.auto_sampling_comp_num,
		aud.auto_sampling_ind,
		aud.cmdty_code,
		aud.cmnt_num,
		aud.confirmation_date,
		aud.cr_anly_init,
		aud.cr_clear_ind,
		aud.credit_term_code,
		aud.del_term_code,
		aud.dest_loc_code,
		aud.estimate_event_date,
		aud.final_dest_loc_code,
		aud.finance_bank_num,
		aud.fully_actualized,
		aud.imp_rec_ind,
		aud.imp_rec_reason_oid,
		aud.insp_acct_num,
		aud.inspection_date,
		aud.inspector_percent,
		aud.inv_num,
		aud.item_num,
		aud.lc_num,
		aud.load_port_loc_code,
		aud.max_ai_est_actual_num,
		aud.net_nom_num,
		aud.nomin_date_from,
		aud.nomin_date_to,
		aud.nomin_qty_max,
		aud.nomin_qty_max_uom_code,
		aud.nomin_qty_min,
		aud.nomin_qty_min_uom_code,
		aud.order_num,
		aud.origin_loc_code,
		aud.pay_days,
		aud.pay_term_code,
		aud.purchasing_group,
		aud.recap_item_num,
		aud.reporting_date,
		aud.resp_trans_id,
		aud.sap_delivery_line_item_num,
		aud.sap_delivery_num,
		aud.sch_qty,
		aud.sch_qty_periodicity,
		aud.sch_qty_uom_code,
		aud.sec_actual_uom_code,
		aud.secondary_actual_qty,
		aud.ship_agent_comp_num,
		aud.ship_broker_comp_num,
		aud.sub_alloc_num,
		aud.title_tran_date,
		aud.title_tran_loc_code,
		aud.trade_num,
		aud.trans_id,
		aud.transfer_price,
		aud.transfer_price_curr_code,
		aud.transfer_price_curr_code_to,
		aud.transfer_price_currency_rate,
		aud.transfer_price_uom_code,
		aud.vat_ind    
   from dbo.aud_allocation_item aud,
        (select alloc_num,
                alloc_item_num,
                max(resp_trans_id) as resp_trans_id
         from dbo.aud_allocation_item b  
         where (trade_num between @trade_num1 AND @trade_num2) and 
               not exists (select 1 
                           from dbo.allocation_item a 
                           where b.trade_num = a.trade_num and 
                                 b.order_num = a.order_num and
                                 b.item_num = a.item_num)  
         group by alloc_num, alloc_item_num) d 
   where aud.alloc_num = d.alloc_num and 
         aud.alloc_item_num = d.alloc_item_num and
         aud.resp_trans_id = d.resp_trans_id 
   select @errcode = @@error
   if @errcode > 0
   begin
      print '=> Failed to fetch and return aud_allocation_item records!'
      goto endofsp
   end

endofsp: 
if @errcode > 0
   return 1
return 0

GO

IF OBJECT_ID('dbo.fetchDeletedAllocItemsForTrade') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.fetchDeletedAllocItemsForTrade >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.fetchDeletedAllocItemsForTrade >>>'
GO

GRANT EXECUTE ON dbo.fetchDeletedAllocItemsForTrade TO next_usr
GO

