/* Execute este arquivo antes dos dados. Não apaga tabelas existentes. */
CREATE DATABASE IF NOT EXISTS portfolio_manutencao
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE portfolio_manutencao;

CREATE TABLE IF NOT EXISTS equipamentos (
    equipamento_id INT PRIMARY KEY,
    patrimonio VARCHAR(20) NOT NULL UNIQUE,
    descricao VARCHAR(100) NOT NULL,
    setor VARCHAR(60) NOT NULL,
    adquirido_em DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS tecnicos (
    tecnico_id INT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL
);

CREATE TABLE IF NOT EXISTS categorias (
    categoria_id INT PRIMARY KEY,
    nome VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS chamados (
    chamado_id INT PRIMARY KEY,
    equipamento_id INT NOT NULL,
    tecnico_id INT NULL,
    categoria_id INT NOT NULL,
    prioridade VARCHAR(10) NOT NULL,
    status VARCHAR(15) NOT NULL,
    aberto_em DATETIME NOT NULL,
    resolvido_em DATETIME NULL,
    custo_servico DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    descricao VARCHAR(160) NOT NULL,

    CONSTRAINT fk_chamado_equipamento
        FOREIGN KEY (equipamento_id) REFERENCES equipamentos (equipamento_id),
    CONSTRAINT fk_chamado_tecnico
        FOREIGN KEY (tecnico_id) REFERENCES tecnicos (tecnico_id),
    CONSTRAINT fk_chamado_categoria
        FOREIGN KEY (categoria_id) REFERENCES categorias (categoria_id),
    CONSTRAINT ck_chamado_prioridade
        CHECK (prioridade IN ('baixa', 'media', 'alta')),
    CONSTRAINT ck_chamado_status
        CHECK (status IN ('aberto', 'em_andamento', 'encerrado', 'cancelado')),
    CONSTRAINT ck_chamado_resolucao
        CHECK (
            (status = 'encerrado' AND resolvido_em IS NOT NULL)
            OR (status <> 'encerrado' AND resolvido_em IS NULL)
        ),
    CONSTRAINT ck_chamado_datas
        CHECK (resolvido_em IS NULL OR resolvido_em >= aberto_em),
    CONSTRAINT ck_chamado_custo
        CHECK (
            custo_servico >= 0
            AND (status = 'encerrado' OR custo_servico = 0)
        ),

    INDEX idx_chamados_abertura (aberto_em),
    INDEX idx_chamados_status (status)
);

