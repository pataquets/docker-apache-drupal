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
###	Install drush from PEAR repositories
#############################################################################
# Add "Ubuntu git maintainers" PPA.
RUN \
  echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu $(lsb_release -cs) main" \
    | tee /etc/apt/sources.list.d/git.list && \
  DEBIAN_FRONTEND=noniteractive \
    apt-key adv --keyserver hkp://hkps.pool.sks-keyservers.net --recv-keys E1DF1F24 && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y --no-install-recommends install git && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y --no-install-recommends install \
      php-pear \
      wget \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/

RUN \
  pear channel-discover pear.drush.org && \
  pear install drush/drush && \
  ln -s /usr/share/php/drush/drush.complete.sh /etc/bash_completion.d/
#############################################################################
