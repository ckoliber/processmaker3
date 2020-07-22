# Base Image
FROM alpine

# Declare ARGS and ENV Variables
ARG URL
ENV URL $URL
ENV VERSION 3.4.11

# Image labels
LABEL version=${VERSION}
LABEL maintainer="Captain KoLiBer koliberr136a1@gmail.com"
LABEL description="ProcessMaker ${VERSION} Docker Image."

# Required packages
RUN apk update
RUN apk add \
    supervisor \
    nginx \
    curl \
    php7 \
    php7-xml \
    php7-dom \
    php7-fpm \
    php7-opcache \
    php7-curl \
    php7-gd \
    php7-mysqli \
    php7-soap \
    php7-mbstring \
    php7-ldap \
    php7-mcrypt \
    php7-session

# Download ProcessMaker OpenSource
RUN mkdir -p /opt
RUN wget -O /tmp/processmaker.tar.gz \
    https://sourceforge.net/projects/processmaker/files/ProcessMaker/${VERSION}/processmaker-${VERSION}-community.tar.gz
RUN tar -C /opt -xzvf /tmp/processmaker.tar.gz
RUN rm /tmp/processmaker.tar.gz

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY php-fpm.conf /etc/php7/php-fpm.d/www.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# NGINX Ports
EXPOSE 80

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:9000/fpm-ping