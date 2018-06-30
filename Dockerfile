FROM babim/apache:base

RUN apt-get update && \
    apt-get install -y --force-yes php7.2 libapache2-mod-php7.2 && \
    apt-get install -y --force-yes imagemagick \
    php7.2-cgi php7.2-cli php7.2-phpdbg libphp7.2-embed php7.2-dev php-xdebug sqlite3 \
    php7.2-curl php7.2-gd php7.2-imap php7.2-interbase php7.2-intl php7.2-ldap php7.2-readline php7.2-odbc \
    php7.2-pgsql php7.2-pspell php7.2-recode php7.2-tidy php7.2-xmlrpc php7.2 php7.2-json php-all-dev php7.2-sybase \
    php7.2-sqlite3 php7.2-mysql php7.2-opcache php7.2-bz2 php7.2-mbstring php7.2-zip php-apcu php-imagick \
    php-memcached php-pear libsasl2-dev libssl-dev libsslcommon2-dev libcurl4-openssl-dev \
    php7.2-gmp php7.2-xml php7.2-bcmath php7.2-enchant php7.2-soap php7.2-xsl && \
    a2enmod rewrite headers http2 ssl && \
	#&& pecl install mongodb \
	#&& echo "extension=mongodb.so" >> /etc/php/7.2/apache2/php.ini \
	#&& echo "extension=mongodb.so" >> /etc/php/7.2/cli/php.ini && \
    ln -sf /usr/bin/php7.2 /etc/alternatives/php

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