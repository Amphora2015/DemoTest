print ' '
print 'Granting object permissions ...'
go

/* main tables */
grant select, insert, update, delete on dbo.topic_portfolio_mappings to next_usr
grant select, insert, update, delete on dbo.rabbitmq_security_auth to next_usr
go

