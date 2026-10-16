# Como funciona

## Modelo

Cada chamado pertence a um equipamento e a uma categoria. Pode ter um técnico responsável ou ficar sem responsável enquanto aguarda triagem.

- Um equipamento pode ter nenhum, um ou vários chamados.
- Um técnico pode ter nenhum, um ou vários chamados.
- Uma categoria pode aparecer em vários chamados.
- Cada chamado guarda uma data de abertura e, quando encerrado, uma data de resolução.

As chaves estrangeiras impedem cadastrar um chamado para um equipamento, técnico ou categoria inexistente. O valor nulo em `tecnico_id` significa que ainda não há responsável atribuído.

## Dicionário de dados

### equipamentos

| Coluna | Significado |
| --- | --- |
| `equipamento_id` | Identificador usado nos relacionamentos |
| `patrimonio` | Código único do ativo, como TI-001 |
| `descricao` | Nome curto do equipamento |
| `setor` | Área em que ele é utilizado |
| `adquirido_em` | Data fictícia de aquisição |

### tecnicos

| Coluna | Significado |
| --- | --- |
| `tecnico_id` | Identificador do técnico |
| `nome` | Nome fictício para apresentação nos resultados |

### categorias

| Coluna | Significado |
| --- | --- |
| `categoria_id` | Identificador da categoria |
| `nome` | Rede, Sistema, Hardware, Impressão ou Acesso |

### chamados

| Coluna | Significado |
| --- | --- |
| `chamado_id` | Identificador do chamado |
| `equipamento_id` | Equipamento relacionado |
| `tecnico_id` | Responsável, permitindo NULL |
| `categoria_id` | Tipo de ocorrência |
| `prioridade` | baixa, media ou alta |
| `status` | aberto, em_andamento, encerrado ou cancelado |
| `aberto_em` | Data e hora da abertura |
| `resolvido_em` | Data e hora da resolução; preenchida só para encerrados |
| `custo_servico` | Despesa direta final em reais; só encerrados podem ter custo |
| `descricao` | Resumo da ocorrência |

Os valores monetários usam `DECIMAL(10, 2)`, adequado para representar centavos. As datas usam `DATETIME` sem conversão automática de fuso: todos os horários do exemplo representam o mesmo horário local.

Os identificadores são definidos explicitamente para facilitar a leitura e a reprodução da carga.

## O que as regras garantem

Os `CHECK` impedem prioridades e situações fora da lista, custos negativos, resolução anterior à abertura e combinações incompatíveis entre situação, custo e data de resolução.

A situação `cancelado` não é uma resolução. Por isso ela não participa do tempo médio, custo final ou repetição de ocorrências. Entra apenas nas contagens gerais de abertura e situação. A data do cancelamento não foi modelada.

O banco não acompanha cada mudança de situação. Se um chamado voltar a apresentar problema, o exemplo registra uma nova ocorrência, sem tentar representar uma reabertura com histórico completo.

## Agrupamento e contagem

`GROUP BY` reúne linhas que possuem o mesmo valor. Na primeira consulta, ele forma um grupo para cada situação; `COUNT(*)` conta os chamados daquele grupo.

A consulta de repetição agrupa por equipamento e categoria. `HAVING COUNT(*) >= 2` mantém apenas grupos com duas ou mais ocorrências. O `WHERE` filtra as linhas antes do agrupamento; o `HAVING` filtra os grupos depois.

## Por que usar LEFT JOIN

Um `JOIN` comum exige correspondência nas duas tabelas. Um `LEFT JOIN` preserva todas as linhas da tabela da esquerda.

Na consulta de custos, os equipamentos ficam à esquerda. Assim, o TI-010 aparece mesmo sem chamados. O filtro `c.status = 'encerrado'` fica no `ON`. Se fosse colocado no `WHERE`, os equipamentos sem encerramentos seriam retirados do resultado.

Nesse caso, a contagem usa `COUNT(c.chamado_id)`, que ignora valores nulos. Usar `COUNT(*)` contaria a linha do equipamento sem chamado e mostraria um resultado incorreto.

A função `SUM` soma os custos. Quando um equipamento não tem chamados encerrados, o resultado da soma é nulo; `COALESCE` mostra zero no lugar.

A consulta liga somente equipamentos e chamados. Cada custo aparece uma vez. Se houvesse uma tabela de peças ou interações com várias linhas por chamado, seria necessário conferir a multiplicação das linhas antes de somar.

## Tempo até a resolução

`TIMESTAMPDIFF(SECOND, aberto_em, resolvido_em)` calcula o intervalo em segundos. A função `AVG` calcula a média; a divisão por 3600 converte para horas. O arredondamento é aplicado apenas ao resultado final.

Só entram chamados encerrados. A média de Diego aparece como `NULL`, porque ele não tem resoluções. Mostrar zero daria a impressão errada de que ele resolveu chamados imediatamente.

A média por técnico não é uma medida isolada de produtividade. Os chamados têm prioridades e complexidades diferentes, e o intervalo inclui espera por peças e tempo fora do expediente.

## Datas e interpretação

A fila pendente usa `@data_referencia = '2026-10-01 00:00:00'`. A data fixa evita que os resultados mudem apenas porque o projeto foi aberto em outro dia.

A base representa o estado conhecido nessa referência. Alterar a variável para uma data passada não reconstrói a situação histórica dos chamados, pois só existe a situação atual de cada registro.

A contagem mensal de aberturas usa `aberto_em`; a de resoluções usa `resolvido_em`. Os chamados 8 e 15 atravessam o fim do mês e ajudam a perceber essa diferença.

Repetição na mesma categoria é um sinal para investigação. Categorias amplas, como Hardware, podem reunir defeitos diferentes.

