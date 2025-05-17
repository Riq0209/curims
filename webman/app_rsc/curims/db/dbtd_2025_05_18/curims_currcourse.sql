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
-- Table structure for table `curims_currcourse`
--

DROP TABLE IF EXISTS `curims_currcourse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curims_currcourse` (
  `id_currcourse_62base` binary(6) NOT NULL,
  `id_curriculum_62base` binary(6) NOT NULL,
  `id_course_62base` binary(6) NOT NULL,
  `year_taken` int(11) DEFAULT NULL,
  `semester_taken` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `created_time` time DEFAULT NULL,
  PRIMARY KEY (`id_currcourse_62base`),
  KEY `fk_curriculum` (`id_curriculum_62base`),
  KEY `fk_course` (`id_course_62base`),
  CONSTRAINT `fk_course` FOREIGN KEY (`id_course_62base`) REFERENCES `curims_course` (`id_course_62base`),
  CONSTRAINT `fk_curriculum` FOREIGN KEY (`id_curriculum_62base`) REFERENCES `curims_curriculum` (`id_curriculum_62base`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curims_currcourse`
--

LOCK TABLES `curims_currcourse` WRITE;
/*!40000 ALTER TABLE `curims_currcourse` DISABLE KEYS */;
INSERT INTO `curims_currcourse` (`id_currcourse_62base`, `id_curriculum_62base`, `id_course_62base`, `year_taken`, `semester_taken`, `status`, `created_date`, `created_time`) VALUES ('XV0Lqu','vjRppe','lnclCM',1,1,'Core','2024-05-19','14:30:00'),
('pay4dC','vjRppe','rbNWb5',2,2,'Elective','2024-05-19','14:30:00');
/*!40000 ALTER TABLE `curims_currcourse` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-05-18  2:56:12
