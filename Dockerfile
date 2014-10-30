FROM pataquets/apache-php

RUN DEBIAN_FRONTEND=noninteractive \
        apt-get update && \
        apt-get -y install \
                php5-curl \
                php5-gd \
                php5-mysql \
                php5-pgsql \
                php5-sqlite \
        && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/

RUN a2enmod rewrite
