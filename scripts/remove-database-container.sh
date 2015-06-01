#!/bin/bash

cd ${0%/*}

docker_exec=$(which /usr/bin/docker)
db_ps=$(${docker_exec} ps -a -q -f name=spotweb_db)
cid_file=db.cid

if [ -n "$db_ps" ]; then
	echo "Removing database container $db_ps"
	echo "This may fail if another container is linked to the database container"
	$docker_exec kill $db_ps;$docker_exec rm $db_ps
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
