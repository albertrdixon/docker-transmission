FROM debian:jessie
MAINTAINER Albert Dixon <albert@timelinelabs.com>

ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/bin:$PATH

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y transmission \
    transmission-daemon ca-certificate &&\
    apt-get remove -y --purge $(dpkg --get-selections | egrep "\-dev:?" | cut -f1) &&\
    apt-get autoclean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN bash -c "mkdir -p /root/.config/transmission-daemon/{blocklists,resume,torrents}" &&\
    mkdir -p /root/Downloads /downloads

COPY configs/settings.json /root/.config/transmission-daemon/
COPY scripts/docker-start.sh /usr/local/bin/docker-start
RUN chmod 0755 /usr/local/bin/docker-start &&\
    chmod 0600 /root/.config/transmission-daemon/settings.json

CMD ["docker-start"]
VOLUME ["/downloads"]