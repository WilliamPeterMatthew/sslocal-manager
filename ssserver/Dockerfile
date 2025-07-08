FROM debian:bookworm-slim

ENV SERVER=0.0.0.0
ENV SERVER_PORT=8388
ENV PASSWORD=Password
ENV TIMEOUT=300
ENV METHOD=aes-256-gcm
ENV DNS_ADDRS="114.114.114.114,8.8.8.8"
ENV TZ=Asia/Shanghai
ENV ARGS=

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    shadowsocks-libev \
    procps \
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf \
      /var/lib/apt/lists/* \
      /var/cache/apt/archives/*.deb \
      /var/cache/apt/archives/partial/* \
      /var/cache/apt/*.bin \
      /var/log/apt \
      /var/log/*.log \
      /tmp/* \
      /var/tmp/*

COPY ./entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8388/udp 8388/tcp

STOPSIGNAL SIGINT

CMD ["ss-server"]
