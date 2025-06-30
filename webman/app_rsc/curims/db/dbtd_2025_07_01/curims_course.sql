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
-- Table structure for table `curims_course`
--

DROP TABLE IF EXISTS `curims_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curims_course` (
  `id_course_62base` binary(6) NOT NULL,
  `course_code` varchar(50) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `credit_hour` int(1) NOT NULL,
  `prerequisite_code` varchar(100) DEFAULT 'N/A',
  `course_synopsis` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id_course_62base`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curims_course`
--

LOCK TABLES `curims_course` WRITE;
/*!40000 ALTER TABLE `curims_course` DISABLE KEYS */;
INSERT INTO `curims_course` (`id_course_62base`, `course_code`, `course_name`, `credit_hour`, `prerequisite_code`, `course_synopsis`) VALUES ('0O5Gxy','SECB4134','Bioinformatics Project II',4,'SECB3032',NULL),
('0TKjv9','SECJ3104','Applications Development',4,'SECJ2203, SECD2523, SECV2223, SECJ2154',NULL),
('0j8N6p','SECJ3203','Theory of Computer Science',3,'SECI1013, SECJ2013',NULL),
('0wptQu','SECP4112','Initial Industry Project Proposal',2,'N/A',NULL),
('0xG767','SEBB4173','Cellular and Molecular Biology for Bioinformatics',3,'N/A',NULL),
('1B68an','SECP1513','Technology & Information System',3,'N/A',NULL),
('1Rwwl2','SECPXXX3 - P3','Elective Courses - Choose 2 (7 credits)',7,'N/A',NULL),
('1Z1pJK','SECJ4114','Industrial Training Report',4,'92 credits CGPA >= 2.0',NULL),
('2HPep1','SECP4114','Professional Development',4,'N/A',NULL),
('4UkNh6','SECJ3603','Knowledge-Based & Expert Systems',3,'SECJ3533',NULL),
('4gqR2Z','SECP3823','Knowledge Management Systems',3,'N/A',NULL),
('5dYi4p','SECP4234','Industrial Integrated Project Report',4,'N/A',NULL),
('5dyHJU','SECR1013','Digital Logic',3,'N/A',NULL),
('5wwGpR','SECJ3553','Artificial Intelligence',3,'SECJ2013',NULL),
('6A5YcI','SECR4114','Industrial Training Report',4,'92 credits CGPA >= 2.0',NULL),
('6E8wts','SEXBXXX3 - B2','SECB Core Elective #2',3,'N/A',NULL),
('6F0dXE','SECV3313','Geometric Modelling',3,'SECV2213',NULL),
('6FAP7B','SECV3032','Graphics and Multimedia Software Project I',2,'SECV3104',NULL),
('6tcpxh','SECJ2XX3 - J1','Elective Courses - Choose 1 (3 Credits)',3,'N/A',NULL),
('7JDfLG','SECP3XX3 - P4','Elective Courses - Choose 4 (15 credits)',15,'N/A',NULL),
('7gv4VK','SECB3032','Bioinformatics Project I',2,'N/A',NULL),
('7lyRpl','SECV2113','Human Computer Interaction',3,'N/A',NULL),
('8hXdNb','SECJ4383','Software Construction',3,'SECJ2203','This course equips the students with knowledge in software construction particularly on howsoftware engineering approaches assist software development. The knowledge unit for thiscoursearea emphasize the following topics; design foundation, reuse, design by contract, components andadvance components, framework, refactoring and code smells. The objective of this course is tointroduce students with key software construction practices in software development and give\npractical experience to the students in developing a software using appropriate software\nconstruction techniques and tools.'),
('8hcigx','SECB4213','Bioinformatics Visualization',3,'N/A',NULL),
('9SiKQ5','SECJ3XXX - J2','Elective Courses - Choose 4 (13 Credits)\n',13,'N/A',NULL),
('A3OeBg','SECP3213','Business Intelligence',3,'N/A',NULL),
('A90hPP','SECR1033','Computer Organisation and Architecture',3,'SECR1013',NULL),
('APfEcV','SECI1013','Discrete Structure',3,'N/A',NULL),
('AcJHjM','SECV1113','Mathematics for Computer Graphics',3,'N/A',NULL),
('AmdEoo','SECBXXX3 - B3','Elective Course - Choose 2 (6 Credits)',6,'N/A',NULL),
('BlnUB2','SECJ3563','Computational Intelligence',3,'SECJ3553',NULL),
('Ci6eFs','SECJ4423','Real-Time Software Engineering',3,'SECJ2203',NULL),
('CjfgWZ','SECRXXX3 - R2','Elective Courses - Choose 3 (9 Credits)',9,'',NULL),
('DA2hv0','SECP2753','Data Mining',3,'N/A',NULL),
('DYFLof','SECD2523','Database',3,'N/A',NULL),
('DyES0T','SECV3223','Multimedia Data Processing',3,'SECJ1023',NULL),
('ESlPVT','SECV4273','Introduction to Speech Recognition',3,'SECJ1023',NULL),
('EV6QcK','SECP4124','Professional Practice',4,'N/A',NULL),
('EX6IJ6','SECP4223','Industrial Integrated Project Proposal',3,'N/A',NULL),
('Etv49u','SECV4134','Graphics and Multimedia Software Project II',4,'SECV3032',NULL),
('FAZwHG','SECB3203','Programming for Bioinformatics',3,'N/A',NULL),
('Fh0Xnd','SECB4243','Special Topic in Bioinformatics',3,'N/A',NULL),
('GoE9uH','SECRXXX3 - R1','Elective Courses - Choose 1 (3 Credits)',3,'SECJ1023',NULL),
('H4dnVq','SECJ1023','Programming Technique II',3,'SECJ1013',NULL),
('HdhOFU','SECV3123','Real-time Computer Graphics',3,'SECV2213',NULL),
('Hncr2h','SECJ3303','Internet Programming',3,'SECJ2154, SECV2223',NULL),
('I6W4nh','UHLM1012','Malaysian Language for Communication (International Students Only)',2,'N/A',NULL),
('IAAJTw','SECR4118','Industrial Training (HW)',8,'92 credits CGPA >= 2.0',NULL),
('IHa46s','SECV4233','Data Visualisation',3,'N/A',NULL),
('JLTpGx','SECPXXX3 - P1','Elective Courses - Choose 1 (3 credits)',3,'N/A',NULL),
('K8CXyC','SECB3133','Computational Biology I',3,'N/A',NULL),
('KSFFw6','SEXBXXX3 - B1','SECB Core Elective #1',3,'N/A',NULL),
('Kls83J','SECD3761','Technopreneurship Seminar',1,'N/A',NULL),
('M6sjlq','UBSS1032','Introduction to Entrepreneurship',2,'N/A',NULL),
('NWIGSZ','SECP3106','Application Development',6,'N/A',NULL),
('OIuCTf','SECP3744','Enterprise Systems Design and Modeling',4,'N/A',NULL),
('OUpWFo','UKQF2XX2','Service-Learning and Community Engagement Courses',2,'N/A',NULL),
('PQnai0','SECP3723','System Development Technology',3,'N/A',NULL),
('PRaLWU','SECV4213','Computer Games Development',3,'SECJ1013',NULL),
('Q2xGqk','SECR3242','Internetworking Technology (CCNA3 & 4)',2,'SECR2242',NULL),
('QWEoq0','SEBB4203','Proteins Biomolecules',3,'N/A',NULL),
('Rq3UXS','SECB4118','Industrial Training (HW)',8,'92 credits CGPA >= 2.0',NULL),
('Rt5EWI','SECP3133','High Performance Data Processing',3,'N/A',NULL),
('SaRwqt','SECV4114','Industrial Training Report',4,'92 credits CGPA >= 2.0',NULL),
('SqLPqV','SECJ3343','Software Quality Assurance',3,'SECJ2203',NULL),
('TLgFLH','SECR4134','Computer Network & Security Project II',4,'SECR3032',NULL),
('UWq95x','SECB3213','Bioinformatic Database',3,'N/A',NULL),
('UXFuR7','SECJ3403','Special Topic in Software Engineering',3,'N/A',NULL),
('VCoHry','SECR2941','Computer Networks Lab',1,'SECR1213',NULL),
('VH9Uip','SECR3941','Internetworking Technology Lab',1,'SECR2941',NULL),
('VYuJLT','SECP4235','Industrial Integrated Project Development',5,'N/A',NULL),
('VvffOs','SECV4XX3 - V4','Elective Courses - Choose 2 (6 Credits)',6,'N/A',NULL),
('XIiQr6','SECJ2253','Requirements Engineering & Software Modelling',3,'SECJ2203',NULL),
('XVVMcV','SECJ4XX3 - J4','Elective Courses - Choose 2 (6 Credits)\n',6,'N/A',NULL),
('XYKvHF','SECJ3032','Software Engineering Project I',2,'SECJ3104',NULL),
('XnG91i','SECX2XX3 - V1','Elective Courses - Choose 1 (3 Credits)',3,'N/A',NULL),
('YSsVeJ','SECJ2013','Data Structure and Algorithm',3,'SECJ1023',NULL),
('YeoLjx','UHIS1022','Philosophy and Current Issues',2,'N/A',NULL),
('ZK9FdD','SECP3713','Database Administration',3,'N/A',NULL),
('ZasWqt','SEBB4193','Gene and Protein Technology',3,'N/A',NULL),
('ZxUtto','SECP3223','Data Analytic Programming',3,'N/A',NULL),
('a3nATB','SECJ3XX3 - J3','Elective Courses - Choose 4 (12 Credits)\n',12,'N/A',NULL),
('aQiSp3','SECJ2203','Software Engineering',3,'N/A',NULL),
('b2vSoj','SECJ3623','Mobile Application Programming',3,'SECJ2154',NULL),
('bctZVM','SECP4134','Professional Development and Practice Report',4,'N/A',NULL),
('bwaPhq','ULRS3032','Entrepreneurship and Innovation',2,'N/A',NULL),
('cVhkPB','SECR3223','High Performance & Parallel Computing',3,'SECJ1023',NULL),
('cqw31D','SECR2213','Network Communications',3,'SECJ1023',NULL),
('dxaR9H','SECR3413','Computer Security',3,'SECR2043',NULL),
('f1IwYH','SXXXXXX3','University Free Electives*',3,'N/A',NULL),
('fIP0UA','SECXXXX3 - V3','Elective Courses - Choose 4 (12 Credits)',12,'N/A',NULL),
('fqTDfl','SECB4114','Industrial Training Report',4,'92 credits CGPA >= 2.0',NULL),
('gK7MsX','SECR2043','Operating Systems',3,'N/A',NULL),
('haLk5f','SECV4118','Industrial Training (HW)',8,'92 credits CGPA >= 2.0',NULL),
('hw9V0i','UHLB1112','English Communication Skills',1,'Muet Band 3 and below',NULL),
('i59Xns','SECD2613','System Analysis and Design',3,'N/A',NULL),
('jX3sm8','SECR2242','Computer Networks (CCNA2)',2,'SECR1213',NULL),
('jaDYXS','SECP3416','Management Information Systems',6,'N/A',NULL),
('jx11Su','SECR3032','Computer Network & Security Project I',2,'SECR3104',NULL),
('kOwrTk','SECB3103','Bioinformatics I',3,'N/A',NULL),
('lB6bai','SECP2633','Information Retrieval',3,'N/A',NULL),
('lNhaEI','SECJ1013','Programming Technique I',3,'N/A',NULL),
('lTWF3g','SECX3XXX - V2','Elective Courses - Choose 4 (13 Credits)',13,'N/A',NULL),
('mKquKF','SECI1113','Computational Mathematics',3,'N/A',NULL),
('mQkZF5','SECJ2363','Software Project Management',3,'N/A',NULL),
('n0aP0N','SECJ4134','Software Engineering Project II',4,'SECJ3032',NULL),
('nMdDLo','SECV2213','Fundamental of Computer Graphics',3,'SECV1113, SECJ1023',NULL),
('nrMTyA','SECJ2154','Object Oriented Programming',4,'SECJ1023',NULL),
('ogHhKI','SECP3623','Database Programming',3,'N/A',NULL),
('osc34g','SECJ3323','Software Design & Architecture',3,'SECJ2203',NULL),
('pg0ylu','ULRS1032','Integrity and Anti-Corruption Course',2,'N/A',NULL),
('qGh9NH','UHLB2122','Professional Communication Skills 1',2,'UHLB1112',NULL),
('qHdw4q','SECPXXX3 - P2','Elective Courses - Choose 2 (6 credits)',6,'N/A',NULL),
('qbxfkg','SECJ3483','Web Technology',3,'SECJ2154, SECV2223',NULL),
('qoIsZA','SECJ4118','Industrial Training (HW)',8,'92 credits CGPA >= 2.0',NULL),
('sQBcE0','ULRS1012','Value and Identity',2,'N/A',NULL),
('sVgf9o','SEXBXXX3 - B4','Elective Courses - Choose 2 (6 Credits)',6,'N/A',NULL),
('syGrFk','UHLB3132','Professional Communication Skills 2',2,'UHLB2122',NULL),
('tEm0LM','SECB3223','Computational Biology II',3,'N/A',NULL),
('tGUT4P','SECBXXX3 - B5','Elective Courses - Choose 3 (9 Credits)',9,'N/A',NULL),
('tfKCcU','SECI1143','Probability & Statistical Data Analysis',3,'N/A',NULL),
('thAmFK','SECV4543','Advanced Computer Graphics',3,'SECV2213',NULL),
('tksy5g','UHLx1112','Foreign Language Communication Elective',2,'N/A',NULL),
('to5fZh','SECB4313','Bioinformatics Modeling and Simulation',3,'N/A',NULL),
('u2SAHa','ULRS1182','Appreciation of Ethics and Civilizations (Malaysian Students Only)',2,'N/A',NULL),
('u9pfw6','SECP3843','Special Topic in Data Engineering',3,'N/A',NULL),
('ukZb2M','SECV3213','Fundamental of Image Processing',3,'SECV2213',NULL),
('vanMg5','SECB3104','Applications Development',4,'SECD2523, SECV1223, SECJ2203, SECJ2154',NULL),
('vu9I2j','SECP2733','Multimedia Data Modeling',3,'N/A',NULL),
('wCfLka','SECV2223','Web Programming',3,'N/A',NULL),
('wf6N4P','SECJ4463','Agent-Oriented Software Engineering',2,'SECJ2203, SECJ2154',NULL),
('xAADvu','SECR3443','Introduction to Cryptography',3,'SECR3413',NULL),
('yhiQV1','SECV3263','Multimedia Web Programming',3,'N/A',NULL);
/*!40000 ALTER TABLE `curims_course` ENABLE KEYS */;
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
