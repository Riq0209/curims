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
-- Table structure for table `webman_appAdmin_link_reference`
--

DROP TABLE IF EXISTS `webman_appAdmin_link_reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_appAdmin_link_reference` (
  `link_ref_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `link_id` smallint(6) DEFAULT NULL,
  `dynamic_content_num` smallint(6) DEFAULT NULL,
  `twal_test_link_reference` varchar(255) DEFAULT NULL,
  `ref_type` varchar(14) DEFAULT NULL,
  `ref_name` varchar(255) DEFAULT NULL,
  `blob_id` smallint(6) DEFAULT NULL,
  `dynamic_content_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`link_ref_id`)
) ENGINE=MyISAM AUTO_INCREMENT=8402 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_appAdmin_link_reference`
--

LOCK TABLES `webman_appAdmin_link_reference` WRITE;
/*!40000 ALTER TABLE `webman_appAdmin_link_reference` DISABLE KEYS */;
INSERT INTO `webman_appAdmin_link_reference` (`link_ref_id`, `link_id`, `dynamic_content_num`, `twal_test_link_reference`, `ref_type`, `ref_name`, `blob_id`, `dynamic_content_name`) VALUES (5594,1,0,NULL,'DYNAMIC_MODULE','webman_dynamic_links',0,NULL),(7550,2,0,NULL,'DYNAMIC_MODULE','webman_dynamic_links',0,NULL),(1338,3,0,NULL,'DYNAMIC_MODULE','webman_dynamic_links',0,NULL),(2436,1,1,NULL,'DYNAMIC_MODULE','app_admin_user',0,NULL),(1544,5,0,NULL,'DYNAMIC_MODULE','webman_dynamic_links',0,NULL),(7800,5,1,NULL,'DYNAMIC_MODULE','app_admin_group',0,NULL),(1368,2,1,NULL,'DYNAMIC_MODULE','app_admin_component',0,NULL),(4780,6,0,NULL,'DYNAMIC_MODULE','webman_dynamic_links',0,NULL),(5380,6,1,NULL,'DYNAMIC_MODULE','app_admin_db_item_auth',0,NULL),(4082,3,1,NULL,'DYNAMIC_MODULE','webman_dynamic_links',0,NULL),(2327,7,2,NULL,'DYNAMIC_MODULE','app_admin_login_info_all',0,NULL),(7453,8,2,NULL,'DYNAMIC_MODULE','app_admin_login_info_daily',0,NULL),(1151,11,-1,NULL,'DYNAMIC_MODULE','webman_main',NULL,''),(3000,13,2,NULL,'DYNAMIC_MODULE','app_admin_login_info_all_hits_content',-1,''),(2762,13,1,NULL,'DYNAMIC_MODULE','webman_link_path_generator',-1,''),(5015,14,0,NULL,'DYNAMIC_MODULE','webman_dynamic_links',-1,''),(2536,14,1,NULL,'DYNAMIC_MODULE','app_admin_link',-1,''),(8401,9,2,NULL,'DYNAMIC_MODULE','app_admin_login_info_monthly',-1,'');
/*!40000 ALTER TABLE `webman_appAdmin_link_reference` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-06-05 16:02:49
