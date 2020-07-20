# Base Image
FROM alpine

# Declare ARGS and ENV Variables
ARG URL
ENV URL $URL
ENV VERSION 3.3.10

# Image labels
LABEL version=${VERSION}
LABEL maintainer="Captain KoLiBer koliberr136a1@gmail.com"
LABEL description="ProcessMaker ${VERSION} Docker Container."

# Required packages
RUN apk update
RUN apk add \
    openrc \
    wget \
    nginx \
    php7 \
    php7-fpm \
    php7-opcache \
    php7-gd \
    php7-mysqlnd \
    php7-soap \
    php7-mbstring \
    php7-ldap \
    php7-mcrypt
  
# Download ProcessMaker OpenSource
RUN wget -O "/tmp/processmaker.tar.gz" \
    "https://sourceforge.net/projects/processmaker/files/ProcessMaker/${VERSION}/processmaker-${VERSION}-community.tar.gz"

# ProcessMaker required configurations
RUN sed -i '/short_open_tag = Off/c\short_open_tag = On' /etc/php7/php.ini
RUN sed -i '/post_max_size = 8M/c\post_max_size = 24M' /etc/php7/php.ini
RUN sed -i '/upload_max_filesize = 2M/c\upload_max_filesize = 24M' /etc/php7/php.ini
RUN sed -i '/;date.timezone =/c\date.timezone = America/New_York' /etc/php7/php.ini
RUN sed -i '/expose_php = On/c\expose_php = Off' /etc/php7/php.ini

# OpCache configurations
RUN sed -i '/;opcache.enable_cli=0/c\opcache.enable_cli=1' /etc/php7/conf.d/00_opcache.ini
RUN sed -i '/opcache.max_accelerated_files=4000/c\opcache.max_accelerated_files=10000' /etc/php7/conf.d/00_opcache.ini
RUN sed -i '/;opcache.max_wasted_percentage=5/c\opcache.max_wasted_percentage=5' /etc/php7/conf.d/00_opcache.ini
RUN sed -i '/;opcache.use_cwd=1/c\opcache.use_cwd=1' /etc/php7/conf.d/00_opcache.ini
RUN sed -i '/;opcache.validate_timestamps=1/c\opcache.validate_timestamps=1' /etc/php7/conf.d/00_opcache.ini
RUN sed -i '/;opcache.fast_shutdown=0/c\opcache.fast_shutdown=1' /etc/php7/conf.d/00_opcache.ini

# Copy configuration files
COPY nginx.conf /etc/nginx
COPY default.conf /etc/nginx/conf.d
COPY processmaker-fpm.conf /etc/php7/php-fpm.d

# NGINX Ports
EXPOSE 80

# Docker entrypoint
COPY docker-entrypoint.sh /bin/
RUN chmod a+x /bin/docker-entrypoint.sh
# ENTRYPOINT [ "docker-entrypoint.sh" ]
