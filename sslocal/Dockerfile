FROM debian:bookworm-slim

ENV SERVER=ss.example.com
ENV SERVER_PORT=8388
ENV LOCAL_ADDRESS=0.0.0.0
ENV LOCAL_PORT=1080
ENV PASSWORD=Password
ENV TIMEOUT=300
ENV METHOD=aes-256-gcm
ENV TZ=Asia/Shanghai
ENV ARGS=

RUN apt-get update && apt-get install -y --no-install-recommends \
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

EXPOSE 1080/udp 1080/tcp

STOPSIGNAL SIGINT

CMD ["ss-local"]
