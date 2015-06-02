#!/bin/bash

cd ${0%/*}

echo "Starting new database container"
./start-blank-db.sh

sleep 2

echo "Starting spotweb server"
./create-server-container.sh

echo "Database Information"
docker_exec=$(which /usr/bin/docker)
db_ps=$(${docker_exec} ps -a -q -f name=spotweb_db)
server_ps=$(${docker_exec} ps -a -q -f name=spotweb_server)

IP_ADDRESS=$($docker_exec inspect --format='{{.NetworkSettings.IPAddress}}' ${db_ps})
echo "IP ADDRESS=$IP_ADDRESS"
for fn in $($docker_exec run spotweb_db env); do
        echo $fn
done
