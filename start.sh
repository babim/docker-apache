#!/bin/sh

export TERM=xterm

if [ -z "`ls /etc/apache2`" ] 
then
	cp -R /etc-start/apache2/* /etc/apache2
fi

# Start apache
exec /usr/sbin/httpd -D FOREGROUND
