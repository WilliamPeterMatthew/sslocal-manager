FROM debian:bookworm-slim

ENV SERVER_ADDR=0.0.0.0
ENV SERVER_PORT=8388
ENV PASSWORD=Password
ENV METHOD=aes-256-gcm
ENV TIMEOUT=300
ENV DNS_ADDRS="114.114.114.114,8.8.8.8"
ENV TZ=Asia/Shanghai
ENV ARGS=

# 更新系统包以修复已知漏洞，并安装shadowsocks-libev和依赖
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    shadowsocks-libev \
    procps \
 && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8388

STOPSIGNAL SIGINT

CMD ["ss-server"]
