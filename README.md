# Usage
```
docker run -it -p 80:80 -p 443:443 -v /abc:/etc/apache2/sites-available  -v /data/web:/var/www -v /data/phpconfig:/etc/php -d babim/apache
```

Volume:
```
/var/www
/etc/apache2
/etc/php
```

## Environment apache, php value
```
TIMEZONE
PHP_MEMORY_LIMIT
MAX_UPLOAD
PHP_MAX_FILE_UPLOAD
PHP_MAX_POST
MAX_INPUT_TIME
MAX_EXECUTION_TIME
```
## with environment ID:
```
auid = user id
agid = group id
auser = username
Default: agid = auid
```
## Environment ssh, cron option
```
SSHOPTION=false
CRONOPTION=false
NFSOPTION=false
SYNOLOGYOPTION=false
UPGRADEOPTION=false
WWWUSER=www-data
MYSQLUSER=mysql
FULLOPTION=true
```

## NFS option
Writing back to the host:
```
docker run -itd \
    --privileged=true \
    --net=host \
    --name nfs-movies \
    -v /media/nfs-movies:/mnt/nfs-1:shared \
    -e SERVER=192.168.0.9 \
    -e SHARE=movies \
    babim/........
```
```
default:
FSTYPE nfs4
MOUNT_OPTIONS nfsvers=4
MOUNTPOINT /mnt/nfs-1
---
max FSTYPE, MOUNT_OPTIONS, MOUNTPOINT
FSTYPE2
FSTYPE3
FSTYPE4
```