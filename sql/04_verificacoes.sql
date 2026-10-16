USE portfolio_manutencao;

/* Conferências do conjunto original. Todas as linhas devem mostrar OK.
   Se você alterar os dados para estudar, os totais esperados podem mudar. */
SELECT 'equipamentos' AS verificacao, 10 AS esperado,
       COUNT(*) AS encontrado,
       IF(COUNT(*) = 10, 'OK', 'REVISAR') AS resultado
FROM equipamentos
UNION ALL
SELECT 'tecnicos', 4, COUNT(*), IF(COUNT(*) = 4, 'OK', 'REVISAR')
FROM tecnicos
UNION ALL
SELECT 'categorias', 5, COUNT(*), IF(COUNT(*) = 5, 'OK', 'REVISAR')
FROM categorias
UNION ALL
SELECT 'chamados', 30, COUNT(*), IF(COUNT(*) = 30, 'OK', 'REVISAR')
FROM chamados
UNION ALL
SELECT 'encerrados', 18, COUNT(*), IF(COUNT(*) = 18, 'OK', 'REVISAR')
FROM chamados WHERE status = 'encerrado'
UNION ALL
SELECT 'pendentes', 10, COUNT(*), IF(COUNT(*) = 10, 'OK', 'REVISAR')
FROM chamados WHERE status IN ('aberto', 'em_andamento')
UNION ALL
SELECT 'cancelados', 2, COUNT(*), IF(COUNT(*) = 2, 'OK', 'REVISAR')
FROM chamados WHERE status = 'cancelado'
UNION ALL
SELECT 'custo_total', 1985.00, COALESCE(SUM(custo_servico), 0),
       IF(COALESCE(SUM(custo_servico), 0) = 1985.00, 'OK', 'REVISAR')
FROM chamados WHERE status = 'encerrado'
UNION ALL
SELECT 'horas_resolucao_total', 273,
       COALESCE(SUM(TIMESTAMPDIFF(SECOND, aberto_em, resolvido_em)) / 3600, 0),
       IF(SUM(TIMESTAMPDIFF(SECOND, aberto_em, resolvido_em)) = 982800,
          'OK', 'REVISAR')
FROM chamados WHERE status = 'encerrado';

/* Deve retornar zero linhas. */
SELECT c.chamado_id
FROM chamados AS c
LEFT JOIN equipamentos AS e ON e.equipamento_id = c.equipamento_id
LEFT JOIN categorias AS cat ON cat.categoria_id = c.categoria_id
LEFT JOIN tecnicos AS t ON t.tecnico_id = c.tecnico_id
WHERE e.equipamento_id IS NULL
    OR cat.categoria_id IS NULL
    OR (c.tecnico_id IS NOT NULL AND t.tecnico_id IS NULL);

/* Deve retornar zero linhas. */
SELECT chamado_id
FROM chamados
WHERE resolvido_em < aberto_em
    OR custo_servico < 0
    OR (status = 'encerrado' AND resolvido_em IS NULL)
    OR (status <> 'encerrado' AND resolvido_em IS NOT NULL)
    OR (status <> 'encerrado' AND custo_servico <> 0)
    OR aberto_em >= '2026-10-01 00:00:00'
    OR resolvido_em >= '2026-10-01 00:00:00';

/* Equipamento sem chamados: deve retornar somente TI-010. */
SELECT e.patrimonio
FROM equipamentos AS e
LEFT JOIN chamados AS c ON c.equipamento_id = e.equipamento_id
WHERE c.chamado_id IS NULL
ORDER BY e.patrimonio;

/* Técnico sem resoluções: deve retornar somente Diego. */
SELECT t.nome
FROM tecnicos AS t
LEFT JOIN chamados AS c
    ON c.tecnico_id = t.tecnico_id AND c.status = 'encerrado'
WHERE c.chamado_id IS NULL
ORDER BY t.nome;

/* Chamados encerrados em mês diferente da abertura: 8 e 15. */
SELECT chamado_id
FROM chamados
WHERE status = 'encerrado'
    AND DATE_FORMAT(aberto_em, '%Y-%m') <> DATE_FORMAT(resolvido_em, '%Y-%m')
ORDER BY chamado_id;

