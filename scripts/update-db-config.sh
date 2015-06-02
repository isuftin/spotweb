#!/bin/bash

source base.sh

IP_ADDRESS=$($docker_exec inspect --format='{{.NetworkSettings.IPAddress}}' $db_ps)
for fn in $($docker_exec run isuftin/${name_db} env); do
	eval $fn
done

$docker_exec exec $server_ps /update-db.sh --ip $IP_ADDRESS --dbname $MYSQL_DATABASE --user $MYSQL_USER --pass $MYSQL_PASSWORD
