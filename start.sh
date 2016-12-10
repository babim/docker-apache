#!/bin/bash
export TERM=xterm

if [ -z "`ls /etc/apache2`" ]; then cp -R /etc-start/apache2/* /etc/apache2; fi
if [ -z "`ls /etc/php`" ]; then cp -R /etc-start/php/* /etc/php; fi

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
	-e "s|^;*\(opcache.enable\) *=.*|\1 = 1|" \
        -e "s|^;*\(opcache.enable_cli\) *=.*|\1 = 1|" \
        -e "s|^;*\(opcache.fast_shutdown\) *=.*|\1 = 1|" \
        -e "s|^;*\(opcache.interned_strings_buffer\) *=.*|\1 = 8|" \
        -e "s|^;*\(opcache.max_accelerated_files\) *=.*|\1 = 4000|" \
        -e "s|^;*\(opcache.memory_consumption\) *=.*|\1 = 128|" \
	-e "s|^;*\(opcache.revalidate_freq\) *=.*|\1 = 60|" \
	/etc/php/7.0/*/php.ini

# set ID docker run
agid=${agid:-$auid}
auser=www-data

if [[ -z "${auid}" ]]; then
  echo "start"
elif [[ "$auid" = "0" ]] || [[ "$aguid" == "0" ]]; then
 echo "can't run in Root user. Default user still run."
else
  usermod -u $auid $auser
  groupmod -g $agid $auser
fi

# Start apache
apache2 -D FOREGROUND
