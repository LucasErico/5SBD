Excelente! Aqui estão os scripts SQL para a nova lista de tarefas.

Parte 1 – Junções e Produto Cartesiano (Seção 7)
1. Usando a sintaxe proprietária da Oracle, exiba o nome de cada cliente junto com o número de sua conta.

SQL

SELECT c.cliente_nome, co.conta_numero
FROM cliente c, conta co
WHERE c.cliente_cod = co.cliente_cliente_cod;
2. Mostre todas as combinações possíveis de clientes e agências (produto cartesiano).

SQL

SELECT c.cliente_nome, a.agencia_nome
FROM cliente c, agencia a;
3. Usando aliases de tabela, exiba o nome dos clientes e a cidade da agência onde mantêm conta.

SQL

SELECT
    c.cliente_nome,
    a.agencia_cidade
FROM
    cliente c
JOIN
    conta co ON c.cliente_cod = co.cliente_cliente_cod
JOIN
    agencia a ON co.agencia_agencia_cod = a.agencia_cod;
Parte 2 – Funções de Grupo, COUNT, DISTINCT e NVL (Seção 8)
4. Exiba o saldo total de todas as contas cadastradas.

SQL

SELECT SUM(saldo) AS saldo_total
FROM conta;
5. Mostre o maior saldo e a média de saldo entre todas as contas.

SQL

SELECT MAX(saldo) AS maior_saldo, AVG(saldo) AS media_saldo
FROM conta;
6. Apresente a quantidade total de contas cadastradas.

SQL

SELECT COUNT(*) AS total_de_contas
FROM conta;
7. Liste o número de cidades distintas onde os clientes residem.

SQL

SELECT COUNT(DISTINCT cidade) AS numero_cidades_distintas
FROM cliente;
8. Exiba o número da conta e o saldo, substituindo valores nulos por zero.

Nota: A coluna saldo foi definida como NOT NULL. Este comando é demonstrativo para colunas que pudessem ter valores nulos.

SQL

SELECT conta_numero, NVL(saldo, 0) AS saldo
FROM conta;
Parte 3 – GROUP BY, HAVING, ROLLUP e Operadores de Conjunto (Seção 9)
9. Exiba a média de saldo por cidade dos clientes.

SQL

SELECT
    c.cidade,
    AVG(co.saldo) AS media_saldo_por_cidade
FROM
    cliente c
JOIN
    conta co ON c.cliente_cod = co.cliente_cliente_cod
GROUP BY
    c.cidade;
10. Liste apenas as cidades com mais de 3 contas associadas a seus moradores.

SQL

SELECT
    c.cidade,
    COUNT(co.conta_numero) AS quantidade_contas
FROM
    cliente c
JOIN
    conta co ON c.cliente_cod = co.cliente_cliente_cod
GROUP BY
    c.cidade
HAVING
    COUNT(co.conta_numero) > 3;
11. Utilize a cláusula ROLLUP para exibir o total de saldos por cidade da agência e o total geral.

SQL

SELECT
    a.agencia_cidade,
    SUM(co.saldo) AS total_saldos
FROM
    agencia a
JOIN
    conta co ON a.agencia_cod = co.agencia_agencia_cod
GROUP BY
    ROLLUP(a.agencia_cidade);
12. Faça uma consulta com UNION que combine os nomes de cidades dos clientes e das agências, sem repetições.

SQL

SELECT cidade FROM cliente
UNION
SELECT agencia_cidade FROM agencia;
Seção 10 – Subconsultas
Parte 1 – Subconsultas de Linha Única
1. Liste os nomes dos clientes cujas contas possuem saldo acima da média geral de todas as contas registradas.

SQL

SELECT c.cliente_nome, co.saldo
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo > (SELECT AVG(saldo) FROM conta);
2. Exiba os nomes dos clientes cujos saldos são iguais ao maior saldo encontrado no banco.

SQL

SELECT c.cliente_nome, co.saldo
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo = (SELECT MAX(saldo) FROM conta);
3. Liste as cidades onde a quantidade de clientes é maior que a quantidade média de clientes por cidade.

SQL

