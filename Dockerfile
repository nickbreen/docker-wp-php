FROM nickbreen/cron:v2.0.1

MAINTAINER Nick Breen <nick@foobar.net.nz>

RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list \
    && curl -sSfL https://download.newrelic.com/548C16BF.gpg | apt-key add - \
    && apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      newrelic-php5 \
      php-http \
      php-cli \
      php-curl \
      php-imagick \
      php-gd \
      php-json \
      php-mysql \
      php-oauth \
    && apt-get clean -y

ENV NR_INSTALL_KEY="" NR_APP_NAME=""

# Configure and test the PHP configurations
RUN phpenmod curl gd imagick json mysqli oauth opcache

COPY newrelic.ini /etc/php/7.0/mods-available/30-newrelic.ini
RUN phpenmod 30-newrelic
