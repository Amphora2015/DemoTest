print ' '
print 'Granting object permissions ...'
go

/* main tables */
grant select, insert, update, delete on dbo.riskmgr_win_def to next_usr
go
grant select, insert, update, delete on dbo.riskmgr_win_pivot_def to next_usr
go
