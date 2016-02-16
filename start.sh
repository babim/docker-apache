#!/bin/bash

export TERM=xterm

if [ -z "`/etc/apache2/sites-available`" ] 
then
	cp -R /etc-start/apache2/sites-available/ /etc/apache2/sites-available
fi

# Start apache
/usr/sbin/apache2 -D FOREGROUND
