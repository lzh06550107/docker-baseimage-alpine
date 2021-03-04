#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

echo -n "Waiting config file /usr/local/etc/haproxy/haproxy.cfg"
while [ ! -e "/usr/local/etc/haproxy/haproxy.cfg" ]
do
  echo -n "."
  sleep 0.1
done
echo "ok"

exec /usr/local/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg
