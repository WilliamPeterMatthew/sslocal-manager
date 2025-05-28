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

# 更新系统包以修复已知漏洞，并安装shadowsocks-libev和依赖
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    shadowsocks-libev \
    procps \
 && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 1080/udp 1080/tcp

STOPSIGNAL SIGINT

CMD ["ss-local"]
