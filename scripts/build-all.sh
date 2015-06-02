#!/bin/bash

source base.sh

$docker_exec build -t ${name_db}:latest ../${name_db}/
$docker_exec build -t spotweb:latest ../${name_server}/
