# Resultados esperados

Referência calculada a partir dos registros de `02_dados.sql`, sem alterações, com data de referência em **01/10/2026 às 00:00**.

Os valores abaixo permitem conferir cada consulta. A interface pode mostrar mais casas decimais ou ponto no lugar de vírgula.

## 1. Quantidade por situação

| status | quantidade |
| --- | ---: |
| aberto | 6 |
| cancelado | 2 |
| em_andamento | 4 |
| encerrado | 18 |

## 2 e 3. Aberturas e resoluções por mês

São resultados de consultas diferentes, reunidos aqui para comparação.

| Mês | Aberturas, incluindo cancelados | Resoluções |
| --- | ---: | ---: |
| 2026-07 | 8 | 7 |
| 2026-08 | 8 | 7 |
| 2026-09 | 14 | 4 |

Os chamados 8 e 15 foram resolvidos no mês seguinte à abertura.

## 4. Tempo médio

| chamados_encerrados | media_horas_resolucao |
| ---: | ---: |
| 18 | 15,17 |

Os intervalos somam 273 horas. A média antes do arredondamento é 273 ÷ 18 = 15,1666... horas.

## 5. Custo por equipamento

| patrimonio | chamados_encerrados | custo_total |
| --- | ---: | ---: |
| TI-004 | 2 | 650,00 |
| TI-001 | 3 | 300,00 |
| TI-002 | 3 | 300,00 |
| TI-007 | 2 | 220,00 |
| TI-008 | 2 | 210,00 |
| TI-003 | 2 | 170,00 |
| TI-005 | 2 | 135,00 |
| TI-006 | 2 | 0,00 |
| TI-009 | 0 | 0,00 |
| TI-010 | 0 | 0,00 |

Soma: R$ 1.985,00. TI-006 tem serviços encerrados sem despesa direta; TI-009 só tem pendências e um cancelado; TI-010 não tem chamados.

## 6. Repetição por equipamento e categoria

| patrimonio | categoria | quantidade |
| --- | --- | ---: |
| TI-002 | Sistema | 3 |
| TI-003 | Rede | 3 |
| TI-004 | Hardware | 3 |
| TI-005 | Impressão | 3 |
| TI-006 | Acesso | 3 |
| TI-008 | Rede | 3 |
| TI-001 | Hardware | 2 |
| TI-001 | Sistema | 2 |
| TI-007 | Sistema | 2 |

Cancelados não participam dessa contagem. A consulta inclui encerrados e pendentes.

## 7. Fila pendente

| chamado_id | patrimonio | prioridade | status | tecnico | horas_em_aberto | dias_em_aberto |
| ---: | --- | --- | --- | --- | ---: | ---: |
| 25 | TI-007 | baixa | aberto | Sem responsável | 304 | 12,67 |
| 19 | TI-001 | alta | aberto | Diego | 256 | 10,67 |
| 20 | TI-002 | media | aberto | Sem responsável | 135 | 5,63 |
| 22 | TI-004 | alta | em_andamento | Ana | 110 | 4,58 |
| 26 | TI-008 | alta | em_andamento | Carla | 84 | 3,50 |
| 21 | TI-003 | alta | em_andamento | Carla | 64 | 2,67 |
| 23 | TI-005 | media | aberto | Sem responsável | 39 | 1,63 |
| 28 | TI-009 | baixa | aberto | Diego | 38 | 1,58 |
| 24 | TI-006 | baixa | em_andamento | Diego | 16 | 0,67 |
| 27 | TI-009 | media | aberto | Sem responsável | 8 | 0,33 |

## 8. Resoluções por técnico

| nome | chamados_encerrados | media_horas_resolucao |
| --- | ---: | ---: |
| Ana | 6 | 27,67 |
| Bruno | 6 | 12,33 |
| Carla | 6 | 5,50 |
| Diego | 0 | NULL |

As médias de duração não representam um ranking de desempenho.

## 9. Distribuição por categoria

| categoria | quantidade |
| --- | ---: |
| Hardware | 8 |
| Sistema | 7 |
| Rede | 6 |
| Acesso | 4 |
| Impressão | 3 |

Soma: 28 chamados, pois os dois cancelados ficaram fora.

## Conferências adicionais

Em `04_verificacoes.sql`:

- As nove verificações numéricas devem mostrar `OK`.
- As consultas de referências e regras inválidas devem retornar zero linhas.
- Equipamento sem qualquer chamado: TI-010.
- Técnico sem chamados encerrados: Diego.
- Chamados que atravessaram o mês: 8 e 15.

## Execução conferida

Em 16/10/2026, os quatro scripts foram executados em uma instância isolada do MySQL 8.4.11. Todas as saídas acima foram conferidas com a execução real.

Também foram verificados:

- Reexecução de estrutura e dados sem duplicar registros, mantendo as nove verificações com resultado `OK`.
- Preservação de uma alteração no setor do TI-010 após reexecutar a carga. O valor original foi restaurado após a conferência.
- Rejeição de custo negativo, prioridade inválida, encerramento sem data, resolução anterior à abertura e chamado pendente com custo, pelas regras `CHECK`.
- Rejeição de referência a um equipamento inexistente pela chave estrangeira.

Esses testes verificam as regras deste modelo e do conjunto de exemplo. A versão mínima declarada não foi executada nesta conferência.

