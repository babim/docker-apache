FROM babim/ubuntubase

RUN apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:ondrej/php5-5.6 -y && \
    apt-get update && \
    apt-get install apache2 php5 php5-json php5-gd php5-sqlite curl php5-curl php-xml-parser php5-ldap php5-mysql php5-pgsql php5-imap php5-tidy php5-xmlrpc php5-mcrypt php5-memcache php-apc php5-intl ImageMagick -y --force-yes && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    a2enmod rewrite && \
    a2enmod headers

RUN sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php5/apache2/php.ini && \
    sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php5/cli/php.ini && \
    sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Ho_Chi_Minh/g' /etc/php5/cli/php.ini && \
    sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Ho_Chi_Minh/g' /etc/php5/apache2/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 520M/" /etc/php5/apache2/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 520M/" /etc/php5/cli/php.ini && \
    sed -i "s/post_max_size = 8M/post_max_size = 520M/" /etc/php5/apache2/php.ini && \
    sed -i "s/post_max_size = 8M/post_max_size = 520M/" /etc/php5/cli/php.ini && \
    sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php5/apache2/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 3600/" /etc/php5/apache2/php.ini && \
    sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php5/cli/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 3600/" /etc/php5/cli/php.ini

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2/sites-available/", "/etc/php5"]
RUN mkdir -p /etc-start/apache2/sites-available \
    && cp -R /etc/apache2/sites-available/* /etc-start/apache2/sites-available \
    && mkdir -p /etc-start/php5 && cp -R /etc/php5/* /etc-start/php5

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
