const express = require('express');
const cors = require('cors');
const app = express();
const mariadb = require('mysql2/promise');

require('dotenv').config();

app.use(express.json());
app.use(cors());

const pool = mariadb.createPool({
    host: process.env.DB_HOST,
    database: process.env.DB_DTB,
    user: process.env.DB_USER,
    password: process.env.DB_PWD,
    port: process.env.DB_PORT
});

//Route pour récupérer le top 5 par loisir
app.get('/api/index', async (req, res) => {
    let conn;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query(`
            SELECT 
                l.idloisir,
                l.type,
                l.nom,
                t.nom as nom_type,
                l.images,
                l.description,
                l.date_sortie,
                AVG(n.note) AS moyenne_notes
            FROM 
                loisir l
            LEFT JOIN
                type t ON l.type = t.id
            WHERE 
                l.idloisir = ?
            GROUP BY 
                l.idloisir, l.type, t.nom, l.nom, l.images, l.description, l.date_sortie
        `);
        const groupedByType = rows[0].reduce((acc, loisir) => {
            const type = loisir.type;
            if (!acc[type]) {
                acc[type] = [];
            }
            acc[type].push(loisir);
            return acc;
        }, {});

        const top5ByType = Object.keys(groupedByType).reduce((acc, type) => {
            acc[type] = groupedByType[type]
                .sort((a, b) => b.moyenne_notes - a.moyenne_notes)
                .slice(0, 5);
            return acc;
        }, {});

        res.status(200).json(top5ByType);
    } catch (err) {
        console.log(err);
        res.status(400).json({ message: 'Erreur lors de la récupération des loisirs !' });
    } finally {
        if (conn) conn.release();
    }
});

// Route pour récupérer tous les loisirs avec leur moyennes
app.get('/api/loisirs', async (req, res) => {
    let conn;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query('SELECT l.idloisir, l.type, l.nom, l.images, l.description, l.date_sortie, AVG(n.note) AS moyenne_notes FROM loisir l LEFT JOIN note n ON l.idloisir = n.loisir GROUP BY l.idloisir, l.type, l.nom, l.images, l.description, l.date_sortie order by l.nom ASC');
        res.status(200).json(rows[0]);
    } catch (err) {
        console.log(err);
        res.status(400).json({ message: 'Erreur lors de la récupération des loisirs !' });
    } finally {
        if (conn) conn.release();
    }
});

// Route pour récupérer un loisir par son id
app.get('/api/loisir/:id', async (req, res) => {
    let conn;
    let id = req.params.id;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query(`
            SELECT 
                l.idloisir, 
                l.type, 
                l.nom, 
                t.nom as nom_type,
                l.images, 
                l.description, 
                l.date_sortie, 
                AVG(n.note) AS moyenne_notes
            FROM 
                loisir l
            LEFT JOIN 
                note n ON l.idloisir = n.loisir
            LEFT JOIN
                type t ON l.type = t.id
            WHERE 
                l.idloisir = ?
            GROUP BY 
                l.idloisir, l.type, t.nom, l.nom, l.images, l.description, l.date_sortie
        `, [id]);
        res.status(200).json(rows[0]);
    } catch (err) {
        console.log(err);
        res.status(400).json({ message: 'Erreur lors de la récupération du loisir !' });
    } finally {
        if (conn) conn.release();
    }
});

// Route pour ajouter un loisir
app.post('/api/loisir', async (req, res) => {
    let conn;
    try {
        let { type, nom, images, description, date_sortie } = req.body;
        conn = await pool.getConnection();
        const rows = await conn.query('INSERT INTO loisir (type, nom, images, description, date_sortie) VALUES (?, ?, ?, ?, ?)', [type, nom, images, description, date_sortie]);
        res.status(200).json({ message: 'Loisir bien ajouté !' });
    } catch (err) {
        console.log(err);
        res.status(400).json({ message: 'Erreur lors de l\'ajout du loisir !' });
    } finally {
        if (conn) conn.release();
    }
});

// Route pour modifier un loisir
app.put('/api/loisir/:id', async (req, res) => {
    let conn;
    let id = req.params.id;
    let { type, nom, images, description, date_sortie } = req.body;

    // Valider les entrées
    if (!type || !nom || !images || !description || !date_sortie) {
        return res.status(400).json({ message: 'Toutes les informations du loisir sont requises.' });
    }

    try {
        conn = await pool.getConnection();
        const result = await conn.query(`
            UPDATE loisir 
            SET type = ?, nom = ?, images = ?, description = ?, date_sortie = ? 
            WHERE idloisir = ?
        `, [type, nom, images, description, date_sortie, id]);
        res.status(200).json({ message: 'Loisir modifié avec succès !' });
    } catch (err) {
        console.log(err);
        res.status(400).json({ message: 'Erreur lors de la modification du loisir !' });
    } finally {
        if (conn) conn.release();
    }
});
//ajouter des notes 
app.post('/api/loisir/:id/note', async (req, res) => {
    let conn;
    let id = req.params.id;
    let { note } = req.body;

    // Valider la note
    if (note == null || isNaN(note) || note < 1 || note > 5) {
        return res.status(400).json({ message: 'Note invalide, elle doit être un nombre entre 1 et 5.' });
    }

    try {
        conn = await pool.getConnection();
        const result = await conn.query('INSERT INTO note (loisir, note) VALUES (?, ?)', [id, note]);
        res.status(200).json({ message: 'Note ajoutée avec succès !'});
        // insertId: result[0].insertId 
    } catch (err) {
        console.log(err);
        res.status(400).json({ message: 'Erreur lors de l\'ajout de la note !' });
    } finally {
        if (conn) conn.release();
    }
});
// Route pour récupérer tous les types
app.get('/api/types', async (req, res) => {
    let conn;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query('SELECT * FROM type');
        res.status(200).json(rows[0]);
    } catch (err) {
        console.log(err);
        res.status(400).json({ message: 'Erreur lors de la récupération des types !' });
    } finally {
        if (conn) conn.release();
    }
});

// Route pour récupérer les notes d'un loisir par son id
app.get('/api/loisir/:id/notes', async (req, res) => {
    let conn;
    let id = req.params.id;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query('SELECT * FROM note WHERE loisir = ?', [id]);
        res.status(200).json(rows[0]);
    } catch (err) {
        console.log(err);
        res.status(400).json({ message: 'Erreur lors de la récupération des notes du loisir !' });
    } finally {
        if (conn) conn.release();
    }
});

app.listen(8000, () => {
    console.log("Serveur à l'écoute sur le port 8000");
});
