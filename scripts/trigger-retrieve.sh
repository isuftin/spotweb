#!/bin/bash

source base.sh

$docker_exec exec $server_ps /etc/cron.hourly/spotweb-update 

