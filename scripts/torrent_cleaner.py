#!/usr/bin/env python
import transmissionrpc
import logging
import sys
from getopt import getopt
from threading import Thread, Event
from time import sleep


class TorrentCleanerThread(Thread):
  """Really naive transmission torrent cleaner"""
  def __init__(self, host="127.0.0.1", port=9091, ratio=1.0, logger=logging.getLogger()):
    super(TorrentCleanerThread, self).__init__()
    self._clean = Event()
    self._quit = Event()
    self.host = host
    self.port = port
    self.ratio = ratio
    self.log = logger
    self.finished = False
    self.client = None
    self.torrents = {}

  def clean(self):
    self._clean.set()

  def stop(self):
    self._quit.set()
    self._clean.set()
    self.finished = True

  def should_quit(self):
    if self._quit.is_set():
      self.log.info("Cleaner shutting down")
      exit(0)

  def run(self):
    while not self._quit.is_set():
      self.log.info("Waiting for 'clean' event")
      self._clean.wait()
      self.should_quit()

      self.log.info("Running torrent cleaner")
      self.finished = False

      for i in range(1, 5):
        self.should_quit()
        if self.finished:
         break
        self.log.debug("Clean attempt #{}.".format(i))
        try:
          self.log.debug("Acquiring client.")
          self.client = self.client or transmissionrpc.Client(self.host, port=self.port)
          self.log.debug("Getting list of torrents.")
          torrents = self.client.get_torrents()
          t_ids = [i.id for i in torrents]
          for rm in [t for t in self.torrents if t not in t_ids]:
            self.log.info("Removing '{}' from torrent list".format(self.torrents[rm]["name"]))
            self.torrents.pop(rm, None)
          if not torrents:
            self.log.info("No torrents to process!")
            self.finished = True
          else:
            for torrent in torrents:
              self.should_quit()
              if torrent.id not in self.torrents:
                self.torrents[torrent.id] = {"name": torrent.name, "reason": "", "strikes": 0}
              t = self.torrents[torrent.id]
              if torrent_finished(torrent, self.ratio):
                self.log.info("Torrent #{} ('{}') reporting finished.".format(torrent.id, torrent.name))
                t["strikes"] += 1
                t["reason"] = "finished (Done: {}, Ratio: {})".format(torrent.isFinished, torrent.ratio)
              elif torrent_stalled(torrent):
                self.log.info("Torrent #{} ('{}') reporting stalled.".format(torrent.id, torrent.name))
                t["strikes"] += 1
                t["reason"] = "stalled (Stalled: {}, Status: {})".format(torrent.isStalled, torrent.status)
              self.torrents[torrent.id] = t
              if t["strikes"] >= 2:
                self.log.info("Torrent #{} ('{}') being removed because it is {}".format(torrent.id, torrent.name, t["reason"]))
                self.client.remove_torrent(torrent.id, delete_data=True)
                self.torrents.pop(torrent.id, None)
              else:
                self.log.info("Torrent #{} ('{}') is still active (Progress: {}%, Ratio: {})".format(torrent.id, torrent.name, torrent.progress, torrent.ratio))
            else:
              self.finished = True
        except Exception, e:
          self.log.error("ERROR: {}".format(e))
          if i < 4:
            sleep(i * 3)
          continue
      self.log.info("Cleaning run complete!")
      self.client = None
      self._clean.clear()
    self.should_quit()


def torrent_finished(torrent, ratio):
  done = False
  if torrent.isFinished:
    done = True
  elif torrent.progress >= 100 and torrent.ratio >= ratio:
    done = True
  return done


def torrent_stalled(torrent):
  stalled = False
  if torrent.isStalled:
    stalled = True
  elif torrent.status == "stopped":
    stalled = True
  return stalled


def main(argv):
  usage = "torrent_cleaner.py -H <transmission_host> [ -p <transmission_port> ] [ -f <clean_frequency_in_seconds> ] [ -r <ratio_limit> ]"
  host, port, frequency, ratio, debug = None, 9091, 3600, 1.0, False
  opts, args = getopt(argv, "hdH:p:f:r:", ["host=", "port=", "frequency=", "ratio="])
  for opt, arg in opts:
    if opt == '-h':
      print(usage)
      sys.exit(2)
    elif opt == '-d':
      debug = True
    elif opt in ('-H', '--host'):
      host = arg
    elif opt in ('-p', '--port'):
      try:
        port = int(arg)
      except:
        print("Expected int for port, using default.")
    elif opt in ('-f', '--frequency'):
      try:
        frequency = int(arg)
      except:
        print("Expected int for frequency, using default.")
    elif opt in ('-r', '--ratio'):
      try:
        ratio = float(arg)
      except:
        print("Expected float for ratio, using default.")

  if host is None:
    print("Must specify transmission host!")
    print(usage)
    sys.exit(1)

  level = logging.INFO
  if debug:
    level = logging.DEBUG
  log = logging.getLogger("torrent_cleaner")
  log.setLevel(level)

  ch = logging.StreamHandler(sys.stdout)
  ch.setLevel(level)
  formatter = logging.Formatter('[%(asctime)s] [%(module)s] %(levelname)s: %(message)s', datefmt='%d/%m/%Y %H:%M:%S')
  ch.setFormatter(formatter)
  log.addHandler(ch)
  logging.getLogger('transmissionrpc').setLevel(level)

  log.info("Cleaner started against {}:{}".format(host, port))
  log.info("Will try to clean every {} minutes".format((frequency / 60)))
  cleaner = TorrentCleanerThread(host=host, port=port, ratio=ratio, logger=log)
  cleaner.start()

  try:
    while True:
      sleep(frequency)
      cleaner.clean()
  except (KeyboardInterrupt, SystemExit):
    log.info("Caught interrupt, quitting")
    cleaner.stop()
    sys.exit()


if __name__ == "__main__":
  main(sys.argv[1:])
