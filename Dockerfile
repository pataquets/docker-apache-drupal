FROM pataquets/apache-php:5.5

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
      php5-curl \
      php5-gd \
      php5-mysql \
      php5-pgsql \
      php5-sqlite \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
  && \
  echo ";Recommended PHP settings for Drupal" > \
    /etc/php5/mods-available/drupal-recommended.ini && \
  echo ";See https://www.drupal.org/requirements/php" >> \
    /etc/php5/mods-available/drupal-recommended.ini && \
  echo "allow_url_fopen=off" >> \
    /etc/php5/mods-available/drupal-recommended.ini && \
  echo "expose_php=off" >> \
    /etc/php5/mods-available/drupal-recommended.ini \
  && \
  a2enmod rewrite && \
  php5enmod drupal-reccomended

#############################################################################
###	Install drush from PEAR repositories
#############################################################################
# Add "Ubuntu git maintainers" PPA.
RUN \
  echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu precise main" \
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
  pear install drush/drush
#############################################################################
