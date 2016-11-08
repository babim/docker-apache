#!/bin/sh

export TERM=xterm

# Prepare
if [ -z "`ls /etc/apache2`" ]; then cp -R /etc-start/apache2/* /etc/apache2; fi
if [ -z "`ls /var/www`" ]; then cp -R /etc-start/www/* /var/www; fi

# Start apache
exec httpd -D FOREGROUND
