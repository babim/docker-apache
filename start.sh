#!/bin/bash

export TERM=xterm

if [ -z "`ls /etc/apache2/sites-available`" ] 
then
	cp -R /etc-start/apache2/sites-available/* /etc/apache2/sites-available
fi
if [ -z "`ls /etc/apache2/sites-enabled`" ] 
then
	cp -R /etc-start/apache2/sites-enabled/* /etc/apache2/sites-enabled
fi

# Start apache
apache2 -D FOREGROUND
