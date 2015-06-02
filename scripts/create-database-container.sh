#!/bin/bash

source base.sh

if [ ! -n "$db_ps" ]; then
	$docker_exec run -d --volumes-from="${name_data}" -h $name_db --name="${name_db}" $name_db:latest > db.cid
else
	echo "Spotweb database server already running with ID: $db_ps"
	echo $db_ps > db.cid
fi
