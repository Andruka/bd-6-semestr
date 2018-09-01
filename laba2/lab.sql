drop table purchase;
drop table product_provider;
drop table payment_system;
drop table product;
drop table provider;
drop table buyer;


create table product(
id int NOT NULL,
name varchar(40) NOT NULL,
shelf_life int NOT NULL,
cost numeric(10,2) NOT NULL,
PRIMARY KEY (id)
);

create table provider(
id int NOT NULL,
name varchar(40) NOT NULL,
PRIMARY KEY (id)
);

create table buyer(
id int NOT NULL,
name varchar(40) NOT NULL,
discount numeric(5,2) NOT NULL,
PRIMARY KEY (id)
);


create table payment_system(
id int NOT NULL,
name varchar(40) NOT NULL,
PRIMARY KEY (id)
);


create table product_provider(
id_product int,
foreign key (id_product) references product(id) on delete cascade on update cascade,
id_provider int,
foreign key (id_provider) references provider(id) on delete cascade on update cascade,
data date NOT NULL
);

create table purchase(
id_product int,
foreign key (id_product) references product(id) on delete cascade on update cascade,
id_buyer int,
foreign key (id_buyer) references buyer(id) on delete cascade on update cascade,
id_pay_s int,
foreign key (id_pay_s) references payment_system(id) on delete cascade on update cascade,
data date NOT NULL
);

insert into product values
(1,'Кедровое_масло',6,700),
(2,'Орехи_кедровые',3,950),
(3,'Кофе',12,500),
(4,'Чай',12,440),
(5,'Грильяж',9,170),
(6,'Арахис',2,32),
(7,'Столовая_вода',24,22),
(8,'Квас',3,130),
(9,'Чипсы',6,160),
(10,'Сухари_ржаные',24,160),
(11,'Арахис_в_шоколаде',6,320),
(12,'Семечки_жареные',9,125),
(13,'Подарочный_набор_приправ_1',24,650),
(14,'Подарочный_набор_приправ_2',24,1200),
(15,'Сёмга',1,1129),
(16,'Лосось',1,1699),
(17,'Вафли',2,180),
(18,'Торт',1,240),
(19,'Сироп_калиновый',2,300),
(20,'Сироп_малиновый',2,300);


insert into provider values
(1,'Крепкое_здоровье'),
(2,'Альфа_Групп'),
(3,'Кея'),
(4,'АКВА_КРИСТАЛЛ'),
(5,'Восточный_караван'),
(6,'Сём_Сёмыч'),
(7,'Викро'),
(8,'Русский_рыбный_мир'),
(9,'Брянконфи'),
(10,'Лесные_продукты');



insert into buyer values(1,'Кузьминов',50),
(2,'Бугаков',5),
(3,'Родин',10),
(4,'Васильев',12),
(5,'Семериков',7);



insert into payment_system values
(1,'QIWI'),
(2,'ЯндексДеньги'),
(3,'PerfectMoney'),
(4,'PayPal'),
(5,'Webmoney'),
(6,'WEX');



insert into product_provider values
(1,1,'21-09-2017'),
(2,1,'03-08-2017'),
(3,2,'24-09-2017'),
(4,2,'30-10-2017'),
(5,3,'24-08-2017'),
(6,3,'15-09-2017'),
(7,4,'30-10-2017'),
(8,4,'15-09-2017'),
(9,5,'30-08-2017'),
(10,5,'15-09-2017'),
(11,6,'24-10-2017'),
(12,6,'30-09-2017'),
(13,7,'24-08-2017'),
(14,7,'30-09-2017'),
(15,8,'15-08-2017'),
(16,8,'24-10-2017'),
(17,9,'30-08-2017'),
(18,9,'16-09-2017'),
(19,10,'30-09-2017'),
(20,10,'17-10-2017');




insert into purchase values
(1,1,3,'23-09-2017'),
(2,2,3,'05-07-2017'),
(3,5,2,'30-10-2017'),
(4,3,1,'13-09-2017'),
(5,4,3,'19-10-2017'),
(6,2,5,'18-09-2017'),
(7,4,2,'22-10-2017'),
(8,1,5,'25-09-2017'),
(9,2,1,'12-08-2017'),
(10,3,2,'17-09-2017'),
(11,2,1,'11-10-2017'),
(12,1,6,'02-09-2017'),
(13,3,5,'01-08-2017'),
(14,3,2,'09-09-2017'),
(15,4,6,'15-08-2017'),
(16,2,1,'09-10-2017'),
(17,5,1,'30-08-2017'),
(18,2,3,'16-09-2017'),
(19,1,6,'30-09-2017'),
(20,2,5,'08-10-2017'),
(1,3,1,'21-09-2017'),
(3,5,6,'21-10-2017'),
(5,2,2,'24-08-2017'),
(7,5,6,'26-09-2017'),
(9,2,2,'30-08-2017'),
(14,4,5,'27-10-2017'),
(15,5,1,'15-08-2017'),
(17,2,6,'30-09-2017'),
(18,4,3,'20-10-2017'),
(19,5,5,'13-08-2017'),
(20,2,6,'17-10-2017');




