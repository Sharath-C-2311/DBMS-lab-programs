select COUNT(driver_id)
from participated p, accident a
where p.report_no=a.report_no and a.accident_date like "2021%";


select count(distinct report_no)
from Participated
where driver_id = (select driver_id from Person where driver_name = "Smith");


delete from car where model="Mazda" and reg_no in 
(select o.reg_no from Owns o,Person p where o.driver_id=p.driver_id and p.driver_name="Smith");


update Participated set damage_amount = 30000 where reg_no="KA-09-MA-1234";

create view modelandyear as
select model,c_year from Car;


-- A trigger that prevents a driver from participating in more than 2 accidents in a given year.

CREATE TRIGGER prevent
BEFORE INSERT ON Participated
WHEN (SELECT COUNT(*) FROM Participated WHERE driver_id = NEW.driver_id) >= 2
BEGIN
  SELECT RAISE(FAIL, 'Driver already involved in more than 2 accidents');
END;

--or

DELIMITER //
create trigger PreventParticipation
before insert on participated
for each row
BEGIN
	IF 2<=(select count(*) from participated where driver_id=new.driver_id) THEN
		signal sqlstate '45000' set message_text='Driver has already participated in 2 accidents';
	END IF;
END;//
DELIMITER ;
