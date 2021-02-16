FROM babim/alpinebase:3.7

## alpine linux
RUN apk add --no-cache wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh
    
RUN apk add --no-cache apache2 php5-apache2 imagemagick \
	nano php5-fpm php5-json php5-gd php5-sqlite3 curl php5-curl php5-ldap php5-mysql php5-mysqli php5-pgsql php5-imap php5-bcmath \
	php5-xmlrpc php5-mcrypt php5-intl php5-zip php5-opcache php5-mssql php5-bz2 php5-odbc php5-gettext php5-dba php5-soap \
	php5-xml php5-zlib php5-exif php5-pdo php5-pdo_odbc php5-pdo_dblib php5-pdo_sqlite php5-pdo_pgsql php5-pdo_mysql php5-pear

# Download option
RUN apk add --no-cache wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh && apk del wget

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2", "/etc/php5"]
RUN mkdir -p /etc-start/apache2 && cp -R /etc/apache2/* /etc-start/apache2 && \
    mkdir -p /etc-start/php5 && cp -R /etc/php5/* /etc-start/php5 && \
    mkdir -p /etc-start/www  && cp -R /var/www/* /etc-start/www

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER apache
ENV APACHE_RUN_GROUP apache
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www

# fix apache pid no suck file
RUN mkdir -p /run/apache2

EXPOSE 80 443
ADD start.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["httpd", "-D", "FOREGROUND"]
