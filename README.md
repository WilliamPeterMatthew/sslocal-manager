# sslocal-manager
A webpage to manage ss-local

![Docker Pulls](https://img.shields.io/docker/pulls/petermatthew/sslocal-manager)
![Docker Image Size](https://img.shields.io/docker/image-size/petermatthew/sslocal-manager)
![Docker Image Version](https://img.shields.io/docker/v/petermatthew/sslocal-manager)

Build via Docker Compose, using the Python Flask framework.

# ssserver-libev
A backup image to start ss-server

![Docker Pulls](https://img.shields.io/docker/pulls/petermatthew/ssserver-libev)
![Docker Image Size](https://img.shields.io/docker/image-size/petermatthew/ssserver-libev)
![Docker Image Version](https://img.shields.io/docker/v/petermatthew/ssserver-libev)

Build via Docker Compose, Source Repo: [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev/).

## Step 1
Clone this repo.
```bash
git clone https://github.com/WilliamPeterMatthew/sslocal-manager.git -b proxy_local
```

## Step 2
Modify or keep the ports in `docker-compose.yml` file (use `docker-compose-prebuild.yml` file if you want to use a pre-build version of the image instead of building locally) .

## Step 3
Run the project by executing the following command in the directory.
```bash
docker-compose up -d
```

You can also use a pre-built version of the image instead of building locally.
```bash
docker-compose -f docker-compose-prebuild.yml up -d
```

## Congratulations
Now you can access the web page on the port you set in Step 2.

## Optional
You can configure Apache or Nginx to reverse proxy to port 80.

Apache Example
```apache
<VirtualHost *:80>
    ServerName example.com

    ProxyRequests Off
    ProxyPreserveHost On
    ProxyPass / http://localhost:<the port you set in Step 2>/
    ProxyPassReverse / http://localhost:<the port you set in Step 2>/

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Nginx Example
```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:<the port you set in Step 2>;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    error_log /var/log/nginx/sslocal_manager_error.log;
    access_log /var/log/nginx/sslocal_manager_access.log;
}

```
