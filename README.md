# sslocal-manager
A webpage to manage ss-local

![Docker Pulls](https://img.shields.io/docker/pulls/petermatthew/sslocal-manager)
![Docker Image Size](https://img.shields.io/docker/image-size/petermatthew/sslocal-manager)
![Docker Image Version](https://img.shields.io/docker/v/petermatthew/sslocal-manager)

Build via Docker Compose, using the Python Flask framework.

> There is a solution to deploy ss-libev and ss-manager to the local machine at the same time, located in the branch [proxy_local](https://github.com/WilliamPeterMatthew/sslocal-manager/tree/proxy_local)

## Step 1
Clone this repo.
```bash
git clone https://github.com/WilliamPeterMatthew/sslocal-manager.git
```

## Step 2
Modify `.ssconfig.json` file like this.
```
  {
    "server": "ss.example.com",
    "server_port": 10080,
    "local_address": "0.0.0.0",
    "local_port": 1080,
    "password": "Password",
    "timeout": 300,
    "method": "aes-256-gcm"
  }

```

## Step 3
Modify or keep the ports in `docker-compose.yml` file (use `docker-compose-prebuild.yml` file if you want to use a pre-build version of the image instead of building locally) .

## Step 4
Run the project by executing the following command in the directory.
```bash
docker-compose up -d
```

You can also use a pre-built version of the image instead of building locally.
```bash
docker-compose -f docker-compose-prebuild.yml up -d
```

## Congratulations
Now you can access the web page on the port you set in Step 3.

## Optional
You can configure Apache or Nginx to reverse proxy to port 80.

Apache Example
```apache
<VirtualHost *:80>
    ServerName example.com

    ProxyRequests Off
    ProxyPreserveHost On
    ProxyPass / http://localhost:<the port you set in Step 3>/
    ProxyPassReverse / http://localhost:<the port you set in Step 3>/

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
        proxy_pass http://localhost:<the port you set in Step 3>;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    error_log /var/log/nginx/resendmail_error.log;
    access_log /var/log/nginx/resendmail_access.log;
}

```
