
-------------------------- Visão 1: tabela que indica a relação de condutores com pontos na carteira --------------------------


CREATE VIEW condutor_pontosCnh AS
    ( SELECT con.idcadastro,con.nome as Condutor, 
    con.idcategoriacnh, date_part('year',mult.datainfracao)
    as ano, sum(infra.pontos) as Total_infracao
    FROM condutor con  JOIN multa mult
    ON con.idcadastro = mult.idcondutor  join infracao infra
    on mult.idinfracao = infra.idinfracao
    GROUP BY date_part('year',mult.datainfracao), con.idcadastro
);


--------------------------- Visão 2: tabela que apresenta a relação dos veiculos/proprietários ---------------------------------

CREATE VIEW  veiculos_proprietarios AS
( 
	 SELECT vei.renavam, vei.placa, con.nome as Proprietario,
	 mod.denominacao Modelo, mar.nome as Marca, cid.nome as cidade, cid.id_uf as Estado, ti.descricao as Tipo
	 from veiculo vei join condutor con on vei.idproprietario
	 = con.idcadastro join modelo mod on vei.idmodelo = mod.idmodelo
	 join cidade cid on vei.idcidade = cid.idcidade
	 join marca mar on mod.idmarca = mar.idmarca join tipo ti
	 on mod.idtipo = ti.idtipo
);


-------------------------- Visão 3: tabela que apresente o número de infrações e valores em multas registrados por ano e mês.------------


CREATE VIEW infracoes_valores AS 
( 
	SELECT date_part('year',datainfracao) Ano, date_part('month',datainfracao) Mês, COUNT(idinfracao) Num_infracoes, 
	sum(valor) Valores_multas
	FROM multa
	GROUP BY date_part('year',datainfracao),date_part('month',datainfracao)
);


