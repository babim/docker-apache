FROM babim/alpinebase

RUN apk add --no-cache apache2 php5-apache2 imagemagick \
	nano php5-fpm php5-json php5-gd php5-sqlite3 curl php5-curl php5-ldap php5-mysql php5-mysqli php5-pgsql php5-imap php5-bcmath \
	php5-xmlrpc php5-mcrypt php5-memcache php5-intl php5-zip php5-opcache php5-mssql php5-bz2 php5-odbc php5-gettext php5-dba php5-soap \
	php5-xml php5-zlib php5-exif php5-pdo php5-pdo_odbc php5-pdo_dblib php5-pdo_sqlite php5-pdo_pgsql php5-pdo_mysql php5-pear

RUN sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php5/php.ini && \
    sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Ho_Chi_Minh/g' /etc/php5/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 520M/" /etc/php5/php.ini && \
    sed -i "s/post_max_size = 8M/post_max_size = 520M/" /etc/php5/php.ini && \
    sed -i "s/;opcache.enable=0/opcache.enable=0/" /etc/php5/php.ini

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2", "/etc/php5"]
RUN mkdir -p /etc-start/apache2 && cp -R /etc/apache2/* /etc-start/apache2 && \
    mkdir -p /etc-start/php5 &&  cp -R /etc/php5/* /etc-start/php5 && \
    mkdir -p /etc-start/www  && cp -R /var/www/* /etc-start/www

# fix apache pid no suck file
RUN mkdir -p /run/apache2

EXPOSE 80 443
ADD start.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh
CMD ["/entrypoint.sh"]
