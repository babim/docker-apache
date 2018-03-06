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

Environment
```
TIMEZONE
PHP_MEMORY_LIMIT
MAX_UPLOAD
PHP_MAX_FILE_UPLOAD
PHP_MAX_POST
MAX_INPUT_TIME
MAX_EXECUTION_TIME
```
with environment ID:
```
auid = user id
agid = group id
auser = username
Default: agid = auid
```
