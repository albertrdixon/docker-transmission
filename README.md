# Docker - Transmission

A minimal debian based [Docker](http://www.docker.com) container running [Transmission](https://www.transmissionbt.com/).

## Repos

[quay.io](http://quay.io): quay.io/albertrdixon/transmission

[docker](http://hub.docker.com): albertdixon/transmission

## Usage

env vars:
  * `USERNAME`:     rpc_username, default=client
  * `PASSWORD`:     rpc_password, default='' (blank)
  * `RPC_PORT`:     rpc_port, default=9091
  * `PEER_PORT`:    peer port, default=51413
  * `DOWNLOAD_DIR`: completed torrents go here, default=/downloads
  * `WATCH_DIR`:    watch for .torrent files, default=/torrents

```
$ docker -d -p 9000:9000 -e RPC_PORT=9000 -e USERNAME=me -e PASSWORD=mypassword -v /storage/tv_shows:/downloads docker-start
```