FROM debian:jessie
MAINTAINER Albert Dixon <albert.dixon@schange.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install --no-install-recommends -y --force-yes \
    openvpn transmission-daemon transmission-remote-cli \
    transmission-cli curl locales python supervisor \
    && curl -#kL https://bootstrap.pypa.io/get-pip.py | python

RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

ADD requirements.txt requirements.txt
RUN venv/bin/pip install -r requirements.txt && rm requirements.txt

RUN curl -#kL https://github.com/albertrdixon/tmplnator/releases/download/v2.1.0/tnator-linux-amd64.tar.gz |\
    tar xvz -C /usr/local/bin

RUN apt-get autoremove -y && apt-get autoclean -y &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
