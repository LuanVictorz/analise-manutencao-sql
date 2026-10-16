# Análise de manutenção de equipamentos

Consultas em MySQL para acompanhar chamados de suporte, custos de manutenção e equipamentos com ocorrências repetidas.

A base simula uma operação pequena com 10 equipamentos, 4 técnicos e 30 chamados entre julho e setembro de 2026. Todos os registros são fictícios. O projeto é um estudo de SQL e não representa atendimento realizado em uma empresa.

## Perguntas do projeto

- Qual é o volume de chamados por mês e por situação?
- Quanto tempo os chamados encerrados levaram até a resolução?
- Quais equipamentos concentram os maiores custos?
- Onde há repetição de chamados na mesma categoria?
- Quais chamados continuam pendentes em 1º de outubro de 2026?
- Como incluir técnicos e equipamentos que ainda não tiveram resoluções?

## O que precisa estar instalado

- MySQL Server 8.0.16 ou superior, incluindo a linha 8.4.
- MySQL Workbench, ou outro cliente capaz de executar arquivos SQL.
- Uma conexão local com permissão para criar a base de estudo.

O Workbench é a interface. O servidor MySQL precisa estar instalado e em execução para que a conexão funcione.

## Como executar

1. Abra a conexão local no Workbench.
2. Confira se o nome `portfolio_manutencao` está livre para este estudo. Se já for usado por outro projeto, substitua esse nome nos quatro arquivos SQL por um nome novo.
3. Abra e execute o conteúdo completo de `sql/01_estrutura.sql`.
4. No menu **Query**, ative **Stop Script Execution On Errors**. Execute `sql/02_dados.sql` e confirme que o painel de execução não mostra erros.
5. Execute `sql/04_verificacoes.sql`. O primeiro resultado deve ter apenas linhas com `OK`.
6. Execute `sql/03_consultas.sql` para ver as análises. A variável de data no começo do arquivo precisa ser executada na mesma aba e conexão das consultas que a utilizam.
7. Compare os resultados com [RESULTADOS_ESPERADOS.md](docs/RESULTADOS_ESPERADOS.md).

O [roteiro do Workbench](docs/ROTEIRO_WORKBENCH.md) explica a execução com mais detalhes e propõe pequenas alterações para praticar.

## Resultados principais da base original

| Indicador | Resultado |
| --- | ---: |
| Chamados cadastrados | 30 |
| Chamados encerrados | 18 |
| Chamados pendentes | 10 |
| Chamados cancelados | 2 |
| Custo dos serviços encerrados | R$ 1.985,00 |
| Tempo médio até a resolução | 15,17 horas corridas |

O equipamento TI-004 concentra R$ 650,00 de custo. Isso justifica investigar o histórico, mas a base não informa idade útil, valor de reposição ou impacto operacional suficientes para decidir uma substituição.

O chamado 25 é o mais antigo da fila pendente: 304 horas na data de referência. Ele tem prioridade baixa. A ordem por idade ajuda a enxergar a fila, mas não substitui uma regra de atendimento por impacto e prioridade.

## Arquivos

| Arquivo | Função |
| --- | --- |
| `sql/01_estrutura.sql` | Base, tabelas, relacionamentos e regras de integridade |
| `sql/02_dados.sql` | Registros fictícios |
| `sql/03_consultas.sql` | Nove consultas de análise |
| `sql/04_verificacoes.sql` | Conferências dos dados e dos casos de borda |
| [COMO_FUNCIONA.md](docs/COMO_FUNCIONA.md) | Modelo, dicionário e decisões das consultas |
| [RESULTADOS_ESPERADOS.md](docs/RESULTADOS_ESPERADOS.md) | Referência para conferir os resultados |
| [ROTEIRO_WORKBENCH.md](docs/ROTEIRO_WORKBENCH.md) | Execução, exercícios e perguntas para explicar o projeto |

## Reexecução e limites

Os arquivos não contêm comandos para apagar a base ou tabelas. A estrutura usa `IF NOT EXISTS`. O arquivo de dados mantém o conteúdo de registros que já existem com as mesmas chaves, em vez de criar duplicatas ou substituir alterações.

Essa reexecução não restaura os valores originais e não atualiza uma estrutura antiga. Para repetir o exercício desde o início, escolha outra base vazia e ajuste o nome nos quatro arquivos. Não execute sobre uma base de trabalho.

Se a execução parar por um erro durante a carga, execute `ROLLBACK;` na mesma conexão antes de corrigir e tentar novamente. A carga usa uma transação; os comandos de criação da estrutura ficam em um arquivo separado. Se o cliente continuar após um erro e chegar ao `COMMIT`, o `ROLLBACK` posterior não desfaz o que já foi confirmado. Confira sempre as saídas e as verificações.

Os tempos são corridos, incluindo noites e fins de semana. Não há metas de SLA, histórico de mudanças de status, controle de expediente ou aplicação para cadastrar chamados. Custo zero significa ausência de despesa direta registrada no exemplo, não ausência de trabalho.

## Validação

Os quatro scripts foram executados em uma instância isolada do MySQL 8.4.11 em 16/10/2026. As nove verificações numéricas passaram, as consultas corresponderam aos resultados documentados e a reexecução da estrutura e dos dados não criou duplicatas. Também foi conferida a preservação de uma alteração existente e a rejeição de dados que violam as regras de integridade. Os detalhes estão em [RESULTADOS_ESPERADOS.md](docs/RESULTADOS_ESPERADOS.md).

