# Roteiro no MySQL Workbench

## Preparar a conexão

1. Abra o Workbench e entre na sua conexão local.
2. Se não houver conexão disponível, confirme se o MySQL Server está instalado e iniciado. Instalar apenas o Workbench não cria um servidor.
3. Abra uma aba SQL e execute `SELECT VERSION();`. Este projeto precisa de MySQL 8.0.16 ou mais recente por causa das regras `CHECK`.
4. Execute `SHOW DATABASES LIKE 'portfolio_manutencao';`. Se o nome já pertence a outro trabalho, escolha outro nome e faça a substituição nos quatro arquivos deste projeto.

Não é necessário colocar senha em arquivo do projeto. Use a conexão configurada no Workbench.

## Criar e carregar

1. Use **File > Open SQL Script** para abrir `sql/01_estrutura.sql`.
2. Execute o arquivo completo. No Workbench, a opção de executar todo o script é diferente da opção de executar apenas a instrução onde está o cursor. Ao usar o botão de raio para o script, deixe o texto sem seleção.
3. Confira o painel **Action Output**. Avisos de que uma base ou tabela já existe podem ocorrer em uma reexecução. Erros precisam ser resolvidos antes de continuar.
4. Atualize a lista **Schemas** para visualizar `portfolio_manutencao` e suas quatro tabelas.
5. No menu **Query**, ative **Stop Script Execution On Errors**, opção descrita no [manual do Workbench](https://dev.mysql.com/doc/workbench/en/wb-sql-editor-main-menu.html). Abra `sql/02_dados.sql` e execute o arquivo completo, da transação até o `COMMIT`.
6. Se a execução parar por um erro na carga, execute `ROLLBACK;` na mesma conexão antes de corrigir. Caso o cliente tenha continuado e executado o `COMMIT`, o `ROLLBACK` posterior não desfaz a carga confirmada. Não siga para as análises supondo que todos os dados foram inseridos; confira as verificações.

## Conferir os dados

1. Execute `sql/04_verificacoes.sql`.
2. No primeiro conjunto de resultados, todas as nove linhas devem mostrar `OK`.
3. Os dois resultados seguintes devem estar vazios, indicando ausência das inconsistências verificadas.
4. A lista de equipamentos sem chamados deve mostrar TI-010.
5. A lista de técnicos sem resoluções deve mostrar Diego.
6. A consulta final deve mostrar os chamados 8 e 15.

Se aparecer `REVISAR`, confira a quantidade encontrada e veja se a carga terminou ou se você já alterou algum dado. O arquivo verifica o conjunto original.

## Ler as análises

1. Abra `sql/03_consultas.sql`.
2. Execute primeiro `USE portfolio_manutencao;` e a instrução que define `@data_referencia`.
3. Execute uma consulta por vez selecionando todo o seu texto, até o ponto e vírgula.
4. Leia o comentário acima da consulta e descreva a pergunta com suas próprias palavras.
5. Compare com [RESULTADOS_ESPERADOS.md](RESULTADOS_ESPERADOS.md).
6. Para guardar uma saída, use a exportação do resultado para CSV. Não é necessário exportar o banco inteiro para publicar este projeto.

## Exercícios curtos

Faça uma cópia da consulta antes de alterá-la. Assim, os arquivos originais continuam servindo de referência.

1. Na consulta 7, acrescente um filtro para prioridade alta. Devem aparecer 4 chamados: 19, 21, 22 e 26, ordenados por idade.
2. Na consulta 6, mude a regra para pelo menos 3 ocorrências. Devem aparecer 6 grupos.
3. Na consulta 5, tente entender por que TI-006, TI-009 e TI-010 têm custo zero, apesar de possuírem históricos diferentes.
4. Troque o `LEFT JOIN` da consulta 8 por `JOIN`. Observe que Diego desaparece. Volte à consulta original.
5. Compare as consultas 2 e 3. Localize os chamados que foram abertos e resolvidos em meses diferentes.

## Perguntas para apresentar o projeto

**Qual problema a base ajuda a analisar?**  
Acompanhamento de fila, custos e ocorrências em equipamentos de uma operação pequena.

**Por que os cancelados não entram na média de resolução?**  
Eles não representam um atendimento concluído e não têm data de resolução no modelo.

**Qual a diferença entre WHERE e HAVING?**  
O primeiro filtra registros; o segundo filtra resultados depois do agrupamento.

**Por que alguns filtros estão no ON?**  
Para limitar os chamados correspondentes e ainda preservar todos os equipamentos ou técnicos da tabela da esquerda.

**Por que COUNT(chamado_id) em vez de COUNT(*) no LEFT JOIN?**  
Para contar apenas os chamados encontrados, sem contar a linha preservada de um cadastro sem correspondência.

**O que o projeto não permite concluir?**  
Não permite avaliar SLA, produtividade individual ou decidir a troca de um equipamento apenas com os indicadores disponíveis.

**Qual seria um próximo passo?**  
Registrar o histórico de mudanças de situação ou comparar custos com o valor de reposição. Cada avanço precisaria de dados e regras adicionais.

