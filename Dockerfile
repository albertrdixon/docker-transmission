FROM debian:jessie
MAINTAINER Albert Dixon <albert@timelinelabs.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y unzip openvpn software-properties-common \
    transmission-daemon transmission-remote-cli transmission-cli curl supervisor \
    python3 python python-dev python-pip build-essential &&\
    pip install envtpl &&\
    apt-get remove --purge -y build-essential python-dev &&\
    apt-get autoremove -y && apt-get autoclean -y &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY configs /templates
COPY scripts/* /usr/local/bin/
RUN chmod a+rx /usr/local/bin/*
RUN mkdir /downloads

WORKDIR /
ENTRYPOINT ["docker-start"]
VOLUME ["/downloads"]
EXPOSE 9091 51234

ENV PATH                        /usr/local/bin:$PATH
ENV LOGDIR                      /logs
ENV TRANSMISSION_HOME           /transmission
ENV OPENVPN_HOME                /transmission/openvpn
ENV OPENVPN_GATEWAY             162.253.129.98
ENV OPENVPN_GATEWAY_PORT        1194
ENV OPENVPN_PROTO               udp
ENV SPEED_LIMIT_DOWN            100
ENV SPEED_LIMIT_DOWN_ENABLED    false
ENV DOWNLOAD_DIR                /downloads
ENV PEER_PORT                   51234
ENV RPC_PORT                    9091
ENV RPC_USERNAME                client
ENV RPC_PASSWORD                client
ENV RPC_AUTHENTICATION_REQUIRED true
ENV WATCH_DIR                   /torrents
ENV WATCH_DIR_ENABLED           false
ENV SPEED_LIMIT_DOWN            100
ENV SPEED_LIMIT_DOWN_ENABLED    false
ENV SPEED_LIMIT_UP              3200
ENV SPEED_LIMIT_UP_ENABLED      true
ENV PEER_LIMIT_GLOBAL           1200
ENV PEER_LIMIT_PER_TORRENT      180
ENV MESSAGE_LEVEL               2