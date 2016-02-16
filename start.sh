#!/bin/bash
export TERM=xterm

if [ -z "`/etc/apache2/sites-available`" ] 
then
	rsync -a /etc-start/apache2/sites-available/* /etc/apache2/sites-available
fi

if [ -z "`/etc/php/7.0`" ] 
then
	rsync -a /etc-start/php/7.0/* /etc/php/7.0
fi

# Start php7
service php7.0-fpm start
# Start apache
/usr/sbin/apache2 -D FOREGROUND
