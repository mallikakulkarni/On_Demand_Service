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
		service_id		varchar(10),
        name			varchar(20),
        primary key (service_id)
    );
create table worker_availability
	(
		worker_id		varchar(10),
        sm_id			varchar(10),
        slot_id			varchar(10),
        primary key (sm_id, worker_id, slot_id),
        foreign key (sm_id) references small_business(sm_id)
			on delete cascade,
		foreign key (worker_id) references worker(worker_id)
			on delete cascade,
		foreign key (slot_id) references schedule(slot_id)
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
		slot_id				varchar(10),
        sm_id				varchar(10),
        service_id			varchar(10),
        primary key (sm_id, worker_id, slot_id),
        foreign key (sm_id) references small_business(sm_id)
			on delete cascade,
		foreign key (worker_id) references worker(worker_id)
			on delete cascade,
		foreign key (slot_id) references service(service_id)
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
  referrrer VARCHAR(45));

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
    
CREATE VIEW customer_public AS
	SELECT email, name, mobile
	FROM service_recipient



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


