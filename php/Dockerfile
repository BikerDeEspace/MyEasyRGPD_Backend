###############################
# APPLICATION PHP ENVIRONMENT #
###############################

# BASE IMAGE
FROM php:7.2-fpm

# INSTALL & UPDATE PACKAGES
RUN apt-get update && apt-get install -y openssl git unzip

# INSTALL COMPOSER 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# SET TIMEZONE
ARG TIMEZONE
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini
RUN "date"

# INSTALL DOCKER PHP EXTENSIONS 
## docker-php-ext-install to see available extensions
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pdo_pgsql

RUN apt-get update && apt-get install -y zlib1g-dev \
    && docker-php-ext-install zip

# INSTALL XDEBUG
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'alias sf="php app/console"' >> ~/.bashrc
RUN echo 'alias sf3="php bin/console"' >> ~/.bashrc

###############################
# APPLICATION SOURCES & SETUP #
###############################
# DESACTIVATE CACHE FOR BUILD
ARG CACHEBUST=1

#COPY SOURCES
COPY src/ /var/www/symfony
#SET WORKDIR
WORKDIR /var/www/symfony

#COPY .ENV FILE
COPY app.env /var/www/symfony/.env

#COPY INIT SCRIPT
COPY ./post_install_script/post_install.sh /var/www/symfony/post_install_script/post_install.sh
COPY ./post_install_script/wait_postgres.sh /var/www/symfony/post_install_script/wait_postgres.sh
# SET EXECUTE PERMISSIONS
RUN ["chmod", "+x", "post_install_script/post_install.sh"]
RUN ["chmod", "+x", "post_install_script/wait_postgres.sh"]
RUN ["chmod", "+x", "bin/console"]

# COMPOSER INSTALL
RUN composer install --no-interaction --no-scripts

# ASSETS INSTALL & CACHE CLEAN
RUN bin/console assets:install --no-interaction
RUN bin/console cache:warmup --no-interaction

CMD ["php-fpm", "-F"]