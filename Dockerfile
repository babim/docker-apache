FROM babim/ubuntubase

RUN apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:ondrej/php -y && \
    add-apt-repository ppa:ondrej/apache2 -y && \
    apt-get update && \
    apt-get install -y --force-yes inetutils-ping telnet \
    apache2 php7.1 libapache2-mod-php7.1 && \
    apt-get install -y --force-yes imagemagick \
    php7.1-cgi php7.1-cli php7.1-phpdbg libphp7.1-embed php7.1-dev php-xdebug sqlite3 \
    php7.1-curl php7.1-gd php7.1-imap php7.1-interbase php7.1-intl php7.1-ldap php7.1-mcrypt php7.1-readline php7.1-odbc \
    php7.1-pgsql php7.1-pspell php7.1-recode php7.1-tidy php7.1-xmlrpc php7.1 php7.1-json php-all-dev php7.1-sybase \
    php7.1-sqlite3 php7.1-mysql php7.1-opcache php7.1-bz2 php7.1-mbstring php7.1-zip php-apcu php-imagick \
    php-memcached php-pear libsasl2-dev libssl-dev libsslcommon2-dev libcurl4-openssl-dev \
    php7.1-gmp php7.1-xml php7.1-bcmath php7.1-enchant php7.1-soap php7.1-xsl && \
    a2enmod rewrite headers http2 ssl && \
	#&& pecl install mongodb \
	#&& echo "extension=mongodb.so" >> /etc/php/7.1/apache2/php.ini \
	#&& echo "extension=mongodb.so" >> /etc/php/7.1/cli/php.ini && \
    ln -sf /usr/bin/php7.1 /etc/alternatives/php

# install option for webapp (owncloud)
RUN apt-get install -y --force-yes smbclient ffmpeg ghostscript openexr openexr openexr libxml2 gamin

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2", "/etc/php"]
RUN mkdir -p /etc-start/apache2 && cp -R /etc/apache2/* /etc-start/apache2 && \
    mkdir -p /etc-start/php && cp -R /etc/php/* /etc-start/php && \
    mkdir -p /etc-start/www && cp -R /var/www/* /etc-start/www

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
