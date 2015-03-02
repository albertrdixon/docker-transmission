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
ENV TRANSMISSION_LOG            /dev/stderr
ENV OPENVPN_LOG                 /dev/stderr
ENV OPENVPN_GATEWAY             162.253.129.98
ENV OPENVPN_GATEWAY_PORT        1194
ENV OPENVPN_PROTO               udp
ENV OPENVPN_VERB                3
ENV DOWNLOAD_DIR                /downloads
ENV PEER_PORT                   51234
ENV RPC_PORT                    9091
ENV RPC_USERNAME                client
ENV RPC_PASSWORD                client
ENV RPC_AUTHENTICATION_REQUIRED true
ENV WATCH_DIR                   /torrents
ENV WATCH_DIR_ENABLED           false
ENV RATIO_LIMIT                 1
ENV RATIO_LIMIT_ENABLED         true
ENV DOWNLOAD_QUEUE_ENABLED      true
ENV DOWNLOAD_QUEUE_SIZE         3
ENV SEED_QUEUE_ENABLED          true
ENV SEED_QUEUE_SIZE             1
ENV QUEUE_STALLED_ENABLED       true
ENV QUEUE_STALLED_MINUTES       15
ENV SPEED_LIMIT_DOWN            100
ENV SPEED_LIMIT_DOWN_ENABLED    false
ENV SPEED_LIMIT_UP              24
ENV SPEED_LIMIT_UP_ENABLED      true
ENV UPLOAD_SLOTS_PER_TORRENT    3
ENV PEER_LIMIT_GLOBAL           130
ENV PEER_LIMIT_PER_TORRENT      78
ENV MESSAGE_LEVEL               1
ENV COMPLETED_SCRIPT_ENABLED    true