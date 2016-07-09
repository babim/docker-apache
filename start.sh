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

# Start apache
/usr/sbin/apache2 -D FOREGROUND
