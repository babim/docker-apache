FROM babim/apache:php7.2

# install laravel
RUN apt-get update && apt-get install -y composer php-*dom php-*mbstring zip unzip git
RUN cd /var/www/html && git clone https://github.com/laravel/laravel && \
    cd laravel && composer install

# Define mountable directories.
RUN mkdir -p /etc-start/laravel && cp -R /var/www/laravel/* /etc-start/laravel

# clean depend
RUN apt-get purge git -y

# clean
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ADD start.sh /start.sh
RUN chmod 0755 /start.sh