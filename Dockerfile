FROM alpine:3.16
LABEL maintainer="kev <noreply@datageek.info>, Sah <contact@leesah.name>, vndroid <waveworkshop@outlook.com>"

ENV SERVER_ADDR=0.0.0.0
ENV SERVER_PORT=8388
ENV PASSWORD=Password
ENV METHOD=aes-256-gcm
ENV TIMEOUT=300
ENV DNS_ADDRS="114.114.114.114,8.8.8.8"
ENV TZ=Asia/Shanghai
ENV ARGS=

COPY src/ /tmp/repo/
RUN set -x \
 # Build environment setup
 && apk add --no-cache --virtual .build-deps \
      autoconf \
      automake \
      build-base \
      c-ares-dev \
      libcap \
      libev-dev \
      libtool \
      libsodium-dev \
      linux-headers \
      mbedtls-dev \
      pcre-dev \
      pax-utils \
 # Build & install
 && cd /tmp/repo \
 && ./autogen.sh \
 && ./configure --prefix=/usr/local --disable-documentation \
 && make -j$(getconf _NPROCESSORS_ONLN) \
 && make install \
 && cd /usr/local/bin \
 && ls /usr/local/bin/ss-* | xargs -n1 setcap cap_net_bind_service+ep \
 && strip $(ls /usr/local/bin | grep -Ev 'ss-nat') \
 && apk del .build-deps \
 # Runtime dependencies setup
 && apk add --no-cache \
      ca-certificates \
      rng-tools \
      tzdata \
      $(scanelf --needed --nobanner /usr/local/bin/ss-* \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u) \
 && rm -rf /tmp/repo

COPY ./entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8388

STOPSIGNAL SIGINT

CMD ["ss-server"]