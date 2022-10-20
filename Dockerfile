FROM php:7.4-apache

ENV PHP_TIMEZONE=Europe/Moskow
ENV PHP_DISPLAY_ERRORS=Off
ENV PHP_MEMORY_LIMIT=128m

RUN apt-get update -y
RUN apt-get install -y  \
    sendmail  \
    libzip-dev  \
    libpng-dev  \
    libjpeg-dev  \
    libfreetype6-dev

RUN docker-php-ext-configure gd --with-jpeg
RUN docker-php-ext-install pdo pdo_mysql zip gd
RUN docker-php-ext-install mysqli

COPY php.ini $PHP_INI_DIR