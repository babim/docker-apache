FROM babim/ubuntubase

RUN apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:ondrej/php -y && \
    add-apt-repository ppa:ondrej/apache2 -y && \
    apt-get update && \
    apt-get install -y --force-yes \
    apache2 php7.0 libapache2-mod-php7.0 && \
    apt-get install -y --force-yes \
    php7.0-cgi php7.0-cli php7.0-phpdbg libphp7.0-embed php7.0-dev php-xdebug sqlite3 \
    php7.0-curl php7.0-gd php7.0-imap php7.0-interbase php7.0-intl php7.0-ldap php7.0-mcrypt php7.0-readline php7.0-odbc \
    php7.0-pgsql php7.0-pspell php7.0-recode php7.0-tidy php7.0-xmlrpc php7.0 php7.0-json php-all-dev php7.0-sybase \
    php7.0-sqlite3 php7.0-mysql php7.0-opcache php7.0-bz2 php7.0-mbstring php-apcu php-apcu-bc php-imagick \
	php-memcached php-pear libsasl2-dev libssl-dev libsslcommon2-dev libcurl4-openssl-dev npm nodejs-legacy && \
    a2enmod rewrite && \
    a2enmod headers && \
    npm install -g grunt-cli bower \
	&& pecl install mongodb \
	&& echo "extension=mongodb.so" >> /etc/php/7.0/apache2/php.ini \
	&& echo "extension=mongodb.so" >> /etc/php/7.0/cli/php.ini
	
RUN apt-get install -y php7.0-bcmath && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove

RUN sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php/7.0/apache2/php.ini && \
    sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php/7.0/cli/php.ini && \
    sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Ho_Chi_Minh/g' /etc/php/7.0/cli/php.ini && \
    sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Ho_Chi_Minh/g' /etc/php/7.0/apache2/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 520M/" /etc/php/7.0/apache2/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 520M/" /etc/php/7.0/cli/php.ini && \
    sed -i "s/post_max_size = 8M/post_max_size = 520M/" /etc/php/7.0/apache2/php.ini && \
    sed -i "s/post_max_size = 8M/post_max_size = 520M/" /etc/php/7.0/cli/php.ini && \
    sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/7.0/apache2/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 3600/" /etc/php/7.0/apache2/php.ini && \
    sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/7.0/cli/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 3600/" /etc/php/7.0/cli/php.ini

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2/sites-available/", "/etc/php/7.0"]
RUN mkdir -p /etc-start/apache2/sites-available \
    && cp -R /etc/apache2/sites-available/* /etc-start/apache2/sites-available \
    && mkdir -p /etc-start/php/7.0 &&  cp -R /etc/php/7.0/* /etc-start/php/7.0

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
