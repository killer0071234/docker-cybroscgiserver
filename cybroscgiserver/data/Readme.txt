================================================================================
                 CyBroScgiServer (c) 2010-2014 Cybrotech Ltd
================================================================================

Description

CyBroScgiServer is communication server for reading and writing CyBro variables.

Connection options are:

- local access
- wan access with static ip (CyBro has static ip)
- wan access using push messages (server has static ip or dynamic DNS)

It may be used as:

- command line (stdin for request, stdout for answer)
- CGI interface (web server using standard CGI)
- SCGI interface (web server using SCGI module)

Server is written in Python and works on any platform (Windows, Linux, Mac).
Python interpreter is free and may be downloaded from http://www.python.org/.
Recommended version is 2.6.x.

To configure server, edit scgi_server.ini. If file is changed when server is
running, it will automatically reload within a few seconds.

Server has access to controllers in push list and, if LocalAccess is True,
local controllers listed in config.ini. If controller is not listed, it will
not be visible.

For advanced options edit sys_config.py, then restart server.

Command line operation

- install Python
- run cybro_scgi_server.py (and leave running)
- use cybro_com_server.py from command line same way as CyBroComServer.exe

Web server operation (CGI mode, low performance)

- install Python
- start cybro_scgi_server.py
- copy cybro_com_server.py into /cgi-bin directory

Web server operation (SCGI mode, high performance)

- install Python
- start cybro_scgi_server.py
- install and configure (httpd.conf) SCGI module for your web server:

  # add SCGI module to list of active modules
  LoadModule scgi_module modules/mod_scgi.so

  # location for which SCGI protocol is forced
  <Location "/scgi">
    SCGIHandler On
  </Location>

  # Hostname and port number where SCGI server is accessable.
  SCGIMount /scgi 127.0.0.1:4000

Leave SCGI server running. Window may be minimized. For a permament operation,
put link in startup directory. To shut-down SCGI server, open window and press
Ctrl-C. To run SCGI server as NT service, check XYNTService.zip.

Cache

To improve performance, server implements data caching. Configuration options
are cache_request and cache_valid, both given in seconds.

cache_valid defines cache validity time. After cache expires, next read request
is performed by reading from CyBro.

cache_request defines time period in which no requests are sent to CyBro.
After this period, requests still return data from cache, then perform read
cycle to refresh cache.

                            read from cache,
     read from cache        send read request        read from CyBro
|-----------------------|-----------------------|----------------------->
0                 cache_request            cache_valid

Writing is performed independently of cache.

System variables (server level)

- sys.scgi_port_status
  - no response, server down
  - "active", scgi server active
- sys.scgi_request_count, total number of requests
- sys.scgi_request_pending, number of currently serving requests
- sys.server_uptime, "hh:mm:ss" or "dd days, hh:mm:ss", server uptime
- sys.push_port_status
  - "active"
  - "inactive", PushEnable is False
  - "error", port already used by another application
- sys.push_list_count, total number of controllers in push list
- sys.nad_list, list of currently available controllers (LAN+push+static):
  <data>
    <var>
      <name>sys.nad_list</name>
      <value>
        <item>1000</item>
        <item>6512</item>
        <item>9462</item>
      </value>
      <description>List of autodetected NADs.</description>
    </var>
  </data>
- sys.push_list, formated list of controllers in push list, together with
  status (nad, ip:port, plc status, plc program, alc file, response time)
- sys.cache_request, read request time [s]
- sys.cache_valid, cache valdity time [s]
- sys.server_version, returned as "major.minor.release"

System variables (CyBro level)

- c6512.sys.ip_port, returned as "xxx.xxx.xxx.xxx:yyyy"
- c6512.sys.timestamp, as read from plc_head.transfer
- c6512.sys.plc_status
- c6512.sys.plc_program_status
- c6512.sys.alc_file_status
- c6512.sys.response_time
- c6512.sys.bytes_transfered
- c6512.sys.alc_file, complete alc file, same as saved by CyPro

Command-line example

> cybro_com_server.py "c6512.scan_time&c6512.cybro_qx00"

<?xml version="1.0" encoding="ISO-8859-1"?>
<data>
   <var>
     <name>c6512.scan_time</name>
     <value>3</value>
     <description>Last scan execution time [ms].</description>
   </var>
   <var>
     <name>c6512.cybro_qx00</name>
     <value>0</value>
     <description>Relay output (0-open, 1-closed).</description>
   </var>
</data>

Always put command string within quotation marks.

--------------------------------------------------------------------------------