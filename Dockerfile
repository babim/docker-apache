FROM babim/apache:base

RUN apt-get update && \
    apt-get install -y --force-yes apache2 php7.0 libapache2-mod-php7.0 && \
    apt-get install -y --force-yes imagemagick \
    php7.0-cgi php7.0-cli php7.0-phpdbg libphp7.0-embed php7.0-dev php-xdebug sqlite3 \
    php7.0-curl php7.0-gd php7.0-imap php7.0-interbase php7.0-intl php7.0-ldap php7.0-mcrypt php7.0-readline php7.0-odbc \
    php7.0-pgsql php7.0-pspell php7.0-recode php7.0-tidy php7.0-xmlrpc php7.0 php7.0-json php-all-dev php7.0-sybase \
    php7.0-sqlite3 php7.0-mysql php7.0-opcache php7.0-bz2 php7.0-mbstring php7.0-zip php-apcu php-imagick \
    php-memcached php-pear libsasl2-dev libssl-dev libsslcommon2-dev libcurl4-openssl-dev \
    php7.0-gmp php7.0-xml php7.0-bcmath php7.0-enchant php7.0-soap php7.0-xsl && \
    a2enmod rewrite headers ssl && \
	#&& pecl install mongodb \
	#&& echo "extension=mongodb.so" >> /etc/php/7.0/apache2/php.ini \
	#&& echo "extension=mongodb.so" >> /etc/php/7.0/cli/php.ini && \
    ln -sf /usr/bin/php7.0 /etc/alternatives/php

# install option for webapp (owncloud)
RUN apt-get install -y --force-yes smbclient ffmpeg ghostscript openexr openexr openexr libxml2 gamin

# install oracle client extension
ENV ORACLE_VERSION 12.2.0.1.0
RUN apt-get install -y --force-yes wget unzip libaio-dev php5.6-dev php-pear
RUN wget http://media.matmagoc.com/oracle/instantclient-basic-linux.x64-$ORACLE_VERSION.zip && \
    wget http://media.matmagoc.com/oracle/instantclient-sdk-linux.x64-$ORACLE_VERSION.zip && \
    wget http://media.matmagoc.com/oracle/instantclient-sqlplus-linux.x64-$ORACLE_VERSION.zip && \
    unzip instantclient-basic-linux.x64-$ORACLE_VERSION.zip -d /usr/local/ && \
    unzip instantclient-sdk-linux.x64-$ORACLE_VERSION.zip -d /usr/local/ && \
    unzip instantclient-sqlplus-linux.x64-$ORACLE_VERSION.zip -d /usr/local/ && \
    ln -s /usr/local/instantclient_12_2 /usr/local/instantclient && \
    ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so && \
    ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus && \
    echo 'instantclient,/usr/local/instantclient' | pecl install oci8-2.0.12 && \
    echo "extension=oci8.so" > /etc/php/7.0/apache2/conf.d/30-oci8.ini && \
    echo "extension=oci8.so" > /etc/php/7.0/cli/conf.d/30-oci8.ini && \
    rm -f instantclient-basic-linux.x64-$ORACLE_VERSION.zip instantclient-sdk-linux.x64-$ORACLE_VERSION.zip instantclient-sqlplus-linux.x64-$ORACLE_VERSION.zip

RUN apt-get purge wget -y && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# prepare etc start
RUN [ -d /etc/nginx ] || mkdir -p /etc-start/nginx && \
    [ -d /etc/nginx ] || cp -R /etc/nginx/* /etc-start/nginx && \
    [ -d /etc/php ] || mkdir -p /etc-start/php && \
    [ -d /etc/php ] || cp -R /etc/php/* /etc-start/php && \
    [ -d /etc/apache2 ] || mkdir -p /etc-start/apache2 && \
    [ -d /etc/apache2 ] || cp -R /etc/apache2/* /etc-start/apache2 && \
    [ -d /var/www ] || mkdir -p /etc-start/www && \
    [ -d /var/www ] || cp -R /var/www/* /etc-start/www

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2", "/etc/php"]

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
ENTRYPOINT ["/start.sh"]
CMD ["apache2", "-D", "FOREGROUND"]

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2", "/etc/php"]