FROM nickbreen/cron:v2.0.2

MAINTAINER Nick Breen <nick@foobar.net.nz>

ENV NR_INSTALL_KEY="YOUR_LICENSE_KEY" NR_APP_NAME="My App Name"

RUN echo newrelic-php5 newrelic-php5/application-name string '${NR_APP_NAME}' | debconf-set-selections \
 && echo newrelic-php5 newrelic-php5/license-key string '${NR_INSTALL_KEY}' | debconf-set-selections

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
      php-mbstring \
      php-mysql \
      php-oauth \
    && apt-get clean -y

COPY logging.ini /etc/php/7.0/mods-available/logging.ini

RUN sed -e '/^;\?newrelic.browser_monitoring.auto_instrument/{s/true/false/;s/^\;//}' \
        -e '/^;\?newrelic.transaction_tracer.detail/{s/1/0/;s/^\;//}' \
        -i /etc/php/7.0/mods-available/newrelic.ini \
 && egrep -vn '^;|^\s*$' /etc/php/7.0/mods-available/newrelic.ini \
 && phpenmod newrelic logging curl gd imagick json mbstring mysqli oauth opcache && php -i
