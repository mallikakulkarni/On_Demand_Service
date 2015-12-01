use project;

select * from service_record;
select * from schedule;
select * from worker_availability;
select * from service;
select * from service_recipient;
select * from worker;
select * from small_business;


alter table service_record add admin_review boolean;
alter table service_record drop admin_review;

alter table service_record add admin_review boolean default false;
desc service_record;

DROP PROCEDURE getJobs;
DROP PROCEDURE getRating;
CALL getJobs('61171436');
CALL getRating('123456', '58934997', @worker_rating);SELECT @worker_rating;
SET @worker_rating = ""; CALL getRating("123456", "61171436", @worker_rating);SELECT @worker_rating;

insert into small_business values ('58934997', 'abc@uber.com', 'password', '1 Infinite Loop', 'San Jose', 'CA', 95129, 4085551234, 'XYZ');

insert into service values ('1', 'Cleaning');

insert into schedule values ('1', now(), 'Saturday', 0800, 1159);
insert into schedule values ('2', now(), 'Saturday', 1200, 1559);
insert into schedule values ('3', now(), 'Saturday', 1600, 1959);
insert into schedule values ('4', now(), 'Saturday', 2000, 2359);
insert into schedule values ('5', now()+2, 'Saturday', 2000, 2359);

select * from schedule where slot_id in (select slot_id from worker_availability where sm_id = '58934997' AND slot_id in (select slot_id from schedule where date between now()+1 AND now()+7));

insert into worker_availability values ('123456', '58934997', '1', '5');
insert into worker_availability values ('900', '58934997', '2', '5');

drop table worker_availability;
insert into worker values ('123456', '58934997', 'secret', 'John Deer');
insert into worker values ('900', '58934997', 'secret', 'Bill Weasley');
insert into service_provider values ('900', '58934997', '2');

insert into service_record values ('1', '123456', '58934997', '1', '1', 's@g.com', 'PENDING', null);
insert into service_record values ('2', '123456', '58934997', '2', '1', 's@g.com', 'PENDING', 1);
insert into service_record values ('3', '123456', '58934997', '3', '1', 's@g.com', 'FINISHED', 4);
insert into service_record values ('4', '123456', '58934997', '4', '1', 's@g.com', 'PAID', 3);
insert into service_record values ('5', '890', '1', '4', '1', 's@g.com', 'PAID', NULL, false);
insert into service_record values ('6', '890', '1', '4', '1', 's@g.com', 'PAID', NULL, false);

update service_record set rating = null where record_id = '2';

insert into service_recipient values ('s@g.com', 'Harry Potter', 'secret', '1 Washington Square', 'San Jose', 'CA', 95129, 4085551555);

select * from getRating;

drop view cutomer_public;
update worker set worker_id = '1' where name = 'Jane Doe';
delete from worker where name = 'Jane Doe';
select * from customer_public;

select distinct sm_id from service_provider where service_id = (select service_id from service where name = 'Nanny Services');

SELECT sm_id, name, email, mobile, street_address, city, state, zip FROM small_business where city = 'San Jose' AND sm_id IN ('58934997');

select * from service_record_public;

select * from service_record;

update service_record set rating = NULL where service_status != 'PENDING';

select * from service_record_public where status != 'PENDING' AND rating IS NULL AND customer = "s@g.com";


select * 
from schedule 
where slot_id in 
	(select slot_id from worker_availability where sm_id = '58934997' AND worker_id in 
    (select worker_id from service_provider where sm_id = '58934997' AND service_id = '1'
	having count(worker_id) = (select count(worker_id) from service_provider where sm_id = '58934997' AND service_id = '1')))
    AND slot_id in (select slot_id from schedule where date between NOW()+1 AND NOW()+7);


select worker_id from worker_availability where worker_id in
(select worker_id from service_provider where sm_id = '58934997' AND service_id = '2' )
having count(worker_id) = (select count(worker_id) from service_provider where sm_id = '58934997' AND service_id = '2');


select count(worker_id) from service_provider where sm_id = '58934997' AND service_id = '2';

select distinct sm_id from service_provider where service_id = (select service_id from service where name = "Nanny Services");

select * from schedule;


select * from worker where worker_id in 
	(select worker_id from service_provider 
	where sm_id = '58934997' AND 
    service_id = (select service_id from service where name = 'Cleaning'))
    AND NOT EXISTS 
		(select * from worker_availability 
		where sm_id = '58934997' AND slot_id in (select slot_id from schedule where date = STR_TO_DATE('11/30/2015', '%m/%d/%Y') AND begin_time = 2000 AND end_time = 2359) AND worker_id = worker.worker_id);

select slot_id from schedule where date = STR_TO_DATE('11/30/2015', '%m/%d/%Y') AND begin_time = 2000 AND end_time = 2359;

select now() from small_business;

update schedule set date = now() where slot_id = '5';

update service_record set rating = NULL where service_status <> 'Pending';
select * from schedule;
