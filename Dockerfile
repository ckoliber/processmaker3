# Base Image
FROM alpine:3.8

# Declare ARGS and ENV Variables
ENV VERSION 3.5.4

# Image labels
LABEL version=$VERSION
LABEL maintainer="Captain KoLiBer koliberr136a1@gmail.com"
LABEL description="ProcessMaker $VERSION Docker Image."

# Install dependencies
RUN apk add bash curl curl-dev openldap-dev tzdata nginx ca-certificates freetds \
    php5-fpm \
    php5-opcache \
    php5-json \
    php5-zlib \
    php5-xml \
    php5-pdo \
    php5-phar \
    php5-openssl \
    php5-pdo_mysql \
    php5-mysqli \
    php5-mysql \
    php5-gd \
    php5-iconv \
    php5-mcrypt \
    php5-ctype \
    php5-cli \
    php5-curl \
    php5-soap \
    php5-ldap \
    php5-dom
RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
RUN mkdir -p /run/nginx

# Install ProcessMaker
RUN curl -L -o /tmp/processmaker.tar.gz https://artifacts.processmaker.net/official/processmaker-$VERSION-community.tar.gz
RUN tar -C /srv -xzvf /tmp/processmaker.tar.gz
RUN rm /tmp/processmaker.tar.gz
RUN chown -R nginx:nginx /srv/processmaker
RUN chmod -R 777 /srv/processmaker
WORKDIR /srv/processmaker

# Copy configurations
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY php-fpm.conf /etc/php5/php-fpm.conf

# Nginx Ports
EXPOSE 80

# Start crond & php-fpm & nginx
CMD ["/bin/sh", "-c", "crond && php-fpm5 && nginx"]