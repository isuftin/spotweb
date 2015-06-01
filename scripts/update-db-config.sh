#!/bin/bash

cd ${0%/*}

docker_exec=$(which /usr/bin/docker)
db_ps=$(${docker_exec} ps -a -q -f name=spotweb_db)
server_ps=$(${docker_exec} ps -a -q -f name=spotweb_server)

IP_ADDRESS=$($docker_exec inspect --format='{{.NetworkSettings.IPAddress}}' ${db_ps})
for fn in $($docker_exec run spotweb_db env); do
	eval $fn
done

$docker_exec exec $server_ps /update-db.sh --ip $IP_ADDRESS --dbname $MYSQL_DATABASE --user $MYSQL_USER --pass $MYSQL_PASSWORD
