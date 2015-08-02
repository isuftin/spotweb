#!/bin/bash

cd ${0%/*}

DB_TYPE="pdo_mysql"
DB_NAME="spotweb"
USER="spotweb"
PASS="spotweb"

while [[ $# > 0 ]]; do
        key="$1"
        case $key in
                --ip*)
                IP_ADDRESS=$(echo "$1" | sed -e 's/^[^=]*=//g')
                shift
                ;;
                --dbname*)
                DB_NAME=$(echo "$1" | sed -e 's/^[^=]*=//g')
                shift
                ;;
                --user*)
                USER=$(echo "$1" | sed -e 's/^[^=]*=//g')
                shift
                ;;
                --pass*)
                PASS=$(echo "$1" | sed -e 's/^[^=]*=//g')
                shift
                ;;
                --dbtype*)
                DB_TYPE=$(echo "$1" | sed -e 's/^[^=]*=//g')
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

        # For some reason Spotweb needs this run twice or it complains :(
        # I also want to set the default password of admin to spotweb 
        /usr/bin/php /var/www/spotweb/upgrade-db.php
        /usr/bin/php /var/www/spotweb/upgrade-db.php  --reset-groupmembership=true --reset-securitygroups=true --reset-password admin
else
        echo "Missing argument(s). Could not continue."
        exit 1
fi
