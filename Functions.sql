------------------------- Função para o calculo renavam -------------------------

CREATE OR REPLACE FUNCTION calculo_renavam()
RETURNS char(13)
AS $$
DECLARE

	num INTEGER := 0;
	soma INTEGER := 0;
	ret INTEGER := 0;
	j INTEGER := 0;
	ren text := '';
	fatt INTEGER [] := array [3,2,9,8,7,6,5,4,3,2];
	
BEGIN
	
	FOR j in 1..10 LOOP
		num := trunc(random()*10);
		ren := ren || num;
		soma := soma + num * fatt[j];
		ret := (soma * 10) % 11;
		
	END LOOP;
	ren := ren || ret;
	RAISE NOTICE 'Retorno: %',ret;
	RAISE NOTICE 'RENAVAM: %',ren;
	return ren;
END; $$

LANGUAGE plpgsql;


	
----------------------- Função que retorna  trigger para fazer Transferência de Propriedade -----------------------
		
CREATE OR REPLACE FUNCTION TransferenciaPropriedade()
RETURNS TRIGGER AS $$
BEGIN
	insert into transferencia (renavam,idproprietario,datacompra,datavenda) values 
	(old.renavam,OLD.idproprietario,OLD.dataaquisicao,new.dataaquisicao);
	return new;

END; $$
LANGUAGE plpgsql;

CREATE TRIGGER transferencia
AFTER
UPDATE ON veiculo
FOR EACH ROW
EXECUTE PROCEDURE TransferenciaPropriedade();


update veiculo
set idproprietario = 3, dataaquisicao = '11/06/2019'
where renavam = '44129834981'




--------------------------- DADA VENCIMENTO NA TABELA LICENCIAMENTO --------------------------- 

/*OBS:.*/
/* ANTES DE RODAR A FUNÇÃO DATA_VENCIMENTO,FAÇA UM TRUNCATE NA TABELA licencimento,POIS ALGUNS DADOS FORAM ALTERADOS.*/
/* PARA APAGAR OS INSERTES : TRUNCATE TABLE licenciamento*/
/* PARA APAGAR A FUNÇÃO: DROP FUNCTION [NOME]*/
/* EM SEGUIDA: GERE NOVOS DADOS COM A FUNÇÃO INSERT_LICEN() */
/* DEPOIS RODE A FUNÇÃO DATA_VENCIMNETO()*/

CREATE OR REPLACE function INSERT_lICEN()
returns void
LANGUAGE plpgsql 
AS $$

Declare
final_placa Integer;
placas CURSOR for select * from veiculo v;

Begin 
For placaa in placas LOOP
select RIGHT(placaa.placa, 1) into final_placa;
case 
	when final_placa = 1 then INSERT INTO Licenciamento values (2019, placaa.renavam, '28/03/2018', 'S');
	when final_placa = 2 then INSERT INTO Licenciamento values (2019, placaa.renavam, '30/04/2018', 'S');
	when final_placa = 3 then INSERT INTO Licenciamento values (2019, placaa.renavam, '30/05/2018', 'S');
	when final_placa = 4 then INSERT INTO Licenciamento values (2019, placaa.renavam, '29/06/2018', 'S');
	when final_placa = 5 then INSERT INTO Licenciamento values (2019, placaa.renavam, '31/07/2018', 'S');
	when final_placa = 6 then INSERT INTO Licenciamento values (2019, placaa.renavam, '31/08/2018', 'S');
	when final_placa = 7 then INSERT INTO Licenciamento values (2019, placaa.renavam, '28/09/2018', 'S');
	when final_placa = 8 then INSERT INTO Licenciamento values (2019, placaa.renavam, '31/10/2018', 'S');
	when final_placa = 9 then INSERT INTO Licenciamento values (2019, placaa.renavam, '30/11/2018', 'S');
	when final_placa = 0 then INSERT INTO Licenciamento values (2019, placaa.renavam, '28/12/2018', 'S');
	else raise notice 'NÂO FINALIZADO';
	
COMMIT;	
RAISE NOTICE 'ERRO';	
End Case;
End Loop;
End$$;

