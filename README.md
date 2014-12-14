# Docker - Transmission

[![Docker Repository on Quay.io](https://quay.io/repository/albertrdixon/transmission/status "Docker Repository on Quay.io")](https://quay.io/repository/albertrdixon/transmission)

A minimal debian based [Docker](http://www.docker.com) container running [Transmission](https://www.transmissionbt.com/) along with openvpn and [Private Internet Access](https://www.privateinternetaccess.com/).

Shamelessly steals from the fabulous work done by [Scott Hansen](https://github.com/firecat53):
* [Transmission container](https://github.com/firecat53/dockerfiles/tree/master/transmission)
* [pia_transmission_monitor](https://github.com/firecat53/pia_transmission_monitor)

## Repos

[quay.io](http://quay.io): quay.io/albertrdixon/transmission

[docker](http://hub.docker.com): albertdixon/transmission

## Usage

You must, at minimum:
* Have a [Private Internet Access](https://www.privateinternetaccess.com/) account and provide your PIA username and password with the ENV vars `PIA_USER` and `PIA_PASS`.
* Set a static IP for your container. I use other strategies, but feel free to alter the project to use [pipework](https://github.com/jpetazzo/pipework) or whatever new hotness strategy you desire.
* Run your container with `--priviledged` or `--cap-add=NET_ADMIN`

```
$ docker -d --cap-add=NET_ADMIN -e PIA_USER=username -e PIA_PASS=mypassword -v /storage/tv_shows:/downloads albertdixon/transmission docker-start
```

`TRANSMISSION_HOME` is set to /transmission

If you want Transmission config and state to persist, then mount a volume to /transmission. If a `settings.json` is found in `$TRANSMISSION_HOME` then it will use that, otherwise it will copy over the `settings.json` from the container.

```
$ docker -d --cap-add=NET_ADMIN -e PASSWORD=1234 -v /path/to/transmission:/transmission -v /storage/tv_shows:/downloads albertdixon/transmission docker-start
```

## Env Vars

| Var Name | Default Value | Description |
|----------|---------------|-------------|
| `PIA_USER` | none | Your PIA login |
| `PIA_PASS` | none | Your PIA password |
| `DOWNLOAD_DIR` | /downloads | Default torrent download dir |
| `MESSAGE_LEVEL` | 1 | Transmission message level. (0 = None, 1 = Error, 2 = Info, 3 = Debug, default = 2) |
| `OPENVPN_GATEWAY` | pia_ca_north | PIA gateway server |
| `PEER_LIMIT_GLOBAL` | 1200 | Global peer limit |
| `PEER_LIMIT_PER_TORRENT` | 180 | Peer limit per torrent |
| `PEER_PORT` | 51234 | Peer port |
| `RPC_AUTHENTICATION_REQUIRED` | true | Is authentication required? |
| `RPC_PASSWORD` | client | Password for RPC connections |
| `RPC_PORT` | 9091 | Transmission's RPC port |
| `RPC_USERNAME` | client | Username for RPC connections |
| `SPEED_LIMIT_DOWN` | 100 | Download speed limit |
| `SPEED_LIMIT_DOWN_ENABLED` | false | Enable download speed limiting? |
| `SPEED_LIMIT_UP` | 3200 | Upload speed limit |
| `SPEED_LIMIT_UP_ENABLED` | true | Enable upload speed limiting? |
| `TRANSMISSION_HOME` | /transmission | Transmission's home dir |
| `WATCH_DIR` | /torrents | Directory to watch for .torrent files |
| `WATCH_DIR_ENABLED` | false | Is watch dir enabled? |
