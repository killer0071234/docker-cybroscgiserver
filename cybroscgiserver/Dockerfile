FROM debian:latest

MAINTAINER Daniel Gangl <killer007@gmx.at>

RUN apt-get update

RUN apt-get upgrade -y

RUN apt-get install -y curl lighttpd

RUN apt-get install -y python-pip python-mysqldb

RUN pip install pytz

WORKDIR /opt/cybroscgiserver/

ADD core/cybroscgiserver.tar.xz /opt/cybroscgiserver/

ADD config/lighttpd.conf /etc/lighttpd/lighttpd.conf

RUN chmod +x /opt/cybroscgiserver/run.sh

CMD /opt/cybroscgiserver/run.sh

HEALTHCHECK --interval=5s --timeout=2s --retries=12 \
  CMD curl --silent --fail http://localhost/scgi/?sys.server_uptime || exit 1
