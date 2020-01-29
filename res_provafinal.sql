-- RESPOSTAS


--Questâo 1


select ma.nome,count(*) "Quantidades de veiculo" from veiculo v inner join modelo mo on v.idmodelo = mo.idmodelo
join marca ma on mo.idmarca = ma.idmarca
group by mo.idmarca,ma.nome
having mo.idmarca = 7


--Questâo 2

select inf.descricao, (max(mu.quant)) from 
(select idinfracao,count(*) quant from multa group by idinfracao) mu inner join infracao inf on inf.idinfracao = mu.idinfracao
group by inf.descricao




-- Questâo 3


select v.renavam, v.placa, con.nome,mo.denominacao, mo.idmarca, v.ano
from veiculo v inner join condutor con on v.idproprietario = con.idcadastro
join modelo mo on v.idmodelo = mo.idmodelo
where date_part('year',current_date) - v.ano >  8








-- Questâo 4

select con.idcadastro, con.nome, con.idcategoriacnh
from condutor con left join multa mul on mul.idcondutor = con.idcadastro
where idmulta is  null






-- 05

CREATE OR REPLACE FUNCTION Historico (_renavam CHAR)
	RETURNS TABLE (
	Renavam char(13),
   	Proprietario varchar(50),
	DataCompra date,
	DataVenda date
	)
AS $$
BEGIN
	return query	
		SELECT t.renavam,con.nome ,t.datacompra,t.datavenda
		FROM transferencia t join condutor con on
		t.idproprietario = con.idcadastro 
		union
		select vei.renavam, cond.nome, vei.datacompra, null
		from veiculo vei inner join condutor cond on vei.idproprietario = cond.idcadastro
		where vei.renavam = _renavam;
        order by datacompra

	
	
	
END; $$
LANGUAGE 'plpgsql';

/*Testando*/

SELECT * FROM Historico('13846331103');







