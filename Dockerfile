FROM ubuntu:utopic
MAINTAINER Albert Dixon <albert@timelinelabs.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y unzip openvpn software-properties-common \
    transmission-daemon transmission-remote-cli transmission-cli gettext-base curl python3 anytun &&\
    apt-get autoremove -y && apt-get autoclean -y &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://github.com/jpetazzo/pipework/archive/master.zip /pipework.zip
RUN unzip pipework.zip && rm pipework.zip &&\
    cp pipework-master/pipework /usr/local/bin/pipework &&\
    chmod a+x /usr/local/bin/pipework

COPY configs /templates
COPY scripts/* /usr/local/bin/
RUN chmod a+rx /usr/local/bin/*

WORKDIR /
ENTRYPOINT ["docker-start"]
VOLUME ["/downloads"]
EXPOSE 9091 51234

ENV PATH                        /usr/local/bin:$PATH
ENV TRANSMISSION_HOME           /transmission
ENV OPENVPN_HOME                /transmission/openvpn
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