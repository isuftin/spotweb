#!/bin/bash

# This finds the processes running the database volume and database containers and 
# kills and removes them. The containers don't necessarily have to be running or 
# exist. If not, this will not cause an error. 
# The database volume container and database container will then be recreated

source base.sh

./remove-database-container.sh
./remove-volume-container.sh
./start-blank-db.sh
