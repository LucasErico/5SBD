Seção 12 – Conversões Implícitas e Explícitas
Exiba o número da conta e o saldo formatado com separador de milhar e vírgula como separador decimal.

SQL

SELECT
    numero_conta,
    TO_CHAR(saldo, 'FM99G999D00', 'NLS_NUMERIC_CHARACTERS = '',.''') AS saldo_formatado
FROM
    conta;
Mostre a data atual no formato 'DD/MM/YYYY'.

SQL

SELECT
    TO_CHAR(SYSDATE, 'DD/MM/YYYY') AS data_atual_formatada
FROM
    DUAL;
Exiba o nome do cliente concatenado com a cidade onde ele reside.

SQL

SELECT
    nome || ' reside em ' || cidade AS cliente_cidade
FROM
    cliente;
Liste os empréstimos com valor superior a R$ 5000, formatando o valor com símbolo monetário.

SQL

SELECT
    id_emprestimo,
    TO_CHAR(valor, 'L9G999D00', 'NLS_NUMERIC_CHARACTERS = '',.'' NLS_CURRENCY = ''R$''') AS valor_formatado
FROM
    emprestimo
WHERE
    valor > 5000;
Seção 13 – Tipos de Dados Avançados
Adicione uma coluna do tipo TIMESTAMP na tabela cliente chamada data_cadastro.

SQL

ALTER TABLE cliente ADD data_cadastro TIMESTAMP;
Mostre quantos dias se passaram desde o cadastro de cada cliente.

SQL

SELECT
    nome,
    data_cadastro,
    TRUNC(SYSDATE - data_cadastro) AS dias_desde_cadastro
FROM
    cliente;
Adicione uma coluna do tipo INTERVAL YEAR TO MONTH na tabela cliente chamada tempo_fidelidade.

SQL

ALTER TABLE cliente ADD tempo_fidelidade INTERVAL YEAR TO MONTH;
Exiba para cada cliente a data de cadastro e uma previsão de renovação de cadastro adicionando 3 meses.

SQL

SELECT
    nome,
    data_cadastro,
    ADD_MONTHS(data_cadastro, 3) AS previsao_renovacao
FROM
    cliente;
Seção 14 – Constraints
Crie uma tabela chamada cartao_credito com as seguintes restrições: - cartao_numero (PK), - cliente_cod (FK), - limite_credito (NOT NULL), - status (CHECK: 'ATIVO', 'BLOQUEADO', 'CANCELADO').

SQL

CREATE TABLE cartao_credito (
    cartao_numero   VARCHAR2(16) PRIMARY KEY,
    cliente_cod     NUMBER NOT NULL,
    limite_credito  NUMBER(10, 2) NOT NULL,
    status          VARCHAR2(10) CHECK (status IN ('ATIVO', 'BLOQUEADO', 'CANCELADO')),
    CONSTRAINT fk_cartao_cliente FOREIGN KEY (cliente_cod) REFERENCES cliente (cod_cliente)
);
Tente inserir um cartão de crédito com campo limite_credito nulo (explique o erro).

SQL

INSERT INTO cartao_credito (cartao_numero, cliente_cod, limite_credito, status)
VALUES ('1234567890123456', 1, NULL, 'ATIVO');

-- Erro Esperado: ORA-01400: cannot insert NULL into ("SUA_TABELA"."LIMITE_CREDITO")
Insira ao menos três registros válidos na tabela cartao_credito.

SQL

INSERT INTO cartao_credito (cartao_numero, cliente_cod, limite_credito, status)
VALUES ('1111222233334444', 101, 8500.00, 'ATIVO');

INSERT INTO cartao_credito (cartao_numero, cliente_cod, limite_credito, status)
VALUES ('5555666677778888', 102, 2500.00, 'BLOQUEADO');

INSERT INTO cartao_credito (cartao_numero, cliente_cod, limite_credito, status)
VALUES ('9999000011112222', 103, 15000.00, 'ATIVO');

COMMIT;
Crie uma tabela transacao com restrição CHECK para valores positivos.

SQL

CREATE TABLE transacao (
    id_transacao    NUMBER PRIMARY KEY,
    conta_origem    NUMBER NOT NULL,
    valor           NUMBER(10, 2) NOT NULL,
    data_transacao  DATE DEFAULT SYSDATE,
    CONSTRAINT chk_valor_positivo CHECK (valor > 0)
);
Tente inserir uma transação com valor negativo (explique o erro).

SQL

INSERT INTO transacao (id_transacao, conta_origem, valor)
VALUES (1, 10, -50.00);

-- Erro Esperado: ORA-02290: check constraint (SUA_TABELA.CHK_VALOR_POSITIVO) violated
Crie uma consulta que relacione clientes ativos com seus respectivos limites de crédito acima de 3000.

SQL

SELECT
    c.nome AS nome_cliente,
    cc.limite_credito
FROM
    cliente c
INNER JOIN
    cartao_credito cc ON c.cod_cliente = cc.cliente_cod
WHERE
    cc.status = 'ATIVO'
    AND cc.limite_credito > 3000;
Crie uma VIEW chamada vw_clientes_com_cartao que exiba nome, cidade e status do cartão.

SQL

CREATE VIEW vw_clientes_com_cartao AS
SELECT
    c.nome,
    c.cidade,
    cc.status AS status_cartao
FROM
    cliente c
INNER JOIN
    cartao_credito cc ON c.cod_cliente = cc.cliente_cod;
