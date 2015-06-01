#!/bin/bash

cd ${0%/*}

docker_exec=$(which /usr/bin/docker)

$docker_exec build -t spotweb_db:latest ../spotweb_db/
$docker_exec build -t spotweb:latest ../spotweb_server/
