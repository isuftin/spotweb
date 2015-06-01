#!/bin/bash

cd ${0%/*}

docker_exec=$(which /usr/bin/docker)
server_ps=$(${docker_exec} ps -a -q -f name=spotweb_server)
cid_file=spotweb.cid

if [ -n "$server_ps" ]; then
	echo "Removing spotweb container $db_ps"
	$docker_exec kill $server_ps;$docker_exec rm $server_ps
	if [ $? -eq 0 ]; then
		if [ -f $cid_file ]; then
			rm $cid_file
		fi
	fi
else
	if [ -f $cid_file ]; then
		rm $cid_file
	fi
fi
