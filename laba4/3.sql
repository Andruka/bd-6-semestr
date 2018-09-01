\connect school
create or replace function pupil_mark() returns table(data date,lesson varchar(40) ,mark int ) as
$code$
declare
begin
return query select pupil_performance.data, lessons.name, pupil_performance.mark from pupil_performance , lessons, pupils where  lessons.id=pupil_performance.lesson and pupil_performance.pupil=pupils.id and pupils.login=(select session_user);
end;
$code$
language plpgsql
SECURITY DEFINER;

create or replace function pupil_homework() returns table(data date,lesson varchar(40),class varchar(4),homework varchar(60) ) as
$code$
begin
  return query select homework.data, lessons.name , class.name, homework.homework from homework , lessons,class, pupils where lessons.id=homework.lesson and class.id=homework.class and class.id=pupils.class and pupils.login=(select session_user);
end;
$code$
language plpgsql
SECURITY DEFINER;

create or replace function teather_mark() returns table(data date,lesson varchar(40),	class varchar(4),mark int, pupil varchar(40)) as
$code$
begin
    return query select pupil_performance.data, lessons.name, class.name ,pupil_performance.mark, pupils.name from pupil_performance , lessons , pupils, class ,teathers where  lessons.id=pupil_performance.lesson and pupils.id=pupil_performance.pupil and class.id=pupil_performance.class and lessons.teather=teathers.id and teathers.login=(select session_user) ;
end;
$code$
language plpgsql
SECURITY DEFINER;


create or replace function teather_homework() returns table(data date,lesson varchar(40), class varchar(4),homework varchar(40)) as
$code$
begin
   return query select homework.data, lessons.name, class.name ,homework.homework from homework , lessons , class, teathers where  lessons.id=homework.lesson and class.id=homework.class and lessons.teather=teathers.id and teathers.login=(select session_user) ;
end;
$code$
language plpgsql
SECURITY DEFINER;

create or replace function teather_show_class(cl varchar) returns table(name varchar(40),middle numeric) as
$code$
begin
   return query select pupils.name,AVG(pupil_performance.mark) from pupils, class, pupil_performance, lessons, teathers where class.name=cl and class.id=pupils.class and pupil_performance.pupil=pupils.id and lessons.teather=teathers.id and teathers.login=(select session_user) group by pupils.name;
end;
$code$
language plpgsql
SECURITY DEFINER;

GRANT ALL ON DATABASE school TO pupils, teathers;
GRANT UPDATE,INSERT ON homework,pupil_performance TO teathers;
GRANT EXECUTE ON function teather_mark() TO teathers;
REVOKE EXECUTE ON function teather_mark() FROM PUBLIC;
GRANT EXECUTE ON function teather_homework() TO teathers;
REVOKE EXECUTE ON function teather_homework() FROM PUBLIC;
GRANT EXECUTE ON function pupil_mark() TO pupils;
REVOKE EXECUTE ON function pupil_mark() FROM PUBLIC;
GRANT EXECUTE ON function pupil_homework() TO pupils;
REVOKE EXECUTE ON function pupil_homework() FROM PUBLIC;
GRANT EXECUTE ON function teather_show_class(cl varchar) TO teathers;
REVOKE EXECUTE ON function teather_show_class(cl varchar) FROM PUBLIC;