/*SELECT INSERT_lICEN()*/




---------------------------FUNCTION OFICIAL DA TABELA LICENCIAMENTO--------------------------------------------

/*ATUALIZAÇÃO DA DATA DE VENCIMENTO*/


CREATE OR REPLACE function DATA_VENCIMENTO()
returns void
LANGUAGE plpgsql 
AS $$

Declare
final_placa Integer;
placas CURSOR for select * from veiculo v join licenciamento l on v.renavam = l.renavam;
			
Begin 
For placaa in placas LOOP
select RIGHT(placaa.placa, 1) into final_placa;
case 

	when final_placa = 1 then UPDATE licenciamento SET datavenc = '28/03/2019' WHERE datavenc= placaa.datavenc;
	when final_placa = 2 then UPDATE licenciamento SET datavenc = '30/04/2019' WHERE datavenc= placaa.datavenc;
	when final_placa = 3 then UPDATE licenciamento SET datavenc = '30/05/2019' WHERE datavenc= placaa.datavenc;
	when final_placa = 4 then UPDATE licenciamento SET datavenc = '29/06/2019' WHERE datavenc= placaa.datavenc;
	when final_placa = 5 then UPDATE licenciamento SET datavenc = '31/07/2019' WHERE datavenc= placaa.datavenc;
	when final_placa = 6 then UPDATE licenciamento SET datavenc = '31/08/2019' WHERE datavenc= placaa.datavenc;
	when final_placa = 7 then UPDATE licenciamento SET datavenc = '28/09/2019' WHERE datavenc= placaa.datavenc;
	when final_placa = 8 then UPDATE licenciamento SET datavenc = '31/10/2019' WHERE datavenc= placaa.datavenc;
	when final_placa = 9 then UPDATE licenciamento SET datavenc = '30/11/2019' WHERE datavenc= placaa.datavenc;
	when final_placa = 0 then UPDATE licenciamento SET datavenc = '28/12/2019' WHERE datavenc= placaa.datavenc;
	else raise notice 'NÂO FINALIZADO';


COMMIT;	
RAISE NOTICE 'ERRO';	
End Case;
End Loop;
End$$;



------------------- Função que retorna uma tabela  com  o histórico de transação através do renavam do veículo ------------------- 
			
CREATE OR REPLACE FUNCTION Historico (_renavam CHAR)
	RETURNS TABLE (
	Renavam_ char(13),
        Modelo_  varchar(100),
        Marca_   varchar(40),
	Ano_ int,
	Proprietario_ varchar(50),
	DataCompra_ date,
	DataVenda_ date
	)
AS $$
BEGIN
    if exists (SELECT renavam from transferencia  WHERE renavam = _renavam) then
	return query	
		SELECT t.renavam,mod.denominacao ,ma.nome ,ve.ano,con.nome ,t.datacompra,t.datavenda
		FROM transferencia t  join
		veiculo ve on t.renavam = ve.renavam join condutor con on
		t.idproprietario = con.idcadastro join modelo mod on 
		ve.idmodelo = mod.idmodelo join marca ma on mod.idmarca = ma.idmarca
		WHERE ve.renavam = _renavam;

    else
	return query
		select vei.renavam, mode.denominacao,mar.nome, vei.ano, cond.nome, vei.datacadastro, vei.dataaquisicao
		from veiculo vei join condutor cond
		on vei.idproprietario = cond.idcadastro join modelo mode on vei.idmodelo = mode.idmodelo join marca mar on mode.idmarca = mar.idmarca
		WHERE vei.renavam = _renavam;
	 		/*OU*/
	  	/*Raise Notice 'Sem historico de transação';*/
    end if;
	
END; $$
LANGUAGE 'plpgsql';

/*Testando*/

SELECT * FROM Historico('54508013274');


-----------------------Função para data de vencimento da multa ----------------------
			/*Incompleta*/
CREATE OR REPLACE FUNCTION vencimento_multa()
RETURNS date
AS $$

