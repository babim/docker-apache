#!/bin/bash

export TERM=xterm

if [ -z "`ls /etc/apache2`" ]; then cp -R /etc-start/apache2/* /etc/apache2; fi

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
	#sed -i -e "/^user = .*/cuser = $auser" /etc/php/5.6/fpm/php-fpm.conf
	#sed -i -e "/^group = .*/cgroup = $auser" /etc/php/5.6/fpm/php-fpm.conf
	#sed -i -e "/^user .*/cuser  $auser;" /etc/nginx/nginx.conf
	#sed -i -e "/^#user .*/cuser  $auser;" /etc/nginx/nginx.conf
elif id $auid >/dev/null 2>&1; then
        echo "UID exists. Please change UID"
else
if id $auser >/dev/null 2>&1; then
        echo "user exists"
	#sed -i -e "/^user = .*/cuser = $auser" /etc/php/5.6/fpm/php-fpm.conf
	#sed -i -e "/^group = .*/cgroup = $auser" /etc/php/5.6/fpm/php-fpm.conf
	#sed -i -e "/^user .*/cuser  $auser;" /etc/nginx/nginx.conf
	#sed -i -e "/^#user .*/cuser  $auser;" /etc/nginx/nginx.conf
	export APACHE_RUN_USER=$auser
	export APACHE_RUN_GROUP=$auser
	# usermod alpine
		#deluser $auser && delgroup $auser
		#addgroup -g $agid $auser && adduser -D -H -G $auser -s /bin/false -u $auid $auser
	# usermod ubuntu/debian
		usermod -u $auid $auser
		groupmod -g $agid $auser
else
        echo "user does not exist"
	export APACHE_RUN_USER=$auser
	export APACHE_RUN_GROUP=$auser
	# create user alpine
	#addgroup -g $agid $auser && adduser -D -H -G $auser -s /bin/false -u $auid $auser
	# create user ubuntu/debian
	groupadd -g $agid $auser && useradd --system --uid $auid --shell /usr/sbin/nologin -g $auser $auser
	#sed -i -e "/^user = .*/cuser = $auser" /etc/php/5.6/fpm/php-fpm.conf
	#sed -i -e "/^group = .*/cgroup = $auser" /etc/php/5.6/fpm/php-fpm.conf
	#sed -i -e "/^user .*/cuser  $auser;" /etc/nginx/nginx.conf
	#sed -i -e "/^#user .*/cuser  $auser;" /etc/nginx/nginx.conf
fi

fi

# ssh
if [ -f "/runssh.sh" ]; then /runssh.sh; fi
# cron
if [ -f "/runcron.sh" ]; then /runcron.sh; fi
# nfs
if [ -f "/mountnfs.sh" ]; then /mountnfs.sh; fi

# Start apache
apache2 -D FOREGROUND
