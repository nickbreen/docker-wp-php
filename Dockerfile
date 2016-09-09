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
      php-mbstring \
      php-mysql \
      php-oauth \
    && apt-get clean -y

RUN phpenmod curl gd imagick json mbstring mysqli oauth opcache

ENV NR_INSTALL_KEY="" NR_APP_NAME="PHP Application"

RUN sed -i -e '/^newrelic.appname/s/"PHP Application"/"${NR_APP_NAME}"/' \
  -e '/^newrelic.license/s/""/"${NR_INSTALL_KEY}"/' \
  -e '/^;\?newrelic.browser_monitoring.auto_instrument/{s/true/false/;s/^\;//}' \
  -e '/^;\?newrelic.transaction_tracer.detail/{s/1/0/;s/^\;//}' \
  /etc/php/7.0/mods-available/newrelic.ini && \
  egrep '^[^;]' /etc/php/7.0/mods-available/newrelic.ini | nl

COPY logging.ini /etc/php/7.0/mods-available/logging.ini
RUN phpenmod newrelic logging

RUN php -r 'phpinfo(INFO_GENERAL|INFO_CONFIGURATION|INFO_MODULES|INFO_ENVIRONMENT);'
