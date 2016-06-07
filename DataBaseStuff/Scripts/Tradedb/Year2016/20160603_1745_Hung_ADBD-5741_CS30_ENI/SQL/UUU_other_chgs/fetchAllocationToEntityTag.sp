if object_id('dbo.fetchAllocationToEntityTag','P') is null
exec('create procedure dbo.fetchAllocationToEntityTag as select getdate()')
go

alter procedure dbo.fetchAllocationToEntityTag  
(  
   @alloc_num          int,  
   @asof_trans_id      int  
)  
as  
set nocount on  
   
   select asof_trans_id = @asof_trans_id,
		entity_tag_id,
		entity_tag_key,
		key1,
		key2,
		key3,
		key4,
		key5,
		key6,
		key7,
		key8,
		resp_trans_id = NULL,
		target_key1,
		target_key2,
		target_key3,
		target_key4,
		target_key5,
		target_key6,
		target_key7,
		target_key8,
		trans_id
   from dbo.entity_tag
   where entity_tag_id in (select oid from dbo.entity_tag_definition 
   where entity_id = (select oid from icts_entity_name where entity_name = 'Allocation' ))
   and key1 = convert(varchar,@alloc_num) and trans_id <= @asof_trans_id  
   union  
   select asof_trans_id = @asof_trans_id,
			entity_tag_id,
			entity_tag_key,
			key1,
			key2,
			key3,
			key4,
			key5,
			key6,
			key7,
			key8,
			resp_trans_id,
			target_key1,
			target_key2,
			target_key3,
			target_key4,
			target_key5,
			target_key6,
			target_key7,
			target_key8,
			trans_id
   from dbo.aud_entity_tag
   where entity_tag_id in (select oid from dbo.entity_tag_definition 
   where entity_id = (select oid from dbo.icts_entity_name where entity_name = 'Allocation' )) 
   and key1 = convert(varchar,@alloc_num) and (trans_id <= @asof_trans_id and resp_trans_id > @asof_trans_id)  
return  
go

grant exec on dbo.fetchAllocationToEntityTag to next_usr
go

if object_id('dbo.fetchAllocationToEntityTag','P') is not null
print '<<< CREATE/ALTER dbo.fetchAllocationToEntityTag is successfull...>>>'
else
print '<<< Failed to CREATE/ALTER dbo.fetchAllocationToEntityTag...>>>'
go