# Base Image
FROM alpine

# Declare ENV variables
# Declare ARGS and ENV Variables
ARG URL
ENV VERSION 3.4.4

# Image labels
LABEL version=$VERSION
LABEL maintainer="Captain KoLiBer koliberr136a1@gmail.com"
LABEL description="ProcessMaker $VERSION Docker Image."

# Install Nginx
RUN apk update
RUN apk add curl nginx
RUN mkdir -p /run/nginx

# Install ProcessMaker
RUN curl -L -o /tmp/processmaker.tar.gz https://sourceforge.net/projects/processmaker/files/ProcessMaker/$VERSION/processmaker-$VERSION-community.tar.gz
RUN tar -C /srv -xzvf /tmp/processmaker.tar.gz
RUN rm /tmp/processmaker.tar.gz
RUN chown -R nginx:www-data /srv/processmaker
RUN chmod -R 777 /srv/processmaker

# Install PHP
RUN apk add \
    php7-fpm \
    php7-opcache \
    php7-json \
    php7-zlib \
    php7-xml \
    php7-pdo \
    php7-phar \
    php7-openssl \
    php7-pdo_mysql \
    php7-mysqli \
    php7-gd \
    php7-iconv \
    php7-mcrypt \
    php7-ctype \
    php7-cli \
    php7-curl \
    php7-soap \
    php7-ldap \
    php7-dom

# Copy configurations
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf

# Nginx Ports
EXPOSE 80

# Start php-fpm & nginx
CMD ["/bin/sh", "-c", "sed -i 's,server_name _;,server_name '$URL';,g' /etc/nginx/conf.d/default.conf && php-fpm7 && nginx"]