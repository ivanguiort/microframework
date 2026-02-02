# Imagen oficial PHP con Apache
FROM php:8.2-apache

# Puerto
ENV PORT=8080

# Instalar extensiones necesarias de PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Prioridad a index.php
RUN sed -i 's/DirectoryIndex.*/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf

# Configurar puerto Railway
RUN sed -i "s/80/${PORT}/" /etc/apache2/ports.conf \
 && sed -i "s/:80>/:${PORT}>/" /etc/apache2/sites-enabled/000-default.conf

# ⚠ Deshabilitar MPM conflictivos
RUN a2dismod mpm_event mpm_worker \
 && a2enmod mpm_prefork

# Eliminar página default de Apache
RUN rm -f /var/www/html/index.html

# Copiar tu código PHP
WORKDIR /var/www/html
COPY index.php /var/www/html/index.php

# Permisos
RUN chown -R www-data:www-data /var/www/html

EXPOSE ${PORT}

# Arrancar Apache
CMD ["apache2-foreground"]
