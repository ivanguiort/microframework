const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Conexión a MySQL (Railway)
const db = mysql.createPool({
  uri: process.env.MYSQL_URL,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Servir el HTML
app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'index.html')));

// LEER (Read)
app.get('/api/items', (req, res) => {
    db.query('SELECT * FROM items ORDER BY codigo DESC', (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
    });
});

// CREAR (Create)
app.post('/api/items', (req, res) => {
    const { codigo, nombre } = req.body;
    if (!codigo || !nombre) return res.status(400).json({ error: "Código y nombre son requeridos." });

    db.query('INSERT INTO items (codigo, nombre) VALUES (?, ?)', [codigo, nombre], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ success: true });
    });
});

// BORRAR (Delete)
app.delete('/api/items/:codigo', (req, res) => {
    db.query('DELETE FROM items WHERE codigo = ?', [req.params.codigo], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ success: true });
    });
});

app.listen(port, "0.0.0.0", () => console.log(`Servidor en puerto ${port}`));
