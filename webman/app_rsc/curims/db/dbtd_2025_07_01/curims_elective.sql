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
-- Table structure for table `curims_elective`
--

DROP TABLE IF EXISTS `curims_elective`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curims_elective` (
  `id_elective_62base` binary(6) NOT NULL,
  `id_curriculum_62base` binary(6) NOT NULL,
  `id_currcourse_62base` binary(6) NOT NULL,
  `id_course_62base` binary(6) NOT NULL,
  `year_taken` int(11) NOT NULL,
  `semester_taken` int(11) NOT NULL,
  `semester_no` int(11) NOT NULL,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`id_elective_62base`),
  KEY `id_currcourse_62base` (`id_currcourse_62base`),
  KEY `id_course_62base` (`id_course_62base`),
  KEY `fk_elective_curriculum` (`id_curriculum_62base`),
  CONSTRAINT `curims_elective_ibfk_1` FOREIGN KEY (`id_currcourse_62base`) REFERENCES `curims_currcourse` (`id_currcourse_62base`),
  CONSTRAINT `curims_elective_ibfk_2` FOREIGN KEY (`id_course_62base`) REFERENCES `curims_course` (`id_course_62base`),
  CONSTRAINT `fk_elective_curriculum` FOREIGN KEY (`id_curriculum_62base`) REFERENCES `curims_curriculum` (`id_curriculum_62base`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curims_elective`
--

LOCK TABLES `curims_elective` WRITE;
/*!40000 ALTER TABLE `curims_elective` DISABLE KEYS */;
INSERT INTO `curims_elective` (`id_elective_62base`, `id_curriculum_62base`, `id_currcourse_62base`, `id_course_62base`, `year_taken`, `semester_taken`, `semester_no`, `status`) VALUES ('2I1C9s','Qb4Jeb','Jm62xb','Hncr2h',3,1,5,'Core'),
('3H8oYF','Qb4Jeb','xu0mtq','XIiQr6',2,2,2,'Core'),
('AdSw2J','Qb4Jeb','i1j4Y7','BlnUB2',3,2,6,'Core'),
('BTVLvw','Qb4Jeb','xu0mtq','mQkZF5',2,2,2,'Core'),
('EIbArO','Qb4Jeb','qpfTeq','wf6N4P',4,2,8,'Core'),
('HNfYN4','Qb4Jeb','Jm62xb','0TKjv9',3,1,5,'Core'),
('KvgQas','Qb4Jeb','i1j4Y7','b2vSoj',3,2,6,'Core'),
('QD0GVm','Qb4Jeb','Jm62xb','4UkNh6',3,1,5,'Core'),
('ZnXqun','Qb4Jeb','Jm62xb','5wwGpR',3,1,5,'Core'),
('aX7GVm','Qb4Jeb','qpfTeq','8hXdNb',4,2,8,'Core'),
('fZAHkl','EoGi6B','LeWwG8','nMdDLo',2,2,4,'Core'),
('fl1STC','Qb4Jeb','i1j4Y7','qbxfkg',3,2,6,'Core'),
('iW8OMV','Qb4Jeb','i1j4Y7','UXFuR7',3,2,6,'Core'),
('m19tDM','Qb4Jeb','i1j4Y7','SqLPqV',3,2,6,'Core'),
('mvv5tS','Qb4Jeb','qpfTeq','Ci6eFs',4,2,8,'Core'),
('qi1EEd','Qb4Jeb','Jm62xb','osc34g',3,1,5,'Core'),
('uiANgA','EoGi6B','LeWwG8','mQkZF5',2,2,4,'Core');
/*!40000 ALTER TABLE `curims_elective` ENABLE KEYS */;
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
