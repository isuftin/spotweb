#!/bin/bash

source base.sh

./remove-server-container.sh
./remove-database-container.sh
./remove-volume-container.sh

