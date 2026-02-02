FROM php:8.2-apache

# Instalar extensiones PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copiar código
COPY index.php /var/www/html/index.php
RUN rm -f /var/www/html/index.html

EXPOSE 8080
CMD ["apache2-foreground"]
