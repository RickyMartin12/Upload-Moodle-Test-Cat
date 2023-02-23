#FROM geerlingguy/php-apache:latest
FROM php:8.0-apache

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN docker-php-ext-install -j "$(nproc)" opcache
RUN set -ex; \
  { \
    echo "; Cloud Run enforces memory & timeouts"; \
    echo "memory_limit = -1"; \
    echo "max_execution_time = 0"; \
    echo "; File upload at Cloud Run network limit"; \
    echo "upload_max_filesize = 2048M"; \
    echo "post_max_size = 2048M"; \
    echo "; Configure Opcache for Containers"; \
    echo "opcache.enable = On"; \
    echo "opcache.validate_timestamps = Off"; \
    echo "; Configure Opcache Memory (Application-specific)"; \
    echo "opcache.memory_consumption = 32"; \
  } > "$PHP_INI_DIR/conf.d/cloud-run.ini"

WORKDIR /var/www/html

#RUN rm /var/www/html/index.html
COPY . /var/www/html/.

RUN chmod -R 777 /var/www/html
RUN chmod -R 777 /var/www/html/cat

COPY ./ports.conf /etc/apache2/ports.conf
COPY ./apache.conf /etc/apache2/site-enabled/000-default.conf

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"