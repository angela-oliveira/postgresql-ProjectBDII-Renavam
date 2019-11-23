################# Visão 1: tabela que indica a relação de condutores com pontos na carteira ################# 

                    ---Falta testar

CREATE VIEW condutor_pontosCnh AS
    ( SELECT con.idcadastro,con.nome as Condutor, 
    con.idcategoriacnh, date_part('year',mult.datainfracao)
    as ano, sum(infra.pontos)
    FROM condutor con  JOIN multa mult
    ON con.idcadastro = mult.idcondutor  join infracao infra
    on mult.idinfracao = infra.idinfracao
    GROUP BY date_part('year',mult.datainfracao), con.idcadastro
);
