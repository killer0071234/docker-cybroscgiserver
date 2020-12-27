================================================================================
                 CyBroScgiServer (c) 2010-2020 Cybrotech Ltd.
================================================================================

FEATURES

CyBroScgiServer is a communication driver for reading and writing Cybro variables.

- server is waiting for http requests on a given port (defualt is 4000)
- http requests are used to read and write cybro variables
- written in Python 3, it works on any Windows or Linux machine
- cybro connection options are ethernet/LAN, ethernet/WAN and CAN
- push module is used to receive and acknowledge push messages from cybro
- data logger module is used to write cybro variables into a database
- relay module allows system administrator to connect cypro to any controller

Connection options are:

1. LAN access using ip autodetect (controller and server in the same subnet)

  [ETH]/enabled = true
  [ETH]/autodetect_enabled = true
  [PUSH]/enabled = false
  [CAN]/enabled = false

2. LAN/WAN access using static ip (controller has a static ip address)

  [ETH]/enabled = true
  [ETH]/autodetect_enabled = false
  [PUSH]/enabled = false
  [CAN]/enabled = false
  [c20000]/ip_address = 192.168.1.100
  [c20001]/ip_address = 192.168.1.101
  [c20002]/ip_address = 192.168.1.102

3. WAN access using push (controller uses push, server has a static ip or domain name)

  [ETH]/enabled = true
  [ETH]/autodetect_enabled = false
  [PUSH]/enabled = true
  [CAN]/enabled = false

4. CAN access (1-to-1 connection, Raspberry Pi + PiCAN2 to a single controller)

  [ETH]/enabled = false
  [ETH]/autodetect_enabled = false
  [PUSH]/enabled = false
  [CAN]/enabled = true

Server is configured by editing config.ini file.

READ/WRITE DATA

There are two ways to check the operation of the SCGI server:

1. Web browser

  http://localhost:4000/?c20000.rtc_sec

2. Command line

  cybro_com_server.py c20000.rtc_sec

Both will attempt to connect server on the local machine, and read variable
rtc_sec from controller with address (serial number) 2000.

The result should look like this:

<?xml version="1.0" encoding="ISO-8859-1"?>
<data>
  <var>
    <name>c20000.rtc_sec</name>
    <value>47</value>
    <description></description>
  </var>
</data>

To process a request, server needs ip address of the controller. It is retrieved
in the following order, depending on configuration:

- static address, when configured
- push list, when server is enabled and controller is sending push messages
- autodetect, server will broadcast ping message, and use answer to get the ip
- when CAN is enabled, ip address is not used, controller is accessd directly

DATA CACHE

To improve performance, server implements data caching. Configuration options,
valid_period_s, request_period_s and cleanup_period_s, are given in seconds.

Valid_period_s defines cache validity time. When cache expires, read is
performed directly from controller, waiting for the answer.

Request_period_s is an intermediate time, smaller than valid_period_s, in which
value is still returned from cache, but read request is sent, and the answer is
used to update the cache.

     read from cache,          read from cache,            send request,
     request not sent     send request to update cache    wait for answer
|-------------------------|-------------------------|------------------------>
0                  request_period              valid_period

Cleanup_period_s defines the period when invalidated items will be removed from
cache.

SYSTEM VARIABLES (server)

- sys.scgi_port_status
    - no response, server down
    - "active", SCGI server active

- sys.scgi_request_count
    - total number of requests

- sys.scgi_request_pending
    - number of currently serving requests

- sys.server_uptime
    - "hh:mm:ss" or "dd days, hh:mm:ss", server uptime

- sys.push_port_status
    - "active"
    - "inactive", PushEnable is False
    - "error", port already used by another application

- sys.push_count
    - total number of push messages received from controllers

- push_ack_errors
    - total number of push acknowledge errors (out of push_count)

- sys.push_list_count
    - total number of controllers currently in push list

- sys.nad_list
    - list of controllers currently in push list

- sys.push_list
    -  list of controllers with status info (nad, ip:port, plc status, plc program, alc file, response time)

- sys.cache_request
    - configured read request time [s]

- sys.cache_valid
    - configured cache validity time [s]

- sys.server_version
    - returned as "major.minor.release"

- sys.udp_rx_count
    - total number of UDP packets received through UDP proxy

- sys.udp_tx_count
    - total number of UDP packets transmitted through UDP proxy

- sys.abus_list
    - abus list contains detailed information for low level communication
    between SCGI server and Cybro controllers

- sys.datalogger_status
    - datalogger module can be 'active' or 'stopped'

- sys.datalogger_list
    - datalogger list contains detailed data for datalogger sample and alarm

- sys.proxy_activity_list
    - proxy activity list represents data for proxy activity

SYSTEM VARIABLES (controller)

