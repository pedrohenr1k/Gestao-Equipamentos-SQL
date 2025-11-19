/*
  PROJETO: Sistema de Gestão de Equipamentos
  OBJETIVO: Controle de empréstimos e manutenções
*/

-- 1. CRIAÇÃO DO BANCO E TABELAS

CREATE DATABASE IF NOT EXISTS GestaoEquipamentos;
USE GestaoEquipamentos;

-- Cadastro de pessoas
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    tipo_usuario VARCHAR(50) -- Aluno, Professor, etc.
);

-- Itens do patrimônio
CREATE TABLE Equipamento (
    id_equipamento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    patrimonio VARCHAR(50) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'Disponível'
);

-- Controle de quem pegou o que
CREATE TABLE Emprestimo (
    id_emprestimo INT AUTO_INCREMENT PRIMARY KEY,
    data_emprestimo DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_prevista_devolucao DATE NOT NULL,
    data_devolucao DATETIME,
    id_usuario INT,
    id_equipamento INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_equipamento) REFERENCES Equipamento(id_equipamento)
);

-- Histórico de consertos
CREATE TABLE Manutencao (
    id_manutencao INT AUTO_INCREMENT PRIMARY KEY,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    descricao TEXT,
    id_equipamento INT,
    FOREIGN KEY (id_equipamento) REFERENCES Equipamento(id_equipamento)
);

-- 2. MASSA DE DADOS (INSERTS)

-- Criando usuários
INSERT INTO Usuario (nome, email, telefone, tipo_usuario) VALUES
('João Silva', 'joao@escola.com', '1199999-1111', 'Aluno'),
('Maria Lima', 'maria@escola.com', '1198888-2222', 'Professor'),
('Carlos Teste', 'carlos@teste.com', '1197777-3333', 'Técnico'); -- Usuário extra para teste de delete

-- Criando equipamentos
INSERT INTO Equipamento (nome, categoria, patrimonio, status) VALUES
('Notebook Dell', 'TI', 'NTB-01', 'Empréstimo'),
('Projetor Epson', 'Vídeo', 'PRJ-02', 'Disponível'),
('Câmera Canon', 'Foto', 'CAM-03', 'Manutenção'),
('Cabo HDMI', 'Acessório', 'CAB-04', 'Disponível'); -- Equipamento extra para teste de delete

-- Criando empréstimo
INSERT INTO Emprestimo (data_emprestimo, data_prevista_devolucao, id_usuario, id_equipamento) 
VALUES ('2023-11-01 08:00:00', '2023-11-05', 1, 1);

-- Criando manutenção
INSERT INTO Manutencao (data_inicio, descricao, id_equipamento) 
VALUES ('2023-11-02', 'Troca de lente', 3);


-- 3. CONSULTAS (SELECTS)
-- Requisito: 2 a 5 consultas (WHERE, JOIN, ORDER BY, etc)

-- Consulta 1: Listar tudo que está disponível (WHERE)
SELECT * FROM Equipamento WHERE status = 'Disponível';

-- Consulta 2: Ver quem está com qual equipamento (JOIN)
SELECT u.nome, e.nome, emp.data_emprestimo 
FROM Emprestimo emp
JOIN Usuario u ON emp.id_usuario = u.id_usuario
JOIN Equipamento e ON emp.id_equipamento = e.id_equipamento;

-- Consulta 3: Listar usuários em ordem alfabética (ORDER BY)
SELECT * FROM Usuario ORDER BY nome ASC;


-- 4. ATUALIZAÇÕES (UPDATES)
-- Requisito: Ao menos 3 comandos

-- Update 1: Devolvendo equipamento (registrando data devolução)
UPDATE Emprestimo SET data_devolucao = NOW() WHERE id_emprestimo = 1;

-- Update 2: Alterando telefone de um usuário
UPDATE Usuario SET telefone = '1190000-0000' WHERE id_usuario = 1;

-- Update 3: Mudando status de um equipamento para Indisponível
UPDATE Equipamento SET status = 'Indisponível' WHERE id_equipamento = 2;


-- 5. REMOÇÕES (DELETES)
-- Requisito: Ao menos 3 comandos com condições

-- Delete 1: Apagar uma manutenção (ex: registro errado)
DELETE FROM Manutencao WHERE id_manutencao = 1;

-- Delete 2: Apagar um equipamento específico (que não tenha vínculo)
DELETE FROM Equipamento WHERE patrimonio = 'CAB-04';

-- Delete 3: Apagar um usuário específico (que não tenha empréstimos)
DELETE FROM Usuario WHERE nome = 'Carlos Teste';