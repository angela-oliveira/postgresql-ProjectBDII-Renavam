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




