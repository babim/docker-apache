FROM babim/apache:base

ENV PHP_VERSION 7.0
RUN curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20PHP%20install/apache.sh | bash

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2", "/etc/php"]

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
ENTRYPOINT ["/start.sh"]
CMD ["apache2", "-D", "FOREGROUND"]

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2", "/etc/php"]