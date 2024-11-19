# PHP Service
FROM php:8.1-fpm as php

# Install dependencies
RUN apt-get update -y && apt-get install -y \
    unzip libpq-dev libcurl4-gnutls-dev git \
    && docker-php-ext-install pdo pdo_mysql bcmath

# Install Redis PHP extension
RUN pecl install redis && docker-php-ext-enable redis

# Set working directory
WORKDIR /var/www
COPY . .

# Install Composer
COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

# Expose port
ENV PORT=8000
ENTRYPOINT ["docker/entrypoint.sh"]

# ===================================================
# Node Service
FROM node:14-alpine as node

WORKDIR /usr/src/app
COPY . .

RUN npm install --global cross-env && npm install

VOLUME /usr/src/app/node_modules
