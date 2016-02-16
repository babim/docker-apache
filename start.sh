#!/bin/bash

export TERM=xterm

if [ -z "`/etc/apache2/sites-available`" ] 
then
	rsync -a /etc-start/apache2/sites-available/* /etc/apache2/sites-available
fi

if [ -z "`/etc/php5`" ] 
then
	rsync -a /etc-start/php5/* /etc/php5
fi

# Start apache
/usr/sbin/apache2 -D FOREGROUND
