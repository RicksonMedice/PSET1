--------------Apagar banco de dados caso exista-----------------------
DROP DATABASE  IF EXISTS uvv;

--------------Apagar role caso exista---------------------------------
DROP ROLE IF EXISTS rickson_medice;

--------------Apagar usuário caso existenta---------------------------
DROP                   USER
IF EXISTS              rickson_medice;

--------------Criar o usuário com senha cryptografada-----------------
CREATE USER rickson_medice
WITH CREATEDB CREATEROLE 
ENCRYPTED PASSWORD '123';

--------------Concetar o usuário--------------------------------------
SET ROLE              rickson_medice; 	

--------------Criar o Banco de dados----------------------------------
CREATE DATABASE       uvv
WITH OWNER =          rickson_medice
TEMPLATE =            template0
ENCODING =            'UTF8'
LC_COLLATE =          'pt_BR.UTF-8'
LC_CTYPE =            'pt_BR.UTF-8'
allow_connections = true;

--------------Setar senha para que nao precise ao logar---------------
\setenv PGPASSWORD '123'

--------------Concectar-se--------------------------------------------
\c uvv                rickson_medice

----------------Apagar schema caso exista-----------------------------

DROP SCHEMA IF EXISTS lojas;

----------------Criar schema------------------------------------------
CREATE SCHEMA IF NOT EXISTS lojas AUTHORIZATION rickson_medice;
ALTER USER rickson_medice SET search_path TO lojas, '$user', public;

----------------Alter o serach_path-----------------------------------
SET                   search_path 
TO                    lojas, '$user', public;

----------------Concetar o usuário------------------------------------
SET ROLE              rickson_medice;



----------------Alterar o Dono do schema------------------------------
ALTER SCHEMA          lojas 
OWNER TO              rickson_medice;


----------------Criação da tabela produtos----------------------------
CREATE TABLE lojas.produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produto_id PRIMARY KEY (produto_id)
);

----------------Checagem da tabela produtos---------------------------
ALTER TABLE lojas.produtos
ADD CONSTRAINT cc_produtos_preco_unitario
CHECK (preco_unitario >= 0);

----------------Comentarios da tabela Produtos------------------------
COMMENT ON TABLE lojas.produtos                            IS 'tabela referente aos produtos das lojas.lojas possui como primary key a coluna produto_id';
COMMENT ON COLUMN lojas.produtos.produto_id                IS 'coluna referente ao id dos produtos da loja. number.';
COMMENT ON COLUMN lojas.produtos.nome                      IS 'coluna referente ao nome dos produtos. varchar(255).';
COMMENT ON COLUMN lojas.produtos.preco_unitario            IS 'coluna referente ao preço de cada produto. number(10,2).';
COMMENT ON COLUMN lojas.produtos.detalhes                  IS 'coluna referente ao detalhe dos produtos. blob';
COMMENT ON COLUMN lojas.produtos.imagem                    IS 'coluna referente a imagem dos produtos. blob.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type          IS 'coluna referente a imagem mime dos produtos. varchar(512).';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo            IS 'coluna referente a imagem do arquivo dos produtos. varchar(512).';
COMMENT ON COLUMN lojas.produtos.imagem_charset            IS 'coluna referente a imagem charset dos produtos. varchar(512).';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'coluna referente a ultima atualizaçao dos produtos. date.';

----------------Criação da tabela clientes----------------------------
CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT cliente_id PRIMARY KEY (cliente_id)
);

---------------Comentarios da tabela clientes--------------------------
COMMENT ON TABLE lojas.clientes             IS 'tabela referente ao dados dos clientes. e possui como primary key o cliente_id';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'coluna do id do cliente. numeric.';
COMMENT ON COLUMN lojas.clientes.email      IS 'coluna referente ao email dos clientes. varchar(255).';
COMMENT ON COLUMN lojas.clientes.nome       IS 'coluna referente ao nome dos clientes. varchar(255).';
COMMENT ON COLUMN lojas.clientes.telefone1  IS 'coluna referente ao primeiro telefone do cliente. varchar(20).';
COMMENT ON COLUMN lojas.clientes.telefone2  IS 'coluna referente ao segundo telefone do cliente. varchar(20).';
COMMENT ON COLUMN lojas.clientes.telefone3  IS 'coluna referente ao terceiro telefone do cliente. varchar(20).';

--------------Criação da tabela lojas-----------------------------------
CREATE TABLE lojas.lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT loja_id PRIMARY KEY (loja_id)
);
-------------Checagem da tabela lojas-----------------------------------
ALTER TABLE lojas.lojas
ADD CONSTRAINT cc_lojas_endereco_web_fisico
CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);

---------------Comentarios da tabela lojas-------------------------------
COMMENT ON TABLE lojas.lojas                          IS 'Essa é a tabela das lojas e possui como primary key. loja_id';
COMMENT ON COLUMN lojas.lojas.loja_id                 IS 'coluna referente ao id das lojas. é uma primary key. number(38)';
COMMENT ON COLUMN lojas.lojas.nome                    IS 'essa é a coluna referente ao nome das lojas. varchar(255)';
COMMENT ON COLUMN lojas.lojas.endereco_web            IS 'coluna dos endereços da web. varchar(100).';
COMMENT ON COLUMN lojas.lojas.endereco_fisico         IS 'coluna do endereço fisico. varchar(512).';
COMMENT ON COLUMN lojas.lojas.latitude                IS 'coluna referente a latitude das lojas. number.';
COMMENT ON COLUMN lojas.lojas.longitude               IS 'coluna da longitude referente as lojas. number.';
COMMENT ON COLUMN lojas.lojas.logo                    IS 'coluna referente a logo das lojas. blob.';
COMMENT ON COLUMN lojas.lojas.logo_mime_type          IS 'coluna da logo_mime_type da tabela lojas. varchar(512).';
COMMENT ON COLUMN lojas.lojas.logo_arquivo            IS 'coluna da logo dos arquivos das lojas. varchar(512).';
COMMENT ON COLUMN lojas.lojas.logo_charset            IS 'coluna referente a logo chartset da tabela lojas. varchar(512).';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'coluna da ultima atualização das lojas. date';