DECLARE
-- 	data_ date := CAST('2019-09-01' AS DATE);
	data_venci date := (select  datainfracao  + INTERVAL' 40 days' from  multa);
		
BEGIN
	CASE date_part('dow',data_venci)
		WHEN 0 THEN
			data_venci := data_venci +1; 
			RAISE NOTICE 'Domingo';
			return data_venci;
		WHEN 6 THEN
			data_venci := data_venci +2; 
			RAISE NOTICE 'Sábado';
			return data_venci;

		ELSE
			return data_venci;
END CASE;
END; $$
LANGUAGE plpgsql;


----------------Outro teste do mesmo requesito

CREATE OR REPLACE FUNCTION vencimento_multa1()
RETURNS trigger
AS $$

DECLARE
-- 	data_ date := CAST('2019-09-01' AS DATE);
	data_venci date := (select  new.datainfracao  + INTERVAL' 40 days' from  multa);
		
BEGIN
	CASE date_part('dow',data_venci)
		WHEN 0 THEN
			data_venci := data_venci +1; 
			RAISE NOTICE 'Domingo';
			update multa
			set datavencimento = data_venci
			where datavencimento = new.datainfracao;    
		WHEN 6 THEN
			data_venci := data_venci +2; 
			RAISE NOTICE 'Sábado';
			update multa
			set datavencimento = data_venci
			where datavencimento = new.datainfracao;

		ELSE
			raise NOTICE 'Erro';
END CASE;
END; $$
LANGUAGE plpgsql;
CREATE TRIGGER vencimento
AFTER
insert ON multa
FOR EACH ROW
EXECUTE PROCEDURE vencimento_multa1();

select * from categoria_cnh


insert into multa(renavam,idInfracao,idCondutor,dataInfracao,dataVencimento,valor,juros,valorFinal,pago) values  ('29471668360',5,2,'02/05/2019','01/12/2019',1467.35,0,1467.35,'S');



------------------------------------------------------FUNÇÃO EM TESTE----------------------------------------------------
------------TEM ERROS 


CREATE OR REPLACE FUNCTION vencimento_multa()
RETURNS date
LANGUAGE plpgsql 
AS $$

DECLARE
linhas integer :=1 ;
data_venci date ; 

-- 	data_ date := CAST('2019-09-01' AS DATE);

	CURSOR_PONTOS CURSOR for select I.idinfracao ,Sum(pontos)* 0.01  as TotalPontos from MULTA M join CONDUTOR C
		on C.IDCADASTRO = M.IDMULTA 
		JOIN INFRACAO I
		ON  M.IDINFRACAO = I.IDINFRACAO
	
		GROUP BY I.idinfracao ;
	
		
		
BEGIN

For SUSPENSAO in CURSOR_PONTOS LOOP

     IF EXISTS( SELECT M.datainfracao, M.idmulta,I.PONTOS,I.DESCRICAO FROM multa M JOIN INFRACAO I ON M.IDINFRACAO = I.IDINFRACAO
         where  data_venci = (select  datainfracao  + INTERVAL' 40 days' from  multa  as infrac
	GROUP BY datainfracao ,idmulta,PONTOS,DESCRICAO HAVING idcondutor = idcondutor ORDER BY idmulta,datainfracao) )THEN 


	CASE date_part('dow',data_venci)
		WHEN 0 THEN
			data_venci := data_venci +1;
			RAISE NOTICE 'Domingo';
			return data_venci;
		WHEN 6 THEN
			data_venci := data_venci +2;
			RAISE NOTICE 'Sábado';
			return data_venci;

		ELSE
			return data_venci;
			


	END CASE;
     END IF; 
end loop;
  END$$;

--DROP FUNCTION vencimento_multa()
--select vencimento_multa()

--select * from veiculo
--select * from multa
--select * from infracao




-------------------------------------------------FUNÇÃO SUSPENSAO CNH--------------------------------------------------------

 --- FOI TESTADA
 ---ESSA LÓGICA É SÓ PRA TER UMA NOÇÃO DO QUE PODE SER FEITO,PROVAVELMENTE SERÁ REFEITA.

 ---QUANDO FIZER O TESTE VERIFICAR EM 'MENSAGENS'
 
