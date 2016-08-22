FROM babim/ubuntubase

RUN apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install apache2 php5.6 php5.6-json php5.6-gd php5.6-sqlite curl php5.6-curl php-xml-parser php5.6-ldap \
    php5.6-mysql php5.6-pgsql php5.6-imap php5.6-tidy php5.6-xmlrpc php5.6-mcrypt php5.6-memcache php5.6-intl \
    php-apcu php-apcu-bc php-imagick php5.6-mbstring -y --force-yes && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    a2enmod rewrite && \
    a2enmod headers

RUN sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php/5.6/apache2/php.ini && \
    sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php/5.6/cli/php.ini && \
    sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Ho_Chi_Minh/g' /etc/php/5.6/cli/php.ini && \
    sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Ho_Chi_Minh/g' /etc/php/5.6/apache2/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 520M/" /etc/php/5.6/apache2/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 520M/" /etc/php/5.6/cli/php.ini && \
    sed -i "s/post_max_size = 8M/post_max_size = 520M/" /etc/php/5.6/apache2/php.ini && \
    sed -i "s/post_max_size = 8M/post_max_size = 520M/" /etc/php/5.6/cli/php.ini && \
    sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/5.6/apache2/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 3600/" /etc/php/5.6/apache2/php.ini && \
    sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/5.6/cli/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 3600/" /etc/php/5.6/cli/php.ini

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2/sites-available/", "/etc/apache2/sites-enabled/", "/etc/php/5.6"]
RUN mkdir -p /etc-start/apache2/sites-available && mkdir -p /etc-start/apache2/sites-enabled && \
    cp -R /etc/apache2/sites-available/* /etc-start/apache2/sites-available && \
    cp -R /etc/apache2/sites-enabled/* /etc-start/apache2/sites-enabled && \
    mkdir -p /etc-start/php/5.6 &&  cp -R /etc/php/5.6/* /etc-start/php/5.6

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
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
