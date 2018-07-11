FROM babim/ubuntubase:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Download option
RUN apt-get update && \
    apt-get install -y wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh && apt-get purge -y wget

RUN apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:ondrej/php -y && \
    add-apt-repository ppa:ondrej/apache2 -y

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*


ADD start.sh /start.sh
RUN chmod 0755 /start.sh

