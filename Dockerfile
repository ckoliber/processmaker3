# Base Image
FROM byrnedo/alpine-curl

# Declare ENV variables
ENV VERSION 3.4.4

# Image labels
LABEL version=${VERSION}
LABEL maintainer="Captain KoLiBer koliberr136a1@gmail.com"
LABEL description="ProcessMaker ${VERSION} Docker Image."

# Download ProcessMaker OpenSource
RUN curl -L -o /tmp/processmaker.tar.gz https://sourceforge.net/projects/processmaker/files/ProcessMaker/$VERSION/processmaker-$VERSION-community.tar.gz
RUN tar -C /srv -xzvf /tmp/processmaker.tar.gz
RUN rm /tmp/processmaker.tar.gz

# Change Base Image
FROM ahrotahntee/nginx-php5

# PHP packages
RUN apk update && apk add \
    php5-mysqli \
    php5-xml \
    php5-mcrypt \
    php5-soap \
    php5-ldap \
    php5-gd \
    php5-curl \
    php5-ctype \
    openssl \
    php5-mysql \
    php5-xml \
    php5-dom \
    php5-openssl \
    php5-pdo \
    php5-json \
    php5-pdo_mysql

# Copy configuration files
COPY default.conf /etc/nginx/conf.d/default.conf
RUN chown nginx:nginx -R /srv && chmod 770 /srv/shared && cd /srv/processmaker/workflow/engine && chmod 770 config content/languages plugins xmlform js/labels
WORKDIR "/srv/processmaker/workflow/engine"
VOLUME "/srv"