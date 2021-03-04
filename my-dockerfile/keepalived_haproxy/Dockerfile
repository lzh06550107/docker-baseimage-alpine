# Use osixia/light-baseimage
# sources: https://github.com/osixia/docker-light-baseimage
FROM osixia/light-baseimage:alpine-0.1.8

# Keepalived version
ARG KEEPALIVED_VERSION=2.0.20
ARG HAPROXY_VERSION=2.3.5

# Download, build and install Keepalived
RUN apk update \
    && /container/tool/add-multiple-process-stack \
	&& apk --no-cache add \
    autoconf \
    curl \
    gcc \
    ipset \
    ipset-dev \
    iptables \
    iptables-dev \
    libnfnetlink \
    libnfnetlink-dev \
    libnl3 \
    libnl3-dev \
    make \
    musl-dev \
    openssl \
    openssl-dev \
    lua5.3 \
    lua5.3-dev \
    pcre2 \
    pcre2-dev \
    readline-dev \
    zlib-dev \
    && curl -o keepalived.tar.gz -SL http://keepalived.org/software/keepalived-${KEEPALIVED_VERSION}.tar.gz \
    && mkdir -p /container/keepalived-sources \
    && tar -xzf keepalived.tar.gz --strip 1 -C /container/keepalived-sources \
    && rm -f keepalived.tar.gz \
    && cd container/keepalived-sources \
    && ./configure --disable-dynamic-linking \
    && make && make install \
    && cd - && mkdir -p /etc/keepalived \
    && rm -rf /container/keepalived-sources \
    && curl -o haproxy.tar.gz -SL https://www.haproxy.org/download/2.3/src/haproxy-${HAPROXY_VERSION}.tar.gz \
    && mkdir -p /container/haproxy-sources \
    && tar -xzf haproxy.tar.gz --strip 1 -C /container/haproxy-sources \
    && rm -f haproxy.tar.gz \
    && cd /container/haproxy-sources \
    && makeOpts=' \
       		TARGET=linux-musl \
       		USE_GETADDRINFO=1 \
       		USE_LUA=1 LUA_INC=/usr/include/lua5.3 LUA_LIB=/usr/lib/lua5.3 \
       		USE_OPENSSL=1 \
       		USE_PCRE2=1 USE_PCRE2_JIT=1 \
       		USE_ZLIB=1 \
       		EXTRA_OBJS="contrib/prometheus-exporter/service-prometheus.o" \
       	' \
    && nproc="$(getconf _NPROCESSORS_ONLN)" \
    && eval "make -C /container/haproxy-sources -j '$nproc' all $makeOpts" \
    && eval "make -C /container/haproxy-sources install-bin $makeOpts" \
    && mkdir -p /usr/local/etc/haproxy \
    && cp -R /container/haproxy-sources/examples/errorfiles /usr/local/etc/haproxy/errors \
    && rm -rf /container/haproxy-sources \
    && apk --no-cache del \
    autoconf \
    gcc \
    ipset-dev \
    iptables-dev \
    libnfnetlink-dev \
    libnl3-dev \
    make \
    musl-dev \
    openssl-dev \
    lua5.3-dev \
	pcre2-dev \
	readline-dev \
	zlib-dev

# Add service directory to /container/service
ADD service /container/service

# Use baseimage install-service script
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-service
RUN /container/tool/install-service

# Add default env variables
ADD environment /container/environment/99-default
