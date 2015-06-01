FROM mysql:latest

ENV MYSQL_DATABASE spotweb
ENV MYSQL_USER spotweb
ENV MYSQL_PASSWORD spotweb
ENV MYSQL_ROOT_PASSWORD spotweb

RUN mkdir -p /etc/mysql/conf.d/
COPY host_resolution.cnf /etc/mysql/conf.d/host_resolution.cnf 
