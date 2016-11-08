FROM babim/alpinebase

RUN apk add --no-cache apache2

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2"]
RUN mkdir -p /etc-start/apache2 && cp -R /etc/apache2/* /etc-start/apache2 && \
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
CMD ["/entrypoint.sh"]
