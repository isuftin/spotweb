# Spotweb Docker Container
   ----------------------

## Spotweb

[Spotweb](https://github.com/spotweb/spotweb/wiki)  is a decentralized usenet community based on the [Spotnet](https://github.com/spotnet/spotnet/wiki) protocol.

Spotweb requires an operational webserver with PHP5 installed, it uses either an MySQL or an PostgreSQL database to store it's contents in.

## Features
Spotweb is one of the most-featured Spotnet clients currently available, featuring among other things:

* Fast
* Customizable filter system from within the system
* Posting of comments and spots
* Showing and filtering on new spots since the last view
* Watchlist
* Easy to download multiple files
* Runs on NAS devices like Synology and qnap
* Rating of spots
* Integration with [Sick beard](http://www.sickbeard.com) and [CouchPotato](http://couchpotatoapp.com/) as a 'newznab' provider
* Platform independent (reported to work on Linux, \*BSD and Windows)
* Both central as user-specific blacklist support built-in
* Spam reporting
* Easy layout customization by providing custom CSS
* Boxcar/Growl/Notify My Android/Notify/Prowl and Twitter integration
* Spot statistics on your system
* Sabnzbd and nzbget integration
* Multi-language
* Multiple-user ready
* Opensource and open development model



# Spotweb Docker Container

Runs Spotweb in Apache, exposing port 80 on an Ubuntu 15.10 base, connecting to a MySQL database. Retrieves spots and comments once an hour. Spotweb is downloaded from the [Spotweb GitHub source repository](https://github.com/spotweb) from a specific tag. By default, the tag is [1.3.1](https://github.com/spotweb/spotweb/tree/1.3.1). This can be changed by injecting the environment variable `SPOTWEB_VERSION` with a valid GitHub tag when building the server container.

## Prerequisites

- [Docker](http://docs.docker.com/installation/) is installed
- Access to a [Usenet server](http://www.reddit.com/r/usenet/wiki/providers) to pull NTTP feeds

## Directories

- /spotweb_db - The optional MySQL database docker container for use with the Spotweb server docker container
- /spotweb_server - The Spotweb docker container  which runs the Docker server

## Running Spotweb

#### I have my own MySQL server
If you already have a MySQL server available and accepting connections, you can immediately run the Spotweb server docker container:

    docker run -d -p80:80 --name="spotweb_server" isuftin/spotweb

You should now be able to access the Spotweb server at http://localhost/spotweb/install.php to finish configuration of the Spotweb server.

Note: The spotweb Apache/PHP server runs in the America/Chicago timezone by default. If you wish to change this, you will want to set the "timezone" environment vairable during your run. See [http://php.net/manual/en/timezones.america.php](http://php.net/manual/en/timezones.america.php) for available timezones. Example (Notice the escaping):

    docker run -d -p80:80 --name="spotweb_server" -e "timezone=America\\\/Los_Angeles" isuftin/spotweb

#### I have my own MySQL Docker container
You may be running your own MySQL server in a docker container. If so, you can run the Spotweb server docker container to link to the MySQL container:

    docker run -d p80:80 --name="spotweb_server" --link="my_db_containers_name_or_id:spotweb_db" isuftin/spotweb

#### I want to run your MySQL Docker container along with your Spotweb container

The easiest way to get up and running with a full stack (volume container, database container and server container) is to run the top-level docker-compose script:

`$ docker-compose up`

This will create two volume containers, start the database container and automatically have it use the volume container as a persistent data store and start the Spotweb server and automatically connect it to the database. The Spotweb container will also use a volume container to hold its data.

Once the server has started, you should be able to access it at [http://localhost/spotweb/install.php](http://localhost/spotweb/install.php)

If you are running boot2docker, use `boot2docker ip` to get the address to replace localhost with.

If you are using docker-machine, use `docker-machine ip <name of machine>` to get the address to replace localhost with.

You are now free to configure the server as you wish.

If using docker-compose, the database container's hostname is spotweb_db. During the configuration portion, replace database host 'localhost' with 'spotweb_db'. The rest should be left default.

If you do not wish to use docker-compose, you will want to create a Docker volume container:

    docker create --name spotweb_data -v /var/lib/mysql alpine:latest /bin/true

Now you can create the database container:

    docker run -d --volumes-from="spotweb_data" -h spotweb_db --name="spotweb_db" isuftin/spotweb_db

Finally, create the Spotweb server container:

    docker run -d --link="spotweb_db:spotweb_db" -h spotweb_server --name="spotweb_server" isuftin/spotweb

You should now be able to access the Spotweb server at [http://localhost/spotweb/install.php](http://localhost/spotweb/install.php) to finish configuration of the Spotweb server.