- c6512.sys.ip_port
    - returned as "xxx.xxx.xxx.xxx:yyyy"

- c6512.sys.timestamp
    - as read from plc_head.transfer

- c6512.sys.plc_status
- c6512.sys.plc_program_status
- c6512.sys.response_time
- c6512.sys.bytes_transferred

- c6512.sys.alc_file
    - complete alc file, same as saved by CyPro

- c6512.sys.comm_error_count
    - total number of communication errors encountered by controller

DATALOGGER

Data logger is a separate task, used to read Cybro variables and store them
into database. Configuration consists of a different tasks, samples and
alarms/envents.

- samples are read periodically, and stored directly into database
- alarms/events are read periodically, but stored only if condition is fulfiled

Samples are stored into 'measurements' table, alarms and events into 'alarms'
table. In difference to events, alarms are expected to be acknowledged by user.

To configure data logger, edit data_logger.xml file. To start data logger,
edit config.ini and set [DATALOGGER]/enabled to true. When data_logger.xml is
changed while server is running, it will reload the file and restart.

DATABASE

If [DATALOGGER] or [RELAY] are used, MySQL database must be installed. In such
case, [DBASE] should also be enabled, and valid access data must be provided.

Database structure is given by db_scgi_create_v303.sql.

--------------------------------------------------------------------------------
                           SCGI SERVER INSTALLATION
--------------------------------------------------------------------------------

INSTALL PYTHON

Server is written in Python and works on major platforms (Windows, Linux, Mac).
Python interpreter may be downloaded from http://www.python.org. Recommended
version is 3.8.x.

During the installation check option: "add Python 3.8 to path".

INSTALL VIRTUAL ENVIRONMENT

Although not necessary, it's recommended to install Python dependencies inside
the virtual environment, to avoid pollution of global scope. To get more info,
open https://docs.python.org/3/library/venv.html.

1. Run this command in the SCGI server root:

  python -m venv venv

Recommended installation directory is:

win:    C:\Program Files (x86)\Cybrotech\CyBroScgiServer\scgi_server
linux:  /usr/local/bin/scgi_server

2. Activate the virtual environment:

  ./venv/Scripts/activate

Once virtual environment is activated, you can install the packages and run the
application. In case you don't need SCGI server any more, you may deactivate
the virtual environment:

  ./venv/Scripts/deactivate

INSTALL DEPENDENCIES

  cd /usr/local/bin/scgi_server
  pip install -r src/requirements.txt

INSTALL DATABASE (Windows)

Download the MSI package from https://downloads.mariadb.org, choose the latest
stable version. Follow installation instructions. Configure [DBASE] section of
config.ini.

Once MariaDB is installed, make sure path to mysql executable is specified in
PATH environment variable.

INSTALL DATABASE (Linux)

  sudo apt-get install mariadb-server

CONFIGURE DATABASE (Windows and Linux)

Log into mysql shell

  mysql -u <user> -p

Run mysql commands to create cybro database:

  create database cybro;
  use cybro;
  source db_scgi_create_v303.sql

Enable zero date mode:

  SET GLOBAL sql_mode = 'NO_ZERO_IN_DATE';

Grant all privileges on a database:

  GRANT ALL ON cybro .* TO <user> IDENTIFIED BY <password>;

When finished, enter dbase connection parameters to config.ini.

START SCGI SERVER

Run app.py script.

  cd src
  python app.py

ENVIRONMENT INFORMATION

* Microsoft Windows 10
* python 3.8
* pip 19.3.1

CONFIG PYCHARM

File > Settings > Project: scgi_server > Project Structure

Mark src directory as "Sources"

INSTALL SCGI ON RASPBERRY PI

Raspberry Pi may have the old v2 python interpreter, so it may be necessary to
install python 3 manually. You can check version with the following command:

  python -V

Install dependencies before installation of Python 3.8:

  sudo apt-get install -y build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev tar wget vim

Download Python (change directory to Downloads):

  wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz

Unpack and install Python:

  sudo tar zxf Python-3.8.0.tgz
  cd Python-3.8.0
  sudo ./configure --enable-optimizations
  sudo make -j 4
  sudo make altinstall

Make Python 3.8 as the default version:

  echo "alias python=/usr/local/bin/python3.8" >> ~/.bashrc
  source ~/.bashrc

CONFIGURE CAN INTERFACE ON RASPBERRY PI

Open /boot/config.txt and add these lines to the end of the file:

  dtparam=spi=on
  dtoverlay=mcp2515-can0,oscillator=16000000,interrupt=25
  dtoverlay=spi-bcm2835-overlay

Configure 'can0' interface:

  sudo /sbin/ip link set can0 up type can bitrate 100000
  sudo ifconfig can0 txqueuelen 1000
  sudo ifconfig can0 up