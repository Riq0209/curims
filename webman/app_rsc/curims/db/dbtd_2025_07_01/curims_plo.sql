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
-- Table structure for table `curims_plo`
--

DROP TABLE IF EXISTS `curims_plo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curims_plo` (
  `id_plo_62base` binary(6) NOT NULL,
  `id_curriculum_62base` binary(6) NOT NULL,
  `plo_code` varchar(20) NOT NULL,
  `plo_tag` varchar(10) DEFAULT NULL,
  `plo_description` text DEFAULT NULL,
  PRIMARY KEY (`id_plo_62base`),
  KEY `fk_curriculum_plo` (`id_curriculum_62base`),
  CONSTRAINT `fk_curriculum_plo` FOREIGN KEY (`id_curriculum_62base`) REFERENCES `curims_curriculum` (`id_curriculum_62base`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curims_plo`
--

LOCK TABLES `curims_plo` WRITE;
/*!40000 ALTER TABLE `curims_plo` DISABLE KEYS */;
INSERT INTO `curims_plo` (`id_plo_62base`, `id_curriculum_62base`, `plo_code`, `plo_tag`, `plo_description`) VALUES ('1yUsJX','rPkHvc','PLO8',NULL,'Ability to work effectively and adapt to the new cultures of communities, professional\nfields, and environments'),
('4GQ8e6','RW7vPh','PLO4',NULL,'Ability to present technical solutions to a range of audience'),
('4IGkCH','ZvA8fl','PLO5',NULL,'Ability to think critically and creatively in order to solve problems'),
('5Ntp44','rPkHvc','PLO5',NULL,'Ability to think critically and creatively to solve real world problem'),
('654dAc','Qb4Jeb','PLO8','LAR','Ability to function individually or in teams, effectively, with a capability to be a\nleader'),
('8BEaIi','rPkHvc','PLO2',NULL,'Ability to apply theoretical principles of Computer Science and Bioinformatics for\nanalysing, designing, and developing computer system'),
('8BbbKe','rPkHvc','PLO6',NULL,'Ability to lead and work effectively in a team to achieve common goals'),
('9ABi4L','RW7vPh','PLO2',NULL,'Ability to apply theoretical principles of Computer Science and Data\nEngineering for analyzing, designing and developing computer system and\nadapt it in practice'),
('9XEEnx','ZvA8fl','PLO4',NULL,'Ability to communicate technical solutions to a range of audience'),
('Bd0BQd','ZvA8fl','PLO2',NULL,'Ability to exhibit technical competencies in configuring, analysing, designing\nand developing computer network and security system using standard\napproaches'),
('C5OWBe','ZvA8fl','PLO7',NULL,'Ability to lead and work effectively in a team to achieve common goals'),
('D1Jn9n','Qb4Jeb','PLO1 ','KW','Ability to acquire and apply knowledge of Computer Sciences and Software\nEngineering fundamentals.'),
('EhhCQ6','Qb4Jeb','PLO4','IPS','Ability to perform effective collaboration with stakeholders professionally\n'),
('EkhEep','RW7vPh','PLO9',NULL,'Ability to identify business opportunities and develop entrepreneurship mind-set\nand skills'),
('GSPHcZ','ZvA8fl','PLO1',NULL,'Ability to acquire the theory and principles of Computer Science and be\nequipped with social science and personal development knowledge'),
('Hry8cP','EoGi6B','PLO4','IPS','Ability to perform effective collaboration with stakeholders professionally'),
('Ij5I59','Qb4Jeb','PLO10','ENT','Ability to initiate entrepreneurial project with relevant knowledge and expertise\n'),
('JWVNTT','EoGi6B','PLO3','PS','Ability to demonstrate technical and scientific expertise in a field of graphics\nand multimedia software'),
('JvgR1G','Qb4Jeb','PLO3','PS','Ability to demonstrate technical and scientific expertise in a field of software\nengineering'),
('Lv4NG7','ZvA8fl','PLO3',NULL,'Ability to creatively solve real world computer network and security problems\nthrough Computer Science principles using current tools and techniques'),
('M3SeQH','Qb4Jeb','PLO11','ETS','Ability to conduct respectable, ethical and professional practices in organization\nand society'),
('MnOdN0','EoGi6B','PLO1','KW','Ability to acquire and apply knowledge of Computer Sciences and Graphics\nand Multimedia Software fundamentals'),
('Mr1IoG','ZvA8fl','PLO8',NULL,'Ability to work effectively and adapt to the new cultures of communities,\nprofessional fields and environments'),
('QbQ4wv','rPkHvc','PLO9',NULL,'Ability to identify business opportunities and develop entrepreneurship mind-set and\nskills'),
('QfLxu9','ZvA8fl','PLO10',NULL,'Ability to identify business opportunities and develop entrepreneurship mind-set\nand skills'),
('ST7EpC','ZvA8fl','PLO6',NULL,'Ability to continuously integrate Computer Science knowledge and skills\nthrough lifelong learning process'),
('SfVqsF','Qb4Jeb','PLO5','CS','Ability to communicate effectively both in written and spoken form with other\nprofessionals and community.'),
('U8nCl8','RW7vPh','PLO6',NULL,'Ability to continuously integrate Computer Science knowledge and skills\nthrough lifelong learning process'),
('XsN9Jl','RW7vPh','PLO3',NULL,'Ability to integrate and demonstrate knowledge to solve real world industry\nproblems through data engineering principles and methodologies, and propose\nIT related business solutions innovatively using current tools and techniques'),
('Y4tZ89','EoGi6B','PLO7','NS','Ability to analyse numerical or graphical data using quantitative or qualitative\ntools in solving problems'),
('YSfY7G','RW7vPh','PLO8',NULL,'Ability to work effectively and adapt to the new cultures of communities,\nprofessional fields and environments'),
('Z4YUxn','Qb4Jeb','PLO2 ','CG','Ability to demonstrate comprehensive problem analysis and creative design skill\nto solve and manage complex computing problems using systematic and\ncurrent approaches'),
('bf3D5o','EoGi6B','PLO5','CS','Ability to communicate effectively both in written and spoken form with other\nprofessionals and community'),
('cL8Sr7','rPkHvc','PLO7',NULL,'Ability to continuously integrate Computer Science knowledge and skills through\nlifelong learning process'),
('dfrrBi','RW7vPh','PLO7',NULL,'Ability to lead and work effectively in a team to achieve common goals'),
('dgUMrF','EoGi6B','PLO11','ETS','Ability to conduct respectable, ethical and professional practices in\norganization and society'),
('fYuVcE','EoGi6B','PLO8','LAR','Ability to function individually or in teams, effectively, with a capability to be a\nleader'),
('jaMQZ9','RW7vPh','PLO1',NULL,'Ability to acquire the theory and principles of Computer Science and Data\nEngineering and be equipped with social science and personal development\nknowledge'),
('k4G101','RW7vPh','PLO5',NULL,'Ability to think critically and creatively to solve problems'),
('omxNJm','Qb4Jeb','PLO9','PRS','Ability to self-advancement through continuous academic or professional\ndevelopment'),
('qFcNmE','rPkHvc','PLO4',NULL,'Ability to present technical solutions to a range of audience'),
('qsbxIF','rPkHvc','PLO3',NULL,'Ability to integrate and demonstrate knowledge to solve real world problems through\nBioinformatics principles and methodologies, and to develop computationally efficient\nsolutions to address biological challenges'),
('rQ6D3L','EoGi6B','PLO2','CG','Ability to demonstrate comprehensive problem analysis and creative design\nskill to solve and manage complex computing problems using systematic and\ncurrent approaches'),
('soSmVc','Qb4Jeb','PLO6','DS','Ability to use digital technologies and software to support studies competently\n'),
('tHHnc3','EoGi6B','PLO10','ENT','Ability to initiate entrepreneurial project with relevant knowledge and expertise'),
('tIYE8F','EoGi6B','PLO6','DS','Ability to use digital technologies and software to support studies competently'),
('tPqWXj','Qb4Jeb','PLO7','NS','Ability to analyse numerical or graphical data using quantitative or qualitative\ntools in solving problems'),
('u9mrIi','ZvA8fl','PLO9',NULL,'Ability to behave ethically, responsibly, professionally, and with integrity in\ncarrying out responsibilities and making decisions'),
('ufiSFZ','RW7vPh','PLO10',NULL,'Ability to behave ethically, responsibly, professionally, and with integrity in\ncarrying out responsibilities and making decisions'),
('urQ4i7','rPkHvc','PLO1',NULL,'Ability to acquire theory and principles of Computer Science and Bioinformatics and\nequip with social science and personal development knowledge'),
('wbrwkH','rPkHvc','PLO10',NULL,'Ability to behave ethically, responsibly, professionally, and with integrity in carrying out\nresponsibilities and making decisions.'),
('xu0unK','EoGi6B','PLO9','PRS','Ability to self-advancement through continuous academic or professional\ndevelopment');
/*!40000 ALTER TABLE `curims_plo` ENABLE KEYS */;
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
