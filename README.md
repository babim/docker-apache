# Usage
```
docker run -it -p 80:80 -p 443:443 -v /abc:/etc/apache2  -v /data/web:/var/www -v /data/phpconfig:/etc/php5 -d babim/apache:alpine
```
