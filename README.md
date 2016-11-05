[![Build Status](https://travis-ci.org/robertdebock/docker-drupal.svg?branch=master)](https://travis-ci.org/robertdebock/docker-drupal)

A Docker container for Drupal, including Drush, based on Alpine.

# Usage
The simplest form to start this container would be:

    docker run robertdebock/drupal

But; you're missing settings. You can set these variables to customize the installer:


|Variable|Default|Commment|
|---|---|---|
|DBURL|mysql://drupal:drupal@mysql/drupal|The database connection string.|
|DOMAIN|localhost|Required for "trusted_host_patterns". For example: example.com.|
|SITENAME|drupal|The name of the site, displaying in the title and header.|
|ADMINPASS|newpass|The password for the user "admin".|
|DBHOST|mysql|The (resolvable) hostname (or IP address) used to test the database connection.|
|DBPORT|3306|The TCP port to us to connect to MySQL (using ${DBHOST}.)|
|TIMEOUT|60|The maximum to to wait until MySQL is initialized.|
|MAILSERVER|postfix|The (resolvable) hostname (or IP address) used to send mail.|
|MAILFROM|robert@meinit.nl|The address to use when Drupal sends mail.|

It's quite logical to start this container with Docker Compose; which can be used to setup the required other containers. The docker-compose.yml file may look like this:

    version: '2'
    services:
      drupal:
        image: robertdebock/drupal
        build: drupal
        environment:
          - DBURL=mysql://drupal:drupal@mysql/drupal
          - DBHOST=mysql
          - SITENAME=drupal
          - ADMINPASS=newpass
        ports:
          - 80:80
          - 443:443
        links:
          - mysql
          - postfix
        volumes:
          - /var/www/html
      postfix:
        image: tozd/postfix
        environment:
          - MY_NETWORKS=10.0.0.0/8 172.0.0.0/8 192.168.0.0/16 127.0.0.0/8
          - ROOT_ALIAS=robert@meinit.nl
          - MAILNAME=drupal.meinit.nl
      mysql:
        image: mysql
        environment:
          - MYSQL_ALLOW_EMPTY_PASSWORD=true
          - MYSQL_USER=drupal
          - MYSQL_PASSWORD=drupal
          - MYSQL_DATABASE=drupal
        volumes:
          - ./data/var/lib/mysql:/var/lib/mysql

