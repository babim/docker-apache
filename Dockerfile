FROM babim/ubuntubase

RUN apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:ondrej/php -y && \
    add-apt-repository ppa:ondrej/apache2 -y && \
    apt-get update && \
    apt-get install -y --force-yes apache2 php5.6 inetutils-ping telnet \
    php5.6-json php5.6-gd php5.6-sqlite curl php5.6-curl php-xml-parser php5.6-ldap \
    php5.6-mysql php5.6-pgsql php5.6-imap php5.6-tidy php5.6-xmlrpc php5.6-zip php5.6-mcrypt php5.6-memcache php5.6-intl \
    php-imagick php5.6-mbstring imagemagick php5.6-sqlite3 php5.6-sybase php5.6-bcmath \
    php-mongodb php-redis php-smbclient php-uploadprogress php5.6-phpdbg \
    php5.6-opcache php-xdebug php5.6-bz2 php5.6-odbc php5.6-interbase php5.6-gmp php5.6-xsl \
    php5.6-soap php5.6-xml && \
    a2enmod rewrite headers http2 ssl

RUN wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb && dpkg -i mod-pagespeed-stable_current_amd64.deb && rm -f mod-pagespeed-stable_current_amd64.deb && \
    apt-get clean && \
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
