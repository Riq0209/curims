/*!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.4.2-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: db_webman
-- ------------------------------------------------------
-- Server version	11.4.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `curims_schedule`
--

DROP TABLE IF EXISTS `curims_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curims_schedule` (
  `id_schedule_62base` binary(6) NOT NULL,
  `id_topic_62base` binary(6) NOT NULL,
  `session` varchar(10) NOT NULL,
  `semester` int(11) NOT NULL,
  `week` int(11) NOT NULL,
  `date_start` date NOT NULL,
  `date_end` date NOT NULL,
  `info` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id_schedule_62base`),
  KEY `fk_topic_schedule` (`id_topic_62base`),
  CONSTRAINT `fk_topic_schedule` FOREIGN KEY (`id_topic_62base`) REFERENCES `curims_topic` (`id_topic_62base`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curims_schedule`
--

LOCK TABLES `curims_schedule` WRITE;
/*!40000 ALTER TABLE `curims_schedule` DISABLE KEYS */;
INSERT INTO `curims_schedule` (`id_schedule_62base`, `id_topic_62base`, `session`, `semester`, `week`, `date_start`, `date_end`, `info`) VALUES ('1S4dvq','olYrrf','2024/2025',2,2,'2025-03-24','2025-03-28','Online'),
('1Xpuch','QSkRAP','2024/2025',2,11,'2025-05-26','2025-05-30',NULL),
('5YUPk9','HM5Mhf','2024/2025',2,4,'2025-04-07','2025-04-11',NULL),
('HVI2JC','2U5hSn','2024/2025',2,12,'2025-06-02','2025-06-06',NULL),
('LEWbKu','tVbM7D','2024/2025',2,14,'2025-06-16','2025-06-20',NULL),
('OthD3H','4eidIQ','2024/2025',2,9,'2025-05-12','2025-05-16',NULL),
('U2ky05','dOfZ3g','2024/2025',2,13,'2025-06-09','2025-06-13',NULL),
('VWYEfd','eEom7k','2024/2025',2,5,'2025-04-14','2025-04-18',NULL),
('dT4XOe','B9EqFv','2024/2025',2,3,'2025-03-31','2025-04-04','Online'),
('exmKWt','wwmWcG','2024/2025',2,6,'2025-04-21','2025-04-25',NULL),
('qU0qId','QSkRAP','2024/2025',2,10,'2025-05-19','2025-05-23',NULL),
('rQIDqC','wrpeN7','2024/2025',2,8,'2025-05-05','2025-05-09',NULL),
('uDQK26','RLOCw6','2024/2025',2,7,'2025-04-28','2025-05-02','Labour Day (1st May-Thursday)'),
('uLxq1k','VOmWxb','2024/2025',2,1,'2025-03-17','2025-03-21','Online');
/*!40000 ALTER TABLE `curims_schedule` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:05:20
