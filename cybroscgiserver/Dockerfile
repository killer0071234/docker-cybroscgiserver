FROM debian:latest

MAINTAINER Daniel Gangl <killer007@gmx.at>

RUN apt-get update

RUN apt-get upgrade -y

RUN apt-get install -y curl lighttpd

RUN apt-get -y install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev

WORKDIR /tmp/

RUN curl -O https://www.python.org/ftp/python/3.8.7/Python-3.8.7.tar.xz

RUN tar -xf Python-3.8.7.tar.xz

WORKDIR /tmp/Python-3.8.7

RUN ./configure --enable-optimizations --enable-loadable-sqlite-extensions

RUN make -j 5

RUN make install

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

RUN python3.8 get-pip.py

RUN pip3 install pytz

RUN pip3 install rx

RUN pip3 install watchdog

RUN pip3 install python-can

RUN pip3 install aiomysql

RUN ln -s /usr/share/lighttpd/create-mime.conf.pl /usr/share/lighttpd/create-mime.assign.pl 

WORKDIR /opt/cybroscgiserver/

ADD core/cybroscgiserver.tar.xz /opt/cybroscgiserver/

ADD config/lighttpd.conf /etc/lighttpd/lighttpd.conf

RUN chmod +x /opt/cybroscgiserver/run.sh

CMD /opt/cybroscgiserver/run.sh

HEALTHCHECK --interval=5s --timeout=2s --retries=12 \
  CMD curl --silent --fail http://localhost:4000/?sys.server_uptime || exit 1
