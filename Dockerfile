FROM alpine

MAINTAINER Robert de Bock <robert@meinit.nl>

LABEL Description="Drupal" Vendor="Me in IT Consultancy" Version="8.2.2"

EXPOSE 80 443

ENV DBURL mysql://drupal:drupal@mysql/drupal
ENV DOMAIN localhost
ENV SITENAME drupal
ENV ADMINPASS newpass
ENV DBHOST mysql
ENV DBPORT 3306
ENV TIMEOUT 60
ENV MAILSERVER postfix
ENV MAILFROM robert@meinit.nl

RUN apk add --no-cache \
    apache2 \
    apache2-utils \
    bash \
    curl \
    fcgi \
    git \
    mysql-client \
    php5 \
    php5-apache2 \
    php5-apcu \
    php5-cgi \
    php5-common \
    php5-ctype \
    php5-curl \
    php5-dom \
    php5-gd \
    php5-gettext \
    php5-iconv \
    php5-json \
    php5-mcrypt \
    php5-mysql \
    php5-opcache \
    php5-openssl \
    php5-pdo \
    php5-pdo_mysql \
    php5-phar \
    php5-posix \
    php5-soap \
    php5-xml \
    php5-xmlrpc

RUN apk add --no-cache waitforit \
    --repository http://nl.alpinelinux.org/alpine/edge/testing

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

RUN git clone https://github.com/drush-ops/drush.git /usr/local/src/drush

RUN cd /usr/local/src/drush && \
    composer install && \
    ln -s /usr/local/src/drush/drush /usr/local/bin/drush

RUN cd /var/www/localhost/htdocs && \
    drush dl drupal --drupal-project-rename=drupal 

RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

RUN mkdir /run/apache2

RUN sed -i 's%#LoadModule rewrite_module modules/mod_rewrite.so%LoadModule rewrite_module modules/mod_rewrite.so%' /etc/apache2/httpd.conf

RUN echo "apc.rfc1867 = 1" >> /etc/php5/conf.d/apcu.ini

ADD drupal.conf /etc/apache2/conf.d/drupal.conf

CMD echo '$settings["'"trusted_host_patterns"'"] = array(' >> /var/www/localhost/htdocs/drupal/sites/default/default.settings.php && \
    echo "'"^${DOMAIN}\$"'", >> /var/www/localhost/htdocs/drupal/sites/default/default.settings.php && \
    echo ');' >> /var/www/localhost/htdocs/drupal/sites/default/default.settings.php && \
    echo "SMTP = ${MAILSERVER}" >> /etc/php5/conf.d/mail.ini && \
    echo "smtp_port = 25" >> /etc/php5/conf.d/mail.ini && \
    echo "sendmail_from = ${MAILFROM}" >> /etc/php5/conf.d/mail.ini && \
    echo "Waiting up to ${TIMEOUT} seconds for ${DBHOST}:${DBPORT} to become available..." ;\
    waitforit --timeout ${TIMEOUT} -host ${DBHOST} -port ${DBPORT} && \
    cd /var/www/localhost/htdocs/drupal && \
    drush --yes si standard --db-url=${DBURL} --site-name=${SITENAME} && \
    drush upwd --password="${ADMINPASS}" "admin" && \
    chown -R apache:apache /var/www/localhost/htdocs/drupal && \
    httpd -D FOREGROUND
