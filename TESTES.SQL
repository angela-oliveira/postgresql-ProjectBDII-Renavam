-- /teste para tranferencia DE PROPRIEDADE/
update veiculo
set idproprietario = 3, dataaquisicao = '11/06/2019'
where renavam = '00019658893'

select * from veiculo
select * from transferencia

-- TESTE PARA LICENCIAMNETO
select * from licenciamento
SELECT DATA_VENCIMENTO()

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- TESTE HISTORICO
SELECT * FROM HISTORICO('00019658893')



----------- TESTE VENCIMENTO MULTA ADICIONAR DATA + 40 DIAS E JUROS ------

				/*Data pagamento nulaa  COM UPDATE*/
insert into multa(renavam,idInfracao,idCondutor,dataInfracao,dataVencimento,valor,juros,valorFinal,pago) 
values  ('00019658893',3,2,'02/05/2019',vencimento_multa('02/05/2019'),293.47,0,0,'N');
-- ### Dentro da data
update multa
set datapagamento = '07/06/2019'
where idmulta = 12;
-- ### FORA da data
update multa
set datapagamento = '14/06/2019'
where idmulta = 13;
			  
			   /*Data pagamento NÃO  nulaa  COM INSERT*/
insert into multa(renavam,idInfracao,idCondutor,dataInfracao,dataVencimento,datapagamento,valor,juros,valorFinal,pago) 
values  ('00019658893',3,2,'02/05/2019',vencimento_multa('02/05/2019'),'19/06/2019',293.47,0,0,'N');

SELECT * from multa




-- /teste para tranferencia DE PROPRIEDADE/
update veiculo
set idproprietario = 3, dataaquisicao = '11/06/2019'
where renavam = '00019658893'

select * from veiculo
select * from transferencia

-- TESTE PARA LICENCIAMNETO
select * from licenciamento
SELECT DATA_VENCIMENTO()

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- TESTE HISTORICO
SELECT * FROM HISTORICO('00019658893')



----------- TESTE VENCIMENTO MULTA ADICIONAR DATA + 40 DIAS E JUROS ------

				/*Data pagamento nulaa  COM UPDATE*/
insert into multa(renavam,idInfracao,idCondutor,dataInfracao,dataVencimento,valor,juros,valorFinal,pago) 
values  ('00019658893',4,5,'02/05/2018',vencimento_multa('02/05/201'),293.47,0,0,'N');
-- ### Dentro da data
update multa
set datapagamento = '07/06/2019'
where idmulta = 12;
-- ### FORA da data
update multa
set datapagamento = '14/06/2019'
where idmulta = 13;
			  
			   /*Data pagamento NÃO  nulaa  COM INSERT*/
insert into multa(renavam,idInfracao,idCondutor,dataInfracao,dataVencimento,datapagamento,valor,juros,valorFinal,pago) 
values  ('00019658893',3,4,'02/05/2019',vencimento_multa('02/05/2019'),'19/06/2019',293.47,0,0,'N');

SELECT * from multa
 
SELECT idcadastro,nome, situacaocnh from condutor where situacaocnh = 'S'
----------------- TESTES DE VISÕES---------------

SELECT * FROM condutor_pontosCnh

SELECT  * FROM veiculos_proprietarios

SELECT  * FROM infracoes_valores




---------------------------------------------------- SUPENCÃO DA CNH COM INFRAÇÕES (A OFICIAL)  -----------------------------

CREATE OR REPLACE FUNCTION suspensa()
RETURNS TRIGGER AS $$
declare

	rec_suspender   RECORD;
	ano date;
	CURSOR_PONTOS CURSOR for select * from condutor_pontosCnh;
begin
	OPEN CURSOR_PONTOS;

   LOOP
    -- fetch row into the film
      FETCH CURSOR_PONTOS INTO rec_suspender ;
    -- exit when no more row to fetch
      EXIT WHEN NOT FOUND;
	  if rec_suspender.total_infracao < 20 and rec_suspender.ano < date_part('year',current_date) then
    	delete from multa
		where idcondutor = rec_suspender.idcondutor;
		update  condutor 
		set situacaocnh = 'R'
		where idcadastro = rec_suspender.idcondutor;
		 
	  elsif rec_suspender.total_infracao >= 20 then
	  	ano := (select max(datainfracao) from multa where idcondutor =rec_suspender.idcondutor);
		update condutor
		set situacaocnh = 'S'
		where idcadastro = rec_suspender.idcondutor;
	  end if;
		if current_date = ano + 366 then
			update condutor
			set situacaocnh = 'R'
			where idcadastro = rec_suspender.idcondutor;
        end if;
	
	
	END LOOP;
	
    CLOSE CURSOR_PONTOS;
    return rec_suspender.condutor;
 
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER suspencao
AFTER
insert ON multa
FOR EACH ROW
EXECUTE PROCEDURE suspensa();
