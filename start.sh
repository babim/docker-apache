#!/bin/sh
export TERM=xterm

if [ -z "`ls /etc/apache2`" ] 
then
	cp -R /etc-start/apache2/* /etc/apache2
fi

if [ -z "`ls /etc/php7`" ] 
then
	cp -R /etc-start/php7/* /etc/php7
fi

# Start php7
#service php7.0 start
# Start apache
exec /usr/sbin/httpd -D FOREGROUND
