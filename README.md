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
* Platform independent (reported to work on Linux, *BSD and Windows)
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

Runs Spotweb in Apache, exposing port 80 on an Ubuntu 14.10 base, connecting to a MySQL database. Retrieves spots and comments once an hour. Spotweb is downloaded from the [Spotweb GitHub source repository](https://github.com/spotweb) from the [media branch](https://github.com/spotweb/spotweb/tree/media)

Prerequisites:
- [Docker](http://docs.docker.com/installation/) is installed
- Access to a [Usenet server](http://www.reddit.com/r/usenet/wiki/providers) to pull NTTP feeds

## Directories

- /scripts - Contains a set of bash scripts that automates some of the creation, stopping and removal of the Spotweb docker container, its linked database container and its supporting volume container
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
There are a set of scripts included to make this easy to do. However, it's also possible to do by hand. First, create a volume container:

    docker create --name spotweb_data -v /var/lib/mysql alpine:latest /bin/true

Now you can create the database container:

    docker run -d --volumes-from="spotweb_data" -h spotweb_db --name="spotweb_db" isuftin/spotweb_db

Finally, create the Spotweb server container:

    docker run -d --link="spotweb_db:spotweb_db" -h spotweb_server --name="spotweb_server" isuftin/spotweb

You should now be able to access the Spotweb server at [http://localhost/spotweb/install.php](http://localhost/spotweb/install.php) to finish configuration of the Spotweb server.

#### I want to automate the building, running and removal of the Spotweb containers
You should be able to use the scripts in the /scripts directory in order to build, launch, stop and remove the Spotweb server, database and volume containers.


## Scripts
- **start-all.sh** - If you do not want to build and run individual containers, this script will start the database volume container, database container and server container. It will also output the SQL information needed to plug into the initial Spotweb install screen. Once the script has finished, you will be able to browse to [http://localhost/spotweb/install.php](http://localhost/spotweb/install.php)

		$ ./start-all.sh
		Starting new database container
		Created database volume container with ID: f2e850f56dff9f56c953e0fb86e7ac0c0b4154da81a590849bc1c33ea3495a53
		Created database container with ID: c328f5d281e429f8222f8445e3631f428f4116e0d65d6ec5aef1639206ced3b7
		Starting spotweb server
		Database Information
		IP ADDRESS=172.17.1.79
		HOSTNAME=29b0fd4dc6fc
		MYSQL_VERSION=5.6.24
		MYSQL_DATABASE=spotweb
		MYSQL_PASSWORD=spotweb
		PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
		PWD=/
		SHLVL=0
		HOME=/root
		MYSQL_MAJOR=5.6
		MYSQL_USER=spotweb
		MYSQL_ROOT_PASSWORD=spotweb

- **build-all.sh** - Locally build the docker database and server images locally. The advantage here is that you will pull down the latest Spotweb source available at the time.

      $ ./build-all.sh
	  [...]
	  $ docker images
	  REPOSITORY                    TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
	  isuftin/spotweb               latest              afe125c77e7a        7 seconds ago        320.2 MB
	  isuftin/spotweb_db            latest              432fd712319f        About a minute ago   282.9 MB
		
- **create-volume-container.sh** - Creates the database volume container used by the spotweb_db container. The volume container will be named "spotweb_data". The docker container is built from the [Alpine Docker image](http://gliderlabs.viewdocs.io/docker-alpine) due to its small size.

		$ docker ps -a
		CONTAINER ID        IMAGE                            COMMAND                CREATED             STATUS              PORTS               NAMES
		4e3c391111e9        alpine:latest                    "/bin/true"            2 seconds ago                                               spotweb_data

- **create-database-container.sh** - Runs the MySQL database container and will automatically use the database volume container named spotweb_data. The volume container named spotweb_data needs to exist for this container to start.

		$ docker ps -a
		CONTAINER ID        IMAGE                            COMMAND                CREATED             STATUS              PORTS               NAMES
		ee3a04a3194a        isuftin/spotweb_db:latest        "/entrypoint.sh mysq   6 seconds ago       Up 5 seconds        3306/tcp            spotweb_db
		4e3c391111e9        alpine:latest                    "/bin/true"            9 seconds ago                                               spotweb_data

- **create-server-container.sh** - Runs the Spotweb server container and sets up the link to the MySQL docker container named spotweb_db. The container spotweb_db needs to exist for this container to start.

		$ docker ps -a
		CONTAINER ID        IMAGE                            COMMAND                CREATED             STATUS              PORTS               NAMES
		8c47828033d5        isuftin/spotweb:latest           "/entrypoint.sh"       5 minutes ago       Up 5 minutes        0.0.0.0:80->80/tcp   spotweb_server
		ee3a04a3194a        isuftin/spotweb_db:latest        "/entrypoint.sh mysq   6 seconds ago       Up 5 seconds        3306/tcp            spotweb_db
		4e3c391111e9        alpine:latest                    "/bin/true"            9 seconds ago                                               spotweb_data
- **start-blank-db.sh** - Creates an empty database volume container and a MySQL container linked to it

		$ ./start-blank-db.sh
		Created database volume container with ID: 29da9e292b4203d4b8ae2f717743cec7963ada7da8fe09c3864cad9853a1625f
		Created database container with ID: efcc5af70746206f72ff4c335bad050af79035c72f558157e0a8167c126b39d3

		CONTAINER ID        IMAGE                            COMMAND                CREATED             STATUS                     PORTS               NAMES
		efcc5af70746        isuftin/spotweb_db:latest        "/entrypoint.sh mysq   27 seconds ago      Up 26 seconds              3306/tcp            spotweb_db
		29da9e292b42        alpine:latest                    "/bin/true"            27 seconds ago                                                     spotweb_data

- **remove-volume-container.sh** - Removes the database volume container named "spotweb_data".  ***WARNING:*** This will remove all of your data!

- **remove-database-container.sh** - Removes the running database container named "spotweb_db"

- **remove-server-container.sh** - Removes the running Spotweb server container named "spotweb_server"

- **remove-all.sh** - Removes the database volume, database and server containers. ***WARNING:*** This will remove all of your data!

		$ ./remove-all.sh
		Removing spotweb container 8c47828033d5
		8c47828033d5
		8c47828033d5
		Removing database container ee3a04a3194a
		This may fail if another container is linked to the database container
		ee3a04a3194a
		ee3a04a3194a
		Removing volume container f7d935542d4b
		This may fail if another container is linked to the volume container
		f7d935542d4b

- **trigger-retrieve.sh** - Triggers the retrieve script in a running Spotweb container to begin pulling new spots and comments

		$ ./trigger-retrieve.sh
		Removing Spot information which is beyond retention period,, done
		Last retrieve at Wed Dec 31 18:00:00 1969
		Retrieving new Spots from server ssl.astraweb.com...
		Appr. Message count:    2486861
		First message number:   1989963
		Last message number:    4476824
		Current article number: 1989963

		Retrieving 1989963 till 1994964 (parsed: 5001, in DB: 0, signed: 0, invalid: 5001, rtntn.skip: 0, mod: 0, full: 0, total: 5001) in 2.46 seconds
		[...]