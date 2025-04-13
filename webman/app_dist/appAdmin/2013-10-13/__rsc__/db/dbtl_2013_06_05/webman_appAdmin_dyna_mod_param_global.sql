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
-- Table structure for table `webman_appAdmin_dyna_mod_param_global`
--

DROP TABLE IF EXISTS `webman_appAdmin_dyna_mod_param_global`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_appAdmin_dyna_mod_param_global` (
  `dmpg_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `dyna_mod_name` varchar(255) DEFAULT NULL,
  `dynamic_content_num` smallint(6) DEFAULT NULL,
  `param_name` varchar(255) DEFAULT NULL,
  `param_value` blob,
  `dynamic_content_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`dmpg_id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_appAdmin_dyna_mod_param_global`
--

LOCK TABLES `webman_appAdmin_dyna_mod_param_global` WRITE;
/*!40000 ALTER TABLE `webman_appAdmin_dyna_mod_param_global` DISABLE KEYS */;
INSERT INTO `webman_appAdmin_dyna_mod_param_global` (`dmpg_id`, `dyna_mod_name`, `dynamic_content_num`, `param_name`, `param_value`, `dynamic_content_name`) VALUES (7,'webman_dynamic_links',0,'template_default','template_dynamic_links_level_0.html',''),(2,'webman_dynamic_links',0,'link_separator_tag','|',NULL),(3,'webman_dynamic_links',0,'cgi_get_data','app_name=appAdmin',NULL),(5,'webman_dynamic_links',0,'non_selected_link_color','#0099FF',NULL),(8,'webman_dynamic_links',0,'cgi_get_data_carried','session_id app_name_in_control',''),(9,'webman_dynamic_links',0,'link_path_level','0','');
/*!40000 ALTER TABLE `webman_appAdmin_dyna_mod_param_global` ENABLE KEYS */;
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
