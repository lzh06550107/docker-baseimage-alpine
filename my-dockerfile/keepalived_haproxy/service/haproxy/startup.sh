#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

if [ ! -e "/usr/local/etc/haproxy/haproxy.cfg" ]; then
  ln -sf ${CONTAINER_SERVICE_DIR}/haproxy/assets/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
fi

rm -f /run/haproxy.pid || true

exit 0
