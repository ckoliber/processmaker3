#!/bin/sh
set -ex

# Decompress ProcessMaker
cd /tmp && tar -C /opt -xzvf processmaker.tar.gz
chown -R nginx:nginx /opt/processmaker

# Set NGINX server_name
sed -i 's,server_name ~^.*$;,server_name '"${URL}"';,g' /etc/nginx/conf.d/default.conf

# Start services
rc-update add nginx default
rc-update add php-fpm7 default
nginx -g 'daemon off;'