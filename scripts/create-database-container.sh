#!/bin/bash

cd ${0%/*}

docker_exec=$(which /usr/bin/docker)
db_ps=$(${docker_exec} ps -a -q -f name=spotweb_db)

if [ ! -n "$db_ps" ]; then
	$docker_exec run -d --volumes-from="spotweb_data" -h spotweb_db --name="spotweb_db" spotweb_db:latest > db.cid
else
	echo "Spotweb database server already running with ID: $db_ps"
	echo $db_ps > db.cid
fi
