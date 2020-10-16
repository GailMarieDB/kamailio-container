FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Toronto

RUN apt-get update -y \
        && apt-get install git-core gcc g++ flex bison libmysqlclient-dev make autoconf pkg-config libssl-dev libcurl4-openssl-dev libxml2-dev libpcre3-dev tzdata iproute2 -y \
        && apt-get install mysql-server -y \
        && apt-get install systemctl -y

RUN mkdir -p /usr/local/src/kamailio-5.4 \
        && cd /usr/local/src/kamailio-5.4 \
        && git clone --depth 1 --no-single-branch https://github.com/kamailio/kamailio kamailio \
        && cd kamailio \
        && git checkout -b 5.4 origin/5.4 \
        && make include_modules="db_mysql outbound stun" cfg \
        && make all \
        && make install \
        && cp -r pkg/ src/ \
        && make install-initd-debian

RUN apt-get install build-essential git cmake -y \
        && cd /usr/local/src \
        && git clone -b master https://github.com/sippy/rtpproxy.git \
        && git -C rtpproxy submodule update --init --recursive \
        && cd rtpproxy \
        && ./configure \
        && make clean all \
        && make install

COPY ["startup.sh", "kamailio-mode-1.cfg", "kamailio-mode-2.cfg", "kamailio-mode-3.cfg", "rtpproxy", "/opt/"]

RUN chmod +x /opt/startup.sh

RUN PATH=$PATH:/usr/local/sbin \
        && export PATH

ENTRYPOINT [ "/opt/startup.sh" ]
