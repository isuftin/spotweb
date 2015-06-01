FROM ubuntu:14.10

MAINTAINER Ivan Suftin <isuftin@gmail.com>

RUN apt-get update && \
	apt-get install -y apache2 php5 php5-curl php5-gd php5-gmp php5-mysql git-core && \
	apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y

RUN git clone https://github.com/spotweb/spotweb.git /var/www/spotweb && \
	cd /var/www/spotweb && \
	git checkout media && \
	chmod -R 777 /var/www/spotweb && \
	chown -R root:www-data /var/www/spotweb

COPY /scripts/entrypoint.sh /entrypoint.sh
COPY /scripts/update-db.sh /update-db.sh
COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf

# http://php.net/manual/en/timezones.php
ENV timezone America\\\/Chicago
ENV db_engine mysql
ENV db_host ""
ENV db_name ""
ENV db_user ""
ENV db_pass ""

ENTRYPOINT ["/entrypoint.sh"]
