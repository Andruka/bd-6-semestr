CREATE USER admin WITH password '12345';
ALTER USER admin WITH SUPERUSER;
ALTER USER admin WITH CREATEDB;
ALTER USER admin WITH CREATEROLE;
CREATE USER kuzminov WITH password '54321';
CREATE USER bugakov WITH password '54321';
CREATE USER lifanov WITH password '54321';
CREATE USER kirillov WITH password '54321';
CREATE USER korotkov WITH password '54321';
CREATE USER kruglova WITH password 'qwert';
CREATE USER kalinina WITH password 'qwert';
CREATE USER baturina WITH password 'qwert';
CREATE USER lipatova WITH password 'qwert';
CREATE database school;
create group pupils;
create group teathers;
ALTER GROUP pupils ADD USER kuzminov, bugakov, lifanov, kirillov, korotkov;
ALTER GROUP teathers ADD USER kruglova, kalinina, baturina, lipatova;



