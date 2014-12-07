#!/bin/sh
set -e
trap "exit 0" 2 15
run_cmd() {
  exec $*
}

: ${DOWNLOAD_DIR:=/downloads}
: ${WATCH_DIR:=/torrents}
: ${USERNAME:="client"}
: ${PASSWORD:=""}
: ${RPC_PORT:="9091"}
: ${PEER_PORT:="51234"}

test -d $DOWNLOAD_DIR || mkdir -p $DOWNLOAD_DIR
test -d $WATCH_DIR || mkdir -p $WATCH_DIR

if test -n "$ENABLE_WATCH"; then
  EXTRA_OPTS="-c $WATCH_DIR"
else
  EXTRA_OPTS=""
fi

test -f "$TRANSMISSION_HOME/settings.json" || cp /settings.json "$TRANSMISSION_HOME/"
sed -i "s|__password__|$PASSWORD|" "$TRANSMISSION_HOME/settings.json"
sed -i "s|__username__|$USERNAME|" "$TRANSMISSION_HOME/settings.json"
sed -i "s|__rpc_port__|$RPC_PORT|" "$TRANSMISSION_HOME/settings.json"
sed -i "s|__peer_port__|$PEER_PORT|" "$TRANSMISSION_HOME/settings.json"
run_cmd "transmission-daemon -f -e /dev/stdout $EXTRA_OPTS"