# Kamailio in Docker

## Prerequisites:

- `docker`
- `docker-compose`


## Configuration 

### Deploy modes

1 - SIP Load Balancer  
2 - SIP Load Balancer + SIP Proxy  
3 - SIP Load Balancer + SIP Proxy + RTP Proxy

Set your preferred deploy mode using the `DEPLOY_MODE` environment variable in `docker-compose.yml`

### UAS Endpoints

Set your UAS endpoints as a space-delimited list using the `UAS_ENDPOINTS` environment variable in `docker-compose.yml`

### Optional environment variables

- SIP_DOMAIN: Set it to your IP/Domain where Kamailio is running

- DISPATCHER_PING_FROM: Set it to the SIP URI you want to use in the `From` header in OPTIONS messages


## Build and deploy container

Run the following command in the `/docker` directory to build and deploy `kamailio` container

`docker build -t kamailio . && docker-compose up -d`


## Stop the container


Run the following command in the `/docker` directory to stop `kamailio` container

`docker-compose down`