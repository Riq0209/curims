-- MySQL dump 10.13  Distrib 5.1.53, for Win32 (ia32)
--
-- Host: localhost    Database: db_wm11apps
-- ------------------------------------------------------
-- Server version	5.1.53-community

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
-- Table structure for table `webman_wmcudas_dyna_mod_selector`
--

DROP TABLE IF EXISTS `webman_wmcudas_dyna_mod_selector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_wmcudas_dyna_mod_selector` (
  `dyna_mod_selector_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `link_ref_id` smallint(6) DEFAULT NULL,
  `parent_id` smallint(6) DEFAULT NULL,
  `cgi_param` varchar(100) DEFAULT NULL,
  `cgi_value` varchar(100) DEFAULT NULL,
  `dyna_mod_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`dyna_mod_selector_id`)
) ENGINE=InnoDB AUTO_INCREMENT=275 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_wmcudas_dyna_mod_selector`
--

LOCK TABLES `webman_wmcudas_dyna_mod_selector` WRITE;
/*!40000 ALTER TABLE `webman_wmcudas_dyna_mod_selector` DISABLE KEYS */;
INSERT INTO `webman_wmcudas_dyna_mod_selector` (`dyna_mod_selector_id`, `link_ref_id`, `parent_id`, `cgi_param`, `cgi_value`, `dyna_mod_name`) VALUES (8,12290,NULL,'task','','wmcudas_user_apps_group_link'),(9,12290,NULL,'task','wmcudas_user_multirows_insert','wmcudas_user_multirows_insert'),(10,12290,NULL,'task','wmcudas_user_multirows_update','wmcudas_user_multirows_update'),(11,12290,NULL,'task','wmcudas_user_multirows_delete','wmcudas_user_multirows_delete'),(12,12290,NULL,'task','wmcudas_user_text2db_insert','wmcudas_user_text2db_insert'),(13,12290,NULL,'task','wmcudas_user_text2db_update','wmcudas_user_text2db_update'),(14,12290,NULL,'task','wmcudas_user_text2db_delete','wmcudas_user_text2db_delete'),(15,12290,NULL,'task','wmcudas_user_apps_list','wmcudas_user_apps_list'),(16,12290,NULL,'task','wmcudas_user_apps_add','wmcudas_user_apps_add'),(17,12290,NULL,'task','wmcudas_user_apps_remove','wmcudas_user_apps_remove'),(18,12290,NULL,'task','wmcudas_user_group_list','wmcudas_user_group_list'),(19,12290,NULL,'task','wmcudas_user_group_add','wmcudas_user_group_add'),(20,12290,NULL,'task','wmcudas_user_group_remove','wmcudas_user_group_remove'),(21,18265,NULL,'task','','wmcudas_group_apps_user_link'),(22,18265,NULL,'task','wmcudas_group_multirows_insert','wmcudas_group_multirows_insert'),(23,18265,NULL,'task','wmcudas_group_multirows_update','wmcudas_group_multirows_update'),(24,18265,NULL,'task','wmcudas_group_multirows_delete','wmcudas_group_multirows_delete'),(25,18265,NULL,'task','wmcudas_group_text2db_insert','wmcudas_group_text2db_insert'),(26,18265,NULL,'task','wmcudas_group_text2db_update','wmcudas_group_text2db_update'),(27,18265,NULL,'task','wmcudas_group_text2db_delete','wmcudas_group_text2db_delete'),(28,18265,NULL,'task','wmcudas_group_apps_list','wmcudas_group_apps_list'),(29,18265,NULL,'task','wmcudas_group_apps_add','wmcudas_group_apps_add'),(30,18265,NULL,'task','wmcudas_group_apps_remove','wmcudas_group_apps_remove'),(31,18265,NULL,'task','wmcudas_group_user_list','wmcudas_group_user_list'),(32,18265,NULL,'task','wmcudas_group_user_add','wmcudas_group_user_add'),(33,18265,NULL,'task','wmcudas_group_user_remove','wmcudas_group_user_remove'),(262,17259,NULL,'task','','wmcudas_apps_group_user_link'),(263,17259,NULL,'task','wmcudas_apps_multirows_insert','wmcudas_apps_multirows_insert'),(264,17259,NULL,'task','wmcudas_apps_multirows_update','wmcudas_apps_multirows_update'),(265,17259,NULL,'task','wmcudas_apps_multirows_delete','wmcudas_apps_multirows_delete'),(266,17259,NULL,'task','wmcudas_apps_text2db_insert','wmcudas_apps_text2db_insert'),(267,17259,NULL,'task','wmcudas_apps_text2db_update','wmcudas_apps_text2db_update'),(268,17259,NULL,'task','wmcudas_apps_text2db_delete','wmcudas_apps_text2db_delete'),(269,17259,NULL,'task','wmcudas_apps_group_list','wmcudas_apps_group_list'),(270,17259,NULL,'task','wmcudas_apps_group_add','wmcudas_apps_group_add'),(271,17259,NULL,'task','wmcudas_apps_group_remove','wmcudas_apps_group_remove'),(272,17259,NULL,'task','wmcudas_apps_user_list','wmcudas_apps_user_list'),(273,17259,NULL,'task','wmcudas_apps_user_add','wmcudas_apps_user_add'),(274,17259,NULL,'task','wmcudas_apps_user_remove','wmcudas_apps_user_remove');
/*!40000 ALTER TABLE `webman_wmcudas_dyna_mod_selector` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-10-13  7:12:00
