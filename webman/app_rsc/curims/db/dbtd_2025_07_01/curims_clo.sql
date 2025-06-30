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
-- Table structure for table `curims_clo`
--

DROP TABLE IF EXISTS `curims_clo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curims_clo` (
  `id_clo_62base` binary(6) NOT NULL,
  `id_course_62base` binary(6) NOT NULL,
  `clo_code` varchar(10) NOT NULL,
  `clo_description` text DEFAULT NULL,
  `clo_tl_methods` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id_clo_62base`),
  KEY `fk_course_clo` (`id_course_62base`),
  CONSTRAINT `fk_course_clo` FOREIGN KEY (`id_course_62base`) REFERENCES `curims_course` (`id_course_62base`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curims_clo`
--

LOCK TABLES `curims_clo` WRITE;
/*!40000 ALTER TABLE `curims_clo` DISABLE KEYS */;
INSERT INTO `curims_clo` (`id_clo_62base`, `id_course_62base`, `clo_code`, `clo_description`, `clo_tl_methods`) VALUES ('ICmy5L','8hXdNb','CLO 1','Apply concepts of software\nconstruction in a software\ndevelopment.','Lecture, Tutorial, Active Learning'),
('dXpBdZ','8hXdNb','CLO 4','Organize a team to apply software\nconstruction knowledge in\ndeveloping a medium sized\napplication','Project- based learning'),
('nI7tEF','tksy5g','dsd','sdsd','Collaborative Learning'),
('tCHdcj','8hXdNb','CLO 2','Analyze appropriate software\nengineering methods and tools in\nconstructing a software.','Lab work, Tutorial'),
('u0c9JI','8hXdNb','CLO 3','Revise the code quality of a\nsoftware\nConstruction project in a software\ndevelopment cycle','Lecture, Tutorial, Project- based learning');
/*!40000 ALTER TABLE `curims_clo` ENABLE KEYS */;
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
