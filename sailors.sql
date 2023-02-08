use sailors;
create table sailor(
sid int,
sname varchar(30),
rating int,
age int,
PRIMARY KEY(sid)
);

create table boat(
bid int,
bname varchar(20),
color char(10),
PRIMARY KEY(bid)
);


create table if not exists rservers(
sid int,
bid int,
dates date,
FOREIGN KEY(sid) REFERENCES sailor(sid) ON DELETE CASCADE,
FOREIGN KEY(bid) REFERENCES boat(bid) ON DELETE CASCADE
);
insert into sailor values
(1,"Albert",8,30),
(2,"Shivam",5,40),
(3,"Test",7,50);
insert into sailor values (4, "Astorm Gowda", 3, 68);

insert into boat values
(101,"Boat","Green"),
(102,"Storm","Red"),
(103,"Fire","Black");

insert into rservers values
(1,101,"2022-01-01"),
(3,103,"2023-01-01"),
(2,102,"2019-01-01");

insert into rservers values(1,102,"2022-02-03");
insert into rservers values(1,103,"2022-03-02");

select * from sailor;
select * from boat;
select * from rservers;

#Find the colours of boats reserved by Albert
select sailor.sname,boat.color from sailor,boat,rservers where boat.bid=rservers.bid and sailor.sid=rservers.sid and sailor.sname="Albert";

update sailor set rating=9 where sid=3; 

#Find all sailor id’s of sailors who have a rating of at least 8 or reserved boat 103
(select sid
from sailor
where rating>=8)
UNION
(select sid
from rservers
where bid=103);

#Find the names of sailors who have not reserved a boat whose name contains the string
#“storm”. Order the names in ascending order.
select s.sname
from sailor s
where s.sid not in 
(select s1.sid from sailor s1, rservers r1 where r1.sid=s1.sid)
and s.sname like "%storm%"
order by s.sname ASC;


#Find the names of sailors who have reserved all boats.
select sname from sailor where not exists (select * from boat b where not exists (select * from rservers r where r.sid=sailor.sid and b.bid=r.bid));
select s.sname from sailor s,rservers r where s.sid=r.sid group by s.sname having count(r.sid)=3;

#Find the name and age of the oldest sailor.
select sname,age from sailor where age =(select max(age) from sailor);

#For each boat which was reserved by at least 5 sailors with age >= 40, find the boat id and
#the average age of such sailors.
select b.bid,avg(s.age) from sailor s,boat b,rservers r where r.sid=s.sid and r.bid=b.bid and s.age>=40 group by bid having count(distinct (r.sid))>=1; 


-- Create a view that shows the names and colours of all the boats that have been reserved by a sailor with a specific rating.

create or replace view ReservedBoatsWithRatedSailor as
select distinct b.bname, b.color
from Sailor s, Boat b, rservers r
where s.sid=r.sid and b.bid=r.bid and s.rating=8;

select * from ReservedBoatsWithRatedSailor;

#trigger
DELIMITER //
create trigger t2
before delete on boat
for each row
BEGIN
	IF EXISTS (select * from rservers where rservers.bid=old.bid) THEN
		SIGNAL SQLSTATE '45000' SET message_text='Boat is reserved and hence cannot be deleted';
	END IF;
END;//

DELIMITER ;

drop trigger t1;
delete from boat where bid=101;



