# Base Image
FROM alpine

# Declare ENV variables
ENV VERSION 3.4.4

# Image labels
LABEL version=${VERSION}
LABEL maintainer="Captain KoLiBer koliberr136a1@gmail.com"
LABEL description="ProcessMaker ${VERSION} Docker Image."

# Required packages
RUN apk update
RUN apk add curl nginx supervisor

# Download ProcessMaker OpenSource
RUN curl -L -o /opt/processmaker.tar.gz --create-dirs https://sourceforge.net/projects/processmaker/files/ProcessMaker/$VERSION/processmaker-$VERSION-community.tar.gz
RUN tar -C /opt -xzvf /opt/processmaker.tar.gz
RUN rm /opt/processmaker.tar.gz

# PHP packages
RUN apk add \
    php7 \
    php7-fpm \
    php7-opcache \
    php7-gd \
    php7-soap \
    php7-mbstring \
    php7-ldap \
    php7-mcrypt \
    php7-mysqli \
    php7-mysqlnd \
    php7-xml \
    php7-dom \
    php7-curl \
    php7-session

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY php-fpm.conf /etc/php7/php-fpm.d/www.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# ProcessMaker required configurations
RUN sed -i '/short_open_tag = Off/c\short_open_tag = On' /etc/php7/php.ini
RUN sed -i '/post_max_size = 8M/c\post_max_size = 24M' /etc/php7/php.ini
RUN sed -i '/upload_max_filesize = 2M/c\upload_max_filesize = 24M' /etc/php7/php.ini
RUN sed -i '/;date.timezone =/c\date.timezone = America/New_York' /etc/php7/php.ini
RUN sed -i '/expose_php = On/c\expose_php = Off' /etc/php7/php.ini

# NGINX Ports
EXPOSE 80

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:9000/fpm-ping