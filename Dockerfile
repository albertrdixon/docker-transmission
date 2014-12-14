FROM ubuntu:utopic
MAINTAINER Albert Dixon <albert@timelinelabs.com>

ENV DEBIAN_FRONTEND noninteractive
ENV PATH /root/bin:$PATH

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y unzip openvpn software-properties-common \
    transmission-daemon gettext-base curl python3 anytun &&\
    apt-get autoremove -y && apt-get autoclean -y &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN bash -c "mkdir -p /config/{transmission,openvpn} /config/transmission/{blocklists,resume,torrents,downloads} /downloads"

COPY configs/* /templates/
COPY scripts/* /root/bin/
RUN chmod 755 /root/bin/docker-start &&\
    chmod 755 /root/bin/pia_transmission_monitor

WORKDIR /
ENTRYPOINT ["docker-start"]
VOLUME ["/downloads"]
EXPOSE 9091 51234

ENV TRANSMISSION_HOME           /config/transmission
ENV OPENVPN_HOME                /config/openvpn
ENV OPENVPN_GATEWAY             pia_ca_north
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