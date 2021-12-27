# Dockerfile-app

# Use PHP 5.6 with Apache for the base image
FROM php:5.6-apache

# Enable the Rewrite Apache mod
RUN cd /etc/apache2/mods-enabled && \
    ln -s ../mods-available/rewrite.load

# Install required PHP extensions
ENV MAGICK_HOME=/usr

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        g++ make cron \
        libmagickwand-dev \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install mysql \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install opcache \
    && docker-php-ext-install soap

RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
