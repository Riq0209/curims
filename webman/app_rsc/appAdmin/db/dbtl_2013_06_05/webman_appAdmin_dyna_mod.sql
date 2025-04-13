-- MySQL dump 10.13  Distrib 5.1.53, for Win32 (ia32)
--
-- Host: localhost    Database: db_iwtp
-- ------------------------------------------------------
-- Server version   5.1.53-community

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `webman_appAdmin_dyna_mod`
--

DROP TABLE IF EXISTS `webman_appAdmin_dyna_mod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_appAdmin_dyna_mod` (
  `dyna_mod_name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`dyna_mod_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_appAdmin_dyna_mod`
--

LOCK TABLES `webman_appAdmin_dyna_mod` WRITE;
/*!40000 ALTER TABLE `webman_appAdmin_dyna_mod` DISABLE KEYS */;
INSERT INTO `webman_appAdmin_dyna_mod` (`dyna_mod_name`) VALUES ('appAdmin'),('app_admin_component'),('app_admin_component_access_control'),('app_admin_component_assign_groups'),('app_admin_component_assign_users'),('app_admin_component_list'),('app_admin_db_item_auth'),('app_admin_db_item_auth_list'),('app_admin_group'),('app_admin_group_assign_components'),('app_admin_group_assign_users'),('app_admin_group_list'),('app_admin_link'),('app_admin_link_assign_groups'),('app_admin_link_assign_users'),('app_admin_link_list'),('app_admin_login_info_all'),('app_admin_login_info_all_hits_content'),('app_admin_login_info_all_list'),('app_admin_login_info_daily'),('app_admin_login_info_daily_list'),('app_admin_select_application'),('app_admin_session_management'),('app_admin_user'),('app_admin_user_assign_components'),('app_admin_user_assign_groups'),('app_admin_user_list'),('webman_calendar'),('webman_calendar_interactive'),('webman_calendar_weekly'),('webman_calendar_weekly_timerow'),('webman_calendar_week_list'),('webman_component_init'),('webman_component_selector'),('webman_db_item_delete'),('webman_db_item_delete_multirows'),('webman_db_item_insert'),('webman_db_item_insert_multirows'),('webman_db_item_search'),('webman_db_item_update'),('webman_db_item_update_multirows'),('webman_db_item_view'),('webman_db_item_view_dynamic'),('webman_dynamic_links'),('webman_HTML_printer'),('webman_HTML_static_file'),('webman_image_map_links'),('webman_init'),('webman_JSON'),('webman_JSON_authentication'),('webman_link_path_generator'),('webman_main'),('webman_static_links'),('webman_text2db_map'),('webman_TLD_item_view'),('webman_TLD_item_view_dynamic'),('webman_user_agent');
/*!40000 ALTER TABLE `webman_appAdmin_dyna_mod` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-06-05 16:02:47
