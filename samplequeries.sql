use project;

select * from service_record;
select * from service;
select * from service_recipient;
select * from worker;
select * from small_business;
select * from schedule;

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

insert into worker values ('123456', '58934997', 'secret', 'John Deer');

insert into service_record values ('1', '123456', '58934997', '1', '1', 's@g.com', 'PENDING', null);
insert into service_record values ('2', '123456', '58934997', '2', '1', 's@g.com', 'PENDING', 1);
insert into service_record values ('3', '123456', '58934997', '3', '1', 's@g.com', 'FINISHED', 4);
insert into service_record values ('4', '123456', '58934997', '4', '1', 's@g.com', 'PAID', 3);

update service_record set rating = null where record_id = '2';

insert into service_recipient values ('s@g.com', 'Harry Potter', 'secret', '1 Washington Square', 'San Jose', 'CA', 95129, 4085551555);


select * from getRating;

drop view cutomer_public;

