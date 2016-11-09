FROM babim/ubuntubase

RUN apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:ondrej/php -y && \
    add-apt-repository ppa:ondrej/apache2 -y && \
    apt-get update && \
    apt-get install -y --force-yes \
    apache2 php7.0 libapache2-mod-php7.0 && \
    apt-get install -y --force-yes imagemagick \
    php7.0-cgi php7.0-cli php7.0-phpdbg libphp7.0-embed php7.0-dev php-xdebug sqlite3 \
    php7.0-curl php7.0-gd php7.0-imap php7.0-interbase php7.0-intl php7.0-ldap php7.0-mcrypt php7.0-readline php7.0-odbc \
    php7.0-pgsql php7.0-pspell php7.0-recode php7.0-tidy php7.0-xmlrpc php7.0 php7.0-json php-all-dev php7.0-sybase \
    php7.0-sqlite3 php7.0-mysql php7.0-opcache php7.0-bz2 php7.0-mbstring php7.0-zip php-apcu php-imagick \
    php-memcached php-pear libsasl2-dev libssl-dev libsslcommon2-dev libcurl4-openssl-dev npm nodejs-legacy && \
    php7.0-gmp php7.0-snmp php7.0-xml php7.0-bcmath php7.0-enchant php7.0-soap php7.0-xsl && \
    a2enmod rewrite && \
    a2enmod headers && \
    npm install -g grunt-cli bower
	#&& pecl install mongodb \
	#&& echo "extension=mongodb.so" >> /etc/php/7.0/apache2/php.ini \
	#&& echo "extension=mongodb.so" >> /etc/php/7.0/cli/php.ini
	
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/**

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/php/7.0"]
RUN mkdir -p /etc-start/apache2 && cp -R /etc/apache2/* /etc-start/apache2 && \
    mkdir -p /etc-start/php/7.0 &&  cp -R /etc/php/7.0/* /etc-start/php/7.0

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
