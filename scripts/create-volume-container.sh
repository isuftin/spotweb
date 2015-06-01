#!/bin/bash

cd ${0%/*}

docker_exec=$(which /usr/bin/docker)
data_ps=$(${docker_exec} ps -a -q -f name=spotweb_data)

if [ ! -n "$data_ps" ]; then
	$docker_exec create --name spotweb_data -v /var/lib/mysql alpine:latest /bin/true > data_vol.cid
else
	echo "Spotweb data volume already created with ID: $data_ps"
        echo $data_ps > data_vol.cid
fi
