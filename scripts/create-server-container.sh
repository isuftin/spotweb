#!/bin/bash

cd ${0%/*}

docker_exec=$(which /usr/bin/docker)
server_ps=$(${docker_exec} ps -a -q -f name=spotweb_server)
docker_exec=$(which /usr/bin/docker)
if [ ! -n "$server_ps" ]; then
	$docker_exec run -d --link="spotweb_db:spotweb_db" -h spotweb -p "80:80" --name="spotweb_server" spotweb:latest > spotweb.cid
else
	echo "Spotweb server already running with ID: $server_ps"
	echo $server_ps > spotweb.cid
fi
