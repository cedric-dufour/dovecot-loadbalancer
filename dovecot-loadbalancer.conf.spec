[database]
host = string( min=1, max=256, default='127.0.0.1' )
port = integer( min=1, max=65535, default=5432 )
database = string( min=1, max=256, default='dovecot' )
user = string( min=1, max=256, default='dovecot' )
password = string( min=0, max=256, default='' )

[status]
threads = integer( min=1, max=1024, default=8 )
repeat = float( min=1.0, max=3600.0, default=60.0 )
timeout = float( min=0.0, max=60.0, default=3.0 )
retry = integer( min=0, max=10, default=2 )

[email]
sendmail = string( min=1, max=256, default='/usr/sbin/sendmail' )
sender = string( min=1, max=256, default='dovecot-loadbalancer@localhost.localdomain' )
recipient = string( min=0, max=256, default='' )
prefix = string( min=1, max=256, default='[DOVECOT-LOADBALANCER] ' )
