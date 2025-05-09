create database comercial;
use comercial;

 create table comusuario(
	 id_usuario int primary key not null auto_increment,
	 nome_usuario varchar(100),
	 datanascimento_usuario date
 );
 
 
create table if not exists comcliente(
	id_cliente int primary key auto_increment,
    nome_cliente varchar(100) not null,
    bi_cliente char(14) not null,
    dataNascimento_cliente date,
    fone_cliente char(16),
    razao_cliente varchar(30),
    numero_cliente int
);

insert into comcliente values(2,'Justino','003276543MO076','2000-04-24','987623451','Urgencia',2);
insert into comcliente values(3,'Beatriz','003200513MO023','2000-04-24','947625411','Para uma festa',1);
insert into comcliente values(4,'Edvânia','001278503MO036','2000-04-24','927623401','Ressaca',4);

select * from comcliente;

select id_cliente, nome_cliente from comcliente where id_cliente = 1;

update comcliente set nome_cliente = 'Adriano' where id_cliente = 1;
update comcliente set numero_cliente = 3 where id_cliente = 3;

delete from comcliente where id_cliente = 1;

select nome_cliente  from comcliente where nome_cliente like 'A%';

select  concat(nome_cliente,'   ',fone_cliente) from comcliente order by numero_cliente;

select concat_ws(';',id_cliente, numero_cliente, nome_cliente) 
from comcliente where numero_cliente like  'GREA%';


create table if not exists comendereco(
	id_endereco int primary key auto_increment,
    bairro varchar(50),
    cidade varchar(80),
    rua char(45),
    numer_casa int
);

insert into comendereco values(1,'Viana','Luanda','Via Expressa',287);
insert into comendereco values(2,'Kapango','Luena','Estrada nacional 180',3307);

create table if not exists comfornecedor(
	 id_fornecedor int primary key auto_increment,
	 nome_fornecedor varchar(100),
     email_fornecedor varchar(100),
	 fone_fornecedor char(16),
     id_endereco int,
     constraint foreign key (id_endereco ) references comendereco (id_endereco )
     on delete cascade
     on update cascade
 );
 
 insert into comfornecedor values(1,'Refriango','refriango@outmail.com','965432129',1);
 
create table if not exists comvendedor(
	 id_vendedor int primary key auto_increment,
	 nome_vendedor varchar(100),
	 bi_vendedor char(14) not null,
     dataNascimento_vendedor date,
     email_vendedor varchar(100),
	 fone_vendedor char(16),
     id_endereco int,
     constraint foreign key (id_endereco ) references comendereco (id_endereco )
     on delete cascade
    on update cascade
 ); 
  insert into comvendedor values(1,'Salomçao Capusso','008765231MO054','2003-04-02','edsonfllin99@gmail.com','945050445',2);
  
  
 create table if not exists comproduto(
	 id_produto int primary key auto_increment,
	 nome_produto varchar(100),
	 desc_produto varchar(20),
	 valor_produto float(10,2),
     quantidade_produto int,
	 id_fornecedor int,
	 constraint foreign key (id_fornecedor ) references comfornecedor (id_fornecedor )
     on delete cascade
    on update cascade
 );
 
insert into comproduto values(1,'Refrigerantes','Sem gás',45000,30,1);


 create table if not exists comvenda(
	 id_venda int primary key auto_increment,
	 id_cliente int not null,
	 id_vendedor  int not null,
	 valorvenda float(10,2),
	 descontovenda decimal(10,2),
	 totalvenda float(10,2),
     comissaovenda float(10,2),
	 datavenda date,
     constraint foreign key (id_cliente ) references comcliente (id_cliente ),
     constraint foreign key (id_vendedor ) references comvendedor (id_vendedor )
     on delete cascade
     on update cascade
 );
 
 insert into comvenda values(1,1,1,45000,2000,448000,14,'2025-03-28');
 
 
 select comcliente.numero_cliente as 'Número do cliente'
 from comcliente
 where id_cliente in (select comcliente.id_cliente
 from comvenda
 where id_cliente);
 
 
 select comcliente.numero_cliente as 'Número do cliente'
 from comcliente
 where id_cliente not in (select comcliente.id_cliente
 from comvenda
 where id_cliente);
 
 
