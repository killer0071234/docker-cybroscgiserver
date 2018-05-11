# docker-cybroscgiserver
This is an docker container configuration for running the cybrotech scgi server on an docker container

The CyBroScgiServer is used for communicating with PLC from Cybrotech Ltd.

This docker container is in an early release state!! Use it at your own risk!

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

- SCGI-web requests: http://[ip]:4001/scgi/
- SCGI socket requests (TCP): [ip]:4000
- Abus Push Messages (UDP): [ip]:8442
