#!/bin/bash

cd ${0%/*}

DB_TYPE="pdo_mysql"
DB_NAME="spotweb"
USER="spotweb"
PASS="spotweb"

while [[ $# > 0 ]]; do
        key="$1"
        case $key in
                --ip)
                IP_ADDRESS="$2"
                shift
                ;;
                --dbname)
                DB_NAME="$2"
                shift
                ;;
                --user)
                USER="$2"
                shift
                ;;
                --pass)
                PASS="$2"
                shift
                ;;
                --dbtype)
                DB_TYPE="$2"
                shift
                ;;
        esac
        shift
done

if [[ -n "$DB_TYPE" && -n "$IP_ADDRESS" && -n "$DB_NAME" && -n "$USER" && -n "$PASS" && -n "$DB_TYPE" ]]; then
        echo "Creating database configuration"
        echo "<?php" > /var/www/spotweb/dbsettings.inc.php
        echo "\$dbsettings['engine'] = '$DB_TYPE';" >> /var/www/spotweb/dbsettings.inc.php
        echo "\$dbsettings['host'] = '$IP_ADDRESS';" >> /var/www/spotweb/dbsettings.inc.php
        echo "\$dbsettings['dbname'] = '$DB_NAME';"  >> /var/www/spotweb/dbsettings.inc.php
        echo "\$dbsettings['user'] = '$USER';" >> /var/www/spotweb/dbsettings.inc.php
        echo "\$dbsettings['pass'] = '$PASS';"  >> /var/www/spotweb/dbsettings.inc.php

        /usr/bin/php /var/www/spotweb/upgrade-db.php
else
        echo "Missing argument(s). Could not continue."
fi
