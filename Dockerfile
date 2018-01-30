FROM php:fpm

MAINTAINER tamtampro

RUN apt-get update && apt-get install -y \
        cron \
        apt-utils \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libsqlite3-dev \
        libssl-dev \
        libcurl3-dev \
        libxml2-dev \
        libzzip-dev \
        locales \
        && docker-php-ext-install bz2 iconv json mbstring mysqli pdo_mysql pdo_sqlite phar curl ftp hash session simplexml tokenizer xml xmlrpc zip \
        && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install gd \
        && docker-php-ext-install gettext \
        && pecl install mcrypt-1.0.1 \
        && docker-php-ext-enable mcrypt \
        && pecl install apcu-5.1.9 \
        && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini

RUN     echo nl_BE.UTF-8 UTF-8 >> /etc/locale.gen && \
        echo nl_BE UTF-8 >> /etc/locale.gen && \
        echo de_BE.UTF-8 UTF-8 >> /etc/locale.gen && \
        echo de_BE UTF-8 >> /etc/locale.gen && \
        echo fr_BE.UTF-8 UTF-8 >> /etc/locale.gen && \
        echo fr_BE UTF-8 >> /etc/locale.gen && \
        echo fr_FR.UTF-8 UTF-8 >> /etc/locale.gen && \
        echo fr_FR UTF-8 >> /etc/locale.gen && \
        echo en_US.UTF-8 UTF-8  >> /etc/locale.gen && \
        echo en_US UTF-8  >> /etc/locale.gen && \
        locale-gen

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    curl -O -J -L https://phar.phpunit.de/phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit && \
    chmod +x /usr/local/bin/phpunit

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

WORKDIR /var/www

CMD ["php-fpm"]
