FROM babim/apache:base

RUN wget --no-check-certificate -O - https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20PHP%20install/apache_install.sh | bash

# Define mountable directories.
VOLUME ["/var/log/apache2", "/var/www", "/etc/apache2"]

EXPOSE 80 443
