FROM alpine:3.2
MAINTAINER Albert Dixon <albert.dixon@schange.com>

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update
RUN apk add \
      bash \
      ca-certificates \
      openvpn \
      py-pip \
      py-six \
      python \
      supervisor \
      tar \
      transmission-cli \
      transmission-daemon \
    && pip install -U transmissionrpc>=0.11

ADD https://github.com/albertrdixon/tmplnator/releases/download/v2.2.0/t2-linux.tgz /t2.tgz
RUN tar xvzf /t2.tgz -C /usr/local \
    && ln -s /usr/local/bin/t2-linux /usr/local/bin/t2 \
    && rm -f /t2.tgz

ADD bashrc      /root/.bashrc
ADD configs     /templates
ADD certs       /certs
ADD scripts/*   /usr/local/bin/
RUN chmod a+rx  /usr/local/bin/* \
    && mkdir -p /etc/pia_transmission_monitor \
        /transmission/openvpn \
        /web

ADD https://github.com/ronggang/transmission-web-control/raw/master/release/transmission-control-full.tar.gz /web.tgz
RUN tar xzf /web.tgz -C /web --strip-components=1 \
    && rm -f /web.tgz

WORKDIR /
ENTRYPOINT ["docker-entry"]
CMD ["docker-start"]
EXPOSE 9091

ENV CACHE_SIZE                  50
ENV CLEAN_FREQUENCY             1800
ENV COMPLETED_SCRIPT_ENABLED    false
ENV CONGESTION                  lp
ENV DOWNLOAD_DIR                /downloads
ENV DOWNLOAD_QUEUE_ENABLED      true
ENV DOWNLOAD_QUEUE_SIZE         3
ENV ENABLE_CLEANER              true
ENV IDLE_SEEDING_LIMIT          10
ENV MESSAGE_LEVEL               1
ENV OPEN_FILE_LIMIT             32768
ENV OPENVPN_GATEWAY             ca-toronto.privateinternetaccess.com
ENV OPENVPN_GATEWAY_PORT        1194
ENV OPENVPN_HOME                /transmission/openvpn
ENV OPENVPN_LOG                 /dev/stderr
ENV OPENVPN_MUTE                20
ENV OPENVPN_PROTO               udp
ENV OPENVPN_VERB                3
ENV PATH                        /usr/local/bin:$PATH
ENV PEER_LIMIT_GLOBAL           1200
ENV PEER_LIMIT_PER_TORRENT      180
ENV PEER_PORT                   51234
ENV QUEUE_STALLED_ENABLED       true
ENV QUEUE_STALLED_MINUTES       5
ENV RATIO_LIMIT                 1
ENV RATIO_LIMIT_ENABLED         true
ENV RPC_AUTHENTICATION_REQUIRED false
ENV RPC_PASSWORD                client
ENV RPC_PORT                    9091
ENV RPC_USERNAME                client
ENV SEED_QUEUE_ENABLED          true
ENV SEED_QUEUE_SIZE             2
ENV SPEED_LIMIT_DOWN            5000
ENV SPEED_LIMIT_DOWN_ENABLED    false
ENV SPEED_LIMIT_UP              400
ENV SPEED_LIMIT_UP_ENABLED      true
ENV SUPERVISOR_LOG_LEVEL        INFO
ENV TRANSMISSION_HOME           /transmission
ENV TRANSMISSION_LOG            /dev/stderr
ENV TRANSMISSION_WEB_HOME       /web
ENV UPLOAD_SLOTS_PER_TORRENT    14
ENV WATCH_DIR                   /torrents
ENV WATCH_DIR_ENABLED           false
