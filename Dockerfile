FROM alpine:3.2
MAINTAINER Albert Dixon <albert.dixon@schange.com>

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update
RUN apk add bash openvpn transmission-daemon transmission-cli \
    faenza-icon-theme-transmission supervisor py-six \
    ca-certificates
ADD https://bootstrap.pypa.io/get-pip.py /gp.py
RUN python /gp.py \
    && rm -f /gp.py \
    && pip install -U transmissionrpc>=0.11

ADD https://github.com/albertrdixon/tmplnator/releases/download/v2.2.0/t2-linux.tgz /t2.tgz
RUN tar xvzf /t2.tgz -C /usr/local \
    && ln -s /usr/local/bin/t2-linux /usr/local/bin/t2 \
    && rm -f /t2.tgz

ADD bashrc      /root/.bashrc
ADD configs     /templates
ADD ssl         /ssl
ADD scripts/*   /usr/local/bin/
RUN chmod a+rx  /usr/local/bin/*
RUN bash -c "mkdir -p /downloads/{movies,tv_shows} /etc/pia_transmission_monitor" &&\
    bash -c "mkdir -p /transmission/{blocklists,resume,torrents,downloads,openvpn}"

WORKDIR /
ENTRYPOINT ["docker-entry"]
VOLUME ["/downloads"]
EXPOSE 9091

ENV CLEAN_FREQUENCY             1800
ENV COMPLETED_SCRIPT_ENABLED    false
ENV DOWNLOAD_DIR                /downloads
ENV DOWNLOAD_QUEUE_ENABLED      true
ENV DOWNLOAD_QUEUE_SIZE         3
ENV ENABLE_CLEANER              true
ENV LOGDIR                      /logs
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
ENV PEER_LIMIT_GLOBAL           130
ENV PEER_LIMIT_PER_TORRENT      78
ENV PEER_PORT                   51234
ENV QUEUE_STALLED_ENABLED       true
ENV QUEUE_STALLED_MINUTES       10
ENV RATIO_LIMIT                 1
ENV RATIO_LIMIT_ENABLED         true
ENV RPC_AUTHENTICATION_REQUIRED true
ENV RPC_PASSWORD                client
ENV RPC_PORT                    9091
ENV RPC_USERNAME                client
ENV SEED_QUEUE_ENABLED          true
ENV SEED_QUEUE_SIZE             1
ENV SPEED_LIMIT_DOWN            100
ENV SPEED_LIMIT_DOWN_ENABLED    false
ENV SPEED_LIMIT_UP              24
ENV SPEED_LIMIT_UP_ENABLED      true
ENV SUPERVISOR_LOG_LEVEL        INFO
ENV TRANSMISSION_HOME           /transmission
ENV TRANSMISSION_LOG            /dev/stderr
ENV UPLOAD_SLOTS_PER_TORRENT    3
ENV WATCH_DIR                   /torrents
ENV WATCH_DIR_ENABLED           false
