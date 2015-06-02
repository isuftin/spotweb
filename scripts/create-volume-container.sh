#!/bin/bash

source base.sh

if [ ! -n "$data_ps" ]; then
	$docker_exec create --name $name_data -v /var/lib/mysql alpine:latest /bin/true > data_vol.cid
else
	echo "Spotweb data volume already created with ID: $data_ps"
        echo $data_ps > data_vol.cid
fi
