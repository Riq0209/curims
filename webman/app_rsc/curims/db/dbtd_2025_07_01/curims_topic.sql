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
-- Table structure for table `curims_topic`
--

DROP TABLE IF EXISTS `curims_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curims_topic` (
  `id_topic_62base` binary(6) NOT NULL,
  `id_course_62base` binary(6) NOT NULL,
  `session` varchar(10) NOT NULL,
  `semester` int(11) NOT NULL,
  `topic_no` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `subtopic` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id_topic_62base`),
  KEY `fk_course_topic` (`id_course_62base`),
  CONSTRAINT `fk_course_topic` FOREIGN KEY (`id_course_62base`) REFERENCES `curims_course` (`id_course_62base`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curims_topic`
--

LOCK TABLES `curims_topic` WRITE;
/*!40000 ALTER TABLE `curims_topic` DISABLE KEYS */;
INSERT INTO `curims_topic` (`id_topic_62base`, `id_course_62base`, `session`, `semester`, `topic_no`, `title`, `subtopic`) VALUES ('2U5hSn','8hXdNb','2024/2025',2,9,'Framework','Class libraries, Framework classification, Plug-extension mechanism, Hot-spot\ndriven development, Framework Instantiation\nAssignment 2: Due date Week 15'),
('4eidIQ','8hXdNb','2024/2025',2,7,'Domain Modelling','Application domain, Identification and modelling of domain concepts, Discovering classes\nProblem Solving 3'),
('B9EqFv','8hXdNb','2024/2025',2,3,'Software Reuse','Definition and taxonomy, Reusability, Process and technology, Cost and benefit.\nProblem Solving 1'),
('HM5Mhf','8hXdNb','2024/2025',2,4,'Design by Contract','Violating a contract, DbC in programming language, Contract and Inheritance, Defensive\nprogramming\nProblem Solving 2'),
('QSkRAP','8hXdNb','2024/2025',2,8,'Components and Advanced Component Concept','Properties of components, Components model, OSGi, Managed components (Spring framework),\nComponents View\nProject 1 : Due Date; Week 15'),
('RLOCw6','8hXdNb','2024/2025',2,13,'Mid-Term Face to Face','2nd May 2025 (Friday) 8pm-10pm'),
('VOmWxb','8hXdNb','2024/2025',2,1,'Introduction to Software Construction','Programming paradigms, OO Concepts, Introduction to Git'),
('dOfZ3g','8hXdNb','2024/2025',2,10,'Refactoring','Re-engineering, Refactoring types, Process and guidelines\nProblem Solving 4'),
('eEom7k','8hXdNb','2024/2025',2,5,'DeveOps','Assignment 1: Due date Week 7'),
('olYrrf','8hXdNb','2024/2025',2,2,'Design Foundation','Design principles, Properties of design, Design guideline, Code management'),
('tVbM7D','8hXdNb','2024/2025',2,11,'Code Smells','Code and design smells, Detecting bad smells'),
('wrpeN7','8hXdNb','2024/2025',2,12,'Semester Break','N/A'),
('wwmWcG','8hXdNb','2024/2025',2,6,'DevOps part II','Assignment 1: Due date Week 7');
/*!40000 ALTER TABLE `curims_topic` ENABLE KEYS */;
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
