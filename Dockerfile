FROM babim/alpinebase:edge

RUN apk add --no-cache \
    apache2 php7-apache2 && \
    apk add --no-cache imagemagick \
    php7-cgi php7-phpdbg php7-dev sqlite \
    php7-curl php7-gd php7-imap php7-intl php7-ldap php7-mcrypt php7-odbc php7-exif php7-xml \
    php7-pgsql php7-pspell php7-ftp php7-tidy php7-xmlrpc php7 php7-json php7-ctype php7-zlib php7-bcmath \
    php7-sqlite3 php7-mysqli php7-opcache php7-bz2 php7-mbstring php7-zip  php7-soap php7-gettext \
    php7-pear php7-pdo_dblib php7-pdo_pgsql php7-pdo_odbc php7-pdo_sqlite php7-pdo_mysql php7-pdo
# disable: php7-memcached php7-apcu

# Download option
RUN apk add --no-cache wget && wget https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    mv option.sh /option.sh && chmod 755 /option.sh && apk del wget

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2/", "/etc/php7"]
RUN mkdir -p /etc-start/apache2 && cp -R /etc/apache2/* /etc-start/apache2 && \
    mkdir -p /etc-start/php7 && cp -R /etc/php7/* /etc-start/php7 && \
    mkdir -p /etc-start/www  && cp -R /var/www/* /etc-start/www

# fix apache pid no suck file
RUN mkdir -p /run/apache2

EXPOSE 80 443
ADD start.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh
CMD ["/entrypoint.sh"]
