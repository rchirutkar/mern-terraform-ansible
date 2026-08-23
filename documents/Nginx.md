## Install Nginx

SSH into Web EC2.

```bash 

sudo apt update

sudo apt install nginx -y

# Verify:

nginx -v

sudo systemctl status nginx --no-pager

# Expected:
# Active: active (running)

```

## Remove Default Site and update travelmemory site

```bash

sudo rm /etc/nginx/sites-enabled/default

# Create Nginx Configuration

sudo nano /etc/nginx/sites-available/travelmemory

```

Paste:

```
server {

    listen 80;

    server_name _;

    root /opt/travelmemory/frontend/build;

    index index.html;

    location / {
        try_files $uri /index.html;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:5000/;

        proxy_http_version 1.1;

        proxy_set_header Host $host;

        proxy_set_header X-Real-IP $remote_addr;

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_set_header X-Forwarded-Proto $scheme;
    }

}

```

## Enable Site

```bash
sudo ln -s /etc/nginx/sites-available/travelmemory /etc/nginx/sites-enabled/

# Test config:

sudo nginx -t

# Expected:

# syntax is ok
# test is successful

# Reload:
sudo systemctl reload nginx

```

## Update Frontend API URL

Now React should call same origin instead of port 5000.

Edit frontend .env

```bash
cd /opt/travelmemory/frontend

nano .env

# Replace:

# VITE_API_URL=http://13.xxx.xxx.xxx:5000

# with

# VITE_API_URL=/api

# or for CRA:

# REACT_APP_API_URL=/api
# Rebuild
npm run build

```

Restart frontend PM2 (or stop it later).

## PM2 Frontend Cleanup

Since Nginx serves static files, PM2 is no longer needed for frontend.

```bash
pm2 delete travelmemory-frontend

pm2 save

# Keep backend running.

pm2 list

# Expected:

# Only backend online.

```