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
-- Table structure for table `curims_lecturer`
--

DROP TABLE IF EXISTS `curims_lecturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curims_lecturer` (
  `id_lecturer_62base` binary(6) NOT NULL,
  `name` varchar(100) NOT NULL,
  `office` varchar(50) DEFAULT NULL,
  `contact` varchar(30) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_lecturer_62base`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curims_lecturer`
--

LOCK TABLES `curims_lecturer` WRITE;
/*!40000 ALTER TABLE `curims_lecturer` DISABLE KEYS */;
INSERT INTO `curims_lecturer` (`id_lecturer_62base`, `name`, `office`, `contact`, `email`) VALUES ('0ku1DN','Assoc. Prof. Dr. Norafida binti Ithnin',NULL,NULL,'afida@utm.my'),
('1aa1F0','Assoc. Prof. Dr. Hishamuddin bin Asmuni @ Hasmuni',NULL,NULL,'hishamudin@utm.my'),
('1ou9HF','Prof. Ts. Dr. Kamalrulnizam bin Abu Bakar',NULL,NULL,'knizam@utm.my'),
('4rdgBF','Assoc. Prof. Dr. Mohd Adham bin Isa',NULL,NULL,'mohdadham@utm.my'),
('5hpDpX','Assoc. Prof. Ts. Dr. Siti Hajar binti Othman',NULL,NULL,'sitihajar@utm.my'),
('8hvAKY','Assoc. Prof. Dr. Mohd Murtadha bin Mohamad',NULL,NULL,'murtadha@utm.my'),
('AMN1y5','Assoc. Prof. Dr. Mohd Shahizan bin Othman',NULL,NULL,'shahizan@utm.my'),
('BXxNfm','Prof. Dr. Mohd Shahrizal bin Sunar',NULL,NULL,'shahrizal@utm.my'),
('DJYk8X','Assoc. Prof. Dr. Mohd Yazid binti Idris',NULL,NULL,'yazid@utm.my'),
('I3p8bg','Prof. Dr. Mohd Shafry bin Mohd Rahim',NULL,NULL,'shafry@utm.my'),
('IWefEN','Assoc. Prof. Dr. Rohayanti binti Hassan',NULL,NULL,'rohayanti@utm.my'),
('J0fnTF','Dr. Adila Firdaus binti Arbain',NULL,NULL,'adilafirdaus@utm.my'),
('LlacHs','Assoc. Prof. Dr. Haza Nuzly bin Abdull Hamed',NULL,NULL,'haza@utm.my'),
('MVT210','Prof. Ts. Dr. Wan Mohd Nasir bin Wan Kadir',NULL,NULL,'wnasir@utm.my'),
('Mq7omQ','Assoc. Prof. Dr. Ajune Wanis binti Ismail',NULL,NULL,'ajune@utm.my'),
('PUoeSV','Prof. Dr. Ali bin Selamat',NULL,NULL,'aselamat@utm.my'),
('QCbl5J','Assoc. Prof. Dr. Ramesh KS @ Mohd Zaidi bin Abd Rozan',NULL,NULL,'mdzaidi@utm.my'),
('SAFune','Dr. Mohd Adham Bin Isa','N28A- 201- 02',NULL,'mohdadham@utm.my'),
('SWNmQO','Assoc. Prof. Dr. Azurah binti A Samah',NULL,NULL,'azurah@utm.my'),
('UCAAbD','Prof. Ts. Dr. Dayang Norhayati binti Abang Jawawi',NULL,NULL,'dayang@utm.my'),
('UPyJJ6','Assoc. Prof. Dr. Nor Azman bin Ismail',NULL,NULL,'azman@utm.my'),
('WZftqu','Prof. Dr. Siti Zaiton binti Mohd Hashim',NULL,NULL,'sitizaiton@utm.my'),
('Xw1Kn8','Assoc. Prof. Dr. Noorminshah binti A.Iahad',NULL,NULL,'minshah@utm.my'),
('ZVMA7C','Assoc. Prof. Dr. Ismail Fauzi bin Isnin',NULL,NULL,'ismailfauzi@utm.my'),
('ZVpsL5','Prof. Ts. Dr. Md Asri bin Ngadi',NULL,NULL,'dr.asri@utm.my'),
('ZX88tb','Assoc. Prof. Dr. Ts. Farhan bin Mohamed',NULL,NULL,'farhan@utm.my'),
('a64U19','Dr. Adnan Khalid',NULL,NULL,'khalid.adnan@utm.my'),
('bsOvaT','Assoc. Prof. Dr. Anazida binti Zainal',NULL,NULL,'anazida@utm.my'),
('fIiJ0P','Prof. Dr. Shukor bin Abd Razak',NULL,NULL,'shukorar@utm.my'),
('gN85Ko','Prof. Dr. Azlan bin Mohd Zain',NULL,NULL,'azlanmz@utm.my'),
('k5Z9hM','Prof. Dr. Naomie binti Salim',NULL,NULL,'naomie@utm.my'),
('qPrdnO','Dr. Adila Firdaus Arbain','N28A- 201- 02',NULL,'adilafirdaus@utm.my'),
('qtRmJ2','Assoc. Prof. Dr. Radziah binti Mohamad',NULL,NULL,'radziahm@utm.my'),
('tO2WWy','Assoc. Prof. Dr. Roliana binti Ibrahim',NULL,NULL,'roliana@utm.my'),
('u5APQN','Assoc. Prof. Dr. Ts. Shahida binti Sulaiman',NULL,NULL,'shahidasulaiman@utm.my');
/*!40000 ALTER TABLE `curims_lecturer` ENABLE KEYS */;
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
