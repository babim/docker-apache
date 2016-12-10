#!/bin/bash

export TERM=xterm

if [ -z "`ls /etc/apache2`" ]; then cp -R /etc-start/apache2/* /etc/apache2; fi

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
