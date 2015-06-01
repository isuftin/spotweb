#!/bin/bash

cd ${0%/*}

docker_exec=$(which /usr/bin/docker)
data_vol_ps=$(${docker_exec} ps -a -q -f name=spotweb_data)
cid_file=data_vol.cid

if [ -n "$data_vol_ps" ]; then
	echo "Removing volume container $dat_vol_ps"
	echo "This may fail if another container is linked to the volume container"
	$docker_exec rm $data_vol_ps
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
