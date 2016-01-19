# Docker - Transmission

[![Docker Repository on Quay.io](https://quay.io/repository/albertrdixon/transmission/status "Docker Repository on Quay.io")](https://quay.io/repository/albertrdixon/transmission)

Just a small [Docker](http://www.docker.com) container running [Transmission](https://www.transmissionbt.com/) along with openvpn and [Private Internet Access](https://www.privateinternetaccess.com/). Includes [transmission web control](https://github.com/ronggang/transmission-web-control) as an alternative to the base transmission web ui.

Owes a huge debt of gratitude to the fabulous work done by [Scott Hansen](https://github.com/firecat53):
* [Transmission container](https://github.com/firecat53/dockerfiles/tree/master/transmission)
* [pia_transmission_monitor](https://github.com/firecat53/pia_transmission_monitor)

## Repos

[quay.io](http://quay.io): quay.io/albertrdixon/transmission

[docker](http://hub.docker.com): albertdixon/transmission

## Usage

You must, at minimum:
* Have a [Private Internet Access](https://www.privateinternetaccess.com/) account and provide your PIA username and password with the ENV vars `PIA_USER` and `PIA_PASS`.
* Run your container with `--priviledged` (not advised) or `--cap-add=NET_ADMIN`
* If you want to get to the web ui or the rpc interface you will need to proxy traffic to the container. Use something like jwilder's [nginx-proxy](https://github.com/jwilder/nginx-proxy) or roll your own.

```
$ docker -d --cap-add=NET_ADMIN \
    -e PIA_USER=username -e PIA_PASS=mypassword \
    -v /storage/tv_shows:/downloads \
    albertdixon/transmission start
```

Transmission and Openvpn will set their home dirs - where all their configs and things will be - to `/transmission` and `/transmission/openvpn` respectively. So, if you want to persist things, just mount a local volume or data container volume to `/transmission` 

You can also place custom config and openvpn files in the mounted volume and they will be respected. Transmission will look for `/transmission/settings.json` before creating it. Openvpn will look for `/transmission/openvpn/pia.ovpn`  before creating / copying it.

```
$ docker -d --cap-add=NET_ADMIN \
    -e PIA_USER=username -e PIA_PASS=mypassword \
    -v /path/to/transmission:/transmission \
    -v /storage/tv_shows:/downloads \
    albertdixon/transmission start
```

PIA cert and key are at `/certs/pia.crt` and `/certs/pia.pem`

Completed torrent script is at `/scripts/completed.sh`. Overwrite it with your own if you like!

## Env Vars

| Var Name | Default Value | Description |
|----------|---------------|-------------|
| `PIA_USER` | none | **REQUIRED** Your PIA login |
| `PIA_PASS` | none | **REQUIRED** Your PIA password |
| | |
| `CACHE_SIZE` | 50 | transmission cahce size in MB |
| `CLEAN_FREQUENCY` | 1800 | time in seconds between runs of torrent_cleaner.py |
| `COMPLETED_SCRIPT` | /scripts/completed.sh | script to run after torrent completed |
| `COMPLETED_SCRIPT_ENABLED` | false | enable a script to run on torrent completion |
| `CONGESTION` | lp | use this congestion algorithm. Set to '' to use none |
| `DOWNLOAD_DIR` | /downloads | default download directory |
| `DOWNLOAD_QUEUE_ENABLED` | true | enable download queue? |
| `DOWNLOAD_QUEUE_SIZE` | 3 | size of download queue |
| `ENABLE_CLEANER` | true | enable automatic stalled / finished removal? |
| `MESSAGE_LEVEL` | 1 | Transmission message level. (0: None, 1: Error, 2: Info, 3: Debug) |
| `OPEN_FILE_LIMIT` | 32768 | open file limit. Make sure you have done appropriate tuning in your host kernel. |
| `OPENVPN_GATEWAY` | ca-toronto.privateinternetaccess.com | PIA gateway server. This must be one with port forwarding enabled. [More information](https://www.privateinternetaccess.com/pages/client-support/) |
| `OPENVPN_GATEWAY_PORT` | 1194 | openvpn port. [More information](https://www.privateinternetaccess.com/pages/client-support/) |
| `OPENVPN_HOME` | /transmission/openvpn | openvpn home directory |
| `OPENVPN_LOG` | /dev/stderr | openvpn writes logs here |
| `OPENVPN_MUTE` | 20 | openvpn will suppress duplicate messages. |
| `OPENVPN_PROTO` | udp | openvpn protocol. [More information](https://www.privateinternetaccess.com/pages/client-support/) |
| `OPENVPN_VERB` | 3 | openvpn logging verbosity. [More information](https://openvpn.net/index.php/open-source/documentation/manuals/65-openvpn-20x-manpage.html) |
| `PATH` | /usr/local/bin:$PATH | obvious... |
| `PEER_LIMIT_GLOBAL` | 1200 | global peer limit |
| `PEER_LIMIT_PER_TORRENT` | 180 | peer limit per torrent |
| `PEER_PORT` | 51234 | initial peer port. This gets automatically updated by transmon |
| `QUEUE_STALLED_ENABLED` | true | enable stalled torrent queue? |
| `QUEUE_STALLED_MINUTES` | 5 | place torrent in stalled queue if inactive for this many minutes |
| `RATIO_LIMIT` | 1 | default ratio |
| `RATIO_LIMIT_ENABLED` | true | seed until torrent has reached the ratio limit? |
| `RPC_AUTHENTICATION_REQUIRED` | false | require RPC authentication? |
| `RPC_PASSWORD` | client | RPC password |
| `RPC_PORT` | 9091 | RPC port. If you change this make sure you expose the port. |
| `RPC_USERNAME` | client | RPC password |
| `SEED_QUEUE_ENABLED` | true | enable queue for seeding torrents |
| `SEED_QUEUE_SIZE` | 2 | seed queue size |
| `SPEED_LIMIT_DOWN` | 5000 | download speed limit  |
| `SPEED_LIMIT_DOWN_ENABLED` | false | enable download speed limit? |
| `SPEED_LIMIT_UP` | 400 | upload speed limit |
| `SPEED_LIMIT_UP_ENABLED` | true | enable upload speed limit? |
| `SUPERVISOR_LOG_LEVEL` | INFO | log level for supervisord |
| `TRANSMISSION_HOME` | /transmission | transmission home dir |
| `TRANSMISSION_LOG_LEVEL` | info | one of debug, info, error |
| `TRANSMISSION_WEB_HOME` | /web | custom transmission web interface. Attach your preferred one to this location (default is [transmission-web-control](https://github.com/ronggang/transmission-web-control)). Set this to '' for core transmission UI |
| `TRANSMISSION_UID` | 7000 | set to 0 to run transmission as root |
| `TRANSMISSION_GID` | 7000 | set to 0 to run transmission in the root group |
| `TRANSMON_LOG_LEVEL` | info | one of debug, info, warn, error, fatal |
| `UPLOAD_SLOTS_PER_TORRENT` | 14 | upload slots per torrent |
| `WATCH_DIR` | /torrents | watch dir for .torrent files |
| `WATCH_DIR_ENABLED` | false | enable watch dir? |
