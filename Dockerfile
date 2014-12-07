FROM debian:jessie
MAINTAINER Albert Dixon <albert@timelinelabs.com>

ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/bin:$PATH
ENV TRANSMISSION_HOME /transmission

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y transmission-common \
    transmission-daemon curl ca-certificates &&\
    apt-get remove -y --purge $(dpkg --get-selections | egrep "\-dev:?" | cut -f1) &&\
    apt-get autoclean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN bash -c "mkdir -p /transmission/{blocklists,resume,torrents}" &&\
    mkdir -p /transmission/downloads /downloads

COPY configs/settings.json /
COPY scripts/docker-start.sh /usr/local/bin/docker-start
RUN chmod 0755 /usr/local/bin/docker-start &&\
    chmod 0600 /settings.json &&\
    echo "net.core.rmem_max = 4194304" >> /etc/sysctl.conf &&\
    echo "net.core.wmem_max = 1048576" >> /etc/sysctl.conf

CMD ["docker-start"]
VOLUME ["/downloads"]