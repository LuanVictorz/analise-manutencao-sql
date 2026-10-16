USE portfolio_manutencao;

/* Dados fictícios. IDs repetidos preservam os registros que já existem.
   Para restaurar o exemplo original, use outra base vazia conforme o README. */
START TRANSACTION;

INSERT INTO equipamentos
    (equipamento_id, patrimonio, descricao, setor, adquirido_em)
VALUES
    (1, 'TI-001', 'Computador do caixa', 'Atendimento', '2023-04-10'),
    (2, 'TI-002', 'Computador do estoque', 'Estoque', '2023-04-10'),
    (3, 'TI-003', 'Roteador principal', 'Atendimento', '2022-10-15'),
    (4, 'TI-004', 'Notebook administrativo', 'Administrativo', '2023-08-20'),
    (5, 'TI-005', 'Impressora de documentos', 'Administrativo', '2022-09-05'),
    (6, 'TI-006', 'Computador de relatórios', 'Financeiro', '2024-02-12'),
    (7, 'TI-007', 'Computador da recepção', 'Recepção', '2023-06-18'),
    (8, 'TI-008', 'Switch de rede', 'Administrativo', '2024-01-08'),
    (9, 'TI-009', 'Impressora de etiquetas', 'Estoque', '2025-03-22'),
    (10, 'TI-010', 'Notebook de reserva', 'TI', '2026-05-04')
ON DUPLICATE KEY UPDATE equipamento_id = equipamentos.equipamento_id;

INSERT INTO tecnicos (tecnico_id, nome)
VALUES (1, 'Ana'), (2, 'Bruno'), (3, 'Carla'), (4, 'Diego')
ON DUPLICATE KEY UPDATE tecnico_id = tecnicos.tecnico_id;

INSERT INTO categorias (categoria_id, nome)
VALUES (1, 'Rede'), (2, 'Sistema'), (3, 'Hardware'), (4, 'Impressão'), (5, 'Acesso')
ON DUPLICATE KEY UPDATE categoria_id = categorias.categoria_id;

INSERT INTO chamados (
    chamado_id, equipamento_id, tecnico_id, categoria_id,
    prioridade, status, aberto_em, resolvido_em, custo_servico, descricao
)
VALUES
    (1, 1, 1, 3, 'alta', 'encerrado', '2026-07-02 08:00:00', '2026-07-02 12:00:00', 120, 'Computador desligando durante o expediente'),
    (2, 2, 2, 2, 'media', 'encerrado', '2026-07-03 09:00:00', '2026-07-04 09:00:00', 0, 'Sistema de estoque não iniciava'),
    (3, 3, 3, 1, 'alta', 'encerrado', '2026-07-05 10:00:00', '2026-07-05 12:00:00', 80, 'Perda de conexão no atendimento'),
    (4, 4, 1, 3, 'media', 'encerrado', '2026-07-10 08:00:00', '2026-07-11 08:00:00', 250, 'Notebook com falha na bateria'),
    (5, 5, 2, 4, 'media', 'encerrado', '2026-07-12 13:00:00', '2026-07-12 15:00:00', 60, 'Papel atolando na impressora'),
    (6, 6, 3, 5, 'baixa', 'encerrado', '2026-07-15 09:00:00', '2026-07-15 10:00:00', 0, 'Acesso à pasta compartilhada negado'),
    (7, 1, 1, 3, 'alta', 'encerrado', '2026-07-20 08:00:00', '2026-07-21 08:00:00', 180, 'Ventoinha com ruído e aquecimento'),
    (8, 7, 2, 2, 'media', 'encerrado', '2026-07-31 16:00:00', '2026-08-01 10:00:00', 0, 'Atualização interrompida no fechamento'),
    (9, 8, 3, 1, 'alta', 'encerrado', '2026-08-03 08:00:00', '2026-08-03 11:00:00', 150, 'Porta do switch sem comunicação'),
    (10, 2, 2, 2, 'media', 'encerrado', '2026-08-05 09:00:00', '2026-08-05 12:00:00', 0, 'Erro ao exportar relatório de estoque'),
    (11, 3, 3, 1, 'alta', 'encerrado', '2026-08-08 08:00:00', '2026-08-09 08:00:00', 90, 'Conexão instável após queda de energia'),
    (12, 4, 1, 3, 'media', 'encerrado', '2026-08-10 08:00:00', '2026-08-12 08:00:00', 400, 'Armazenamento com falha de leitura'),
    (13, 5, 2, 4, 'baixa', 'encerrado', '2026-08-15 14:00:00', '2026-08-15 17:00:00', 75, 'Impressão saindo com manchas'),
    (14, 6, 3, 5, 'baixa', 'encerrado', '2026-08-20 09:00:00', '2026-08-20 10:00:00', 0, 'Permissão de pasta precisava de ajuste'),
    (15, 1, 1, 2, 'media', 'encerrado', '2026-08-31 16:00:00', '2026-09-01 10:00:00', 0, 'Aplicativo de caixa travando ao abrir'),
    (16, 7, 2, 3, 'media', 'encerrado', '2026-09-05 08:00:00', '2026-09-06 08:00:00', 220, 'Memória com falha intermitente'),
    (17, 8, 3, 1, 'alta', 'encerrado', '2026-09-10 09:00:00', '2026-09-10 11:00:00', 60, 'Cabo de rede danificado'),
    (18, 2, 1, 3, 'alta', 'encerrado', '2026-09-15 08:00:00', '2026-09-17 08:00:00', 300, 'Fonte com falha de alimentação'),
    (19, 1, 4, 2, 'alta', 'aberto', '2026-09-20 08:00:00', NULL, 0, 'Lentidão no aplicativo de caixa'),
    (20, 2, NULL, 2, 'media', 'aberto', '2026-09-25 09:00:00', NULL, 0, 'Relatório de estoque não conclui'),
    (21, 3, 3, 1, 'alta', 'em_andamento', '2026-09-28 08:00:00', NULL, 0, 'Oscilação na rede do atendimento'),
    (22, 4, 1, 3, 'alta', 'em_andamento', '2026-09-26 10:00:00', NULL, 0, 'Notebook não carrega a bateria'),
    (23, 5, NULL, 4, 'media', 'aberto', '2026-09-29 09:00:00', NULL, 0, 'Fila de impressão parada'),
    (24, 6, 4, 5, 'baixa', 'em_andamento', '2026-09-30 08:00:00', NULL, 0, 'Novo acesso à pasta de relatórios'),
    (25, 7, NULL, 2, 'baixa', 'aberto', '2026-09-18 08:00:00', NULL, 0, 'Falha ao instalar atualização'),
    (26, 8, 3, 1, 'alta', 'em_andamento', '2026-09-27 12:00:00', NULL, 0, 'Rede intermitente no setor administrativo'),
    (27, 9, NULL, 3, 'media', 'aberto', '2026-09-30 16:00:00', NULL, 0, 'Impressora de etiquetas não liga'),
    (28, 9, 4, 5, 'baixa', 'aberto', '2026-09-29 10:00:00', NULL, 0, 'Usuário sem permissão para imprimir etiquetas'),
    (29, 5, NULL, 4, 'baixa', 'cancelado', '2026-08-21 09:00:00', NULL, 0, 'Solicitação duplicada de impressão'),
    (30, 9, 4, 2, 'media', 'cancelado', '2026-09-22 10:00:00', NULL, 0, 'Solicitação aberta para equipamento incorreto')
ON DUPLICATE KEY UPDATE chamado_id = chamados.chamado_id;

COMMIT;

