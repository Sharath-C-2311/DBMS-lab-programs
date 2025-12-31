create table Student (
  regno varchar(10) primary key,
  name varchar(30),
  major varchar(30),
  bdate date
);

create table Course(
  course int primary key,
  cname varchar(30),
dept varchar(40)

);

create table Enroll(
  regno varchar(10),
  course int,
  sem int,
  marks int,
  foreign key(regno) references Student(regno) on delete cascade,
  foreign key(course) references Course(course) on delete cascade
);

create table Text_book (
  book_isbn int primary key,
  book_t varchar(40),
  publisher varchar(40),
  author varchar(40)
);

create table Book_ad(
  course int,
  sem int,
  book_isbn int,
  foreign key(book_isbn) references Text_book(book_isbn) on delete cascade,
  foreign key(course) references Course(course) on delete cascade,
);


INSERT INTO Student VALUES
('S001','Alice','CS','2002-05-12'),
('S002','Bob','CS','2001-11-23'),
('S003','Charlie','EE','2000-07-09'),
('S004','Diana','ME','2002-01-30');

INSERT INTO Course VALUES
(101,'DBMS','CS'),
(102,'Algorithms','CS'),
(103,'Circuits','EE'),
(104,'Thermodynamics','ME');

INSERT INTO Enroll VALUES
('S001',101,1,85),
('S002',101,1,92),
('S003',103,2,78),
('S004',104,2,88),
('S001',102,1,70),
('S002',102,1,65);


INSERT INTO Text_book VALUES
(111,'Database Concepts','Pearson','Elmasri'),
(112,'Advanced DBMS','McGrawHill','Ramakrishnan'),
(113,'Algorithms Design','Pearson','Kleinberg'),
(114,'Circuits Fundamentals','Wiley','Hayt'),
(115,'Thermo Engineering','Pearson','Cengel'),
(116,'CS Handbook','Pearson','Knuth');


INSERT INTO Book_ad VALUES
(101,1,111),
(101,1,112),
(101,1,116),   -- DBMS has 3 books
(102,1,113),
(103,2,114),
(104,2,115);



-- 1
INSERT INTO Text_book VALUES (117,'AI Basics','Springer','Russell');

INSERT INTO Book_ad VALUES (102,1,117);  -- Adopted by CS dept for Algorithms

-- 2
SELECT c.course, b.book_isbn, t.book_t
FROM Course c
JOIN Book_ad b ON c.course = b.course
JOIN Text_book t ON b.book_isbn = t.book_isbn
WHERE c.dept = 'CS'
  AND c.course IN (
      SELECT course
      FROM Book_ad
      GROUP BY course
      HAVING COUNT(book_isbn) > 2
  )
ORDER BY t.book_t;


-- 3
SELECT c.dept
FROM Course c
JOIN Book_ad b ON c.course = b.course
JOIN Text_book t ON b.book_isbn = t.book_isbn
GROUP BY c.dept
HAVING COUNT(DISTINCT t.publisher) = 1;

-- 4
select regno,max(marks) from Enroll where course = (select course from Course where cname='DBMS');


-- 5
create view markslist as
select s.regno,s.name,c.cname,e.marks from 
Student s join Enroll e on s.regno=e.regno
join Course c on c.course=e.course;  


-- 6
create trigger prevent_enroll
before insert on Enroll
when new.marks < 40
begin 
select raise(fail,'your marks less than 40 cannot enroll');
end;

