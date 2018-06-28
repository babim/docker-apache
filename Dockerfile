FROM babim/apache:php7.2

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