select comcliente.id_cliente, comcliente.numero_cliente,
 comvenda.id_venda as 'Código da Venda'
 from comvenda , comcliente
 where comvenda.id_cliente = comcliente.id_cliente
 order by numero_cliente;
 
 
 select comcliente.id_cliente, comcliente.numero_cliente, 
 comvenda.id_venda as 'Código da Venda'
 from comvenda join comcliente
 on comvenda.id_cliente = comcliente.id_cliente
 order by numero_cliente;
 
 
 create table if not exists comvenda_produto(
	 id_venda_produto int primary key auto_increment,
	 id_venda int not null,
	 id_produto int not null,
	 valor_produto decimal(10,2),
	 qtd_produto int,
	 desconto_produto float(10,2),
    constraint foreign key (id_venda ) references comvenda (id_venda ),
    constraint foreign key (id_produto ) references comproduto (id_produto )
 );
 
 
insert into comvenda_produto values(1,1,1,45000,30,200);


select id_venda as 'Código da Venda',
 (select numero_cliente as 'Nome do cliente'
 from comcliente
 where id_cliente = comvenda.id_cliente) as Nome_Cliente
 from comvenda;
 
 
select comcliente.id_cliente, comcliente.numero_cliente,
comvenda.id_venda as 'Código da Venda', count(id_venda) from comvenda  join comcliente 
on comvenda.id_cliente = comcliente.id_cliente  group by numero_cliente having count(id_venda) > 0;


select sum(valorvenda) as 'Valor venda', 
sum(descontovenda) as 'Descontos', 
sum(totalvenda) as 'Total venda' from comvenda where 
datavenda between '2025-01-01' and '2025-04-31';

 select curtime();
 
select datediff('2055-05-08 13:32:41','2025-05-09');

select date_add('2025-02-28', interval 31 day);

select sysdate();

select now();

select curdate();

 select (valor_produto + desconto_produto) as 'Aumento do produto'
 from comvenda_produto
 where id_venda_produto = 1;
 
select (valor_produto - desconto_produto) as 'Desconto do produto'
 from comvenda_produto
 where id_venda_produto = 1;
 
 select truncate((sum(valor_produto) /
 count(id_venda_produto)),2) 
 from comvenda_produto;
 
select (qtd_produto * valor_produto) as 'Multiplicação dos produtos'
 from comvenda_produto
 where id_venda_produto = 1;
 
 select pi();
 select tan(pi()+1);
 
select cos(pi());

select sin(pi());

select sqrt(25);

select truncate(min(totalvenda),1) 'Menor venda'
from comvenda;

select truncate(max(totalvenda),0) 'Maior venda'
 from comvenda;
 
 select format('21123.142',2) from dual;
 
 select round('213.142',2) from dual;

 select ucase('banco de dados mysql') from dual;
 
 select lcase(razao_cliente)
 from comcliente;
 
 select ucase(razao_cliente)
 from comcliente;
 
select dayname('2025-05-08');
  
select dayofmonth('2025-05-08');

select extract(year from '2025-05-08');

 select last_day('2025-05-08');
 
 select date_format('2025-05-08',get_format(date,'AO'));
 
select str_to_date('01.01.2055',get_format(date,'AO'));

set global event_scheduler = on;

 select id_venda Codigo,
 totalvenda 'Total da venda',
 comissaovenda 'Comissao da venda'
 from comvenda
 where
 datavenda between current_date() - interval 60 day
 and current_date();
 
 show variables like '%table%';
 
show variables;
  
show processlist;
    
select table_schema as 'Banco de Dados',
table_name as 'Tabela',
column_name 'Nome da coluna'
from information_schema.columns
where table_schema = 'comercial'
and column_name = 'numero_cliente';
 
 

