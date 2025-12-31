
create table if not exists Sailors(
	sid int primary key,
	sname varchar(35) not null,
	rating float not null,
	age int not null
);

create table if not exists Boat(
	bid int primary key,
	bname varchar(35) not null,
	color varchar(25) not null
);

create table if not exists reserves(
	sid int not null,
	bid int not null,
	sdate date not null,
	foreign key (sid) references Sailors(sid) on delete cascade,
	foreign key (bid) references Boat(bid) on delete cascade
);

insert into Sailors values
(1,"Albert", 5.0, 40),
(2, "Nakul", 5.0, 49),
(3, "Darshan", 9, 18),
(4, "Astorm Gowda", 2, 68),
(5, "Armstormin", 7, 19);


insert into Boat values
(1,"Boat_1", "Green"),
(2,"Boat_2", "Red"),
(103,"Boat_3", "Blue");

insert into reserves values
(1,103,"2023-01-01"),
(1,2,"2023-02-01"),
(2,1,"2023-02-05"),
(3,2,"2023-03-06"),
(5,103,"2023-03-06"),
(1,1,"2023-03-06");


select b.color from Boat b,Sailors s,Reservers r 
where s.sid=r.sid and b.bid=r.bid and s.sname="albert";


select sid from Sailors where rating>=8
UNION
select sid from Reservers where bid=103;
-- or
select distinct s.sid from Sailors s,Reserves r where s.rating>=8 or r.bid=103 and s.sid=r.sid;


select s.sname from Sailors s where s.sid not in 
(select s.sid from Sailors s left join Reserves r where s.sid=r.sid) 
and s.sname like "%storm%";


-- Find the name of the sailors who have reserved all boats
select sname from Sailors s where not exists
	(select * from Boat b where not exists
		(select * from reserves r where r.sid=s.sid and b.bid=r.bid));



SELECT b.bid, AVG(s.age) AS avg_age
FROM Boat b
JOIN Reserves r ON b.bid = r.bid
JOIN Sailors s ON r.sid = s.sid
WHERE s.age >= 40
GROUP BY b.bid
HAVING COUNT(DISTINCT r.sid) >= 2;
-- or 
select b.bid,avg(s.age) from Boat b ,Sailors s , Reserves r 
where b.bid=r.bid and r.sid=s.sid and s.age>=40 
group by b.bid 
having count(distinct r.sid)>=2;



create view specificrating as
select b.bname,b.color from Boat b,Sailors s,Reserves r 
where b.bid=r.bid and s.sid=r.sid and s.rating=5;


create trigger newt
before delete on Boat
when old.bid in (select bid from Reserves)
begin
select raise(fail,"boat reserved cannot be deleted");
end;