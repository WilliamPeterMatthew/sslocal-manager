FROM python:3.12-slim-bookworm

ENV TZ=Asia/Shanghai
ENV ARGS=

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    shadowsocks-libev \
    procps \
 && rm -rf /var/lib/apt/lists/*

RUN pip install flask

WORKDIR /app
COPY templates/ /app/templates/
COPY ./app.py /app/app.py
RUN chmod +x /app/app.py

EXPOSE 5000 1080/udp 1080/tcp

CMD ["python", "app.py"]
