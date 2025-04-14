FROM python:3.9-slim-bullseye

# 安装shadowsocks-libev和依赖
RUN apt-get update && apt-get install -y \
    shadowsocks-libev \
    procps \
 && rm -rf /var/lib/apt/lists/*

# 安装Python依赖
RUN pip install flask

WORKDIR /app
COPY . /app

# 暴露端口
EXPOSE 5000 1080

CMD ["python", "app.py"]