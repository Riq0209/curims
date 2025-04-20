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
-- Table structure for table `webman_curims_link_reference`
--

DROP TABLE IF EXISTS `webman_curims_link_reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_link_reference` (
  `link_ref_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `link_id` smallint(6) NOT NULL,
  `dynamic_content_num` smallint(6) NOT NULL,
  `dynamic_content_name` varchar(255) DEFAULT NULL,
  `ref_type` enum('DYNAMIC_MODULE','STATIC_FILE') NOT NULL,
  `ref_name` varchar(255) NOT NULL,
  `blob_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`link_ref_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15853 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_link_reference`
--

LOCK TABLES `webman_curims_link_reference` WRITE;
/*!40000 ALTER TABLE `webman_curims_link_reference` DISABLE KEYS */;
INSERT INTO `webman_curims_link_reference` (`link_ref_id`, `link_id`, `dynamic_content_num`, `dynamic_content_name`, `ref_type`, `ref_name`, `blob_id`) VALUES (1167,6,-2,'content_main','DYNAMIC_MODULE','webman_HTML_printer',-1),
(4295,1,-1,'','DYNAMIC_MODULE','webman_main',-1),
(7555,1,-2,'link_main','DYNAMIC_MODULE','webman_dynamic_links',-1),
(10000,5,0,NULL,'DYNAMIC_MODULE','webman_JSON',-1),
(10001,4,0,NULL,'DYNAMIC_MODULE','webman_JSON_authentication',-1),
(11933,7,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(14941,12,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(15852,8,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1);
/*!40000 ALTER TABLE `webman_curims_link_reference` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-04-20 16:31:45
