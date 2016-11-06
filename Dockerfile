FROM babim/alpinebase:edge

RUN apk add --no-cache \
    apache2 php7-apache2 && \
    apk add --no-cache imagemagick \
    php7-cgi php7-phpdbg php7-dev sqlite \
    php7-curl php7-gd php7-imap php7-intl php7-ldap php7-mcrypt php7-readline php7-odbc php7-exif php7-xml \
    php7-pgsql php7-pspell php7-ftp php7-tidy php7-xmlrpc php7 php7-json php7-ctype php7-zlib php7-bcmath \
    php7-sqlite3 php7-mysqli php7-opcache php7-bz2 php7-mbstring php7-zip  php7-soap php7-gettext \
    php7-pear php7-pdo_dblib php7-pdo_pgsql php7-pdo_odbc php7-pdo_sqlite php7-pdo_mysql php7-pdo
# disable: php7-memcached php7-apcu

RUN sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php7/php.ini && \
    sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Ho_Chi_Minh/g' /etc/php7/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php7/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 520M/" /etc/php7/php.ini && \
    sed -i "s/post_max_size = 8M/post_max_size = 520M/" /etc/php7/php.ini && \
    sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php7/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 3600/" /etc/php7/php.ini && \
    sed -i "s/;opcache.enable=0/opcache.enable=0/" /etc/php7/php.ini

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2/", "/etc/php7"]
RUN mkdir -p /etc-start/apache2 && \
    cp -R /etc/apache2/* /etc-start/apache2 && \
    mkdir -p /etc-start/php7 &&  cp -R /etc/php7/* /etc-start/php7

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER apache
ENV APACHE_RUN_GROUP apache
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www

EXPOSE 80 443
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["/start.sh"]
