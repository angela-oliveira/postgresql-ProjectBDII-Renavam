CREATE TABLE categoria_cnh(
idCategoriaCNH VARCHAR(3) NOT NULL,
descricao text NOT NULL,
CONSTRAINT PK_categoria PRIMARY KEY (idCategoriaCNH)
);

CREATE TABLE estado (
id_Uf varchar(2) NOT NULL,
nome varchar(50) NOT NULL,
CONSTRAINT PK_estado PRIMARY KEY (id_Uf)
);

CREATE TABLE cidade (
idCidade serial NOT NULL,
nome varchar(50) NOT NULL,
id_Uf varchar(2) NOT NULL,
CONSTRAINT PK_cidade PRIMARY KEY (idCidade),
CONSTRAINT FK_id_Uf FOREIGN KEY (id_Uf) REFERENCES estado(id_Uf)
);

CREATE TABLE condutor (
idCadastro serial NOT NULL,
cpf varchar(11) NOT NULL,
nome varchar(50) NOT NULL,
dataNasc date NOT NULL,
idCategoriaCNH varchar(3) NOT NULL,
id_Uf varchar(2) not null,
endereco varchar(50) NOT NULL,
bairro varchar (30) NOT NULL,
situacaoCNH varchar(1) NOT NULL DEFAULT 'R',
idCidade int NOT NULL,

CONSTRAINT PK_cadastro PRIMARY KEY (idCadastro),
CONSTRAINT AK_cpf UNIQUE (cpf),
CONSTRAINT FK_categoriaCNH FOREIGN KEY (idCategoriaCNH) REFERENCES categoria_cnh (idCategoriaCNH),
CONSTRAINT FK_cidade FOREIGN KEY (idCidade) REFERENCES cidade (idCidade),
CONSTRAINT CHK_situacaoCNH CHECK (situacaoCNH = 'R' or situacaoCNH = 'S' )
);


CREATE TABLE especie (
idEspecie serial not null,
descricao varchar(30) NOT NULL,
CONSTRAINT PK_especie PRIMARY KEY (idEspecie)
);

CREATE TABLE categoria_veiculos (
idCategoria SERIAL NOT NULL,
nome varchar(50) NOT NULL,
idEspecie SMALLINT not null,
CONSTRAINT PK_categoria_veiculos PRIMARY KEY (idCategoria),
CONSTRAINT FK_especie FOREIGN KEY (idEspecie) REFERENCES especie (idEspecie)

);


CREATE TABLE tipo (
idTipo serial NOT NULL,
descricao varchar(30) NOT NULL,
CONSTRAINT PK_tipo PRIMARY KEY (idTipo)
);

CREATE TABLE marca (
idMarca serial NOT NULL,
nome varchar (40) NOT NULL,
origem varchar (40) NOT NULL,
CONSTRAINT PK_marca PRIMARY KEY (idMarca)
);

CREATE TABLE modelo (
idModelo serial NOT NULL,
denominacao varchar (100) NOT NULL,
idMarca integer NOT NULL,
idTipo integer NOT NULL,
CONSTRAINT PK_modelo PRIMARY KEY (idModelo),
CONSTRAINT FK_marca FOREIGN KEY (idMarca) REFERENCES marca(idMarca),
CONSTRAINT FK_tipo_modelo FOREIGN KEY (idTipo) REFERENCES tipo(idTipo)
);

CREATE TABLE infracao(
idInfracao serial NOT NULL,
descricao varchar(100) NOT NULL,
valor numeric NOT NULL,
pontos integer NOT NULL,

CONSTRAINT PK_infracao PRIMARY KEY (idInfracao )

);

CREATE TABLE veiculo (
renavam char(13) NOT NULL,
placa varchar(7) NOT NULL,
ano integer NOT NULL,
idCategoria integer NOT NULL,
idProprietario integer NOT NULL,
idModelo integer NOT NULL,
idCidade int,
dataCadastro date NOT NULL,
dataAquisicao date NOT NULL,
valor float NOT NULL,
situacao varchar(1) NOT NULL DEFAULT 'R' ,


CONSTRAINT PK_renavam PRIMARY KEY (renavam),
CONSTRAINT AK_placa UNIQUE (placa),
CONSTRAINT FK_categoria_veiculo FOREIGN KEY (idCategoria) REFERENCES categoria_veiculos (idCategoria),
CONSTRAINT FK_condutor_veiculo FOREIGN KEY (idProprietario) REFERENCES condutor(idCadastro),
CONSTRAINT FK_modelo_veiculo FOREIGN KEY (idModelo) REFERENCES modelo(idModelo),
CONSTRAINT FK_cidade_veiculo FOREIGN KEY (idCidade ) REFERENCES cidade (idCidade),
CONSTRAINT CHK_situacao_veiculo CHECK (situacao = 'R' or situacao = 'I' or situacao = 'B')
);

CREATE TABLE licenciamento (
ano integer NOT NULL,
renavam char (13) NOT NULL,
dataVenc date ,
pago char (1) DEFAULT 'N',
CONSTRAINT PK_ano PRIMARY KEY (renavam, ano),
CONSTRAINT FK_licenciamento_veiculo FOREIGN KEY (renavam) REFERENCES veiculo(renavam),
CONSTRAINT CHK_licenciamento_pago CHECK (pago = 'S' or pago = 'N')
);

CREATE TABLE multa (
idMulta serial NOT NULL,
renavam char(13) NOT NULL,
idInfracao integer NOT NULL,
idCondutor integer NOT NULL,
dataInfracao date NOT NULL,
dataVencimento date NOT NULL,
dataPagamento date NULL,
valor numeric NOT NULL,
juros numeric NOT NULL,
valorFinal numeric NOT NULL,
pago char(1) NOT NULL DEFAULT 'S',

CONSTRAINT PK_multa PRIMARY KEY (idMulta),
CONSTRAINT FK_multa_renavam FOREIGN KEY (renavam) REFERENCES veiculo(renavam),
CONSTRAINT FK_multa_infracao FOREIGN KEY (idInfracao) REFERENCES infracao(idInfracao),
CONSTRAINT FK_multa_condutor FOREIGN KEY (idCondutor) REFERENCES condutor(idCadastro),
CONSTRAINT CHK_multa_pago CHECK (pago = 'S' or pago = 'N')
);

CREATE TABLE transferencia (
idHistorico serial NOT NULL,
renavam char(13) NOT NULL,
idProprietario integer NOT NULL,
dataCompra date NOT NULL,
dataVenda date,
CONSTRAINT PK_historico_transferencia PRIMARY KEY (idHistorico),
CONSTRAINT FK_tranferencia_veiculo FOREIGN KEY (renavam) REFERENCES veiculo (renavam),
CONSTRAINT FK_transferencia_proprietario FOREIGN KEY (idProprietario) REFERENCES condutor (idCadastro)
);
