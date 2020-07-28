# Base Image
FROM amazonlinux:2018.03

# Declare ENV variables
# Declare ARGS and ENV Variables
ARG URL
ENV VERSION 3.4.11

# Image labels
LABEL version=$VERSION
LABEL maintainer="Captain KoLiBer koliberr136a1@gmail.com"
LABEL description="ProcessMaker $VERSION Docker Image."

# Install Nginx
RUN yum clean all
RUN yum install -y curl nginx
RUN mkdir -p /run/nginx

# Install ProcessMaker
RUN curl -L -o /tmp/processmaker.tar.gz https://artifacts.processmaker.net/official/processmaker-$VERSION-community.tar.gz
RUN tar -C /srv -xzvf /tmp/processmaker.tar.gz
RUN rm /tmp/processmaker.tar.gz
RUN chown -R nginx:nginx /srv/processmaker
RUN chmod -R 777 /srv/processmaker

# Install PHP
RUN yum install -y \
    sendmail \
    php71-fpm \
    php71-opcache \
    php71-gd \
    php71-mysqlnd \
    php71-soap \
    php71-mbstring \
    php71-ldap \
    php71-mcrypt

# Copy configurations
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY php-fpm.conf /etc/php-fpm.conf

# Nginx Ports
EXPOSE 80

# Start php-fpm & nginx
CMD ["/bin/sh", "-c", "sed -i 's,server_name _;,server_name '$URL';,g' /etc/nginx/conf.d/default.conf && php-fpm && nginx"]