CREATE OR REPLACE FUNCTION SUSPENSAO_CNH(PONTOSS FLOAT,MULTAA FLOAT  ) 
RETURNS VOID
LANGUAGE plpgsql 
AS $$
DECLARE 
PONTOSS FLOAT  := 0;


CURSOR_PONTOS CURSOR for select * from MULTA M join CONDUTOR C
 on C.IDCADASTRO = M.IDMULTA 
 JOIN INFRACAO I
 ON  M.IDINFRACAO = I.IDINFRACAO;
			
Begin 
For SUSPENSAO in CURSOR_PONTOS LOOP

	IF EXISTS( SELECT M.datainfracao, M.idmulta,I.PONTOS,I.DESCRICAO FROM multa M JOIN INFRACAO I ON M.IDINFRACAO = I.IDINFRACAO
	WHERE datainfracao BETWEEN '2019-01-01' AND '2020-01-10'
	GROUP BY M.idmulta,I.PONTOS,I.DESCRICAO HAVING idcondutor = idcondutor ORDER BY idmulta,datainfracao) THEN 
END IF;
	CASE 

	     WHEN SUSPENSAO.PONTOS = 20 THEN RAISE NOTICE 'UM ANO SEM DIRIGIR';
	     WHEN SUSPENSAO.pontos = 3 then RAISE NOTICE   'Infração leve';
	     WHEN  SUSPENSAO.pontos = 4 then RAISE NOTICE 'Infração médias';
	     WHEN SUSPENSAO.pontos = 5 then RAISE NOTICE 'Infrações graves';
	     WHEN SUSPENSAO.pontos = 7 then RAISE NOTICE 'infrações gravíssimas';
	     ELSE RAISE NOTICE  'ERRO';

	

END CASE;					  
End LOOP;
End$$;

--select SUSPENSAO_CNH(3,30.00)

--DROP FUNCTION SUSPENSAO_CNH(PONTOSS FLOAT,MULTAA FLOAT) 

--SELECT * FROM INFRACAO
--SELECT * FROM MULTA
--SELECT * FROM LICENCIAMENTO



------------------------------------------ Função teste SUSPENÇÃO DA CNH POR ANO -------------------------------

			/*(ESTÁ ERRADA POIS É DE 12 MESES*/

CREATE OR REPLACE FUNCTION suspensa()
RETURNS TRIGGER AS $$
declare

	rec_film   RECORD;
	
	CURSOR_PONTOS CURSOR for SELECT  con.idcadastro as Condutor,sum(infra.pontos) as Total_infracao
    FROM condutor con  JOIN multa mult
    ON con.idcadastro = mult.idcondutor  join infracao infra
    on mult.idinfracao = infra.idinfracao
    GROUP BY date_part('year',mult.datainfracao),con.idcadastro
	having sum(infra.pontos) >= 20;
	
begin
	OPEN CURSOR_PONTOS;
	
	
   
   LOOP
    -- fetch row into the film
      FETCH CURSOR_PONTOS INTO rec_film ;
    -- exit when no more row to fetch
      EXIT WHEN NOT FOUND;
	
		update condutor
		set situacaocnh = 'S'
		where idcadastro = rec_film.Condutor ;

		    
   END LOOP;
  
   -- Close the cursor
   
   CLOSE CURSOR_PONTOS;
   return rec_film.condutor;

END; $$
LANGUAGE plpgsql;

CREATE TRIGGER suspencao
AFTER
insert ON multa
FOR EACH ROW
EXECUTE PROCEDURE suspensa();



----------------------------------  Função teste SUSPENÇÃO DA CNH POR 12 MESES DA DATA ---------------------------

			/* EM ANDAMENTO*/


