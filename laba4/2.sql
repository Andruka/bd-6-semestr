\connect school
------------------создание----------------------------
create table teathers ( 
	id int primary key,
	name varchar(40),
	login varchar(40)
); 

create table lessons ( 
	id int primary key , 
	name varchar(40) ,
	teather int,

	foreign key (teather) references teathers(id) on delete cascade on update cascade
);

create table class (  
	id int primary key, 
	name varchar(4) 
); 

create table pupils ( 
	id int primary key,
	class int , 
	name varchar(40),
	login varchar(40),
	
	foreign key (class) references class(id) on delete cascade on update cascade
); 

create table pupil_performance ( 
	data date not NULL,
	lesson int not NULL,
	class int not NULL,
	mark int not NULL,
	pupil  int,
	
	foreign key (pupil) references pupils(id) on delete cascade on update cascade,
	foreign key (class) references class(id) on delete cascade on update cascade,
	foreign key (lesson) references lessons(id) on delete cascade on update cascade
);

create table homework ( 
	data date not NULL, 
	lesson int not NULL,
	class int not NULL,
	homework varchar(60),
	
	foreign key (lesson) references lessons(id) on delete cascade on update cascade,
	foreign key (class) references class(id) on delete cascade on update cascade
);


------------------инициализация------------------------

INSERT INTO class values
(1, '11А'),
(2, '10А'),
(3, '9В'),
(4, '11Б');

INSERT INTO pupils values
(1, '1', 'Кузьминов Андрей','kuzminov'),
(2, '1', 'Бугаков Никита','bugakov'),
(3, '2', 'Лифанов Андрей','lifanov'),
(4, '3', 'Кириллов Дмитрий','kirillov'),
(5, '4', 'Коротков Илья','korotkov');

INSERT INTO teathers values
(1, 'Круглова Ольга Дмитриевна','kruglova'),
(2,'Калинина Тамара Васильевна','kalinina'),
(3, 'Батурина Наталья Васильевна','baturina'),
(4, 'Липатова Татьяна Анатольевна','lipatova');

INSERT INTO lessons values
(1, 'Математика','1'),
(2, 'Русский язык', '2'),
(3, 'Химия', '3'),
(4, 'Физика','4');

INSERT INTO pupil_performance values
('02.09.2017', '1', '1', '5', '1'),
('02.09.2017', '1', '1', '3', '2'),
('05.09.2017', '1', '2', '2', '3'),
('11.09.2017', '1', '3', '5', '4'),
('11.09.2017', '1', '4', '4', '5'),
('16.09.2017', '2', '1', '4', '1'),
('16.09.2017', '2', '1', '4', '2'),
('18.09.2017', '2', '2', '3', '3'),
('19.09.2017', '2', '3', '5', '4'),
('21.09.2017', '2', '4', '3', '5'),
('01.10.2017', '3', '1', '5', '1'),
('01.10.2017', '3', '1', '4', '2'),
('08.10.2017', '3', '2', '2', '3'),
('17.10.2017', '3', '3', '5', '4'),
('22.10.2017', '3', '4', '4', '5'),
('02.11.2017', '4', '1', '4', '1'),
('02.11.2017', '4', '1', '4', '2'),
('05.11.2017', '4', '2', '3', '3'),
('14.11.2017', '4', '3', '5', '4'),
('20.11.2017', '4', '4', '4', '5');

INSERT INTO homework values
('01.09.2017', '1', '1', 'стр.5 № 3,4'),
('02.09.2017', '2', '1', 'стр.3 упр.1'),
('03.09.2017', '3', '1', 'параграф 2,3 выучить'),
('04.09.2017', '4', '1', 'вопросы после параграфа №1'),
('02.09.2017', '1', '2', 'стр.2 № 1-3'),
('03.09.2017', '2', '2', 'стр.3-4 выучить правила'),
('04.09.2017', '3', '2', 'параграф 1-3 выучить основные определения'),
('05.09.2017', '4', '2', 'разобрать параграфы 2-4'),
('03.09.2017', '1', '3', 'стр.4 № 2-5'),
('04.09.2017', '2', '3', 'стр.3-4 выучить правила'),
('05.09.2017', '3', '3', 'параграф 2-3 разобрать и выучить'),
('01.09.2017', '4', '3', 'подготовиться к л/р №1'),
('05.09.2017', '1', '4', 'стр.3-5 разобрать примеры'),
('01.09.2017', '2', '4', 'стр. 5 упр. 2,3'),
('03.09.2017', '3', '4', 'вопросы после параграфа №2'),
('04.09.2017', '4', '4', 'подготовиться к л/р №1');

