#!/bin/bash

source base.sh

$docker_exec build -t spotweb_db:latest ../spotweb_db/
$docker_exec build -t spotweb:latest ../spotweb_server/
