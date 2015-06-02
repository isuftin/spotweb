#!/bin/bash

cd ${0%/*}

docker_exec=$(which /usr/bin/docker)
server_ps=$(${docker_exec} ps -a -q -f name=spotweb_server)

$docker_exec exec $server_ps /usr/bin/php /var/www/spotweb/retrieve.php --debug | tee /var/log/spotweb-retrieve.log

