/*********************************************************************/
/*  * * * * Tabelas Simples * * * * * * * * * */
/*********************************************************************/

CREATE TABLE tipo_marca (
    id bigint NOT NULL,
    descricao varchar(250) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE tipo_deposito (
    id serial NOT NULL,
    descricao varchar(230) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

/*Tipos de deposito*/

CREATE TABLE tipo_pagamento (
    id serial NOT NULL,
    descricao varchar(230) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

/*Tipos de recibo*/

CREATE TABLE tipo_recibo (
    id serial NOT NULL,
    descricao varchar(220) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

/*Tipos de transaccao que os usarios podem fazer no sistema (nao tem nada aver com compras e vendas)*/

CREATE TABLE tipo_transacao (
    id serial NOT NULL,
    descricao varchar(250) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

/*Tipos de estados - de modo a caregorizar os estados*/

CREATE TABLE tipo_estado (
    id serial NOT NULL,
    descricao varchar(250) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

/* Cargos de funcionarios */
CREATE TABLE cargo (
    id serial NOT NULL,
    descricao varchar(255) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE categoria (
    id serial NOT NULL,
    descricao varchar(255) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

/*cor de produtos*/

CREATE TABLE cor (
    id serial NOT NULL,
    descricao varchar(250) NOT NULL UNIQUE,
    hexa varchar(20) UNIQUE,
    PRIMARY KEY (id)
);

/*departamentos da empresa*/

CREATE TABLE departamento (
    id serial NOT NULL,
    descricao varchar(250) NOT NULL UNIQUE,
    sigla varchar(20) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

/*Marcas de Produtos */

CREATE TABLE marca (
    id bigint NOT NULL,
    descricao varchar(250) NOT NULL UNIQUE,
    tipo_marca bigint NOT NULL,
    FOREIGN KEY (tipo_marca) REFERENCES tipo_marca (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

/*Metodos de Pagamento*/

CREATE TABLE metodo_pagamento (
    id bigint NOT NULL,
    descricao varchar(200) NOT NULL UNIQUE,
    conta bigint NOT NULL,
    titular varchar(200) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE provincia (
    id serial NOT NULL,
    descricao varchar(50) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE distrito (
    id serial NOT NULL,
    descricao varchar(155) NOT NULL UNIQUE,
    provincia bigint NOT NULL,
    FOREIGN KEY (provincia) REFERENCES provincia (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

/*Tipos de deposito*/

/*Diferentes estados para produtos, usarios, etc ......*/

CREATE TABLE estado (
    id serial NOT NULL,
    descricao varchar(250) NOT NULL UNIQUE,
    tipo_estado BIGINT NOT NULL,
    FOREIGN KEY (tipo_estado) REFERENCES tipo_estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

/*Prmeio  registado mas nao atribuido a ninguem*/

CREATE TABLE premio (
    id bigint NOT NULL,
    referencia varchar(50) NOT NULL UNIQUE,
    data_inicial TIMESTAMP NOT NULL,
    data_final TIMESTAMP NOT NULL CHECK (data_final > data_inicial),
    criterio_atribuicao TEXT NULL UNIQUE,
    PRIMARY KEY (id)
);

/*LOja */

CREATE TABLE armazem (
    id serial NOT NULL,
    distrito bigint NOT NULL,
    nome varchar(50) NOT NULL UNIQUE,
    endereco TEXT NOT NULL,
    FOREIGN KEY (distrito) REFERENCES distrito (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

CREATE TABLE loja (
    id serial NOT NULL,
    distrito bigint NOT NULL,
    nome varchar(50) NOT NULL UNIQUE,
    endereco TEXT NOT NULL,
    FOREIGN KEY (distrito) REFERENCES distrito (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

/* usario DO sistema */

CREATE TABLE utilizador (
    id bigint NOT NULL,
    username varchar(50) NOT NULL UNIQUE,
    PASSWORD TEXT NOT NULL,
    ROLE varchar(50) NOT NULL,
    PRIMARY KEY (id)
);

/*********************************************************************/
/*  * * * * Clientes * * * * * * * * * */
/*********************************************************************/

CREATE TABLE cliente (
    id bigint,
    nome_completo varchar(100) NOT NULL,
    sexo varchar(12) NOT NULL,
    distrito_nascimento bigint NULL,
    data_nascimento DATE NULL CHECK (
        data_nascimento > CURRENT_DATE
    ),
    numero_bi varchar(15) NULL UNIQUE,
    saldo decimal(10, 2) NULL,
    classificacao varchar(255) NULL,
    estado bigint NOT NULL,
    FOREIGN KEY (distrito_nascimento) REFERENCES distrito (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id) REFERENCES utilizador (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

CREATE TABLE cliente_loja (
    cliente bigint NOT NULL,
    loja bigint NOT NULL,
    FOREIGN KEY (cliente) REFERENCES cliente (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (loja) REFERENCES loja (id) ON DELETE CASCADE ON UPDATE CASCADE,
    data_adesao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (
        data_adesao <= CURRENT_TIMESTAMP
    ),
    PRIMARY KEY (loja, cliente)
);

/*********************************************************************/
/*  * * * * Funcionarios * * * * * * * * * */
/*********************************************************************/

CREATE TABLE funcionario (
    id bigint NOT NULL,
    nome_completo varchar(200) NOT NULL,
    data_nascimento DATE NOT NULL CHECK (
        data_contratacao <= CURRENT_DATE
    ),
    data_contratacao DATE NOT NULL CHECK (
        data_contratacao <= CURRENT_DATE
    ),
    distrito_nascimento bigint NOT NULL,
    numero_telefone_1 bigint NOT NULL UNIQUE,
    numero_telefone_2 bigint NULL UNIQUE,
    email varchar(150) NOT NULL UNIQUE,
    numero_documento varchar(20) NOT NULL UNIQUE,
    departamento bigint NOT NULL,
    codigo_funcionario varchar(15) NOT NULL,
    cargo bigint NOT NULL,
    estado bigint NOT NULL,
    FOREIGN KEY (id) REFERENCES utilizador (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (distrito_nascimento) REFERENCES distrito (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (departamento) REFERENCES departamento (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cargo) REFERENCES cargo (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id) REFERENCES utilizador (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

/*Funcionario de uma loja especifica*/

CREATE TABLE funcionario_loja (
    funcionario bigint NOT NULL,
    loja bigint NOT NULL,
    data_alocacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado BIGINT NOT NULL,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (funcionario) REFERENCES funcionario (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (loja) REFERENCES loja (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_alocacao <= CURRENT_TIMESTAMP
    ),
    PRIMARY KEY (funcionario, loja)
);

CREATE TABLE caixa (
    id bigint NOT NULL,
    loja bigint NOT NULL,
    data_alocacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado BIGINT NOT NULL,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (loja) REFERENCES loja (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_alocacao <= CURRENT_TIMESTAMP
    ),
    FOREIGN KEY (id) REFERENCES funcionario (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

CREATE TABLE vendedor (
    id bigint NOT NULL,
    loja bigint NOT NULL,
    data_alocacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado BIGINT NOT NULL,
    FOREIGN KEY (loja) REFERENCES loja (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_alocacao <= CURRENT_TIMESTAMP
    ),
    FOREIGN KEY (id) REFERENCES funcionario (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

CREATE TABLE gestor_produtos (
    id bigint NOT NULL,
    loja bigint NOT NULL,
    estado bigint NOT NULL,
    data_alocacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (
        data_alocacao <= CURRENT_TIMESTAMP
    ),
    FOREIGN KEY (loja) REFERENCES loja (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id) REFERENCES funcionario (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

CREATE TABLE gestor_clientes (
    id bigint NOT NULL,
    loja bigint NOT NULL,
    estado bigint NOT NULL,
    data_alocacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loja) REFERENCES loja (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_alocacao <= CURRENT_TIMESTAMP
    ),
    FOREIGN KEY (id) REFERENCES funcionario (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

/*********************************************************************/
/*  * * * * Produtos * * * * * * * * * */
/*********************************************************************/

/*Produtos que a empresa vende, nao alocados a nehuma loja*/

CREATE TABLE produto (
    id serial NOT NULL,
    nome varchar(255) NOT NULL,
    marca bigint NOT NULL,
    cor bigint NOT NULL,
    categoria bigint NOT NULL,
    preco_compra decimal(10, 2) NOT NULL CHECK (preco_compra > 0),
    preco_venda decimal(10, 2) NOT NULL CHECK (preco_venda > preco_compra),
    tamanho varchar(7) NOT NULL,
    codigo_numerico varchar(50) NOT NULL,
    codigo_barras varchar(50) NOT NULL,
    peso float NOT NULL CHECK (PESO > 0),
    estado bigint NOT NULL,
    data_fabricacao date NOT NULL,
    data_validade date,
    FOREIGN KEY (marca) REFERENCES marca (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cor) REFERENCES cor (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (categoria) REFERENCES categoria (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

CREATE TABLE produto_armazem (
    produto bigint NULL,
    armazem bigint NULL,
    data_aquisicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produto) REFERENCES produto (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (armazem) REFERENCES armazem (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_aquisicao <= CURRENT_TIMESTAMP
    ),
    PRIMARY KEY (produto, armazem)
);

/*Produtos alocados a uma loja especifica*/

CREATE TABLE produto_loja (
    produto bigint NULL,
    loja bigint NULL,
    data_aquisicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produto) REFERENCES produto (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (loja) REFERENCES loja (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_aquisicao <= CURRENT_TIMESTAMP
    ),
    PRIMARY KEY (produto, loja)
);

/*********************************************************************/
/*  * * * * Pagamentos * * * * * * * * * */
/*********************************************************************/

/*Registo de Pagamento feito na empresa- nao importa o tipo de pagamento*/

CREATE TABLE pagamento (
    id bigserial NOT NULL,
    data_pagamento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cliente bigint NOT NULL,
    referencia varchar(250) NOT NULL,
    tipo_pagamento bigint NOT NULL,
    valor decimal(10, 2) NOT NULL,
    caixa bigint NOT NULL,
    metodo_pagamento bigint NOT NULL,
    estado bigint NOT NULL,
    FOREIGN KEY (cliente) REFERENCES cliente (id),
    FOREIGN KEY (tipo_pagamento) REFERENCES tipo_pagamento (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (tipo_pagamento) REFERENCES tipo_pagamento (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (caixa) REFERENCES caixa (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (metodo_pagamento) REFERENCES metodo_pagamento (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_pagamento <= CURRENT_TIMESTAMP
    ),
    PRIMARY KEY (id)
);

/*Pagamentos feitos em uma loja especifica*/

CREATE table pagamento_loja (
 loja bigint not null,
 pagamento bigint not null,
 foreign key (loja) references loja (id),
 foreign key(pagamento) references pagamento (id),
 primary key (pagamento,loja)


);

/*Recibo de Pagamento feito na empresa- nao importa o tipo de pagamento*/

CREATE TABLE recibo (
    id bigserial NOT NULL,
    referencia varchar(50) NOT NULL,
    pagamento bigint NOT NULL,
    observacao TEXT NULL,
    tipo_recibo bigint NOT NULL,
    estado bigint NOT NULL,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (tipo_recibo) REFERENCES tipo_recibo (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pagamento) REFERENCES pagamento (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

/*********************************************************************/
/*  * * * * Vendas * * * * * * * * * */
/*********************************************************************/
CREATE TABLE venda (
    id serial NOT NULL,
    cliente bigint NOT NULL,
    vendedor bigint NOT NULL,
    caixa bigint NOT NULL,
    data_venda TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor decimal(10, 2) NOT NULL,
    estado bigint NOT NULL,
    observacao varchar(200) NULL,
    FOREIGN KEY (cliente) REFERENCES cliente (id),
    FOREIGN KEY (vendedor) REFERENCES vendedor (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (caixa) REFERENCES caixa (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_venda <= CURRENT_TIMESTAMP
    ),
    PRIMARY KEY (id)
);

CREATE TABLE venda_loja (
    loja bigint NOT NULL,
    venda bigint NOT NULL,
    FOREIGN KEY (loja) REFERENCES loja (id),
    FOREIGN KEY (venda) REFERENCES venda (id),
    PRIMARY KEY (venda, loja)
);

CREATE TABLE venda_detalhe (
    venda bigint NOT NULL,
    quantidade integer NOT NULL,
    produto bigint NOT NULL,
    FOREIGN KEY (venda) REFERENCES venda (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (produto) REFERENCES produto (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (venda, produto)
);

/*********************************************************************/
/*  * * * * Reservas * * * * * * * * * */
/*********************************************************************/

CREATE TABLE reserva (
    id serial NOT NULL,
    cliente bigint NOT NULL,
    data_reserva TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_validade TIMESTAMP NOT NULL DEFAULT CURRENT_DATE,
    estado bigint NOT NULL,
    nota TEXT NOT NULL,
    valor decimal(10, 2) NOT NULL,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cliente) REFERENCES cliente (id),
    CHECK (
        data_reserva <= CURRENT_TIMESTAMP
    ),
    CHECK (
        data_validade > CURRENT_TIMESTAMP
    ),
    PRIMARY KEY (id)
);

CREATE TABLE reserva_loja (
    loja bigint NOT NULL,
    reserva bigint NOT NULL,
    FOREIGN KEY (loja) REFERENCES loja (id),
    FOREIGN KEY (reserva) REFERENCES reserva (id),
    PRIMARY KEY (reserva, loja)
);

CREATE TABLE reserva_detalhe (
    produto bigint NOT NULL,
    quantidade integer NOT NULL,
    reserva bigint NOT NULL,
    FOREIGN KEY (reserva) REFERENCES reserva (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (produto) REFERENCES produto (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (produto, reserva)
);

CREATE TABLE reserva_pagamento (
    pagamento bigint NOT NULL,
    reserva bigint NULL,
    FOREIGN KEY (pagamento) REFERENCES pagamento (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (reserva) REFERENCES reserva (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (pagamento, reserva)
);

/*********************************************************************/
/*  * * * * Encomendas * * * * * * * * * */
/*********************************************************************/

CREATE TABLE encomenda (
    id serial NOT NULL,
    cliente bigint NOT NULL,
    data_encomenda TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_pagamento TIMESTAMP NOT NULL,
    data_entrega TIMESTAMP NOT NULL,
    valor decimal(10, 2) NOT NULL,
    estado bigint NOT NULL,
    observacao varchar(200) NULL,
    FOREIGN KEY (cliente) REFERENCES cliente (id),
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_pagamento <= CURRENT_TIMESTAMP
    ),
    CHECK (data_entrega > data_pagamento),
    PRIMARY KEY (id)
);

CREATE TABLE encomenda_loja (
    loja bigint NOT NULL,
    encomenda bigint NOT NULL,
    FOREIGN KEY (loja) REFERENCES loja (id),
    FOREIGN KEY (encomenda) REFERENCES encomenda (id),
    PRIMARY KEY (encomenda, loja)
);

CREATE TABLE encomenda_detalhe (
    encomenda bigint NOT NULL,
    produto bigint NOT NULL,
    quantidade integer NOT NULL,
    FOREIGN KEY (encomenda) REFERENCES encomenda (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (produto) REFERENCES produto (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (encomenda, produto)
);

CREATE TABLE encomenda_pagamento (
    encomenda bigint NOT NULL,
    pagamento bigint NOT NULL,
    FOREIGN KEY (encomenda) REFERENCES encomenda (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pagamento) REFERENCES pagamento (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (encomenda, pagamento)
);

/*********************************************************************/
/*  * * * * Premios * * * * * * * * * */
/*********************************************************************/

/* itens de um premio */

CREATE TABLE premio_item (
    item varchar(50) NOT NULL,
    premio bigint NOT NULL,
    valor decimal(10, 2) NOT NULL,
    quantidade integer NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (premio) REFERENCES premio (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_cadastro <= CURRENT_TIMESTAMP
    ),
    PRIMARY KEY (item, premio)
);

/*premio atribuido a um cliente*/

CREATE TABLE premio_cliente (
    cliente bigint NOT NULL,
    premio bigint NOT NULL,
    data_atribuicao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_entrega TIMESTAMP,
    estado bigint NOT NULL,
    FOREIGN KEY (cliente) REFERENCES cliente (id),
    FOREIGN KEY (premio) REFERENCES premio (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_atribuicao <= CURRENT_TIMESTAMP
    ),
    PRIMARY KEY (cliente, premio)
);

/*********************************************************************/
/*  * * * * Depositos * * * * * * * * * */
/*********************************************************************/

CREATE TABLE deposito (
    id bigserial NOT NULL,
    data_deposito TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cliente bigint NOT NULL,
    valor decimal(10, 2) NOT NULL CHECK (valor > 0),
    tipo_deposito bigint NOT NULL,
    estado bigint NOT NULL,
    FOREIGN KEY (cliente) REFERENCES cliente (id),
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (tipo_deposito) REFERENCES tipo_deposito (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_deposito <= CURRENT_TIMESTAMP
    ),
    PRIMARY KEY (id)
);

CREATE TABLE deposito_loja (
    loja bigint NOT NULL,
    deposito bigint NOT NULL,
    FOREIGN KEY (loja) REFERENCES loja (id),
    FOREIGN KEY (deposito) REFERENCES deposito (id),
    PRIMARY KEY (deposito, loja)
);

/*********************************************************************/
/*  * * * * Dividas * * * * * * * * * */
/*********************************************************************/

CREATE TABLE divida (
    id serial NOT NULL,
    cliente bigint NOT NULL,
    data_aquisicao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_liquidacao TIMESTAMP NOT NULL,
    valor decimal(10, 2) NOT NULL,
    estado bigint NOT NULL,
    observacao varchar(200) NULL,
    FOREIGN KEY (cliente) REFERENCES cliente (id),
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        data_aquisicao <= CURRENT_TIMESTAMP
    ),
    CHECK (
        data_liquidacao > data_aquisicao
    ),
    PRIMARY KEY (id)
);

CREATE TABLE divida_loja (
    loja bigint NOT NULL,
    divida bigint NOT NULL,
    FOREIGN KEY (loja) REFERENCES loja (id),
    FOREIGN KEY (divida) REFERENCES divida (id),
    PRIMARY KEY (divida, loja)
);

CREATE TABLE divida_pagamento (
    divida bigint NOT NULL,
    pagamento bigint NOT NULL,
    FOREIGN KEY (pagamento) REFERENCES pagamento (id),
    FOREIGN KEY (divida) REFERENCES divida (id),
    PRIMARY KEY (divida, pagamento)
);

/*Funcionario da empresa */

CREATE TABLE armazem_reponsavel (
    armazem bigint NOT NULL,
    responsavel bigint NOT NULL,
    data_alocacao timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (armazem) REFERENCES armazem (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (responsavel) REFERENCES funcionario (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (armazem, responsavel)
);

/*funcionario responsavel por uma loja - adminsitrador da loja*/

CREATE TABLE loja_reponsavel (
    loja bigint NOT NULL,
    responsavel bigint NOT NULL,
    data_alocacao timestamp DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loja) REFERENCES loja (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (responsavel) REFERENCES funcionario (id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (loja, responsavel)
);

/*********************************************************************/
/*  * * * * Requisicoes * * * * * * * * * */
/*********************************************************************/

CREATE TABLE requiscao_produto_vendedor (
    id bigserial NOT NULL,
    vendedor bigint NOT NULL,
    data_requisicao timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado bigint NOT NULL,
    FOREIGN KEY (vendedor) REFERENCES vendedor (id),
    FOREIGN KEY (estado) REFERENCES estado (id),
    PRIMARY KEY (id)
);

CREATE TABLE requiscao_produto_vendedor_detalhe (
    produto bigint NOT NULL,
    quantidade integer NOT NULL,
    requiscao_produto_vendedor bigint NOT NULL,
    FOREIGN KEY (produto) REFERENCES produto (id),
    FOREIGN KEY (requiscao_produto_vendedor) REFERENCES requiscao_produto_vendedor (id),
    PRIMARY KEY (
        requiscao_produto_vendedor,
        produto
    )
);

CREATE TABLE requiscao_produto_loja (
    id bigserial NOT NULL,
    loja bigint NOT NULL,
    data_requisicao timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    responsavel bigint NOT NULL,
    estado bigint NOT NULL,
    FOREIGN KEY (loja) REFERENCES loja (id),
    FOREIGN KEY (estado) REFERENCES estado (id),
    FOREIGN KEY (responsavel) REFERENCES gestor_produtos (id),
    PRIMARY KEY (id)
);

CREATE TABLE requiscao_produto_loja_detalhe (
    produto bigint NOT NULL,
    quantidade integer NOT NULL,
    requiscao_produto_vendedor bigint NOT NULL,
    FOREIGN KEY (produto) REFERENCES produto (id),
    FOREIGN KEY (requiscao_produto_vendedor) REFERENCES requiscao_produto_vendedor (id),
    PRIMARY KEY (
        requiscao_produto_vendedor,
        produto
    )
);

/*********************************************************************/
/*  * * * * trabsacoes * * * * * * * * * */
/*********************************************************************/

CREATE TABLE transacao (
    id bigserial NOT NULL,
    descricao TEXT NOT NULL,
    usuario bigint NOT NULL,
    dispositivo varchar(250) NOT NULL,
    gravidade varchar(30) NOT NULL,
    data_transacao varchar(50) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_transacao bigint NOT NULL,
    estado bigint NOT NULL,
    FOREIGN KEY (usuario) REFERENCES utilizador (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado) REFERENCES estado (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (tipo_transacao) REFERENCES tipo_transacao (id) ON DELETE CASCADE ON UPDATE CASCADE,
   
    PRIMARY KEY (id)
);
