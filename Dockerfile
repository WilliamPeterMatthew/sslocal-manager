FROM python:3.12-slim-bookworm

ENV TZ=Asia/Shanghai
ENV ARGS=

RUN apt-get update && apt-get install -y --no-install-recommends \
    shadowsocks-libev \
    procps \
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && cp /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo "$TZ" > /etc/timezone \
 && rm -rf \
      /var/lib/apt/lists/* \
      /var/cache/apt/archives/*.deb \
      /var/cache/apt/archives/partial/* \
      /var/cache/apt/*.bin \
      /var/log/apt \
      /var/log/*.log \
      /tmp/* \
      /var/tmp/*

RUN pip install flask

WORKDIR /app
COPY templates/ /app/templates/
COPY ./app.py /app/app.py
RUN chmod +x /app/app.py

EXPOSE 5000 1080/udp 1080/tcp

CMD ["python", "app.py"]
