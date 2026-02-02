# Usamos imagen oficial de PHP con Apache
FROM php:8.2-apache

# Puerto
ENV PORT=8080

# Instalar extensión de MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Prioridad a index.php
RUN sed -i 's/DirectoryIndex.*/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf

# Configurar Apache para puerto Railway
RUN sed -i "s/80/${PORT}/" /etc/apache2/ports.conf \
 && sed -i "s/:80>/:${PORT}>/" /etc/apache2/sites-enabled/000-default.conf

# Copiar código fuente
WORKDIR /var/www/html
COPY src/ /var/www/html/

# Dar permisos correctos
RUN chown -R www-data:www-data /var/www/html

EXPOSE ${PORT}

# Comando por defecto
CMD ["apache2-foreground"]
