print ' '
print 'Adding a entry into ''new_num'' table to support new table riskmgr_win_def  ...'
go

IF NOT EXISTS (select 1 from dbo.new_num where num_col_name = 'win_id' and loc_num = 0)
   
   INSERT INTO dbo.new_num(num_col_name,loc_num,last_num,owner_table,owner_column,trans_id)
		  VALUES('win_id', 0, 0, 'riskmgr_win_def', 'win_id', 1)
go

print ' '
print 'Adding a entry into ''new_num'' table to support new table riskmgr_win_pivot_def  ...'
go

IF NOT EXISTS (select 1 from dbo.new_num where num_col_name = 'piv_def_id' and loc_num = 0)
   
   INSERT INTO dbo.new_num(num_col_name,loc_num,last_num,owner_table,owner_column,trans_id)
		  VALUES('piv_def_id', 0, 0, 'riskmgr_win_pivot_def', 'piv_def_id', 1)
go