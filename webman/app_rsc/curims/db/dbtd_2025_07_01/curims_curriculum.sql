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
-- Table structure for table `curims_curriculum`
--

DROP TABLE IF EXISTS `curims_curriculum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curims_curriculum` (
  `id_curriculum_62base` binary(6) NOT NULL,
  `curriculum_code` varchar(10) NOT NULL,
  `curriculum_name` varchar(255) NOT NULL,
  `intake_session` varchar(10) NOT NULL,
  `intake_year` int(11) NOT NULL,
  `intake_semester` int(11) NOT NULL,
  PRIMARY KEY (`id_curriculum_62base`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curims_curriculum`
--

LOCK TABLES `curims_curriculum` WRITE;
/*!40000 ALTER TABLE `curims_curriculum` DISABLE KEYS */;
INSERT INTO `curims_curriculum` (`id_curriculum_62base`, `curriculum_code`, `curriculum_name`, `intake_session`, `intake_year`, `intake_semester`) VALUES ('EoGi6B','SECVH','Bachelor of Computer Science (Graphics and Multimedia Software)','2024/2025',1,1),
('Qb4Jeb','SECJH','Bachelor of Computer Science (Software Engineering)','2024/2025',1,1),
('RW7vPh','SECPH','Bachelor of Computer Science (Data Engineering)','2024/2025',1,1),
('ZvA8fl','SECRH','Bachelor of Computer Science (Computer Network and Security)','2024/2025',1,1),
('rPkHvc','SECBH','Bachelor of Computer Science (Bioinformatic)','2024/2025',1,1);
/*!40000 ALTER TABLE `curims_curriculum` ENABLE KEYS */;
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
