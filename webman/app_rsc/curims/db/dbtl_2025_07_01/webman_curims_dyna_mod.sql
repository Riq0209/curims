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
-- Table structure for table `webman_curims_dyna_mod`
--

DROP TABLE IF EXISTS `webman_curims_dyna_mod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_dyna_mod` (
  `dyna_mod_name` varchar(255) NOT NULL,
  PRIMARY KEY (`dyna_mod_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_dyna_mod`
--

LOCK TABLES `webman_curims_dyna_mod` WRITE;
/*!40000 ALTER TABLE `webman_curims_dyna_mod` DISABLE KEYS */;
INSERT INTO `webman_curims_dyna_mod` (`dyna_mod_name`) VALUES ('curims'),
('curims_clo_multirows_delete'),
('curims_clo_multirows_insert'),
('curims_clo_multirows_update'),
('curims_clo_plo_add'),
('curims_clo_plo_link'),
('curims_clo_plo_list'),
('curims_clo_plo_remove'),
('curims_course_assesment_clo_curriculum_topic_link'),
('curims_course_assesment_multirows_delete'),
('curims_course_assesment_multirows_insert'),
('curims_course_assesment_multirows_update'),
('curims_course_assesment_plo_add'),
('curims_course_assesment_plo_link'),
('curims_course_assesment_plo_list'),
('curims_course_assesment_plo_remove'),
('curims_course_clo_list'),
('curims_course_clo_multirows_delete'),
('curims_course_clo_multirows_insert'),
('curims_course_clo_multirows_update'),
('curims_course_curriculum_list'),
('curims_course_information'),
('curims_course_multirows_delete'),
('curims_course_multirows_insert'),
('curims_course_multirows_update'),
('curims_course_topic_multirows_delete'),
('curims_course_topic_multirows_insert'),
('curims_course_topic_multirows_update'),
('curims_course_topic_schedule_link'),
('curims_course_topic_schedule_list'),
('curims_course_topic_schedule_multirows_delete'),
('curims_course_topic_schedule_multirows_insert'),
('curims_course_topic_schedule_multirows_update'),
('curims_curriculum_course_add'),
('curims_curriculum_course_elective_add'),
('curims_curriculum_course_elective_list'),
('curims_curriculum_course_elective_list_view'),
('curims_curriculum_course_elective_remove'),
('curims_curriculum_course_link'),
('curims_curriculum_course_list'),
('curims_curriculum_course_list_bysem'),
('curims_curriculum_course_remove'),
('curims_curriculum_multirows_delete'),
('curims_curriculum_multirows_insert'),
('curims_curriculum_multirows_update'),
('curims_curriculum_plo_list'),
('curims_curriculum_plo_multirows_delete'),
('curims_curriculum_plo_multirows_insert'),
('curims_curriculum_plo_multirows_update'),
('curims_dashboard'),
('curims_elective_add'),
('curims_elective_list'),
('curims_elective_remove'),
('curims_lecturer_course_add'),
('curims_lecturer_course_link'),
('curims_lecturer_course_list'),
('curims_lecturer_course_remove'),
('curims_lecturer_multirows_delete'),
('curims_lecturer_multirows_insert'),
('curims_lecturer_multirows_update'),
('curims_lecturer_text2db_delete'),
('curims_lecturer_text2db_insert'),
('curims_lecturer_text2db_update'),
('curims_schedule_list'),
('curims_schedule_multirows_delete'),
('curims_schedule_multirows_insert'),
('curims_schedule_multirows_update'),
('webman_calendar'),
('webman_calendar_interactive'),
('webman_calendar_weekly'),
('webman_calendar_weekly_timerow'),
('webman_calendar_week_list'),
('webman_component_init'),
('webman_component_selector'),
('webman_db_item_delete'),
('webman_db_item_delete_multirows'),
('webman_db_item_insert'),
('webman_db_item_insert_multirows'),
('webman_db_item_search'),
('webman_db_item_update'),
('webman_db_item_update_multirows'),
('webman_db_item_view'),
('webman_db_item_view_dynamic'),
('webman_dynamic_links'),
('webman_FTP_list'),
('webman_FTP_upload'),
('webman_HTML_printer'),
('webman_HTML_static_file'),
('webman_image_map_links'),
('webman_init'),
('webman_JSON'),
('webman_JSON_authentication'),
('webman_link_path_generator'),
('webman_main'),
('webman_sitemap'),
('webman_static_links'),
('webman_text2db_map'),
('webman_TLD_item_view'),
('webman_TLD_item_view_dynamic'),
('webman_user_agent');
/*!40000 ALTER TABLE `webman_curims_dyna_mod` ENABLE KEYS */;
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
