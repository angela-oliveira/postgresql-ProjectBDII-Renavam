----questao 1

CREATE OR REPLACE FUNCTION devolvido()
RETURNS TRIGGER AS $$
declare  
	dias_juros int;
	calculo_juros float;

BEGIN
	update exemplar
	set disponivel = 'S'
	where codexemplar = old.codexemplar;
	
	if current_date <= old.datadevolucao then
		raise notice 'Pagamento efetuado dentro da data';
		return old;
	else
		dias_juros := current_date - old.datadevolucao;
		calculo_juros := dias_juros * 1.50;
		insert into multa(numEmprestimo,datadevolucao,valor) values (old.numemprestimo,current_date, calculo_juros);
		return new;
	
	end if;	
	
	
	
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER devolucaoo
AFTER
UPDATE ON emprestimo
FOR EACH ROW
EXECUTE PROCEDURE devolvido();

/* TESTENADO*/
update emprestimo
set devolvido = 'S'
where numemprestimo = 13



INSERT INTO emprestimo (codExemplar,codUsuario,dataEmprestimo,dataDevolucao,devolvido)
VALUES (22, 4, '2019-04-10', '2019-12-19'::date + 10, 'N'); 


select * from emprestimo
select * from multa
select * from exemplar

2019-12-11

---------------------3


CREATE VIEW dados_usuarios AS
    ( SELECT  us.nome, us.codusuario,count(us.codusuario),count(mul.numemprestimo) quantidade_multa
	 from usuario us join emprestimo em on us.codusuario = em.codusuario
	 join multa mul on em.numemprestimo = mul.numemprestimo
	 group by us.nome,us.codusuario
);