SELECT cidade, COUNT(*) AS qtd_clientes
FROM cliente
GROUP BY cidade
HAVING COUNT(*) > (SELECT AVG(COUNT(*)) FROM cliente GROUP BY cidade);
Parte 2 – Subconsultas Multilinha
4. Liste os nomes dos clientes com saldo igual a qualquer um dos dez maiores saldos registrados.

SQL

SELECT DISTINCT c.cliente_nome, co.saldo
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo IN (
    SELECT saldo FROM conta ORDER BY saldo DESC FETCH FIRST 10 ROWS ONLY
)
ORDER BY co.saldo DESC;
5. Liste os clientes que possuem saldo menor que todos os saldos dos clientes da cidade de Niterói.

SQL

SELECT c.cliente_nome, co.saldo
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo < ALL (
    SELECT co2.saldo
    FROM conta co2
    JOIN cliente c2 ON co2.cliente_cliente_cod = c2.cliente_cod
    WHERE c2.cidade = 'Niterói'
);
6. Liste os clientes cujos saldos estão entre os saldos de clientes de Volta Redonda.

Nota: Esta consulta assume que "entre" significa entre o saldo mínimo e o máximo dos clientes de Volta Redonda.

SQL

SELECT c.cliente_nome, co.saldo
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo BETWEEN
    (SELECT MIN(co2.saldo) FROM conta co2 JOIN cliente c2 ON co2.cliente_cliente_cod = c2.cliente_cod WHERE c2.cidade = 'Volta Redonda')
    AND
    (SELECT MAX(co2.saldo) FROM conta co2 JOIN cliente c2 ON co2.cliente_cliente_cod = c2.cliente_cod WHERE c2.cidade = 'Volta Redonda');
Parte 3 – Subconsultas Correlacionadas
7. Exiba os nomes dos clientes cujos saldos são maiores que a média de saldo das contas da mesma agência.

SQL

SELECT c.cliente_nome, co.saldo, co.agencia_agencia_cod
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo > (
    SELECT AVG(saldo)
    FROM conta co2
    WHERE co2.agencia_agencia_cod = co.agencia_agencia_cod
);
8. Liste os nomes e cidades dos clientes que têm saldo inferior à média de sua própria cidade.

SQL

SELECT c1.cliente_nome, c1.cidade, co1.saldo
FROM cliente c1
JOIN conta co1 ON c1.cliente_cod = co1.cliente_cliente_cod
WHERE co1.saldo < (
    SELECT AVG(co2.saldo)
    FROM conta co2
    JOIN cliente c2 ON co2.cliente_cliente_cod = c2.cliente_cod
    WHERE c2.cidade = c1.cidade
);
Parte 4 – Subconsultas com EXISTS e NOT EXISTS
9. Liste os nomes dos clientes que possuem pelo menos uma conta registrada no banco.

SQL

SELECT c.cliente_nome
FROM cliente c
WHERE EXISTS (
    SELECT 1
    FROM conta co
    WHERE co.cliente_cliente_cod = c.cliente_cod
);
10. Liste os nomes dos clientes que ainda não possuem conta registrada no banco.

SQL

SELECT c.cliente_nome
FROM cliente c
WHERE NOT EXISTS (
    SELECT 1
    FROM conta co
    WHERE co.cliente_cliente_cod = c.cliente_cod
);
Parte 5 – Subconsulta Nomeada com WITH
11. Usando a cláusula WITH, calcule a média de saldo por cidade e exiba os clientes que possuem saldo acima da média de sua cidade.

SQL

WITH media_por_cidade AS (
    SELECT
        c.cidade,
        AVG(co.saldo) AS media_saldo_cidade
    FROM
        cliente c
    JOIN
        conta co ON c.cliente_cod = co.cliente_cliente_cod
    GROUP BY
        c.cidade
)
SELECT
    c.cliente_nome,
    c.cidade,
    co.saldo,
    mpc.media_saldo_cidade
FROM
    cliente c
JOIN
    conta co ON c.cliente_cod = co.cliente_cliente_cod
JOIN
    media_por_cidade mpc ON c.cidade = mpc.cidade
WHERE
    co.saldo > mpc.media_saldo_cidade;