create or replace function buyer_month_count() returns void as
$$
declare
query text := 'create table buyer_month_count( buyer varchar(40) not NULL';
query1 text;
a record;
b integer := 1;
i integer := 1;
begin
drop table if exists buyer_month_count;
for i in 1..12 by 1
loop
query := query || ',month_'||i||' int';
end loop;
query := query || ');';
execute query;
for a in Select * from buyer
loop
INSERT INTO buyer_month_count(buyer) values(a.name);
end loop;
for a in Select * from buyer
loop
for b in 1..12 by 1
loop
query1 := 'update buyer_month_count set month_'||b|| ' =(select count(id_buyer) from purchase where EXTRACT(MONTH FROM data) = '||b|| ' and id_buyer ='||a.id||') where buyer_month_count.buyer='''||a.name||''';';
execute query1;
end loop;
end loop;
end;
$$
language plpgsql;



create or replace function provider_month_count() returns void as
$$
declare
query text := 'create table provider_month_count( provider varchar(40) not NULL';
query1 text;
a record;
b integer := 1;
i integer := 1;
begin
drop table if exists provider_month_count;
for i in 1..12 by 1
loop
query := query || ',month_'||i||' int';
end loop;
query := query || ');';
execute query;
for a in Select * from provider
loop
INSERT INTO provider_month_count(provider) values(a.name);
end loop;
for a in Select * from provider
loop
for b in 1..12 by 1
loop
query1 := 'update provider_month_count set month_'||b|| ' =(select count(id_provider) from product_provider where EXTRACT(MONTH FROM data) = '||b|| ' and id_provider ='||a.id||') where provider_month_count.provider='''||a.name||''';';
execute query1;
end loop;
end loop;
end;
$$
language plpgsql;



create or replace function pay_s_month_count() returns void as
$$
declare
query text := 'create table pay_s_month_count( payment_system varchar(40) not NULL';
query1 text;
a record;
b integer := 1;
i integer := 1;
begin
drop table if exists pay_s_month_count;
for i in 1..12 by 1
loop
query := query || ',month_'||i||' int';
end loop;
query := query || ');';
execute query;
for a in Select * from payment_system
loop
INSERT INTO pay_s_month_count(payment_system) values(a.name);
end loop;
for a in Select * from payment_system
loop
for b in 1..12 by 1
loop
query1 := 'update pay_s_month_count set month_'||b|| ' =(select count(id_pay_s) from purchase where EXTRACT(MONTH FROM data) = '||b|| ' and id_pay_s ='||a.id||') where pay_s_month_count.payment_system='''||a.name||''';';
execute query1;
end loop;
end loop;
end;
$$
language plpgsql;


create or replace function buyer_pay_s_count() returns void as
$$
declare
query text := 'create table buyer_pay_s_count( buyer varchar(40) not NULL';
query1 text;
query2 text;
a record;
z record;
b integer := 1;
i integer := 1;
begin
drop table if exists buyer_pay_s_count;
for a in Select * from payment_system
loop
    query2 :=a.name;
    query := query ||','|| query2 ||' varchar(40)';
end loop;
query := query || ');';
execute query;
for a in Select * from buyer
loop
    INSERT INTO buyer_pay_s_count(buyer) values(a.name);
end loop;
for a in Select * from buyer
loop
    for z in Select * from payment_system
    loop
        query2 :=z.name;
        query1 := 'update buyer_pay_s_count set '||query2||' =(select count(id_pay_s) from purchase where id_buyer ='||a.id|| 'and id_pay_s='||z.id||') where buyer_pay_s_count.buyer='''||a.name||''';';
        execute query1;
    end loop;
end loop;
end;
$$
language plpgsql;


create or replace function buyer_month_total_cost() returns void as
$$
declare
query text := 'create table buyer_month_total_cost( buyer varchar(40) not NULL';
query1 text;
a record;
b integer := 1;
i integer := 1;
begin
drop table if exists buyer_month_total_cost;
for i in 1..12 by 1
loop
query := query || ',month_'||i||' int';
end loop;
query := query || ');';
execute query;
for a in Select * from buyer
loop
INSERT INTO buyer_month_total_cost(buyer) values(a.name);
end loop;
for a in Select * from buyer
loop
for b in 1..12 by 1
loop
query1 := 'update buyer_month_total_cost set month_'||b|| ' =(select sum(product.cost*(100-buyer.discount)/100) from purchase,product,buyer where EXTRACT(MONTH FROM data) = '||b|| ' and id_buyer ='||a.id||' and product.id=purchase.id_product and buyer.id=purchase.id_buyer) where buyer_month_total_cost.buyer='''||a.name||''';';
execute query1;
end loop;
end loop;
end;
$$
language plpgsql;


create or replace function product_provider_count() returns void as
$$
declare
query text := 'create table product_provider_count( product varchar(40) not NULL';
query1 text;
query2 text;
a record;
z record;
b integer := 1;
i integer := 1;
begin
drop table if exists product_provider_count;
for a in Select * from provider
loop
    query2 :=a.name;
    query := query ||','|| query2 ||' varchar(40)';
end loop;
query := query || ');';
execute query;
for a in Select * from product
loop
    INSERT INTO product_provider_count(product) values(a.name);
end loop;
for a in Select * from product
loop
    for z in Select * from provider
    loop
        query2 :=z.name;
        query1 := 'update product_provider_count set '||query2||' =(select count(id_provider) from product_provider where id_product ='||a.id|| 'and id_provider='||z.id||') where product_provider_count.product='''||a.name||''';';
        execute query1;
    end loop;
end loop;
end;
$$
language plpgsql;
