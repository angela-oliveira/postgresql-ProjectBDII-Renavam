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
			
			/*CERTA*/
			
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

/* TESTENADO*/
update veiculo
set idproprietario = 3, dataaquisicao = '11/06/2019'
where renavam = '44129834981'





---------------------------FUNCTION OFICIAL DA TABELA LICENCIAMENTO--------------------------------------------

/*ATUALIZAÇÃO DA DATA DE VENCIMENTO O USO DO CASE COM SÁBADO E DOMINGO NÃO ESTÁ FUNCIONANDO*/

CREATE OR REPLACE function DATA_VENCIMENTO()
returns void
LANGUAGE plpgsql 
AS $$

Declare
REGISTRO RECORD;
data_venci integer;
final_placa Integer;
placas CURSOR for select * from veiculo v join licenciamento l on v.renavam = l.renavam;
	
Begin 
data_venci =0;
For placaa in placas LOOP
select RIGHT(placaa.placa, 1) into final_placa;

FOR REGISTRO IN select  L.datavenc  from veiculo v join licenciamento l on v.renavam = l.renavam LOOP 


	CASE 
		WHEN 0 THEN
			data_venci = REGISTRO.datavenc +1; 
			RAISE NOTICE 'Domingo';
			update licenciamento
			set datavenc = data_venci
			where datavenc = datavenc;    
		WHEN 0 THEN
			data_venci =REGISTRO.datavenc +2; 
			RAISE NOTICE 'Sábado';
			update multa
			set datavenc= data_venci
			where datavenc = datavenc;
			else raise notice 'NÂO FINALIZADO teste';

 CASE 
    
	 when final_placa = 1 then UPDATE licenciamento SET datavenc = placaa.datavenc + Interval '365 days'  WHERE datavenc= placaa.datavenc;
	 when final_placa = 2 then UPDATE licenciamento SET datavenc = placaa.datavenc + Interval '365 days'  WHERE datavenc= placaa.datavenc;
         when final_placa = 3 then UPDATE licenciamento SET datavenc = placaa.datavenc + Interval '365 days'  WHERE datavenc= placaa.datavenc;
	 when final_placa = 4 then UPDATE licenciamento SET datavenc = placaa.datavenc + Interval '365 days'  WHERE datavenc= placaa.datavenc;
         when final_placa = 5 then UPDATE licenciamento SET datavenc = placaa.datavenc + Interval '365 days'  WHERE datavenc= placaa.datavenc;
         when final_placa = 6 then UPDATE licenciamento SET datavenc = placaa.datavenc + Interval '365 days'  WHERE datavenc= placaa.datavenc;
	 when final_placa = 7 then UPDATE licenciamento SET datavenc = placaa.datavenc + Interval '365 days'  WHERE datavenc= placaa.datavenc;
	 when final_placa = 8 then UPDATE licenciamento SET datavenc = placaa.datavenc + Interval '365 days'  WHERE datavenc= placaa.datavenc;
	 when final_placa = 9 then UPDATE licenciamento SET datavenc = placaa.datavenc + Interval '365 days'  WHERE datavenc= placaa.datavenc;
         when final_placa = 0 then UPDATE licenciamento SET datavenc = placaa.datavenc + Interval '365 days'  WHERE datavenc= placaa.datavenc;
   	 else raise notice 'NÂO FINALIZADO';

COMMIT;
RAISE NOTICE 'ERRO DE DADOS';
End Case;
End Case;
end loop;
end loop;
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
			/*correta*/

CREATE OR REPLACE FUNCTION vencimento_multa( data_infra date)
RETURNS date
AS $$

DECLARE

	data_venci date :=  data_infra + 40;
		
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

----------- FUNÇÃO QUE RETORNA TRIGGER PARA ACRESCENTAR JUROS CASO A DATA DE PAGAMENTO SEJA MAIOR QUE DATA DE VENCIMENTO----------------


CREATE OR REPLACE FUNCTION juros__()
RETURNS trigger
AS $$

DECLARE 
	rec_juros   RECORD;
	dias_juros int;
	calculo_juros float;
		
BEGIN
		if new.datapagamento <= new.datavencimento then
			update multa
			set pago = 'S'
			where datapagamento = new.datapagamento;
-- 			raise notice 'Pagamento efetuado dentro da data';
			return new;
				

	 	else
		 	IF (TG_OP='INSERT') then
				dias_juros := new.datapagamento - new.datavencimento;
			
			elsif (TG_OP='UPDATE') then
				dias_juros := new.datapagamento - OLD.datavencimento;
			end if;
				
			calculo_juros := dias_juros * 0.01;
			update multa
			set juros = calculo_juros, valorfinal =  new.valor + calculo_juros, pago = 'S'
			where datapagamento = new.datapagamento;
-- 			raise notice 'Pagamento efetuado fora da data';
			return new;
		end if;	

END; $$
LANGUAGE plpgsql;
CREATE TRIGGER juros
AFTER 
INSERT OR UPDATE of datapagamento ON multa
FOR EACH ROW
EXECUTE PROCEDURE juros__();




------------------------------------------------------- SUPENCÃO DA CNH COM INFRAÇÕES (A OFICIAL)  -----------------------------

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
    	
	 	alter view condutor_pontosCnh
		alter total_infracao set default 0;
		
		 
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
