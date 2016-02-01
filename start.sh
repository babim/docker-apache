#!/bin/bash

# Start php7
service php7.0-fpm start
# Start apache
/usr/sbin/apache2 -D FOREGROUND
