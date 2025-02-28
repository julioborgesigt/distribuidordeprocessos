-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS distribuidordeprocessos_teste;
USE distribuidordeprocessos_teste;

-- Tabela para armazenar usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,   -- Identificador único do usuário
    nome VARCHAR(255) NOT NULL,           -- Nome do usuário
    email VARCHAR(255) UNIQUE NOT NULL,   -- E-mail do usuário
    senha VARCHAR(255) NOT NULL,          -- Senha do usuário
    cargo ENUM('admin', 'usuario') NOT NULL, -- Cargo do usuário (admin ou usuário)
    status ENUM('ativo', 'inativo') DEFAULT 'ativo', -- Status do usuário
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Data de criação
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Data de atualização
);

-- Tabela para armazenar os processos
CREATE TABLE IF NOT EXISTS processos (
    id INT AUTO_INCREMENT PRIMARY KEY,   -- Identificador único do processo
    numero_processos VARCHAR(255) NOT NULL, -- Número do processo
    descricao TEXT,                      -- Descrição do processo
    status ENUM('pendente', 'cumprido') DEFAULT 'pendente', -- Status do processo
    data_inicio TIMESTAMP,               -- Data de início do processo
    data_fim TIMESTAMP,                  -- Data de fim do processo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data de criação
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Data de atualização
);

-- Tabela para relacionar os processos aos usuários
CREATE TABLE IF NOT EXISTS processos_usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,   -- Identificador único
    usuario_id INT,                      -- ID do usuário
    processo_id INT,                     -- ID do processo
    atribuido_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data de atribuição
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,  -- Relacionamento com a tabela de usuários
    FOREIGN KEY (processo_id) REFERENCES processos(id) ON DELETE CASCADE -- Relacionamento com a tabela de processos
);

-- Tabela para armazenar registros de log (como logs de atividades de administrador)
CREATE TABLE IF NOT EXISTS logs (
    id INT AUTO_INCREMENT PRIMARY KEY,    -- Identificador único
    usuario_id INT,                       -- ID do usuário que fez a ação
    acao VARCHAR(255),                     -- Descrição da ação executada
    data_acao TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data e hora da ação
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE -- Relacionamento com a tabela de usuários
);

-- Tabela para armazenar os registros de importação de CSV
CREATE TABLE IF NOT EXISTS importacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,    -- Identificador único da importação
    usuario_id INT,                       -- ID do usuário que fez a importação
    nome_arquivo VARCHAR(255),             -- Nome do arquivo CSV importado
    data_importacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data e hora da importação
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE -- Relacionamento com a tabela de usuários
);
