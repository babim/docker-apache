FROM babim/ubuntubase

RUN apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:ondrej/php -y && \
    add-apt-repository ppa:ondrej/apache2 -y && \
    apt-get update && \
    apt-get install -y --force-yes inetutils-ping telnet \
    apache2 php7.2 libapache2-mod-php7.2 && \
    wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb && dpkg -i mod-pagespeed-stable_current_amd64.deb && rm -f mod-pagespeed-stable_current_amd64.deb && \
    apt-get install -y --force-yes imagemagick \
    php7.2-cgi php7.2-cli php7.2-phpdbg libphp7.2-embed php7.2-dev php-xdebug sqlite3 \
    php7.2-curl php7.2-gd php7.2-imap php7.2-interbase php7.2-intl php7.2-ldap php7.2-mcrypt php7.2-readline php7.2-odbc \
    php7.2-pgsql php7.2-pspell php7.2-recode php7.2-tidy php7.2-xmlrpc php7.2 php7.2-json php-all-dev php7.2-sybase \
    php7.2-sqlite3 php7.2-mysql php7.2-opcache php7.2-bz2 php7.2-mbstring php7.2-zip php-apcu php-imagick \
    php-memcached php-pear libsasl2-dev libssl-dev libsslcommon2-dev libcurl4-openssl-dev \
    php7.2-gmp php7.2-xml php7.2-bcmath php7.2-enchant php7.2-soap php7.2-xsl && \
    a2enmod rewrite headers http2 ssl
	#&& pecl install mongodb \
	#&& echo "extension=mongodb.so" >> /etc/php/7.2/apache2/php.ini \
	#&& echo "extension=mongodb.so" >> /etc/php/7.2/cli/php.ini

# install option for webapp (owncloud)
RUN apt-get install -y --force-yes smbclient ffmpeg ghostscript openexr openexr openexr libxml2 gamin

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2", "/etc/php"]
RUN mkdir -p /etc-start/apache2 && cp -R /etc/apache2/* /etc-start/apache2 && \
    mkdir -p /etc-start/php &&  cp -R /etc/php/* /etc-start/php

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
