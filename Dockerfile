FROM babim/apache:base

RUN curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20PHP%20install/apache.sh

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2", "/etc/php"]

EXPOSE 80 443
ENTRYPOINT ["/start.sh"]
CMD ["apache2", "-D", "FOREGROUND"]
