FROM php:8.3-apache

RUN apt-get update -y && \
    apt-get install -y  \
    sudo \
    sendmail \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    git \
    cron \
    nano \
    pv \
    inotify-tools \
    rsync

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install pdo pdo_mysql zip gd mysqli session

ENV PHP_TIMEZONE=Europe/Moscow
ENV PHP_DISPLAY_ERRORS=Off
ENV PHP_MEMORY_LIMIT=500m
COPY php.ini $PHP_INI_DIR
COPY conf/site.conf /etc/apache2/sites-available/000-default.conf
COPY entrypoint.sh /var/bitrix/

RUN groupadd bitrix -g 1000
RUN useradd bitrix -g bitrix -d /home/bitrix -m
RUN a2enmod rewrite
RUN echo '%bitrix ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN sed -ri -e 's!www-data!bitrix!g' /etc/apache2/envvars

USER bitrix:bitrix
RUN  mkdir /home/bitrix/extensions
COPY bitrix /home/bitrix/www
COPY DirectoryWatcher /home/bitrix/
WORKDIR /home/bitrix/
VOLUME /home/bitrix/extensions
VOLUME /home/bitrix/www/upload
CMD sudo bash /var/bitrix/entrypoint.sh