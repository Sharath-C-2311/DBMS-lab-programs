create table if not exists Employee(
	ssn varchar(35) primary key,
	name varchar(35) not null,
	address varchar(255) not null,
	sex varchar(7) not null,
	salary int not null,
	super_ssn varchar(35),
	d_no int,
	foreign key (super_ssn) references Employee(ssn) on delete set null
);

create table if not exists Department(
	d_no int primary key,
	dname varchar(100) not null,
	mgr_ssn varchar(35),
	mgr_start_date date,
	foreign key (mgr_ssn) references Employee(ssn) on delete cascade
);

create table if not exists DLocation(
	d_no int not null,
	d_loc varchar(100) not null,
	foreign key (d_no) references Department(d_no) on delete cascade
);

create table if not exists Project(
	p_no int primary key,
	p_name varchar(25) not null,
	p_loc varchar(25) not null,
	d_no int not null,
	foreign key (d_no) references Department(d_no) on delete cascade
);

create table if not exists WorksOn(
	ssn varchar(35) not null,
	p_no int not null,
	hours int not null default 0,
	foreign key (ssn) references Employee(ssn) on delete cascade,
	foreign key (p_no) references Project(p_no) on delete cascade
);

INSERT INTO Employee VALUES
("01NB235", "Chandan_Krishna","Siddartha Nagar, Mysuru", "Male", 1500000, "01NB235", 5),
("01NB354", "Employee_2", "Lakshmipuram, Mysuru", "Female", 1200000,"01NB235", 2),
("02NB254", "Employee_3", "Pune, Maharashtra", "Male", 1000000,"01NB235", 4),
("03NB653", "Employee_4", "Hyderabad, Telangana", "Male", 2500000, "01NB354", 5),
("04NB234", "Employee_5", "JP Nagar, Bengaluru", "Female", 1700000, "01NB354", 1);


INSERT INTO Department VALUES
(001, "Human Resources", "01NB235", "2020-10-21"),
(002, "Quality Assesment", "03NB653", "2020-10-19"),
(003,"System assesment","04NB234","2020-10-27"),
(005,"Production","02NB254","2020-08-16"),
(004,"Accounts","01NB354","2020-09-4");


INSERT INTO DLocation VALUES
(001, "Jaynagar, Bengaluru"),
(002, "Vijaynagar, Mysuru"),
(003, "Chennai, Tamil Nadu"),
(004, "Mumbai, Maharashtra"),
(005, "Kuvempunagar, Mysuru");

INSERT INTO Project VALUES
(241563, "System Testing", "Mumbai, Maharashtra", 004),
(532678, "IOT", "JP Nagar, Bengaluru", 001),
(453723, "Product Optimization", "Hyderabad, Telangana", 005),
(278345, "Yeild Increase", "Kuvempunagar, Mysuru", 005),
(426784, "Product Refinement", "Saraswatipuram, Mysuru", 002);

INSERT INTO WorksOn VALUES
("01NB235", 278345, 5),
("01NB354", 426784, 6),
("04NB234", 532678, 3),
("02NB254", 241563, 3),
("03NB653", 453723, 6);

--1
select w.p_no from WorksOn w,Employee e where e.ssn=w.ssn and e.name like "%Scott%";
-- confusion between these two queries
select p_no,p_name,name from Project p, Employee e where p.d_no=e.d_no and e.name like "%Scott%";


--2
select e.name,e.salary as old_salary,1.1*e.salary as new_salary 
from Employee e,WorksOn w where e.ssn=w.ssn 
and w.p_no=(select p_no from Project where p_name="IOT");


-- 3
select sum(salary),max(salary),min(salary),avg(salary) 
from Employee 
where d_no=(select d_no from Department where dname="Accounts");


-- 4
-- Retrieve the name of each employee who works on all the projects controlled by department number 1 (use NOT EXISTS operator).
select Employee.ssn,name,d_no from Employee where not exists
    (select p_no from Project p where p.d_no=1 and p_no not in
    	(select p_no from WorksOn w where w.ssn=Employee.ssn));


-- 5
select d.d_no,count(*) from Department d 
join Employee e on e.d_no=d.d_no 
group by d.d_no 
having e.salary>600000 and count(e.ssn) > 1;
-- or
select d.d_no, count(*) from Department d 
join Employee e on e.d_no=d.d_no 
where salary>600000 
group by d.d_no 
having count(*) >1;


-- 6
create view Emp_details as
select e.name,d.dname,e.address from Employee e,Department d where e.d_no=d.d_no;


--7
create trigger prevent_deletion
before delete on Project
for each row
begin
if exists (select p_no from WorksOn where p_no=old.p_no) then
signal sqlstate "45000" set message_text="project not yet completed so you cannot delete";
end if;
end;

-- or

create trigger prevent_deletion
before delete on Project
when old.p_no in (select p_no from WorksOn)
begin
select raise(fail,"project not yet completed so you cannot delete");
end;