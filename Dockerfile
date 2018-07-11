FROM babim/apache:base

RUN apt-get update && \
    apt-get install -y --force-yes inetutils-ping apache2 php5.6 libapache2-mod-php5.6 \
    	php5.6-json php5.6-gd php5.6-sqlite curl php5.6-curl php5.6-ldap php5.6-mysql php5.6-pgsql \
        php5.6-imap php5.6-tidy php5.6-xmlrpc php5.6-zip php5.6-mcrypt php5.6-memcache php5.6-intl \
    	php5.6-mbstring imagemagick php5.6-sqlite3 php5.6-sybase php5.6-bcmath php5.6-soap php5.6-xml \
    	php5.6-phpdbg php5.6-opcache php5.6-bz2 php5.6-odbc php5.6-interbase php5.6-gmp php5.6-xsl && \
    a2enmod rewrite headers http2 ssl && \
    ln -sf /usr/bin/php5.6 /etc/alternatives/php

# install option for webapp (owncloud)
RUN apt-get install -y --force-yes imagemagick smbclient ffmpeg ghostscript openexr openexr openexr libxml2 gamin

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
    echo "extension=oci8.so" > /etc/php/5.6/apache2/conf.d/30-oci8.ini && \
    echo "extension=oci8.so" > /etc/php/5.6/cli/conf.d/30-oci8.ini && \
    rm -f instantclient-basic-linux.x64-$ORACLE_VERSION.zip instantclient-sdk-linux.x64-$ORACLE_VERSION.zip instantclient-sqlplus-linux.x64-$ORACLE_VERSION.zip
  
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# copy config
RUN mkdir -p /etc-start/apache2 && cp -R /etc/apache2/* /etc-start/apache2 && \
    mkdir -p /etc-start/php && cp -R /etc/php/* /etc-start/php && \
    mkdir -p /etc-start/www && cp -R /var/www/* /etc-start/www

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
CMD ["/start.sh"]