FROM python:3.12-slim-bookworm

ENV TZ=Asia/Shanghai
ENV ARGS=

# 更新系统包以修复已知漏洞，并安装shadowsocks-libev和依赖
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    shadowsocks-libev \
    procps \
 && rm -rf /var/lib/apt/lists/*

# 安装Python依赖
RUN pip install flask

WORKDIR /app
COPY templates/ /app/templates/
COPY ./app.py /app/app.py
RUN chmod +x /app/app.py

# 暴露端口
EXPOSE 5000 1080

CMD ["python", "app.py"]
