#!/bin/bash

# Create and commit 2-app_server-nginx_config
cat << 'EOF' > 2-app_server-nginx_config
# Configures Nginx to serve the route /airbnb-onepage/ from AirBnB_clone_v2.

server {
    # Listen on port 80
    listen      80 default_server;
    listen      [::]:80 default_server ipv6only=on;

    # Use IP of server as domain name
    server_name 54.89.136.45;

    # Customize HTTP response header
    add_header  X-Served-By 806423-web-01;

    # Serve /airbnb-onepage/ route from AirBnB_clone_v2
    location = /airbnb-onepage/ {
        proxy_pass http://127.0.0.1:5000/airbnb-onepage/;
    }

    # 404 error page
    error_page 404 /404.html;
    location /404 {
        root /var/www/html;
        internal;
    }
}
EOF
git add 2-app_server-nginx_config
git commit -m "2-app_server-nginx_config"

# Create and commit 3-app_server-nginx_config
cat << 'EOF' > 3-app_server-nginx_config
# Configures Nginx to serve the route /airbnb-onepage/ from AirBnB_clone_v2.

server {
    # Listen on port 80
    listen      80 default_server;
    listen      [::]:80 default_server ipv6only=on;

    # Use IP of server as domain name
    server_name 54.89.136.45;

    # Customize HTTP response header
    add_header  X-Served-By 806423-web-01;

    # Serve /airbnb-onepage/ route from AirBnB_clone_v2
    location = /airbnb-onepage/ {
        proxy_pass http://127.0.0.1:5000/airbnb-onepage/;
    }

    # Serve /number_odd_or_even/ route on AirBnB_clone_v2
    location ~ /airbnb-dynamic/number_odd_or_even/(\d+)$ {
        proxy_pass http://127.0.0.1:5001/number_odd_or_even/$1;
    }

    # 404 error page
    error_page 404 /404.html;
    location /404 {
        root /var/www/html;
        internal;
    }
}
EOF
git add 3-app_server-nginx_config
git commit -m "3-app_server-nginx_config"

# Create and commit 4-app_server-nginx_config
cat << 'EOF' > 4-app_server-nginx_config
# Configures Nginx to serve the route /airbnb-onepage/ from AirBnB_clone_v2.

server {
    # Listen on port 80
    listen      80 default_server;
    listen      [::]:80 default_server ipv6only=on;

    # Use IP of server as domain name
    server_name 54.89.136.45;

    # Customize HTTP response header
    add_header  X-Served-By 806423-web-01;

    # Serve /airbnb-onepage/ route from AirBnB_clone_v2
    location = /airbnb-onepage/ {
        proxy_pass http://127.0.0.1:5000/airbnb-onepage/;
    }

    # Serve /number_odd_or_even/ route on AirBnB_clone_v2
    location ~ /airbnb-dynamic/number_odd_or_even/(\d+)$ {
        proxy_pass http://127.0.0.1:5001/number_odd_or_even/$1;
    }

    # Serve AirBnB_clone_v3 API
    location /api {
        proxy_pass http://127.0.0.1:5002/api;
    }

    # 404 error page
    error_page 404 /404.html;
    location /404 {
        root /var/www/html;
        internal;
    }
}
EOF
git add 4-app_server-nginx_config
git commit -m "4-app_server-nginx_config"

# Create and commit 4-reload_gunicorn_no_downtime
cat << 'EOF' > 4-reload_gunicorn_no_downtime
#!/usr/bin/env bash
# Gracefully reload gunicorn
pgrep gunicorn | xargs kill -HUP
EOF
chmod +x 4-reload_gunicorn_no_downtime
git add 4-reload_gunicorn_no_downtime
git commit -m "4-reload_gunicorn_no_downtime"

# Create and commit 5-app_server-nginx_config
cat << 'EOF' > 5-app_server-nginx_config
# Configures Nginx to serve the route /airbnb-onepage/ from AirBnB_clone_v2.

server {
    # Listen on port 80
    listen      80 default_server;
    listen      [::]:80 default_server ipv6only=on;

    # Use IP of server as domain name
    server_name 54.89.136.45;

    # Customize HTTP response header
    add_header  X-Served-By 806423-web-01;

    # Serve /airbnb-onepage/ route from AirBnB_clone_v2
    location = /airbnb-onepage/ {
        proxy_pass http://127.0.0.1:5000/airbnb-onepage/;
    }

    # Serve /number_odd_or_even/ route on AirBnB_clone_v2
    location ~ /airbnb-dynamic/number_odd_or_even/(\d+)$ {
        proxy_pass http://127.0.0.1:5001/number_odd_or_even/$1;
    }

    # Serve AirBnB_clone_v3 API
    location /api {
        proxy_pass http://127.0.0.1:5002/api;
    }

    # Configure /2-hbnb route of AirBnB_clone_v4 as root location
    location / {
        proxy_pass http://127.0.0.1:5003/2-hbnb;
    }

    # Serve static content for AirBnB_clone_v4
    location /static {
        proxy_pass http://127.0.0.1:5003;
    }

    # 404 error page
    error_page 404 /404.html;
    location /404 {
        root /var/www/html;
        internal;
    }
}
EOF
git add 5-app_server-nginx_config
git commit -m "5-app_server-nginx_config"

# Create and commit gunicorn.service
cat << 'EOF' > gunicorn.service
[Unit]
Description = HBNB
After = network.target

[Service]
PermissionsStartOnly = true
PIDFile = /run/hbnb/hbnb.pid
User = ubuntu
Group = ubuntu
WorkingDirectory = /home/ubuntu/AirBnB_clone_v4
ExecStartPre = /bin/mkdir /run/hbnb
ExecStartPre = /bin/chown -R ubuntu:ubuntu /run/hbnb
ExecStart = /home/ubuntu/.local/bin/gunicorn -w 3 --access-logfile /tmp/airbnb-access.log --error-logfile /tmp/airbnb-error.log --bind 0.0.0.0:5003 web_dynamic.2-hbnb:app --pid /run/hbnb/hbnb.pid
ExecReload = /bin/kill -s HUP $MAINPID
ExecStop = /bin/kill -s TERM $MAINPID
ExecStopPost = /bin/rm -rf /run/hbnb
PrivateTmp = false

[Install]
WantedBy = multi-user.target
EOF
git add gunicorn.service
git commit -m "gunicorn.service"

# Final message
echo "All files have been created, committed, and trailing newlines removed."
