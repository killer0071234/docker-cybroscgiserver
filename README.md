# docker-cybroscgiserver
This is an docker container configuration for running the cybrotech scgi server in a docker container

The CyBroScgiServer is used for communicating with PLCs from Cybrotech Ltd.
Supported PLCs:
- CyBro-2
- CyBro-3

## Contains

- Python 3.8.8 required for CyBroScgiServer
- CyBroScgiServer v3.1.1 from http://www.cybrotech.com/
- mySQL-Logging

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

For detailed usage / valid system tags check http://[ip]:4001/data/Readme.txt

- web requests to SCGI socket with xml-answer: http://[ip]:4000/?
  Example: http://[ip]:4000/?sys.server_uptime -> returnes the ScgiServer Uptime
- Abus Push Messages (UDP): [ip]:8442

The configuration file for the scgi server can be found under:
./cybroscgiserver/config/config.ini

To apply a new configuration, you need to restart the docker container