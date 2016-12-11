#!/bin/sh
export TERM=xterm

# Prepare
if [ -z "`ls /etc/apache2`" ]; then cp -R /etc-start/apache2/* /etc/apache2; fi
if [ -z "`ls /etc/php5`" ]; then cp -R /etc-start/php5/* /etc/php5; fi
if [ -z "`ls /var/www`" ]; then cp -R /etc-start/www/* /var/www; fi

   # Set environments
    TIMEZONE1=${TIMEZONE:-Asia/Ho_Chi_Minh}
    PHP_MEMORY_LIMIT1=${PHP_MEMORY_LIMIT:-512M}
    MAX_UPLOAD1=${MAX_UPLOAD:-520M}
    PHP_MAX_FILE_UPLOAD1=${PHP_MAX_FILE_UPLOAD:-200}
    PHP_MAX_POST1=${PHP_MAX_POST:-520M}
    MAX_INPUT_TIME1=${MAX_INPUT_TIME:-3600}
    MAX_EXECUTION_TIME1=${MAX_EXECUTION_TIME:-3600}
	
	sed -i -E \
	-e "s|;*date.timezone =.*|date.timezone = ${TIMEZONE1}|i" \
	-e "s|;*memory_limit =.*|memory_limit = ${MAX_UPLOAD1}|i" \
 	-e "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD1}|i" \
    	-e "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD1}|i" \
    	-e "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST1}|i" \
    	-e "s/max_input_time = 60/max_input_time = ${MAX_INPUT_TIME1}/" \
	-e "s/max_execution_time = 30/max_execution_time = ${MAX_EXECUTION_TIME1}/" \
	/etc/php5/php.ini

# set ID docker run
agid=${agid:-$auid}
auser=${auser:-www-data}

if [[ -z "${auid}" ]]; then
  echo "start"
elif [[ "$auid" = "0" ]] || [[ "$aguid" == "0" ]]; then
	echo "run in user root"
	export auser=root
	export APACHE_RUN_USER=$auser
	export APACHE_RUN_GROUP=$auser
	#sed -i -e "/^user = .*/cuser = $auser" /etc/php/7.0/fpm/php-fpm.conf
	#sed -i -e "/^group = .*/cgroup = $auser" /etc/php/7.0/fpm/php-fpm.conf
	#sed -i -e "/^user .*/cuser  $auser;" /etc/nginx/nginx.conf
	#sed -i -e "/^#user .*/cuser  $auser;" /etc/nginx/nginx.conf
else
if id $auser >/dev/null 2>&1; then
        echo "user exists"
	#sed -i -e "/^user = .*/cuser = $auser" /etc/php/7.0/fpm/php-fpm.conf
	#sed -i -e "/^group = .*/cgroup = $auser" /etc/php/7.0/fpm/php-fpm.conf
	#sed -i -e "/^user .*/cuser  $auser;" /etc/nginx/nginx.conf
	#sed -i -e "/^#user .*/cuser  $auser;" /etc/nginx/nginx.conf
	export APACHE_RUN_USER=$auser
	export APACHE_RUN_GROUP=$auser
	# usermod alpine
		deluser $auser && delgroup $auser
		addgroup -g $agid $auser && adduser -D -H -G $auser -s /bin/false -u $auid $auser
	# usermod ubuntu/debian
		#usermod -u $auid $auser
		#groupmod -g $agid $auser
else
        echo "user does not exist"
	export APACHE_RUN_USER=$auser
	export APACHE_RUN_GROUP=$auser
	# create user alpine
	addgroup -g $agid $auser && adduser -D -H -G $auser -s /bin/false -u $auid $auser
	# create user ubuntu/debian
	#groupadd -g $agid $auser && useradd --system --uid $auid --shell /usr/sbin/nologin -g $auser $auser
	#sed -i -e "/^user = .*/cuser = $auser" /etc/php/7.0/fpm/php-fpm.conf
	#sed -i -e "/^group = .*/cgroup = $auser" /etc/php/7.0/fpm/php-fpm.conf
	#sed -i -e "/^user .*/cuser  $auser;" /etc/nginx/nginx.conf
	#sed -i -e "/^#user .*/cuser  $auser;" /etc/nginx/nginx.conf
fi

fi

# Start apache
exec httpd -D FOREGROUND
