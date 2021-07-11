# docker-cybroscgiserver
This is an docker container configuration for running the cybrotech scgi server in a docker container

The CyBroScgiServer is used for communicating with PLCs from Cybrotech Ltd.
Supported PLCs:
- CyBro-2
- CyBro-3

## Contains

- latest Python 3.8 required for CyBroScgiServer
- CyBroScgiServer v3.1.1 from http://www.cybrotech.com/ (directly loaded from cybrotech.com)
- mySQL-Logging (currently disabled)

## Requirements

- Docker
- Docker-Compose

## Install

```
git clone https://github.com/killer0071234/docker-cybroscgiserver.git docker-cybroscgiserver
cd docker-cybroscgiserver
docker-compose up -d
```

## Usage

For detailed usage / valid system tags check the readme of CyBroScgiServer-v3.1.1.zip under
http://www.cybrotech.com/software-category/tools/

- web requests to SCGI socket with xml-answer: http://[ip]:4000/?
  Example: http://[ip]:4000/?sys.server_uptime -> returns the ScgiServer Uptime
- Abus Push Messages (UDP) from the PLC: [ip]:8442

The configuration file for the scgi server can be found under:
./cybroscgiserver/config/config.ini

For a own configuration mount the config.ini file to:
/usr/local/bin/scgi_server/config.ini
