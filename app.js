const express = require('express');
const mysql = require('mysql2');
const multer = require('multer');
const csv = require('csv-parser');
const fs = require('fs');
const path = require('path');
const app = express();
const dotenv = require('dotenv');
dotenv.config();

// Configuração do banco de dados
const db = mysql.createConnection({
    host: 'localhost',
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

db.connect(err => {
    if (err) {
        console.log('Erro ao conectar no banco de dados:', err);
    } else {
        console.log('Conectado ao banco de dados');
    }
});

// Configuração do multer para upload de arquivos CSV
const upload = multer({ dest: 'uploads/' });

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Rota para importar CSV
app.post('/importar', upload.single('arquivo'), (req, res) => {
    const resultados = [];
    fs.createReadStream(req.file.path)
        .pipe(csv())
        .on('data', (row) => {
            resultados.push(row);
        })
        .on('end', () => {
            resultados.forEach(row => {
                const { numero_processos, prazo_processual, classe_principal, assunto_principal, tarjas, data_intimacao } = row;
                const query = `
                    INSERT INTO processos (numero_processos, prazo_processual, classe_principal, assunto_principal, tarjas, data_intimacao)
                    VALUES (?, ?, ?, ?, ?, ?)`;
                db.query(query, [numero_processos, prazo_processual, classe_principal, assunto_principal, tarjas, data_intimacao], (err) => {
                    if (err) console.log('Erro ao salvar processo:', err);
                });
            });
            res.redirect('/admin');
        });
});

// Rota de login
app.post('/login', (req, res) => {
    const { matricula, senha } = req.body;
    const query = `SELECT * FROM usuarios WHERE matricula = ? AND senha = ?`;
    db.query(query, [matricula, senha], (err, results) => {
        if (results.length > 0) {
            res.redirect(`/user/${results[0].id}`);
        } else {
            res.status(400).send('Credenciais inválidas');
        }
    });
});

// Rota de cadastro
app.post('/cadastrar', (req, res) => {
    const { matricula, senha, nome } = req.body;
    const query = `INSERT INTO usuarios (matricula, senha, nome) VALUES (?, ?, ?)`;
    db.query(query, [matricula, senha, nome], (err) => {
        if (err) return res.status(500).send('Erro no cadastro');
        res.send('Cadastro realizado com sucesso!');
    });
});

// Rota de administração
app.get('/admin', (req, res) => {
    const query = 'SELECT * FROM processos';
    db.query(query, (err, processos) => {
        if (err) return res.status(500).send('Erro ao carregar processos');
        res.render('admin', { processos });
    });
});

// Rota de exibição de processos de usuário
app.get('/user/:id', (req, res) => {
    const userId = req.params.id;
    const query = `SELECT * FROM processos WHERE usuario_id = ?`;
    db.query(query, [userId], (err, processos) => {
        if (err) return res.status(500).send('Erro ao carregar processos do usuário');
        res.render('user', { processos });
    });
});

app.listen(3000, () => {
    console.log('Servidor rodando na porta 3000');
});
