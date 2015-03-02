#!/bin/bash
set -eo pipefail
exec >/dev/stderr

NETRC=/root/.netrc

echo "==> Torrent ID $TR_TORRENT_ID ought to be done."
if [ -n "$(transmission-remote --netrc $NETRC --torrent $TR_TORRENT_ID --info | grep "Percent Done: 100%")" ]; then
  echo "==> $TR_TORRENT_ID is indeed finished, removing it..."
  transmission-remote --netrc $NETRC --torrent $TR_TORRENT_ID --remove
else
  echo "==> $TR_TORRENT_ID is not actually done. wtf?"
fi
