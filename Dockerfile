# PHP Service
FROM php:8.3-fpm as php

RUN apt-get update -y && apt-get install -y \
    unzip libpq-dev libcurl4-gnutls-dev git \
    zip libzip-dev \
    libexif-dev \
    && docker-php-ext-install pdo pdo_mysql bcmath zip exif


RUN pecl install redis && docker-php-ext-enable redis

WORKDIR /var/www
COPY . .

COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer


ENV PORT=8000
ENTRYPOINT ["docker/entrypoint.sh"]



# ===================================================
# Node Service
FROM node:18-alpine as node

RUN corepack enable \
    && corepack prepare yarn@4.5.1 --activate

WORKDIR /var/www

COPY . .

RUN yarn install --frozen-lockfile && yarn build

VOLUME /var/www/node_modules

