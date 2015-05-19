FROM pataquets/apache-php:5.5

ADD files/etc/php5/ /etc/php5/
ADD files/etc/apache2/ /etc/apache2/

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
      php5-curl \
      php5-gd \
      php5-mysql \
      php5-pgsql \
      php5-sqlite \
      mysql-client \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
  && \
  a2enmod rewrite && \
  a2enconf drupal && \
  php5enmod drupal-recommended

#############################################################################
###    Install Drush 6.6 via Composer
#############################################################################
# - Install 'wget' package to download composer
# - Temporarily disable 'drupal-recommended.ini' to enable 'allow_url_fopen'
# - @todo: Check if Drush doesn't needs 'wget' if 'allow_url_fopen' is On
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install wget \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
  && \
  php5dismod drupal-recommended && \
  wget -O - https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer && \
  composer --update-no-dev global require drush/drush:6.* && \
  ln -vs ~/.composer/vendor/drush/drush/drush /usr/bin/drush && \
  ln -vs ~/.composer/vendor/drush/drush/drush.complete.sh \
    /etc/bash_completion.d/ && \
  php5enmod drupal-recommended
#############################################################################
