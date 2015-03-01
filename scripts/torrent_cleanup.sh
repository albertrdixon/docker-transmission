#!/bin/bash
set -eo pipefail
function cleanup { exec 1>&6 6>&-; }
trap cleanup EXIT

exec 6>&1
exec >/dev/stderr

NETRC=/root/.netrc

function download_complete {
  if [ -n "$(transmission-remote -N $NETRC -t $1 -i | grep 'Percent Done: 100%')" ]; then
    return 0
  else
    return 1
  fi
}

function seeding_complete {
  if [ -n "$(transmission-remote -N $NETRC -t $1 -i | grep 'Status: Finished')" ]; then
    return 0
  else
    return 1
  fi
}

function main {
  for ID in $(transmission-remote -N $NETRC -l | sed -e '1d;$d;s/^ *//' | awk '{print $1}')
  do
    echo "==> Working on torrent #$ID"
    if download_complete "$ID"; then
      echo "==> Checking seeding status for torrent #$ID."
      if seeding_complete "$ID"; then
        echo "==> Torrent #$ID is indeed finished. Removing it..."
        transmission-remote -N $NETRC -t $ID --remove-and-delete
        echo "==> All done with torrent #$ID."
      else
        echo "==> Torrent #$ID is still seeding. Skipping."
      fi
    else
      echo "==> Torrent #$ID is not complete. Skipping."
    fi
  done
}

echo "==> Running torrent_cleanup.sh."
main
exit 0