#!/bin/sh
export TERM=xterm

if [ -z "`ls /etc/apache2/sites-available`" ] 
then
	cp -R /etc-start/apache2/sites-available/* /etc/apache2/sites-available
fi

if [ -z "`ls /etc/apache2/sites-enabled`" ] 
then
	cp -R /etc-start/apache2/sites-enabled/* /etc/apache2/sites-enabled
fi

if [ -z "`ls /etc/php/5.6`" ] 
then
	cp -R /etc-start/php/5.6/* /etc/php/5.6
fi

# Start apache
exec /usr/sbin/httpd -D FOREGROUND
