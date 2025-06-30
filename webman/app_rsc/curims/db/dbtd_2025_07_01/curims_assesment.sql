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
-- Table structure for table `curims_assesment`
--

DROP TABLE IF EXISTS `curims_assesment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curims_assesment` (
  `id_assesment_62base` binary(6) NOT NULL,
  `id_course_62base` binary(6) NOT NULL,
  `type` varchar(45) NOT NULL,
  `sequence` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id_assesment_62base`),
  KEY `fk_course_assessment` (`id_course_62base`),
  CONSTRAINT `fk_course_assessment` FOREIGN KEY (`id_course_62base`) REFERENCES `curims_course` (`id_course_62base`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curims_assesment`
--

LOCK TABLES `curims_assesment` WRITE;
/*!40000 ALTER TABLE `curims_assesment` DISABLE KEYS */;
INSERT INTO `curims_assesment` (`id_assesment_62base`, `id_course_62base`, `type`, `sequence`, `name`) VALUES ('8aOkft','8hXdNb','Continuous Assessment',5,'Project development'),
('BNyeNN','Ci6eFs','Continous Assessment',1,'testing'),
('MgcQIf','tksy5g','Continous Assessment',1,'test'),
('TFFZL0','8hXdNb','Continuous Assessment',2,'Midterm Test'),
('bIsSvM','8hXdNb','Continuous Assessment',4,'Assignment 2'),
('gmQTrh','8hXdNb','Final Assessment',6,'Final Examination, Section A'),
('h50XHk','8hXdNb','Continuous Assessment',3,'Assignment 1'),
('je9bOh','8hXdNb','Final Assessment',7,'Final Examination, Section B'),
('xBtSJd','8hXdNb','Continuous Assessment',1,'Problem Solving 1 - 4');
/*!40000 ALTER TABLE `curims_assesment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:05:19
