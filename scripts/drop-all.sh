#!/bin/bash

cd ${0%/*}
./remove-server-container.sh
./remove-database-container.sh
./remove-volume-container.sh

