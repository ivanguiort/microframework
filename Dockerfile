# 1. Imagen base de Node.js (en lugar de PHP)
FROM node:18-slim

# 2. Instalamos el cliente de MySQL (por si quieres hacer pruebas como hacía el de Postgres)
RUN apt-get update && apt-get install -y default-mysql-client && rm -rf /var/lib/apt/lists/*

# 3. Directorio de trabajo
WORKDIR /app

# 4. Copiar archivos de dependencias e instalar
COPY package*.json ./
RUN npm install

# 5. Copiar el resto del código (index.js, index.html)
COPY . .

# 6. Exponer el puerto (Railway suele usar el 3000 o el que diga la variable PORT)
EXPOSE 3000

# 7. Creamos el script de entrada (Entrypoint)
# Este script es el que arranca la aplicación.
RUN printf '%s\n' \
'#!/bin/bash' \
'set -e' \
'' \
'echo "Esperando a que la base de datos esté lista..."' \
'# Aquí podrías meter comandos de inicialización si hiciera falta' \
'' \
'exec node index.js' \
> /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 8. Comando final
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]