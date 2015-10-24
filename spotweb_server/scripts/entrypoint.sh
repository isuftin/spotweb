#!/bin/bash

db_engine=${db_engine:-mysql}
db_host=${db_host:-$SPOTWEB_DB_PORT_3306_TCP_ADDR}
db_name=${db_name:-$SPOTWEB_DB_ENV_MYSQL_DATABASE}
db_user=${db_user:-$SPOTWEB_DB_ENV_MYSQL_USER}
db_pass=${db_pass:-$SPOTWEB_DB_ENV_MYSQL_PASSWORD}

echo "Updating time zone"
# http://php.net/manual/en/timezones.america.php
timezone=${timezone:-"America\\\/Chicago"}
sed -i "s/^;date.timezone = */date.timezone=${timezone}/g" /etc/php5/*/php.ini

echo "Correcting ownership in spotweb directory"
chown -R www-data:www-data /var/www/spotweb

echo "Removing default apache content"
rm -r /var/www/html

echo "Enabling PHP mod rewrite"
/usr/sbin/a2enmod rewrite

echo "Updating hourly cron"
(crontab -l ; echo "0 * * * * /usr/bin/php /var/www/spotweb/retrieve.php | tee /var/log/spotweb-retrieve.log") | crontab -

chmod a+x /update-db.sh

echo "Database Host: $db_host"
echo "Database Name: $db_name"
echo "Database User: $db_user"
echo "Database Pass: $db_pass"
echo "Creating database configuration"

# We sleep here because the MySQL database may not be ready yet
/etc/init.d/apache2 restart && sleep 30 && /update-db.sh --ip=$db_host --dbname=$db_name --user=$db_user --pass=$db_pass --dbtype=$db_engine && tail -F /var/log/apache2/*
