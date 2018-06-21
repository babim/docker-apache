FROM babim/apache:php7.2

# Download option
RUN apt-get update && \
    apt-get install -y wget && cd / && wget https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh && apt-get purge -y wget

# install laravel
RUN apt-get update && apt-get install -y php-*dom php-*mbstring zip unzip git curl && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    ln -sf /usr/bin/php7.2 /etc/alternatives/php
RUN cd /etc-start && git clone https://github.com/laravel/laravel && \
    cd laravel && composer install && cp .env.example .env

# clean depend
RUN apt-get purge git -y

# clean
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ADD start.sh /start.sh
RUN chmod 0755 /start.sh