---------------Criação da tabela estoques--------------------------------
CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoque_id PRIMARY KEY (estoque_id)
);
---------------Checagem da tabela estoques-----------------------------
ALTER TABLE lojas.estoques
ADD CONSTRAINT cc_estoques_quantidade
CHECK (quantidade >= 0);

----------------Comentarios da tabela estoques-------------------------
COMMENT ON TABLE lojas.estoques             IS 'tabela refente ao estoque dos pedidos dos usuários. possui como primary key estoque_id e possui duas FK, loja_id e produto_id.';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'coluna referente ao id dos estoques da loja. number(38).';
COMMENT ON COLUMN lojas.estoques.loja_id    IS 'coluna referente ao id das lojas. é uma primary key. number(38)';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'coluna referente ao id dos produtos da loja. number.';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'coluna referente a quantidade de estoques da loja. number(38).';

---------------Criação da tabela envios---------------------------------
CREATE TABLE lojas.envios (
                envio_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT envio_id PRIMARY KEY (envio_id)
);
----------------Checagem da tabela envios -------------------------------
ALTER TABLE lojas.envios
ADD CONSTRAINT cc_envios_status
CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

----------------Comentarios da tabela envios-----------------------------
COMMENT ON TABLE lojas.envios                   IS 'tabela referente ao envio dos produtos da loja para os clientes. possui como primary key a coluna envio_id e possui duas FK, loja_id e cliente_id.';
COMMENT ON COLUMN lojas.envios.envio_id         IS 'coluna referente ao id dos envios dos produtos. number(38).';
COMMENT ON COLUMN lojas.envios.cliente_id       IS 'coluna do id do cliente. numeric.';
COMMENT ON COLUMN lojas.envios.loja_id          IS 'coluna referente ao id das lojas. é uma primary key. number(38)';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'coluna referente ao endereço de entrega dos produtos. varchar(512).';
COMMENT ON COLUMN lojas.envios.status           IS 'coluna referente ao status dos envios dos produtos para os cliente. varchar(15).';

------------------Criação da tabela pedidos--------------------------------
CREATE TABLE lojas.pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT pedido_id PRIMARY KEY (pedido_id)
);
----------------Checagem da tabela pedidos --------------------------------
ALTER TABLE lojas.pedidos
ADD CONSTRAINT cc_pedidos_status
CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

----------------Comentarios da tabela pedidos-------------------------------
COMMENT ON TABLE lojas.pedidos             IS 'tabela referente aos pedidos dos clientes nas lojas. possui como primary key a coluna pedido_id e possui duas FK, cliente_id e loja_id.';
COMMENT ON COLUMN lojas.pedidos.pedido_id  IS 'coluna referente ao id dos pedidos dos clientes. number.';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'coluna do id do cliente. numeric.';
COMMENT ON COLUMN lojas.pedidos.loja_id    IS 'coluna referente ao id das lojas. é uma primary key. number(38)';
COMMENT ON COLUMN lojas.pedidos.data_hora  IS 'coluna referente a data e hora dos pedidos. timestamp';
COMMENT ON COLUMN lojas.pedidos.status     IS 'coluna referente ao status dos pedidos dos clientes. varchar(15).';

-----------------Criação da tabela pedidos_itens-----------------------------
CREATE TABLE lojas.pedidos_itens (
                produto_id NUMERIC(38) NOT NULL,
                pedido_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38),
                CONSTRAINT pfk_pedido_id PRIMARY KEY (produto_id, pedido_id)
);
-------- Checagem da tabela pedidos_itens -------------------------
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT cc_pedidos_itens_preco_unitario
CHECK (preco_unitario >= 0);

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT cc_pedidos_itens_quantidade
CHECK (quantidade >= 0);


-----------------Comentarios da tabela pedidos_itens--------------------------
COMMENT ON TABLE lojas.pedidos_itens                  IS 'tabela referente ao pedido dos itens, tem duas primary key, pedido_id e produto_id. possui uma FK, envio_id';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id      IS 'coluna referente ao id dos produtos da loja. number.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id       IS 'coluna referente ao id dos pedidos dos clientes. number.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'coluna referente ao numero da linha do pedido do item. number(38).';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario  IS 'coluna referente a cada preço dos pedidos dos itens. number(10,2).';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade      IS 'coluna referente a quantidade dos pedidos. number(38).';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id        IS 'coluna referente ao id dos envios dos produtos. number(38).';


----------------Adiciona uma restrição de chave estrangeira à tabela-
ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

---------------Adiciona uma restrição de chave estrangeira à tabela-
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--------------Adiciona uma restrição de chave estrangeira à tabela-
ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-------------Adiciona uma restrição de chave estrangeira à tabela-
ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

------------Adiciona uma restrição de chave estrangeira à tabela-
ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

------------Adiciona uma restrição de chave estrangeira à tabela-
ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-----------Adiciona uma restrição de chave estrangeira à tabela-
ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-----------Adiciona uma restrição de chave estrangeira à tabela-
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

----------Adiciona uma restrição de chave estrangeira à tabela-
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;