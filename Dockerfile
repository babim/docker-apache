FROM babim/alpinebase

RUN apk add --no-cache apache2

# Download option
RUN apk add --no-cache wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh && apk del wget

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2"]
RUN mkdir -p /etc-start/apache2 && cp -R /etc/apache2/* /etc-start/apache2 && \
    mkdir -p /etc-start/www  && cp -R /var/www/* /etc-start/www

# fix apache pid no suck file
RUN mkdir -p /run/apache2

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

ADD start.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

EXPOSE 80 443
CMD ["/entrypoint.sh"]
