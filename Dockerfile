FROM phusion/baseimage:0.9.18

MAINTAINER Nick Breen <nick@foobar.net.nz>

RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list \
    && curl -sSfL https://download.newrelic.com/548C16BF.gpg | apt-key add - \
    && apt-get update -qqy \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
      newrelic-php5 \
      php-http \
      php5-curl \
      php5-imagick \
      php5-gd \
      php5-json \
      php5-mysql \
      php5-oauth \
    && apt-get clean -qqy

ENV NR_INSTALL_KEY="" NR_APP_NAME=""

# Configure and test the PHP configurations
RUN php5enmod curl gd imagick json mysql oauth opcache

COPY tweaks.ini /etc/php5/mods-available/
RUN php5enmod tweaks
