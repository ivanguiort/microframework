const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// 1. LA CONEXIÓN (Usando la variable de Railway)
const db = mysql.createPool({
  uri: process.env.MYSQL_URL,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// 2. CHEQUEO DE CONEXIÓN Y CREACIÓN DE TABLA
const initDB = () => {
    db.getConnection((err, connection) => {
        if (err) {
            console.log("MySQL no responde todavía, reintentando en 5s...");
            setTimeout(initDB, 5000); // Reintenta si MySQL aún está arrancando
        } else {
            console.log("Conexión a MySQL exitosa. Creando tabla si no existe...");
            const sql = `CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(255) NOT NULL
            )`;
            connection.query(sql, (err) => {
                connection.release(); // Soltamos la conexión al terminar
                if (err) console.error("Error al crear tabla:", err);
                else console.log("Tabla 'users' lista para trabajar.");
            });
        }
    });
};

initDB(); // Ejecutamos la función al arrancar

// 3. LAS RUTAS (EL CRUD)

app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'index.html')));

// LEER (Read)
app.get('/api/usuarios', (req, res) => {
    db.query('SELECT * FROM users ORDER BY id DESC', (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
    });
});

// CREAR (Create)
app.post('/api/usuarios', (req, res) => {
    db.query('INSERT INTO users (name) VALUES (?)', [req.body.name], (err) => {
        if (err) return res.status(500).send(err);
        res.redirect('/');
    });
});

// BORRAR (Delete)
app.get('/api/usuarios/delete/:id', (req, res) => {
    db.query('DELETE FROM users WHERE id = ?', [req.params.id], (err) => {
        if (err) return res.status(500).send(err);
        res.redirect('/');
    });
});

app.listen(port, "0.0.0.0", () => console.log(`Servidor en puerto ${port}`));