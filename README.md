# docker-cybroscgiserver
This is an docker container configuration for running the cybrotech scgi server in a docker container

The CyBroScgiServer is used for communicating with PLCs from Cybrotech Ltd.

## Contains

- CyBroScgiServer v2.3.0 from http://www.cybrotech.com/
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

- web requests with xml-answer: http://[ip]:4001/scgi/?
  Example: http://[ip]:4001/scgi/?sys.server_uptime -> returnes the ScgiServer Uptime
- SCGI socket requests (TCP): [ip]:4000
- Abus Push Messages (UDP): [ip]:8442
