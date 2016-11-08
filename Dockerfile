FROM babim/alpinebase

RUN apk add --no-cache apache2

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2"]
RUN mkdir -p /etc-start/apache2 && cp -R /etc/apache2/* /etc-start/apache2 && \
    mkdir -p /etc-start/www  && cp -R /var/www/* /etc-start/www

# fix apache pid no suck file
RUN mkdir -p /run/apache2

EXPOSE 80 443
ADD start.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh
CMD ["/entrypoint.sh"]
