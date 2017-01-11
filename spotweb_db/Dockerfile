FROM mysql:8.0.0

MAINTAINER Ivan Suftin <isuftin@gmail.com>

ENV MYSQL_DATABASE ${MYSQL_DATABASE:-spotweb}
ENV MYSQL_USER ${MYSQL_USER:-spotweb}
ENV MYSQL_PASSWORD ${MYSQL_PASSWORD:-spotweb}
ENV MYSQL_ROOT_PASSWORD ${MYSQL_ROOT_PASSWORD:-spotweb}

RUN mkdir -p /etc/mysql/conf.d/

COPY host_resolution.cnf /etc/mysql/conf.d/host_resolution.cnf

HEALTHCHECK --interval=2s --timeout=3s \
 CMD echo "SELECT 1+1;" | mysql --user="$MYSQL_USER"  --password="$MYSQL_ROOT_PASSWORD" > /dev/null || exit 1
