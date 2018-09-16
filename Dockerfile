FROM babim/apache:base

RUN wget --no-check-certificate -O - https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20PHP%20install/apache_install.sh

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2", "/etc/php"]

EXPOSE 80 443
ENTRYPOINT ["/start.sh"]
CMD ["supervisord", "-nc", "/etc/supervisor/supervisord.conf"]
