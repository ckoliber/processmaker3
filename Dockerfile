# Base image
FROM amazonlinux:2018.03

# Declare ARGS and ENV Variables
ENV VERSION 3.4.11

# Image labels
LABEL version=$VERSION
LABEL maintainer="Captain KoLiBer koliberr136a1@gmail.com"
LABEL description="ProcessMaker $VERSION Docker Image."

# Install dependencies
RUN yum clean all
RUN yum install -y curl nginx mysql \
    sendmail \
    php71-fpm \
    php71-opcache \
    php71-gd \
    php71-mysqlnd \
    php71-soap \
    php71-mbstring \
    php71-ldap \
    php71-mcrypt
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
COPY php-fpm.conf /etc/php-fpm.conf

# Nginx Ports
EXPOSE 80

# Start crond & php-fpm & nginx
CMD ["/bin/sh", "-c", "php-fpm && nginx"]