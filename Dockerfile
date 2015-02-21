FROM debian:jessie
MAINTAINER Albert Dixon <albert@timelinelabs.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install --no-install-recommends -y --force-yes \
    unar openvpn transmission-daemon transmission-remote-cli \
    transmission-cli curl supervisor python3
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -#kL https://github.com/jwilder/dockerize/releases/download/v0.0.2/dockerize-linux-amd64-v0.0.2.tar.gz |\
    tar xvz -C /usr/local/bin

COPY configs /templates
COPY scripts/* /usr/local/bin/
RUN chmod a+rx /usr/local/bin/*
RUN bash -c "mkdir /downloads /etc/pia_transmission_monitor" &&\
    bash -c "mkdir -p /transmission/{blocklists,resume,torrents,downloads,openvpn}"

WORKDIR /
ENTRYPOINT ["docker-entry"]
VOLUME ["/downloads"]
EXPOSE 9091

ENV SUPERVISOR_LOG_LEVEL        INFO
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