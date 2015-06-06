#!/bin/bash

# This script is used as a source base for other scripts within this dir

cd ${0%/*}
name_db=spotweb_db
name_server=spotweb_server
name_data=spotweb_data
docker_exec=$(which docker)
db_ps=$($docker_exec ps -a -q -f name=$name_db)
server_ps=$($docker_exec ps -a -q -f name=$name_server)
data_ps=$($docker_exec ps -a -q -f name=$name_data)
