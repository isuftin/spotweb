#!/bin/bash

echo "Creating database configuration"
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
echo "#!/bin/bash" > /etc/cron.hourly/spotweb-update.sh
echo "/usr/bin/php /var/www/spotweb/retrieve.php >> /var/log/spotweb-retrieve.log" >> /etc/cron.hourly/spotweb-update.sh
echo "" >> /etc/cron.hourly/spotweb-update.sh
chmod a+x /etc/cron.hourly/spotweb-update.sh

chmod a+x /update-db.sh

echo "Database Host: $db_host"
echo "Database Name: $db_name"
echo "Database User: $db_user"
echo "Database Pass: $db_pass"

/etc/init.d/apache2 restart && tail -F /var/log/apache2/*
