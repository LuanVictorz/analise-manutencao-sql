USE portfolio_manutencao;

/* A mesma data produz os mesmos resultados em qualquer dia de execução. */
SET @data_referencia = CAST('2026-10-01 00:00:00' AS DATETIME);

/* 1. Quantos chamados existem em cada situação? Inclui cancelados. */
SELECT
    status,
    COUNT(*) AS quantidade
FROM chamados
GROUP BY status
ORDER BY status;

/* 2. Quantos chamados foram abertos por mês? Inclui cancelados. */
SELECT
    DATE_FORMAT(aberto_em, '%Y-%m') AS mes_abertura,
    COUNT(*) AS quantidade
FROM chamados
GROUP BY DATE_FORMAT(aberto_em, '%Y-%m')
ORDER BY mes_abertura;

/* 3. Quantos foram resolvidos por mês? Usa a data da resolução. */
SELECT
    DATE_FORMAT(resolvido_em, '%Y-%m') AS mes_resolucao,
    COUNT(*) AS quantidade
FROM chamados
WHERE status = 'encerrado'
GROUP BY DATE_FORMAT(resolvido_em, '%Y-%m')
ORDER BY mes_resolucao;

/* 4. Tempo corrido entre abertura e resolução, somente dos encerrados. */
SELECT
    COUNT(*) AS chamados_encerrados,
    ROUND(
        AVG(TIMESTAMPDIFF(SECOND, aberto_em, resolvido_em)) / 3600,
        2
    ) AS media_horas_resolucao
FROM chamados
WHERE status = 'encerrado';

/* 5. Custo final por equipamento. Um chamado entra uma única vez na soma. */
SELECT
    e.patrimonio,
    e.descricao,
    COUNT(c.chamado_id) AS chamados_encerrados,
    COALESCE(SUM(c.custo_servico), 0.00) AS custo_total
FROM equipamentos AS e
LEFT JOIN chamados AS c
    ON c.equipamento_id = e.equipamento_id
    AND c.status = 'encerrado'
GROUP BY e.equipamento_id, e.patrimonio, e.descricao
ORDER BY custo_total DESC, e.patrimonio;

/* 6. Repetições por equipamento e categoria, sem chamados cancelados.
   A repetição indica um ponto a investigar, não prova o mesmo defeito. */
SELECT
    e.patrimonio,
    cat.nome AS categoria,
    COUNT(*) AS quantidade
FROM chamados AS c
JOIN equipamentos AS e
    ON e.equipamento_id = c.equipamento_id
JOIN categorias AS cat
    ON cat.categoria_id = c.categoria_id
WHERE c.status <> 'cancelado'
GROUP BY e.equipamento_id, e.patrimonio, cat.categoria_id, cat.nome
HAVING COUNT(*) >= 2
ORDER BY quantidade DESC, e.patrimonio, categoria;

/* 7. Fila pendente na data de referência.
   A base representa esse retrato; não há histórico de mudanças de status. */
SELECT
    c.chamado_id,
    e.patrimonio,
    c.prioridade,
    c.status,
    COALESCE(t.nome, 'Sem responsável') AS tecnico,
    TIMESTAMPDIFF(HOUR, c.aberto_em, @data_referencia) AS horas_em_aberto,
    ROUND(
        TIMESTAMPDIFF(SECOND, c.aberto_em, @data_referencia) / 86400,
        2
    ) AS dias_em_aberto
FROM chamados AS c
JOIN equipamentos AS e
    ON e.equipamento_id = c.equipamento_id
LEFT JOIN tecnicos AS t
    ON t.tecnico_id = c.tecnico_id
WHERE c.status IN ('aberto', 'em_andamento')
    AND c.aberto_em <= @data_referencia
ORDER BY horas_em_aberto DESC, c.chamado_id;

/* 8. Técnicos com e sem resoluções. O filtro fica no ON para manter todos. */
SELECT
    t.nome,
    COUNT(c.chamado_id) AS chamados_encerrados,
    ROUND(
        AVG(TIMESTAMPDIFF(SECOND, c.aberto_em, c.resolvido_em)) / 3600,
        2
    ) AS media_horas_resolucao
FROM tecnicos AS t
LEFT JOIN chamados AS c
    ON c.tecnico_id = t.tecnico_id
    AND c.status = 'encerrado'
GROUP BY t.tecnico_id, t.nome
ORDER BY t.tecnico_id;

/* 9. Distribuição por categoria, excluindo cancelados. */
SELECT
    cat.nome AS categoria,
    COUNT(c.chamado_id) AS quantidade
FROM categorias AS cat
LEFT JOIN chamados AS c
    ON c.categoria_id = cat.categoria_id
    AND c.status <> 'cancelado'
GROUP BY cat.categoria_id, cat.nome
ORDER BY quantidade DESC, cat.nome;

