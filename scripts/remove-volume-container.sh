#!/bin/bash

source base.sh

cid_file=data_vol.cid

if [ -n "$data_ps" ]; then
	echo "Removing volume container $data_ps"
	echo "This may fail if another container is linked to the volume container"
	$docker_exec rm $data_ps
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
