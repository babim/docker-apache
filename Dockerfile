FROM babim/apache:base

RUN apt-get update && \
    apt-get install -y --force-yes php7.0 libapache2-mod-php7.0 && \
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