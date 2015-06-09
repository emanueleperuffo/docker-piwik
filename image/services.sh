#!/bin/bash
set -e
source /build/buildconfig
set -x

## Nginx & php for piwik
$minimal_apt_get_install nginx-full \
	php5-fpm php5-mysqlnd php5-ldap php5-gd php5-geoip php-pear php5-dev libgeoip-dev make


## geoip installation from pecl
pecl install geoip
mkdir /usr/share/GeoIP/
curl -L http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz | gunzip > /usr/share/GeoIP/GeoIPCity.dat

cd /var/www && curl -L http://builds.piwik.org/piwik-2.13.1.tar.gz | tar -xvzf -
chown www-data:www-data /var/www/piwik/tmp
cat <<-EOF | php
<?php
define('PIWIK_DOCUMENT_ROOT', '/var/www/piwik');
define('PIWIK_INCLUDE_PATH', PIWIK_DOCUMENT_ROOT);
require PIWIK_INCLUDE_PATH.'/core/bootstrap.php';

require './core/Plugin/Manager.php';
require 'plugins/CorePluginsAdmin/PluginInstaller.php';
\$installer = new Piwik\Plugins\CorePluginsAdmin\PluginInstaller('LoginLdap');
\$installer->installOrUpdatePluginFromMarketplace();
\$manager = Piwik\Plugin\Manager::getInstance();
\$manager->activatePlugin('LoginLdap');
EOF

## Nginx configuration
rm -rf /etc/nginx
cd /etc && curl -L https://github.com/emanueleperuffo/piwik-nginx/archive/v1.0.0.tar.gz | tar -xvzf -
mv /etc/piwik-nginx-1.0.0 /etc/nginx
mkdir /etc/nginx/sites-enabled
# Cache
mkdir -p /var/cache/nginx/fcgicache
chown www-data:www-data /var/cache/nginx -R

## PHP configuration
cp /build/config/php/php.ini /etc/php5/fpm/
cp /build/config/php/php-fpm.conf /etc/php5/fpm/
cp /build/config/php/syslog-open.php /etc/php5/fpm/
cp /build/config/php/syslog-close.php /etc/php5/fpm/

## Daemons
mkdir /etc/service/php-fpm
cp /build/runit/php-fpm /etc/service/php-fpm/run
mkdir /etc/service/nginx
cp /build/runit/nginx /etc/service/nginx/run

#cp /build/config/piwik/config.ini.php /var/www/roundcube/config
#chown www-data:www-data /var/www/roundcube/logs
#chown www-data:www-data /var/www/roundcube/temp