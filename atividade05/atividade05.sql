Seção 15 – Sequências
Crie uma sequência chamada seq_movimento que inicie em 100 e incremente de 10 em 10.

SQL

CREATE SEQUENCE seq_movimento
START WITH 100
INCREMENT BY 10;
Crie uma tabela chamada movimento_conta com as colunas: movimento_id, conta_numero, tipo (C ou D), valor, data_movimento.

SQL

CREATE TABLE movimento_conta (
    movimento_id    NUMBER PRIMARY KEY,
    conta_numero    NUMBER NOT NULL,
    tipo            CHAR(1) CHECK (tipo IN ('C', 'D')), -- C=Crédito, D=Débito
    valor           NUMBER(10, 2) NOT NULL,
    data_movimento  DATE DEFAULT SYSDATE,
    -- Assumindo que 'conta_numero' é uma FK para a tabela 'conta'
    CONSTRAINT fk_mov_conta FOREIGN KEY (conta_numero) REFERENCES conta (numero_conta)
);
Insira pelo menos três movimentações diferentes utilizando a sequência seq_movimento.

Nota: Os comandos abaixo assumem que as contas 1001, 1002 e 1003 (ou outros números válidos) existem na tabela conta.

SQL

INSERT INTO movimento_conta (movimento_id, conta_numero, tipo, valor)
VALUES (seq_movimento.NEXTVAL, 1001, 'C', 500.00);

INSERT INTO movimento_conta (movimento_id, conta_numero, tipo, valor)
VALUES (seq_movimento.NEXTVAL, 1002, 'D', 150.50);

INSERT INTO movimento_conta (movimento_id, conta_numero, tipo, valor)
VALUES (seq_movimento.NEXTVAL, 1003, 'C', 1200.00);

COMMIT;
Seção 16 – Views
Crie uma view chamada vw_contas_clientes que exiba o nome do cliente, o número da conta, saldo e código da agência.

SQL

CREATE VIEW vw_contas_clientes AS
SELECT
    c.nome AS nome_cliente,
    co.numero_conta,
    co.saldo,
    co.agencia_cod
FROM
    cliente c
JOIN
    conta co ON c.cod_cliente = co.cliente_cod;
Crie uma view chamada vw_emprestimos_grandes que exiba número do empréstimo, nome do cliente e valor dos empréstimos acima de R$ 20.000.

SQL

CREATE VIEW vw_emprestimos_grandes AS
SELECT
    e.id_emprestimo,
    c.nome AS nome_cliente,
    e.valor
FROM
    emprestimo e
JOIN
    cliente c ON e.cliente_cod = c.cod_cliente
WHERE
    e.valor > 20000;
Tente fazer um update diretamente na view vw_emprestimos_grandes e observe o que acontece. Explique o motivo.

SQL

-- Tentativa de UPDATE:
UPDATE vw_emprestimos_grandes
SET valor = 25000.00
WHERE id_emprestimo = 1; -- Substituir 1 por um ID de empréstimo válido
Resultado/Explicação:

Erro Esperado: A tentativa de UPDATE geralmente funcionaria se a View fosse baseada em uma única tabela e a coluna a ser modificada não fosse uma coluna de junção.

Porém, neste caso específico: A view vw_emprestimos_grandes é baseada em uma junção (JOIN) de múltiplas tabelas (emprestimo e cliente). O Oracle proíbe, por padrão, operações DML (INSERT, UPDATE, DELETE) em views que envolvam junções de mais de uma tabela.

Motivo: O Oracle não conseguiria determinar inequivocamente qual tabela base deve ser modificada para manter a consistência dos dados nas tabelas originais. Para modificar o valor do empréstimo, o UPDATE deve ser feito diretamente na tabela base emprestimo.

Seção 17 – Privilégios e Roles
Crie uma role chamada atendente_agencia com privilégios de SELECT em cliente e conta, e UPDATE no endereço do cliente.

SQL

CREATE ROLE atendente_agencia;

GRANT SELECT ON cliente TO atendente_agencia;
GRANT SELECT ON conta TO atendente_agencia;

-- Privilégio UPDATE em coluna específica:
GRANT UPDATE ON cliente (endereco) TO atendente_agencia;
Conceda essa role ao usuário carla.

SQL

GRANT atendente_agencia TO carla;
Revogue da role o privilégio de UPDATE no endereço.

SQL

REVOKE UPDATE ON cliente FROM atendente_agencia;

-- Se o privilégio foi concedido na coluna específica:
-- REVOKE UPDATE ON cliente (endereco) FROM atendente_agencia;
Crie um usuário chamado auditor com privilégios para consultar qualquer view do banco.

SQL

CREATE USER auditor IDENTIFIED BY senha_segura;

-- Conceder privilégio de sessão (necessário para logar)
GRANT CREATE SESSION TO auditor;

-- Conceder privilégio de consulta a qualquer VIEW (privilégio de sistema)
GRANT SELECT ANY DICTIONARY TO auditor;
-- OU (mais abrangente e menos recomendado para produção, mas atende ao requisito genérico)
GRANT SELECT ANY TABLE TO auditor;
Seção 🔎 Seção 18 – Expressões Regulares
Nota: As funções Oracle para Expressões Regulares são prefixadas com REGEXP_. Assumimos que a tabela cliente tem colunas nome e email, e o CPF está disponível.

Liste todos os clientes cujo nome começa com 'M' e termina com 'a' (não sensível a maiúsculas/minúsculas).

SQL

SELECT
    nome
FROM
    cliente
WHERE
    REGEXP_LIKE(nome, '^M.*a$', 'i'); -- 'i' torna a busca case-insensitive
Mascarar os seis primeiros dígitos do CPF, mantendo os últimos três visíveis, para todos os clientes.

Nota: Assumimos que o cpf é uma coluna na tabela cliente e tem 11 dígitos ou é um formato fixo.

SQL

SELECT
    nome,
    REGEXP_REPLACE(cpf, '^(.{6})(.*)(.{3})$', '******\3') AS cpf_mascarado
FROM
    cliente;
Exibir o domínio dos e-mails dos clientes (parte após o @).

SQL

SELECT
    nome,
    email,
    REGEXP_SUBSTR(email, '@(.*)$', 1, 1, 'i', 1) AS dominio
FROM
    cliente;

-- Alternativa mais simples (função SUBSTR e INSTR):
-- SELECT SUBSTR(email, INSTR(email, '@') + 1) AS dominio FROM cliente;
Listar clientes com dois ou mais nomes.

Nota: Assumimos que nomes são separados por espaço. O padrão busca por pelo menos um espaço na string do nome.

SQL

SELECT
    nome
FROM
    cliente
WHERE
    REGEXP_LIKE(nome, '.*\s+.*'); -- Busca por qualquer caractere, seguido por um ou mais espaços, seguido por qualquer caractere
Filtrar clientes cujo e-mail termina com '.br'.

SQL

SELECT
    nome,
    email
FROM
    cliente
WHERE
    REGEXP_LIKE(email, '\.br$'); -- '\.' escapa o ponto literal; '$' indica o final da string
