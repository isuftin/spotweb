#!/bin/bash

source base.sh

$docker_exec build -t isuftin/${name_db}:latest ../${name_db}/
$docker_exec build -t isuftin/spotweb:latest ../${name_server}/
