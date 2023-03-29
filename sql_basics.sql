#Step 1 - Create a database
create database demo_exam;
use demo_exam;

#Step 2 - Create table
show tables;

create table check1 (
id varchar(10) unique not null primary key,
date_1 date,
date_2 datetime,
sal float(10),
roll int(10),
got_it bool);

create table check2 (
roll_id int(10) unique not null primary key,
name varchar(50),
country varchar(50) default 'India'
);

select * from check1;
select * from check2;

#Step 3 - Insert values in tables
insert into check1 values ('1a','2023-01-31','2023-01-31 09:30:00',1200,1,True);
insert into check1 values ('1b','2023-01-31','2023-01-31 09:45:00',1205,2,True),('1c','2023-01-31','2023-01-31 10:00:00',1203,3,True);
insert into check1 values ('1d','2023-01-31','2023-01-31 10:15:00',1204,4,True),('1e','2023-01-31','2023-01-31 10:30:00',1203,5,True);
insert into check1 values ('1f','2023-01-31','2023-01-31 10:45:00',1210,6,True),('1g','2023-01-31','2023-01-31 11:00:00',1205,7,True);
insert into check1 values ('1h','2023-01-31','2023-01-31 11:15:00',1209,8,True),('1i','2023-01-31','2023-01-31 11:30:00',1206,9,True);
insert into check1 values ('1j','2023-01-31','2023-01-31 11:45:00',1209,1,True),('1k','2023-01-31','2023-01-31 12:00:00',1206,3,True);

insert into check2 values(1,'Saffron','India'),(2,'Pink','India'),(3,'Brown','India'),(4,'Saffron','India'),(5,'Pink','India'),(6,'Saffron','India'),
(7,'Black','India'),(8,'White','India'),(9,'Blue','India');

#Step 4 - Update value in table
update check1 
set sal = 1205.05
where id = '1b';
select * from check1;

#Step 5 - Delete rows in a table 
delete from check1
where id = '1c';
select * from check1;

#Step 6 - Add a column 
alter table check1
add column low bool default True;
commit;
select * from check1;

#Step 7 - Change a column  
alter table check1
modify column low int(5) default 1;
commit;
select * from check1;
desc check1;

#Step 8 - Delete a column 
alter table check1
drop column low;
select * from check1;

#Step 9 - Use select statment to print 3rd last entry
Select * from check1
order by date_2 desc
limit 1 offset 2
;

#Step 10 - String functions
Select *,
upper(name) as name_in_uppercase,
lower(name) as name_in_lowercase,
length(name) as name_length,
substring(name,3,2) as name_3to4_char,
concat("'",name,"'") as name_in_quotes,
replace(name,'Pink','Green') as original_name,
now() as current_datetime
from check2;

#Step 11 - Aggregate functions
select count(*) as total_rows, sum(sal) total_price, avg(sal) as avg_price, max(sal) as max_price, min(sal) as min_price, round(sum(sal),1)
from check1;

#Step 12 - Math Operators
select sal+roll as add_col,
sal*roll as mul_col,
sal-roll as sub_col, 
sal/roll as div_col, 
sal%roll as mod_col
from check1;

#Step 13 - Joins - left/right/outer/inner, Group by and having clause
select  b.name,floor(avg(a.sal)) as avg_price from check1 a
left join check2 b 
on a.roll = b.roll_id
group by b.name
having floor(avg(a.sal)) > 1205
order by floor(avg(a.sal)) desc
limit 2;

#Step 14 - Extract function with date and time
select date_2,extract(year from date_2) as year_of_date2,
extract(month from date_2) as month_of_date2,
extract(day from date_2) as day_of_date2,
extract(hour from date_2) as hour_of_date2, 
extract(minute from date_2) as minute_of_date2, 
extract(second from date_2) as second_of_date2,
extract(quarter from date_2) as quarter_of_date2,
dayname(date_2) as weekday_of_date2
from check1;

#Step 15 - Joins - Left, right, inner, outer/full outer//full, self
select * from check1 a 
inner join check2 b
on a.roll = b.roll_id;

select * from check1 a 
left join check2 b
on a.roll = b.roll_id;

select * from check1 a 
right join check2 b
on a.roll = b.roll_id;

select * from check1 a 
left outer join check2 b
on a.roll = b.roll_id
union
select * from check1 a 
right outer join check2 b
on a.roll = b.roll_id;


select * from check1 a 
cross join check2 b
on a.roll = b.roll_id;

select * from check2 a 
join check2 b
on a.name = b.name;

#Step 16 - Union and Union all
select * from check1
union 
select * from check1;

select * from check1
union all
select * from check1;

select * from check1
intersect
select * from check1;

#Step 16 - Subquery
select * from check1
where roll in (select roll_id from check2 where lower(name) = 'Saffron');

select a.* from check1 a
where exists (select roll_id,country from check2 b where b.roll_id = a.roll and lower(name) = 'Pink');

#Step 17 - Windows function - aggregate over partition by, ranking over partition by, analytic over partition by
select b.name,
sum(ceiling(a.sal)) over (partition by b.name order by b.roll_id) as sum_price_by_name,
avg(ceiling(a.sal)) over (partition by b.name order by b.roll_id) as sum_price_by_name
from check1 a 
inner join check2 b
on a.roll = b.roll_id;

select *,
row_number() over (order by a.roll) as rownum_for_all_rows,
row_number() over (partition by b.name) as rownum_by_name,
rank() over (order by a.sal) as sal_rank,
dense_rank() over (order by a.sal) as sal_dense_rank,
percent_rank() over (order by a.sal) as sal_per_rank
from check1 a 
inner join check2 b
on a.roll = b.roll_id
order by b.name;

select *,
first_value(a.sal) over (partition by a.roll order by date_2) as 'first_entry_of_price',
last_value(a.sal) over (partition by a.roll order by date_2) as 'last_entry_of_price',
lead(a.date_2) over (order by a.roll) as 'next_value',
lag(a.date_2) over (order by a.roll) as 'prev_value',
lead(a.date_2,2) over (order by a.roll) as 'next2_value',
lag(a.date_2,2) over (order by a.roll) as 'prev2_value'
from check1 a 
inner join check2 b
on a.roll = b.roll_id;

#Step 18 - Case Statements or Case Expression
select *,case 
when sal < 1205 then 'a' else 'b' end as 'group'
from check1;

select *,case sal
when 1205 then 'a' else 'b' end as 'group'
from check1;

#Step 19 - CTE & Views
with res as (
select * from check1)
select a.* from res a
;

with res1 as (
select * from check1),
res2 as (
select * from check2)
select a.*,b.* from res1 a
inner join res2 b
on a.roll = b.roll_id;

create view v1 as select roll_id,name from check2;

select * from v1;

#Step 20 - Defining Foreign Key
alter table check1
add foreign key (`roll`) references `check2`(`roll_id`)
; 
desc check1;

drop database demo_exam;