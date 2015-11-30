SET foreign_key_checks = 0;
drop database if exists project;
create database project;
use project;
create table service_recipient
	(
		email 			varchar(40),
        name 			varchar(30),
        password		varchar(20),
        street_address 	varchar(25),
        city			varchar(20),
        state			varchar(15),
        zip				int,
        mobile			bigint(8),
        primary key (email)
    );
create table small_business
	(
		sm_id			varchar(10),
        email			varchar(40),
        password		varchar(20),
        street_address 	varchar(25),
        city			varchar(20),
        state			varchar(15),
        zip				int,
        mobile			bigint(8),
        name			varchar(30),
        activate		bool NOT NULL DEFAULT false ,
		primary key (sm_id, email)
    );
create table worker
	(
		worker_id		varchar(10),
        sm_id			varchar(10),
        password		varchar(20),
        name			varchar(30),
        primary key (worker_id, sm_id),
        foreign key (sm_id) references small_business(sm_id)
			on delete cascade
    );
create table schedule
	(
		slot_id			varchar(10),
        date			date,
		day				varchar(10),
        begin_time		int(4),
        end_time		int(4),
        primary key (slot_id)
    );
create table service
	(
        service_id 		varchar(10),
        name			varchar(20),
        description     varchar(40),
        primary key(service_id)
    );
create table worker_availability
	(
		worker_id		varchar(10),
        sm_id			varchar(10),
        service_id			varchar(10),
        primary key (sm_id, worker_id, service_id),
        foreign key (sm_id) references small_business(sm_id)
			on delete cascade,
		foreign key (worker_id) references worker(worker_id)
			on delete cascade,
		foreign key (service_id) references schedule(service_id)
			on delete cascade
    );
create table service_record
	(
		record_id			varchar(10),
        worker_id			varchar(10),
        sm_id				varchar(10),
        slot_id				varchar(10),
        service_id			varchar(10),
        service_recipient	varchar(40),
        service_status		varchar(10),
        rating				int(1),
        admin_review		boolean default false,
        primary key (record_id),
        foreign key (sm_id) references small_business(sm_id),
        foreign key (worker_id) references worker(worker_id),
        foreign key (slot_id) references schedule(slot_id),
        foreign key (service_id) references service(service_id),
        foreign key (service_recipient) references service_recipient(email)
    );
create table service_provider
	(
		worker_id			varchar(10),
        sm_id				varchar(10),
        service_id			varchar(10),
        primary key (sm_id, worker_id, service_id),
        foreign key (sm_id) references small_business(sm_id)
			on delete cascade,
		foreign key (worker_id) references worker(worker_id)
			on delete cascade,
		foreign key (service_id) references service(service_id)
			on delete cascade
    );
    

CREATE TABLE log (
  date DATETIME,
  user_id INT,
  worker_id INT,
  small_business_id INT,
  search_term VARCHAR(45),
  page_name VARCHAR(45),
  action VARCHAR(45),
  user_agent VARCHAR(255),
  ip_address VARCHAR(45),
  referrrer VARCHAR(45)
  );

create table small_business_review
	(
		sm_id			varchar(10),
        email			varchar(40),
        password		varchar(20),
        street_address 	varchar(25),
        city			varchar(20),
        state			varchar(15),
        zip				int,
        mobile			bigint(8),
        name			varchar(30),
		primary key (sm_id, email)
    );
create table small_business_activation_log

	(
		sm_id 			varchar(10),
        name			varchar(10),
        activate		bool,
        date			DATETIME
    );
    
create table admin
	(
		admin_id 		int,
        first_name		varchar(10),
        last_name 		varchar(10),
        password		varchar(10),
        primary key(admin_id)
    );
    

CREATE VIEW CONTRACTOR_LIST AS
	SELECT name, email, mobile, street_address, city, state, zip
    FROM small_business;

create table review_log 
	(
		name 			varchar(10),
        sm_id 			varchar(10),
        review 			varchar(200),
        approve_status 	bool NOT NULL DEFAULT false,
        date     		DATETIME,
        primary key(name),
        foreign key (sm_id) references small_business(sm_id)
    
    );

    
    
CREATE VIEW customer_public AS
	SELECT email, name, mobile
	FROM service_recipient;

create or replace view service_public as (select name, description from service);

create or replace view service_record_public as 
select rec.record_id, worker.name as Worker, sm.name as Business, sm.email as Business_email, slot.date as Date, service.name as Service, rec.service_status as Status, rec.rating as Rating, rec.service_recipient as customer
from worker worker, schedule slot, small_business sm, service service, service_record rec
where rec.worker_id = worker.worker_id AND rec.slot_id = slot.slot_id AND rec.sm_id = sm.sm_id AND rec.service_id = service.service_id;


DELIMITER '$';

CREATE PROCEDURE GetJobs(
	in id varchar(10))
BEGIN
	SELECT rec.record_id, w.worker_id, w.name as worker, ser.name as service, sch.date, sch.begin_time, sch.end_time, rec.service_status as status
    FROM service_record rec, worker w, service ser, schedule sch
    WHERE rec.sm_id = id AND rec.slot_id = sch.slot_id AND rec.worker_id = w.worker_id AND rec.service_id = ser.service_id AND rec.service_status = 'PENDING'
    ORDER BY rec.slot_id;
END

DELIMITER '$$$';
CREATE PROCEDURE GetAllJobs(
	in id varchar(10))
BEGIN
	SELECT rec.record_id, w.worker_id, w.name as worker, ser.name as service, sch.date, sch.begin_time, sch.end_time, rec.service_status as status
    FROM service_record rec, worker w, service ser, schedule sch
    WHERE rec.sm_id = id AND rec.slot_id = sch.slot_id AND rec.worker_id = w.worker_id AND rec.service_id = ser.service_id
    ORDER BY rec.slot_id;
END


DELIMITER '$$';
CREATE PROCEDURE GetRating(
	in worker_id varchar(10),
	in sm_id varchar(10),
    out worker_rating varchar(10))
BEGIN
	DECLARE avg_rating float;
    SELECT avgrating INTO avg_rating
    FROM (
		SELECT rec.sm_id, rec.worker_id, avg(rating) as avgrating
		FROM service_record rec 
		WHERE rec.sm_id = sm_id AND rec.worker_id = worker_id
		GROUP BY rec.sm_id, rec.worker_id ) as getRatings;
    IF (avg_rating > 4) THEN
SET worker_rating = 'EXCELLENT';
	ELSEIF (avg_rating > 3 AND avg_rating <= 4) THEN
SET worker_rating = 'GOOD';
	ELSEIF (avg_rating <= 3) THEN
SET worker_rating = 'AVERAGE';
	
    END IF;
    
END

DELIMITER //
CREATE PROCEDURE ActivateBusiness(IN id VARCHAR(10))

BEGIN
	
    UPDATE small_business SET activate = true where sm_id=id;
    INSERT into small_business_activation_log SELECT sm_id, name, activate, now() as date FROM small_business WHERE sm_id=id;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeactivateBusiness(IN id VARCHAR(10))

BEGIN

	UPDATE small_business SET activate = false where sm_id=id;
    INSERT into small_business_activation_log SELECT sm_id, name, activate, now() as date FROM small_business WHERE sm_id=id;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteService(IN serviceid VARCHAR(10))

BEGIN

	IF NOT EXISTS (SELECT service_id from service where service_id = serviceid) THEN	
	
			DELETE FROM service WHERE service_id = serviceid;
            
	END IF;
    
END //
DELIMITER ;

