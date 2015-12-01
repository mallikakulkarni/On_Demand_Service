-- MySQL dump 10.13  Distrib 5.6.27, for osx10.11 (x86_64)
--
-- Host: localhost    Database: project
-- ------------------------------------------------------
-- Server version	5.6.27

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL DEFAULT '0',
  `first_name` varchar(10) DEFAULT NULL,
  `last_name` varchar(10) DEFAULT NULL,
  `password` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'Mallika','Kulkarni','abc');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `contractor_list`
--

DROP TABLE IF EXISTS `contractor_list`;
/*!50001 DROP VIEW IF EXISTS `contractor_list`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `contractor_list` AS SELECT 
 1 AS `name`,
 1 AS `email`,
 1 AS `mobile`,
 1 AS `street_address`,
 1 AS `city`,
 1 AS `state`,
 1 AS `zip`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `customer_public`
--

DROP TABLE IF EXISTS `customer_public`;
/*!50001 DROP VIEW IF EXISTS `customer_public`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `customer_public` AS SELECT 
 1 AS `email`,
 1 AS `name`,
 1 AS `mobile`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `worker_id` int(11) DEFAULT NULL,
  `small_business_id` int(11) DEFAULT NULL,
  `search_term` varchar(45) DEFAULT NULL,
  `page_name` varchar(45) DEFAULT NULL,
  `action` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `referrrer` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule` (
  `slot_id` varchar(10) NOT NULL DEFAULT '',
  `date` date DEFAULT NULL,
  `day` varchar(10) DEFAULT NULL,
  `begin_time` int(4) DEFAULT NULL,
  `end_time` int(4) DEFAULT NULL,
  PRIMARY KEY (`slot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES ('1','2015-11-27','Saturday',800,1159),('2','2015-11-27','Saturday',1200,1559),('3','2015-11-27','Saturday',1600,1959),('4','2015-11-27','Saturday',2000,2359),('5','2015-11-30','Saturday',2000,2359);
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service` (
  `service_id` varchar(10) NOT NULL DEFAULT '',
  `name` varchar(20) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES ('1','Cleaning','Cleaning'),('2','Nanny Services','Nanny');
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_provider`
--

DROP TABLE IF EXISTS `service_provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_provider` (
  `worker_id` varchar(10) NOT NULL DEFAULT '',
  `sm_id` varchar(10) NOT NULL DEFAULT '',
  `service_id` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`sm_id`,`worker_id`,`service_id`),
  KEY `worker_id` (`worker_id`),
  KEY `service_id` (`service_id`),
  CONSTRAINT `service_provider_ibfk_1` FOREIGN KEY (`sm_id`) REFERENCES `small_business` (`sm_id`) ON DELETE CASCADE,
  CONSTRAINT `service_provider_ibfk_2` FOREIGN KEY (`worker_id`) REFERENCES `worker` (`worker_id`) ON DELETE CASCADE,
  CONSTRAINT `service_provider_ibfk_3` FOREIGN KEY (`service_id`) REFERENCES `service` (`service_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_provider`
--

LOCK TABLES `service_provider` WRITE;
/*!40000 ALTER TABLE `service_provider` DISABLE KEYS */;
INSERT INTO `service_provider` VALUES ('123','1','2'),('123456','58934997','1'),('123456','58934997','2'),('890','1','2'),('900','58934997','2');
/*!40000 ALTER TABLE `service_provider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `service_public`
--

DROP TABLE IF EXISTS `service_public`;
/*!50001 DROP VIEW IF EXISTS `service_public`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `service_public` AS SELECT 
 1 AS `name`,
 1 AS `description`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `service_recipient`
--

DROP TABLE IF EXISTS `service_recipient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_recipient` (
  `email` varchar(40) NOT NULL DEFAULT '',
  `name` varchar(30) DEFAULT NULL,
  `password` varchar(20) DEFAULT NULL,
  `street_address` varchar(25) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `zip` int(11) DEFAULT NULL,
  `mobile` bigint(8) DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_recipient`
--

LOCK TABLES `service_recipient` WRITE;
/*!40000 ALTER TABLE `service_recipient` DISABLE KEYS */;
INSERT INTO `service_recipient` VALUES ('s@g.com','Harry Potter','secret','1 Washington Square','San Jose','CA',95129,4085551555);
/*!40000 ALTER TABLE `service_recipient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_record`
--

DROP TABLE IF EXISTS `service_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_record` (
  `record_id` varchar(10) NOT NULL DEFAULT '',
  `worker_id` varchar(10) DEFAULT NULL,
  `sm_id` varchar(10) DEFAULT NULL,
  `slot_id` varchar(10) DEFAULT NULL,
  `service_id` varchar(10) DEFAULT NULL,
  `service_recipient` varchar(40) DEFAULT NULL,
  `service_status` varchar(10) DEFAULT NULL,
  `rating` int(1) DEFAULT NULL,
  `admin_review` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`record_id`),
  KEY `sm_id` (`sm_id`),
  KEY `worker_id` (`worker_id`),
  KEY `slot_id` (`slot_id`),
  KEY `service_id` (`service_id`),
  KEY `service_recipient` (`service_recipient`),
  CONSTRAINT `service_record_ibfk_1` FOREIGN KEY (`sm_id`) REFERENCES `small_business` (`sm_id`),
  CONSTRAINT `service_record_ibfk_2` FOREIGN KEY (`worker_id`) REFERENCES `worker` (`worker_id`),
  CONSTRAINT `service_record_ibfk_3` FOREIGN KEY (`slot_id`) REFERENCES `schedule` (`slot_id`),
  CONSTRAINT `service_record_ibfk_4` FOREIGN KEY (`service_id`) REFERENCES `service` (`service_id`),
  CONSTRAINT `service_record_ibfk_5` FOREIGN KEY (`service_recipient`) REFERENCES `service_recipient` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_record`
--

LOCK TABLES `service_record` WRITE;
/*!40000 ALTER TABLE `service_record` DISABLE KEYS */;
INSERT INTO `service_record` VALUES ('1','123456','58934997','1','1','s@g.com','PENDING',NULL,0),('2','123456','58934997','2','1','s@g.com','PENDING',1,0),('3','123456','58934997','3','1','s@g.com','FINISHED',NULL,0),('4','123456','58934997','4','1','s@g.com','PAID',NULL,0),('5','890','1','4','1','s@g.com','PAID',NULL,0),('6','890','1','4','1','s@g.com','PAID',NULL,0);
/*!40000 ALTER TABLE `service_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `service_record_public`
--

DROP TABLE IF EXISTS `service_record_public`;
/*!50001 DROP VIEW IF EXISTS `service_record_public`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `service_record_public` AS SELECT 
 1 AS `record_id`,
 1 AS `Worker`,
 1 AS `Business`,
 1 AS `Business_email`,
 1 AS `Date`,
 1 AS `Service`,
 1 AS `Status`,
 1 AS `Rating`,
 1 AS `customer`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `small_business`
--

DROP TABLE IF EXISTS `small_business`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `small_business` (
  `sm_id` varchar(10) NOT NULL DEFAULT '',
  `email` varchar(40) NOT NULL DEFAULT '',
  `password` varchar(20) DEFAULT NULL,
  `street_address` varchar(25) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `zip` int(11) DEFAULT NULL,
  `mobile` bigint(8) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  `activate` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`sm_id`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `small_business`
--

LOCK TABLES `small_business` WRITE;
/*!40000 ALTER TABLE `small_business` DISABLE KEYS */;
INSERT INTO `small_business` VALUES ('1','abc@xyz.com','password','1 Infinite Loop','San Jose','CA',95129,4085551234,'testsb',0),('58934997','abc@uber.com','password','1 Infinite Loop','San Jose','CA',95129,4085551234,'XYZ',0);
/*!40000 ALTER TABLE `small_business` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `small_business_activation_log`
--

DROP TABLE IF EXISTS `small_business_activation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `small_business_activation_log` (
  `log_id` varchar(10) NOT NULL DEFAULT '',
  `sm_id` varchar(10) DEFAULT NULL,
  `name` varchar(10) DEFAULT NULL,
  `activate` tinyint(1) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `small_business_activation_log`
--

LOCK TABLES `small_business_activation_log` WRITE;
/*!40000 ALTER TABLE `small_business_activation_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `small_business_activation_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `small_business_review`
--

DROP TABLE IF EXISTS `small_business_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `small_business_review` (
  `sm_id` varchar(10) NOT NULL DEFAULT '',
  `email` varchar(40) NOT NULL DEFAULT '',
  `password` varchar(20) DEFAULT NULL,
  `street_address` varchar(25) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `zip` int(11) DEFAULT NULL,
  `mobile` bigint(8) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`sm_id`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `small_business_review`
--

LOCK TABLES `small_business_review` WRITE;
/*!40000 ALTER TABLE `small_business_review` DISABLE KEYS */;
INSERT INTO `small_business_review` VALUES ('94333816','abc@uber.com','password','1 Infinite Loop','San Jose','CA',95129,4085551234,'XYZ');
/*!40000 ALTER TABLE `small_business_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `worker`
--

DROP TABLE IF EXISTS `worker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worker` (
  `worker_id` varchar(10) NOT NULL DEFAULT '',
  `sm_id` varchar(10) NOT NULL DEFAULT '',
  `password` varchar(20) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`worker_id`,`sm_id`),
  KEY `sm_id` (`sm_id`),
  CONSTRAINT `worker_ibfk_1` FOREIGN KEY (`sm_id`) REFERENCES `small_business` (`sm_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `worker`
--

LOCK TABLES `worker` WRITE;
/*!40000 ALTER TABLE `worker` DISABLE KEYS */;
INSERT INTO `worker` VALUES ('123','1','secret','Jane Doe'),('123456','58934997','secret','John Deer'),('890','1','secret','Albus Dumbledore'),('900','58934997','secret','Bill Weasley');
/*!40000 ALTER TABLE `worker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `worker_availability`
--

DROP TABLE IF EXISTS `worker_availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worker_availability` (
  `worker_id` varchar(10) NOT NULL DEFAULT '',
  `sm_id` varchar(10) NOT NULL DEFAULT '',
  `service_id` varchar(10) NOT NULL DEFAULT '',
  `slot_id` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`sm_id`,`worker_id`,`service_id`,`slot_id`),
  KEY `worker_id` (`worker_id`),
  KEY `service_id` (`service_id`),
  KEY `slot_id` (`slot_id`),
  CONSTRAINT `worker_availability_ibfk_1` FOREIGN KEY (`sm_id`) REFERENCES `small_business` (`sm_id`) ON DELETE CASCADE,
  CONSTRAINT `worker_availability_ibfk_2` FOREIGN KEY (`worker_id`) REFERENCES `worker` (`worker_id`) ON DELETE CASCADE,
  CONSTRAINT `worker_availability_ibfk_3` FOREIGN KEY (`service_id`) REFERENCES `service` (`service_id`) ON DELETE CASCADE,
  CONSTRAINT `worker_availability_ibfk_4` FOREIGN KEY (`slot_id`) REFERENCES `schedule` (`slot_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `worker_availability`
--

LOCK TABLES `worker_availability` WRITE;
/*!40000 ALTER TABLE `worker_availability` DISABLE KEYS */;
INSERT INTO `worker_availability` VALUES ('123456','58934997','1','5'),('900','58934997','2','2'),('900','58934997','2','5');
/*!40000 ALTER TABLE `worker_availability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'project'
--
/*!50003 DROP PROCEDURE IF EXISTS `ActivateBusiness` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActivateBusiness`(IN id VARCHAR(10))
BEGIN

    UPDATE small_business SET activate = true where sm_id=id;
    INSERT into small_business_activation_log SELECT sm_id, name, activate, now() as date FROM small_business WHERE sm_id=id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DeactivateBusiness` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeactivateBusiness`(IN id VARCHAR(10))
BEGIN

UPDATE small_business SET activate = false where sm_id=id;
    INSERT into small_business_activation_log SELECT sm_id, name, activate, now() as date FROM small_business WHERE sm_id=id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DeleteService` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteService`(IN serviceid VARCHAR(10))
BEGIN

IF NOT EXISTS (SELECT service_id from service where service_id = serviceid) THEN

DELETE FROM service WHERE service_id = serviceid;

END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllJobs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllJobs`(
in id varchar(10))
BEGIN
SELECT rec.record_id, w.worker_id, w.name as worker, ser.name as service, sch.date, sch.begin_time, sch.end_time, rec.service_status as status
    FROM service_record rec, worker w, service ser, schedule sch
    WHERE rec.sm_id = id AND rec.slot_id = sch.slot_id AND rec.worker_id = w.worker_id AND rec.service_id = ser.service_id
    ORDER BY rec.slot_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetJobs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetJobs`(
in id varchar(10))
BEGIN
SELECT rec.record_id, w.worker_id, w.name as worker, ser.name as service, sch.date, sch.begin_time, sch.end_time, rec.service_status as status
    FROM service_record rec, worker w, service ser, schedule sch
    WHERE rec.sm_id = id AND rec.slot_id = sch.slot_id AND rec.worker_id = w.worker_id AND rec.service_id = ser.service_id AND rec.service_status = 'PENDING'
    ORDER BY rec.slot_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetRating` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRating`(
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `contractor_list`
--

/*!50001 DROP VIEW IF EXISTS `contractor_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `contractor_list` AS select `small_business`.`name` AS `name`,`small_business`.`email` AS `email`,`small_business`.`mobile` AS `mobile`,`small_business`.`street_address` AS `street_address`,`small_business`.`city` AS `city`,`small_business`.`state` AS `state`,`small_business`.`zip` AS `zip` from `small_business` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `customer_public`
--

/*!50001 DROP VIEW IF EXISTS `customer_public`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `customer_public` AS select `service_recipient`.`email` AS `email`,`service_recipient`.`name` AS `name`,`service_recipient`.`mobile` AS `mobile` from `service_recipient` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `service_public`
--

/*!50001 DROP VIEW IF EXISTS `service_public`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `service_public` AS (select `service`.`name` AS `name`,`service`.`description` AS `description` from `service`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `service_record_public`
--

/*!50001 DROP VIEW IF EXISTS `service_record_public`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `service_record_public` AS select `rec`.`record_id` AS `record_id`,`worker`.`name` AS `Worker`,`sm`.`name` AS `Business`,`sm`.`email` AS `Business_email`,`slot`.`date` AS `Date`,`service`.`name` AS `Service`,`rec`.`service_status` AS `Status`,`rec`.`rating` AS `Rating`,`rec`.`service_recipient` AS `customer` from ((((`worker` join `schedule` `slot`) join `small_business` `sm`) join `service`) join `service_record` `rec`) where ((`rec`.`worker_id` = `worker`.`worker_id`) and (`rec`.`slot_id` = `slot`.`slot_id`) and (`rec`.`sm_id` = `sm`.`sm_id`) and (`rec`.`service_id` = `service`.`service_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-12-01  1:14:50
