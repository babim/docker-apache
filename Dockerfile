FROM babim/apache:php7.2

# install laravel
RUN apt-get update && apt-get install -f composer php-*dom php-*mbstring zip unzip git
RUN cd /var/www/html && git clone https://github.com/laravel/laravel && \
    cd lavarel && composer install

# clean depend
RUN apt-get purge git -y

# clean
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*
