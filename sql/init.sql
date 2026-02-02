-- Crear base de datos
CREATE DATABASE IF NOT EXISTS app_db;

-- Usuarios para localhost y cualquier host
CREATE USER IF NOT EXISTS 'app_user'@'localhost' IDENTIFIED BY 'app_pass';
CREATE USER IF NOT EXISTS 'app_user'@'%' IDENTIFIED BY 'app_pass';

-- Permisos
GRANT ALL PRIVILEGES ON app_db.* TO 'app_user'@'localhost';
GRANT ALL PRIVILEGES ON app_db.* TO 'app_user'@'%';
FLUSH PRIVILEGES;

USE app_db;

-- Crear tabla ITEMS
DROP TABLE IF EXISTS ITEMS;
CREATE TABLE ITEMS (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    item VARCHAR(10) NOT NULL
);

-- Datos de ejemplo
INSERT INTO ITEMS (item) VALUES ('item1'), ('item2'), ('item3');
