FROM alpine:3.3
MAINTAINER Albert Dixon <albert.dixon@schange.com>

ENTRYPOINT ["tini", "-g","--", "docker-entry"]
CMD ["docker-start"]
EXPOSE 9091

ADD https://github.com/albertrdixon/tmplnator/releases/download/v2.2.1/t2-linux.tgz /t2.tgz
ADD https://github.com/albertrdixon/transmon/releases/download/v0.1.0/transmon-linux.tgz /transmon.tgz
ADD https://github.com/ronggang/transmission-web-control/raw/master/release/transmission-control-full.tar.gz /web.tgz
ADD https://www.privateinternetaccess.com/openvpn/openvpn.zip /

COPY bashrc      /root/.bashrc
COPY configs     /templates
COPY scripts/*   /usr/local/bin/

WORKDIR /
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add \
      bash \
      ca-certificates \
      openvpn \
      py-pip \
      py-six \
      python \
      supervisor \
      tar \
      tini \
      transmission-cli \
      transmission-daemon \
      unzip \
    && mkdir -vp \
      /certs \
      /etc/pia_transmission_monitor \
      /openvpn \
      /transmission/openvpn \
      /web \
    && pip install -U transmissionrpc>=0.11 \
    && tar xvzf /t2.tgz -C /bin \
    && tar xvzf /transmon.tgz -C /bin \
    && tar xvzf /web.tgz -C /web --strip-components=1 \
    && unzip -Lj /openvpn.zip ca.crt crl.pem -d /openvpn \
    && mv -vf /openvpn/ca.crt /certs/pia.crt \
    && mv -vf /openvpn/crl.pem /certs/pia.pem \
    && chmod a+rx /usr/local/bin/* \
    && deluser transmission \
    && rm -rvf /openvpn* /*.tgz

ENV CACHE_SIZE=50 \
    CLEAN_FREQUENCY=1800 \
    COMPLETED_SCRIPT_ENABLED=false \
    CONGESTION=lp \
    DOWNLOAD_DIR=/downloads \
    DOWNLOAD_QUEUE_ENABLED=true \
    DOWNLOAD_QUEUE_SIZE=3 \
    ENABLE_CLEANER=true \
    IDLE_SEEDING_LIMIT=10 \
    MESSAGE_LEVEL=1 \
    OPEN_FILE_LIMIT=32768 \
    OPENVPN_GATEWAY=ca-toronto.privateinternetaccess.com \
    OPENVPN_GATEWAY_PORT=1194 \
    OPENVPN_HOME=/transmission/openvpn \
    OPENVPN_LOG=/dev/stderr \
    OPENVPN_MUTE=20 \
    OPENVPN_PROTO=udp \
    OPENVPN_VERB=3 \
    PATH=/usr/local/bin:$PATH \
    PEER_LIMIT_GLOBAL=1200 \
    PEER_LIMIT_PER_TORRENT=180 \
    PEER_PORT=51234 \
    QUEUE_STALLED_ENABLED=true \
    QUEUE_STALLED_MINUTES=5 \
    RATIO_LIMIT=1 \
    RATIO_LIMIT_ENABLED=true \
    RPC_AUTHENTICATION_REQUIRED=false \
    RPC_PASSWORD=client \
    RPC_PORT=9091 \
    RPC_USERNAME=client \
    SEED_QUEUE_ENABLED=true \
    SEED_QUEUE_SIZE=2 \
    SPEED_LIMIT_DOWN=5000 \
    SPEED_LIMIT_DOWN_ENABLED=false \
    SPEED_LIMIT_UP=400 \
    SPEED_LIMIT_UP_ENABLED=true \
    SUPERVISOR_LOG_LEVEL=INFO \
    TRANSMISSION_HOME=/transmission \
    TRANSMISSION_LOG=/dev/stderr \
    TRANSMISSION_WEB_HOME=/web \
    TRANSMISSION_UID=7000 \
    TRANSMISSION_GID=7000 \
    UPLOAD_SLOTS_PER_TORRENT=14 \
    WATCH_DIR=/torrents \
    WATCH_DIR_ENABLED=false
