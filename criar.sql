CREATE DATABASE gerenciamento_processos;

USE gerenciamento_processos;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(8) UNIQUE NOT NULL,
    senha VARCHAR(8) NOT NULL,
    nome VARCHAR(8) NOT NULL
);

CREATE TABLE processos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_processos VARCHAR(255),
    prazo_processual INT,
    classe_principal VARCHAR(255),
    assunto_principal VARCHAR(255),
    tarjas TEXT,
    data_intimacao DATE,
    usuario_id INT DEFAULT NULL,
    dias_restantes INT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);
