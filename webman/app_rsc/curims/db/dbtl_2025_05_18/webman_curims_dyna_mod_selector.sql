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
-- Table structure for table `webman_curims_dyna_mod_selector`
--

DROP TABLE IF EXISTS `webman_curims_dyna_mod_selector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_dyna_mod_selector` (
  `dyna_mod_selector_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `link_ref_id` smallint(6) DEFAULT NULL,
  `parent_id` smallint(6) DEFAULT NULL,
  `cgi_param` varchar(100) DEFAULT NULL,
  `cgi_value` varchar(100) DEFAULT NULL,
  `dyna_mod_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`dyna_mod_selector_id`)
) ENGINE=InnoDB AUTO_INCREMENT=261 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_dyna_mod_selector`
--

LOCK TABLES `webman_curims_dyna_mod_selector` WRITE;
/*!40000 ALTER TABLE `webman_curims_dyna_mod_selector` DISABLE KEYS */;
INSERT INTO `webman_curims_dyna_mod_selector` (`dyna_mod_selector_id`, `link_ref_id`, `parent_id`, `cgi_param`, `cgi_value`, `dyna_mod_name`) VALUES (173,16063,NULL,'task','','curims_curriculum_course_plo_link'),
(174,16063,NULL,'task','curims_curriculum_add','curims_curriculum_add'),
(175,16063,NULL,'task','curims_curriculum_remove','curims_curriculum_remove'),
(242,10239,NULL,'task','','curims_course_list'),
(243,10239,NULL,'task','curims_course_multirows_insert','curims_course_multirows_insert'),
(244,10239,NULL,'task','curims_course_multirows_update','curims_course_multirows_update'),
(245,10239,NULL,'task','curims_course_multirows_delete','curims_course_multirows_delete'),
(246,14822,NULL,'task','','curims_plo_list'),
(247,14822,NULL,'task','curims_plo_multirows_insert','curims_plo_multirows_insert'),
(248,14822,NULL,'task','curims_plo_multirows_update','curims_plo_multirows_update'),
(249,14822,NULL,'task','curims_plo_multirows_delete','curims_plo_multirows_delete'),
(250,17529,NULL,'task','','curims_curriculum_course_details_plo_link'),
(251,17529,NULL,'task','curims_curriculum_multirows_insert','curims_curriculum_multirows_insert'),
(252,17529,NULL,'task','curims_curriculum_multirows_update','curims_curriculum_multirows_update'),
(253,17529,NULL,'task','curims_curriculum_multirows_delete','curims_curriculum_multirows_delete'),
(254,16283,NULL,'task','','curims_curriculum_course_list'),
(255,16283,NULL,'task','curims_curriculum_course_add','curims_curriculum_course_add'),
(256,16283,NULL,'task','curims_curriculum_course_remove','curims_curriculum_course_remove'),
(257,10897,NULL,'task','','curims_curriculum_details_list'),
(258,15376,NULL,'task','','curims_curriculum_plo_list'),
(259,15376,NULL,'task','curims_curriculum_plo_add','curims_curriculum_plo_add'),
(260,15376,NULL,'task','curims_curriculum_plo_remove','curims_curriculum_plo_remove');
/*!40000 ALTER TABLE `webman_curims_dyna_mod_selector` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-05-18  2:56:32
