FROM python:3.12-alpine
LABEL maintainer="kev <noreply@datageek.info>, Sah <contact@leesah.name>, vndroid <waveworkshop@outlook.com>"

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
      procps \
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

# 安装Python依赖
RUN pip install flask

WORKDIR /app
COPY templates/ /app/templates/
COPY ./app.py /app/app.py

# 暴露端口
EXPOSE 5000 1080

CMD ["python", "app.py"]
