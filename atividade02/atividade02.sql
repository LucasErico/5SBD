Parte 1 – Funções de Caracteres, Números e Datas (Seção 4)
1. Exiba os nomes dos clientes com todas as letras em maiúsculas.

SQL

SELECT UPPER(cliente_nome)
FROM cliente;
2. Exiba os nomes dos clientes formatados com apenas a primeira letra maiúscula.

SQL

SELECT INITCAP(cliente_nome)
FROM cliente;
3. Mostre as três primeiras letras do nome de cada cliente.

SQL

SELECT SUBSTR(cliente_nome, 1, 3)
FROM cliente;
4. Exiba o número de caracteres do nome de cada cliente.

SQL

SELECT cliente_nome, LENGTH(cliente_nome) AS numero_de_caracteres
FROM cliente;
5. Apresente o saldo de todas as contas, arredondado para o inteiro mais próximo.

SQL

SELECT conta_numero, saldo, ROUND(saldo, 0) AS saldo_arredondado
FROM conta;
6. Exiba o saldo truncado, sem casas decimais.

SQL

SELECT conta_numero, saldo, TRUNC(saldo) AS saldo_truncado
FROM conta;
7. Mostre o resto da divisão do saldo da conta por 1000.

SQL

SELECT conta_numero, saldo, MOD(saldo, 1000) AS resto_divisao
FROM conta;
8. Exiba a data atual do servidor do banco.

SQL

SELECT SYSDATE
FROM dual;
9. Adicione 30 dias à data atual e exiba como "Data de vencimento simulada".

SQL

SELECT SYSDATE + 30 AS "Data de vencimento simulada"
FROM dual;
10. Exiba o número de dias entre a data de abertura da conta e a data atual.

Nota: A tabela conta não possui uma coluna para "data de abertura". O comando abaixo é um exemplo de como a consulta seria feita se existisse uma coluna chamada data_abertura.

SQL

-- Exemplo hipotético, pois a coluna data_abertura não existe na tabela.
SELECT conta_numero, TRUNC(SYSDATE - data_abertura) AS dias_desde_abertura
FROM conta;
Parte 2 – Conversão de Dados e Tratamento de Nulos (Seção 5)
11. Apresente o saldo de cada conta formatado como moeda local.

SQL

SELECT conta_numero, TO_CHAR(saldo, 'L9G999D99') AS saldo_formatado
FROM conta;
12. Converta a data de abertura da conta para o formato 'dd/mm/yyyy'.

Nota: Conforme o item 10, a coluna data_abertura não existe. O comando abaixo é um exemplo de como a formatação seria aplicada.

SQL

-- Exemplo hipotético, pois a coluna data_abertura não existe na tabela.
SELECT conta_numero, TO_CHAR(data_abertura, 'DD/MM/YYYY') AS data_formatada
FROM conta;
13. Exiba o saldo da conta e substitua valores nulos por 0.

Nota: A coluna saldo foi definida como NOT NULL. Este comando funcionaria para colunas que pudessem ter valores nulos.

SQL

SELECT conta_numero, NVL(saldo, 0)
FROM conta;
14. Exiba os nomes dos clientes e substitua valores nulos na cidade por 'Sem cidade'.

SQL

SELECT cliente_nome, NVL(cidade, 'Sem cidade') AS cidade
FROM cliente;
15. Classifique os clientes em grupos com base em sua cidade:

'Região Metropolitana' se forem de Niterói

'Interior' se forem de Resende

'Outra Região' para as demais cidades

SQL

SELECT
    cliente_nome,
    cidade,
    CASE
        WHEN cidade = 'Niterói' THEN 'Região Metropolitana'
        WHEN cidade = 'Resende' THEN 'Interior'
        ELSE 'Outra Região'
    END AS "Classificação da Cidade"
FROM cliente;
Parte 3 – Junções entre Tabelas (Seção 6)
16. Exiba o nome de cada cliente, o número da conta e o saldo correspondente.

SQL

SELECT c.cliente_nome, co.conta_numero, co.saldo
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod;
17. Liste os nomes dos clientes e os nomes das agências onde mantêm conta.

SQL

SELECT DISTINCT c.cliente_nome, a.agencia_nome
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
JOIN agencia a ON co.agencia_agencia_cod = a.agencia_cod;
18. Mostre todas as agências, mesmo aquelas que não possuem clientes vinculados (junção externa esquerda).

SQL

SELECT a.agencia_nome, c.cliente_nome, co.conta_numero
FROM agencia a
LEFT JOIN conta co ON a.agencia_cod = co.agencia_agencia_cod
LEFT JOIN cliente c ON co.cliente_cliente_cod = c.cliente_cod
ORDER BY a.agencia_nome;
