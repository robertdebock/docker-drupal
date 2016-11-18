[![Build Status](https://travis-ci.org/robertdebock/docker-drupal.svg?branch=master)](https://travis-ci.org/robertdebock/docker-drupal)

A [Docker container for Drupal](https://hub.docker.com/r/robertdebock/docker-drupal/), including Drush, based on Alpine.

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

It's quite logical to start this container with Docker Compose; which can be used to setup the required other containers. See docker-compose.yml" for an initial configuation.
