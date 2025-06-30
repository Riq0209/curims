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
) ENGINE=InnoDB AUTO_INCREMENT=841 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_dyna_mod_selector`
--

LOCK TABLES `webman_curims_dyna_mod_selector` WRITE;
/*!40000 ALTER TABLE `webman_curims_dyna_mod_selector` DISABLE KEYS */;
INSERT INTO `webman_curims_dyna_mod_selector` (`dyna_mod_selector_id`, `link_ref_id`, `parent_id`, `cgi_param`, `cgi_value`, `dyna_mod_name`) VALUES (173,16063,NULL,'task','','curims_curriculum_course_plo_link'),
(174,16063,NULL,'task','curims_curriculum_add','curims_curriculum_add'),
(175,16063,NULL,'task','curims_curriculum_remove','curims_curriculum_remove'),
(665,1738,NULL,'task','curims_course_elective_list','curims_course_elective_list'),
(685,14412,NULL,'task','','curims_curriculum_course_link'),
(686,14412,NULL,'task','curims_curriculum_multirows_insert','curims_curriculum_multirows_insert'),
(687,14412,NULL,'task','curims_curriculum_multirows_update','curims_curriculum_multirows_update'),
(688,14412,NULL,'task','curims_curriculum_multirows_delete','curims_curriculum_multirows_delete'),
(693,14412,NULL,'task','curims_curriculum_course_elective_list','curims_curriculum_course_elective_list'),
(695,14412,NULL,'task','curims_curriculum_course_elective_add','curims_curriculum_course_elective_add'),
(697,14412,NULL,'task','curims_curriculum_plo_list','curims_curriculum_plo_list'),
(698,14412,NULL,'task','curims_curriculum_plo_multirows_insert','curims_curriculum_plo_multirows_insert'),
(699,14412,NULL,'task','curims_curriculum_plo_multirows_update','curims_curriculum_plo_multirows_update'),
(700,14412,NULL,'task','curims_curriculum_plo_multirows_delete','curims_curriculum_plo_multirows_delete'),
(701,13576,NULL,'task','','curims_lecturer_course_link'),
(702,13576,NULL,'task','curims_lecturer_multirows_insert','curims_lecturer_multirows_insert'),
(703,13576,NULL,'task','curims_lecturer_multirows_update','curims_lecturer_multirows_update'),
(704,13576,NULL,'task','curims_lecturer_multirows_delete','curims_lecturer_multirows_delete'),
(705,13576,NULL,'task','curims_lecturer_text2db_insert','curims_lecturer_text2db_insert'),
(706,13576,NULL,'task','curims_lecturer_text2db_update','curims_lecturer_text2db_update'),
(707,13576,NULL,'task','curims_lecturer_text2db_delete','curims_lecturer_text2db_delete'),
(708,13576,NULL,'task','curims_lecturer_course_list','curims_lecturer_course_list'),
(709,13576,NULL,'task','curims_lecturer_course_add','curims_lecturer_course_add'),
(710,13576,NULL,'task','curims_lecturer_course_remove','curims_lecturer_course_remove'),
(716,14412,NULL,'task','curims_curriculum_course_elective_remove','curims_curriculum_course_elective_remove'),
(754,5162,NULL,'task','curims_curriculum_course_elective_list','curims_curriculum_course_elective_list'),
(755,5162,NULL,'task','curims_curriculum_course_elective_add','curims_curriculum_course_elective_add'),
(756,5162,NULL,'task','curims_curriculum_course_elective_remove','curims_curriculum_course_elective_remove'),
(757,5273,NULL,'task','curims_curriculum_course_elective_list','curims_curriculum_course_elective_list'),
(758,5273,NULL,'task','curims_curriculum_course_elective_add','curims_curriculum_course_elective_add'),
(759,5273,NULL,'task','curims_curriculum_course_elective_remove','curims_curriculum_course_elective_remove'),
(765,18215,NULL,'task','','curims_course_assesment_clo_curriculum_topic_link'),
(766,18215,NULL,'task','curims_course_multirows_insert','curims_course_multirows_insert'),
(767,18215,NULL,'task','curims_course_multirows_update','curims_course_multirows_update'),
(768,18215,NULL,'task','curims_course_multirows_delete','curims_course_multirows_delete'),
(769,18215,NULL,'task','curims_course_assesment_plo_link','curims_course_assesment_plo_link'),
(771,18215,NULL,'task','curims_course_assesment_multirows_update','curims_course_assesment_multirows_update'),
(772,18215,NULL,'task','curims_course_assesment_multirows_delete','curims_course_assesment_multirows_delete'),
(777,18215,NULL,'task','curims_course_curriculum_list','curims_course_curriculum_list'),
(778,16845,NULL,'task','','curims_course_topic_schedule_link'),
(779,16845,NULL,'task','curims_course_topic_multirows_insert','curims_course_topic_multirows_insert'),
(780,16845,NULL,'task','curims_course_topic_multirows_update','curims_course_topic_multirows_update'),
(781,16845,NULL,'task','curims_course_topic_multirows_delete','curims_course_topic_multirows_delete'),
(782,18215,NULL,'task','curims_course_assesment_plo_list','curims_course_assesment_plo_list'),
(783,18215,NULL,'task','curims_course_assesment_plo_add','curims_course_assesment_plo_add'),
(784,18215,NULL,'task','curims_course_assesment_plo_remove','curims_course_assesment_plo_remove'),
(790,14412,NULL,'task','curims_curriculum_course_list_bysem','curims_curriculum_course_list_bysem'),
(794,14412,NULL,'task','curims_curriculum_course_list','curims_curriculum_course_list'),
(795,14412,NULL,'task','curims_curriculum_course_add','curims_curriculum_course_add'),
(796,14412,NULL,'task','curims_curriculum_course_remove','curims_curriculum_course_remove'),
(797,14412,NULL,'task','curims_curriculum_course_elective_list_view','curims_curriculum_course_elective_list_view'),
(799,1448,NULL,'task','','curims_dashboard'),
(803,18215,NULL,'task','curims_course_information','curims_course_information'),
(819,16845,NULL,'task','curims_course_topic_schedule_list','curims_course_topic_schedule_list'),
(820,16845,NULL,'task','curims_course_topic_schedule_multirows_insert','curims_course_topic_schedule_multirows_insert'),
(821,16845,NULL,'task','curims_course_topic_schedule_multirows_update','curims_course_topic_schedule_multirows_update'),
(822,16845,NULL,'task','curims_course_topic_schedule_multirows_delete','curims_course_topic_schedule_multirows_delete'),
(829,18215,NULL,'task','curims_course_assesment_multirows_insert','curims_course_assesment_multirows_insert'),
(831,18326,NULL,'task','curims_clo_multirows_insert','curims_clo_multirows_insert'),
(832,18326,NULL,'task','curims_clo_multirows_update','curims_clo_multirows_update'),
(833,18326,NULL,'task','curims_clo_multirows_delete','curims_clo_multirows_delete'),
(834,18326,NULL,'task','curims_clo_plo_list','curims_clo_plo_list'),
(835,18326,NULL,'task','curims_clo_plo_add','curims_clo_plo_add'),
(836,18326,NULL,'task','curims_clo_plo_remove','curims_clo_plo_remove'),
(837,18326,NULL,'task','curims_clo_plo_link','curims_clo_plo_link'),
(839,1448,NULL,'task','curims_curriculum_course_list_bysem','curims_curriculum_course_list_bysem'),
(840,1448,NULL,'task','curims_curriculum_course_elective_list_view','curims_curriculum_course_elective_list_view');
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

-- Dump completed on 2025-07-01  3:04:51