CREATE OR REPLACE FUNCTION suspensa()
RETURNS TRIGGER AS $$
declare

    rec_film   RECORD;
    CURSOR_PONTOS CURSOR for SELECT mult.datainfracao as data_infracao, con.idcadastro as Condutor,infra.pontos as pontos
    FROM condutor con  JOIN multa mult
    ON con.idcadastro = mult.idcondutor  join infracao infra
    on mult.idinfracao = infra.idinfracao
    GROUP BY mult.datainfracao,con.idcadastro,infra.pontos;
-- 	having sum(infra.pontos) >= 20;
	cont int := 0;
begin
	OPEN CURSOR_PONTOS;

	  
   LOOP
    -- fetch row into the film
      FETCH CURSOR_PONTOS INTO rec_film ;
    -- exit when no more row to fetch
      EXIT WHEN NOT FOUND;
		
	  if new.idcondutor  = rec_film.condutor then
	  	if new.datainfracao between rec_film.data_infracao and rec_film.data_infracao + 366 or rec_film.data_infracao
		between new.datainfracao and new.datainfracao + 366 then
			cont := cont + rec_film.pontos;
		end if;
	  end if;
	  if cont >= 20 then
		update condutor
		set situacaocnh = 'S'
		where idcadastro = rec_film.Condutor ;
	  end if;
		    
   END LOOP;
   return rec_film.condutor ;
   -- Close the cursor
   CLOSE CURSOR_PONTOS;
   

END; $$
LANGUAGE plpgsql;

CREATE TRIGGER suspencao
AFTER
insert ON multa
FOR EACH ROW
EXECUTE PROCEDURE suspensa();





-------------------- TESTE SUPENCÃO DA CNH COM INFRAÇÕES AUTO SUSPENSIVAS  --------------------

		/* EM ANDAMENTO*/

CREATE OR REPLACE FUNCTION suspensa()
RETURNS TRIGGER AS $$
declare

	rec_film   RECORD;
	in1 text := 'dirigir sob a influência de álcool, conforme o artigo 165 do CTB';
	in2 text := 'recusar-se a fazer o teste do bafômetro';
	in3 text := 'disputar corridas';
	in4 text := 'fazer manobras perigosas (derrapar, deslizar pneu)';
	in5 text := 'deixar de prestar socorro a uma vítima de acidente no qual está envolvido';
	in6 text := 'deixar de prestar informações para o registro de boletim de ocorrência em caso de acidente';
	
	CURSOR_PONTOS CURSOR for SELECT mult.datainfracao as data_infracao, con.idcadastro as Condutor,
	infra.pontos as pontos,infra.idInfracao as idInfracao_, infra.descricao as Infracao
    FROM condutor con  JOIN multa mult
    ON con.idcadastro = mult.idcondutor  join infracao infra
    on mult.idinfracao = infra.idinfracao
    GROUP BY mult.datainfracao,con.idcadastro,infra.pontos,infra.idInfracao,infra.descricao;
-- 	having sum(infra.pontos) >= 20;
	cont int := 0;
begin
	OPEN CURSOR_PONTOS;

	  
   LOOP
    -- fetch row into the film
      FETCH CURSOR_PONTOS INTO rec_film ;
    -- exit when no more row to fetch
      EXIT WHEN NOT FOUND;
	  
	  
	  if rec_film.Infracao in (in1,in2,in3,in4,in5,in6) then
	  		update condutor
			set situacaocnh = 'S'
			where idcadastro = rec_film.Condutor ;
	  end if;
	  
		
	  if new.idcondutor  = rec_film.condutor then
	  	if new.datainfracao between rec_film.data_infracao and rec_film.data_infracao + 366 or rec_film.data_infracao
		between new.datainfracao and new.datainfracao + 366 then
			cont := cont + rec_film.pontos;
		end if;
	  end if;
	  if cont >= 20 then
			update condutor
			set situacaocnh = 'S'
			where idcadastro = rec_film.Condutor ;
	  end if;
		    
   END LOOP;
   return rec_film.condutor ;
   -- Close the cursor
   CLOSE CURSOR_PONTOS;
   

END; $$
LANGUAGE plpgsql;

CREATE TRIGGER suspencao
AFTER
insert ON multa
FOR EACH ROW
EXECUTE PROCEDURE suspensa();


















