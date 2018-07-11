FROM babim/apache:base

RUN apt-get update && apt-get install -y apache2 && \
    a2enmod proxy proxy_fcgi rewrite headers http2 ssl

# copy config.
RUN mkdir -p /etc-start/apache2 && cp -R /etc/apache2/* /etc-start/apache2 && \
    mkdir -p /etc-start/www && cp -R /var/www/* /etc-start/www

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2", "/etc/php"]