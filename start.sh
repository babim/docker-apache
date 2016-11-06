#!/bin/sh
export TERM=xterm

if [ -z "`ls /etc/apache2`" ] 
then
	cp -R /etc-start/apache2/* /etc/apache2
fi

if [ -z "`ls /etc/php5`" ] 
then
	cp -R /etc-start/php5/* /etc/php5
fi

# Start apache
exec /usr/sbin/httpd -D FOREGROUND
