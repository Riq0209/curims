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
-- Table structure for table `webman_appAdmin_dyna_mod_param`
--

DROP TABLE IF EXISTS `webman_appAdmin_dyna_mod_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_appAdmin_dyna_mod_param` (
  `link_ref_id` smallint(6) DEFAULT NULL,
  `scdmr_id` smallint(6) DEFAULT NULL,
  `param_name` varchar(255) DEFAULT NULL,
  `param_value` blob,
  `dyna_mod_selector_id` smallint(6) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_appAdmin_dyna_mod_param`
--

LOCK TABLES `webman_appAdmin_dyna_mod_param` WRITE;
/*!40000 ALTER TABLE `webman_appAdmin_dyna_mod_param` DISABLE KEYS */;
INSERT INTO `webman_appAdmin_dyna_mod_param` (`link_ref_id`, `scdmr_id`, `param_name`, `param_value`, `dyna_mod_selector_id`) VALUES (2436,0,'template_default','template_app_admin_user.html',NULL),(7800,0,'template_default','template_app_admin_group.html',NULL),(1368,0,'template_default','template_app_admin_component.html',NULL),(5380,0,'template_default','template_app_admin_db_item_auth.html',NULL),(4082,NULL,'link_separator_tag','|',NULL),(4082,0,'link_path_level','1',NULL),(4082,0,'non_selected_link_color','#0099FF',NULL),(4082,-1,'cgi_get_data_carried','session_id app_name_in_control',-1),(2327,0,'template_default','template_app_admin_login_info_all.html',NULL),(7453,0,'template_default','template_app_admin_login_info_all.html',NULL),(4082,NULL,'template_default','template_dynamic_links_level_1_01.html',NULL),(1151,NULL,'sub_component','app_admin_select_application',NULL),(1151,-1,'template_default','template_basic.html',-1),(2762,-1,'carried_get_data','session_id app_name_in_control order_by_login_list dbisn_login_list dmisn_login_list',-1),(2762,-1,'last_not_active','1',-1),(2536,-1,'template_default','template_app_admin_link.html',-1),(8401,-1,'template_default','template_app_admin_login_info_monthly.html',-1);
/*!40000 ALTER TABLE `webman_appAdmin_dyna_mod_param` ENABLE KEYS */;
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
