FROM ubuntu:15.10

MAINTAINER Ivan Suftin <isuftin@gmail.com>

EXPOSE 80

ENV SPOTWEB_VERSION ${SPOTWEB_VERSION:-"1.3.1"}

RUN apt-get update && \
	apt-get install -y apache2 php5 php5-curl php5-gd php5-gmp php5-mysql git-core cron wget curl && \
	apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y

RUN git clone https://github.com/spotweb/spotweb.git /var/www/spotweb && \
	cd /var/www/spotweb && \
	git checkout $SPOTWEB_VERSION && \
	chmod -R 777 /var/www/spotweb && \
	chown -R root:www-data /var/www/spotweb

# http://php.net/manual/en/timezones.php
ENV timezone ${timezone:-"America/Chicago"}

COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf

RUN echo "ServerName localhost" >> /etc/apache2/conf-enabled/fqdn.conf

RUN sed -i "s@^;date.timezone = *@date.timezone=${timezone}@g" /etc/php5/*/php.ini

# Correcting ownership in spotweb directory
RUN chown -R www-data:www-data /var/www/spotweb

# Removing default apache content
RUN rm -r /var/www/html

# Enabling PHP mod rewrite
RUN /usr/sbin/a2enmod rewrite

# Updating hourly cron
RUN (crontab -l ; echo "0 * * * * /usr/bin/php /var/www/spotweb/retrieve.php | tee /var/log/spotweb-retrieve.log") | crontab -

ENV DOCKERIZE_VERSION ${DOCKERIZE_VERSION:-"0.3.0"}

RUN wget https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz

RUN tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz

HEALTHCHECK CMD curl --fail 'http://localhost:80/spotweb/' || exit 1
