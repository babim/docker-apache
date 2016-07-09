#!/bin/bash
export TERM=xterm

if [ -z "`ls /etc/apache2/sites-available`" ] 
then
	cp -R /etc-start/apache2/sites-available/* /etc/apache2/sites-available
fi

if [ -z "`ls /etc/apache2/sites-enable`" ] 
then
	cp -R /etc-start/apache2/sites-enable/* /etc/apache2/sites-enable
fi

if [ -z "`ls /etc/php/7.0`" ] 
then
	cp -R /etc-start/php/7.0/* /etc/php/7.0
fi

# Start php7
#service php7.0 start
# Start apache
/usr/sbin/apache2 -D FOREGROUND
