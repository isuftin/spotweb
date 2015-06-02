#!/bin/bash

source base.sh

if [ -n "$data_ps" ]; then
	echo "Spotweb Data Volume already exists."
	echo "First remove data container ID: ${data_ps}"
	echo "To remove: $docker_exec rm $data_ps"
	echo "Make sure that other containers are not currently using it"
	exit 1
fi

if [ -n "$db_ps" ]; then
	echo "Spotweb database container is already running."
	echo "First remove database container ID: $db_ps"
	echo "To remove: $docker_exec kill $db_ps;$docker rm $db_ps"
	exit 1
fi

./create-volume-container.sh > data_vol.cid
if [ $? -eq 0 ]; then
	echo "Created database volume container with ID: $(cat data_vol.cid)"
else
	echo "Could not create database volume container"
	exit 1
fi

./create-database-container.sh > db.cid
if [ $? -eq 0 ]; then
	echo "Created database container with ID: $(cat db.cid)"
else
	echo "Could not create database container"
	exit 1
fi
