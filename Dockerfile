FROM pataquets/apache-php:bionic

ADD files/etc/php/7.2/ /etc/php/7.2/
ADD files/etc/apache2/ /etc/apache2/

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
      php-curl \
      php-gd \
      php-mbstring \
      php-mysql \
      php-pgsql \
      php-sqlite3 \
      mariadb-client \
      sudo \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
  && \
  a2enmod rewrite && \
  a2enconf drupal && \
  phpenmod drupal-recommended

#############################################################################
###    Install Drush via Git & Composer
#############################################################################
# - Install 'curl' package to download composer
# - Temporarily install 'php-pear' to download Console_Table PEAR package to
#   fix https://github.com/drush-ops/drush/issues/3226
# - Temporarily disable 'drupal-recommended.ini' to enable 'allow_url_fopen'
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y --no-install-recommends install git \
  && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
      curl \
      php-dom \
      php-pear \
  && \
  pear install Console_Table-1.3.1 && \
  rm -vrf /tmp/pear && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y purge php-pear \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
  && \
  phpdismod drupal-recommended && \
  curl --fail --location --silent --show-error https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer && \
  git clone --single-branch --branch 6.7.0 https://github.com/drush-ops/drush.git \
    /usr/local/src/drush && \
  cd /usr/local/src/drush && \
  composer install --verbose --no-dev && \
  composer clear-cache --verbose && \
  phpenmod drupal-recommended && \
  rm -vrf /root/.composer && \
  rm -vrf /root/.drush && \
  ln -vs /usr/local/src/drush/drush /usr/bin/drush && \
  ln -vs /usr/local/src/drush/drush.complete.sh /etc/bash_completion.d/ && \
  drush --verbose status
#############################################################################
