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
-- Table structure for table `webman_curims_blob_content`
--

DROP TABLE IF EXISTS `webman_curims_blob_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_blob_content` (
  `blob_id` smallint(6) NOT NULL,
  `content` mediumblob DEFAULT NULL,
  PRIMARY KEY (`blob_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_blob_content`
--

LOCK TABLES `webman_curims_blob_content` WRITE;
/*!40000 ALTER TABLE `webman_curims_blob_content` DISABLE KEYS */;
/*!40000 ALTER TABLE `webman_curims_blob_content` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:50
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
-- Table structure for table `webman_curims_blob_content_temp`
--

DROP TABLE IF EXISTS `webman_curims_blob_content_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_blob_content_temp` (
  `blob_id` smallint(6) NOT NULL,
  `content` mediumblob DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `extension` varchar(255) DEFAULT NULL,
  `owner_entity_id` smallint(6) DEFAULT NULL,
  `owner_entity_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`blob_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_blob_content_temp`
--

LOCK TABLES `webman_curims_blob_content_temp` WRITE;
/*!40000 ALTER TABLE `webman_curims_blob_content_temp` DISABLE KEYS */;
/*!40000 ALTER TABLE `webman_curims_blob_content_temp` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:50
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
-- Table structure for table `webman_curims_blob_info`
--

DROP TABLE IF EXISTS `webman_curims_blob_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_blob_info` (
  `blob_id` smallint(6) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `extension` varchar(25) NOT NULL,
  `upload_date` date NOT NULL,
  `upload_time` time NOT NULL,
  `mime_type` varchar(255) NOT NULL,
  `owner_entity_id` smallint(6) NOT NULL,
  `owner_entity_name` varchar(255) NOT NULL,
  `language` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`blob_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_blob_info`
--

LOCK TABLES `webman_curims_blob_info` WRITE;
/*!40000 ALTER TABLE `webman_curims_blob_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `webman_curims_blob_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:50
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
-- Table structure for table `webman_curims_blob_parent_info`
--

DROP TABLE IF EXISTS `webman_curims_blob_parent_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_blob_parent_info` (
  `blob_id` smallint(6) NOT NULL,
  `parent_blob_id` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_blob_parent_info`
--

LOCK TABLES `webman_curims_blob_parent_info` WRITE;
/*!40000 ALTER TABLE `webman_curims_blob_parent_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `webman_curims_blob_parent_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:50
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
-- Table structure for table `webman_curims_calendar`
--

DROP TABLE IF EXISTS `webman_curims_calendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_calendar` (
  `cal_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `year` smallint(6) NOT NULL,
  `month` smallint(6) NOT NULL,
  `date` smallint(6) NOT NULL,
  `day` smallint(6) NOT NULL,
  `month_abbr` varchar(10) DEFAULT NULL,
  `day_abbr` varchar(10) DEFAULT NULL,
  `next_cal_id` smallint(6) DEFAULT NULL,
  `prev_cal_id` smallint(6) DEFAULT NULL,
  `iso_ymd` date DEFAULT NULL,
  PRIMARY KEY (`cal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_calendar`
--

LOCK TABLES `webman_curims_calendar` WRITE;
/*!40000 ALTER TABLE `webman_curims_calendar` DISABLE KEYS */;
/*!40000 ALTER TABLE `webman_curims_calendar` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:50
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
-- Table structure for table `webman_curims_cgi_var_cache`
--

DROP TABLE IF EXISTS `webman_curims_cgi_var_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_cgi_var_cache` (
  `id_cgi_var_cache` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(15) DEFAULT NULL,
  `link_id` smallint(6) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `value` text DEFAULT NULL,
  `active_mode` smallint(6) DEFAULT 1,
  PRIMARY KEY (`id_cgi_var_cache`)
) ENGINE=InnoDB AUTO_INCREMENT=351237 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:50
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
-- Table structure for table `webman_curims_comp_auth`
--

DROP TABLE IF EXISTS `webman_curims_comp_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_comp_auth` (
  `comp_name` varchar(100) DEFAULT NULL,
  `login_name` varchar(50) DEFAULT NULL,
  `group_name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_comp_auth`
--

LOCK TABLES `webman_curims_comp_auth` WRITE;
/*!40000 ALTER TABLE `webman_curims_comp_auth` DISABLE KEYS */;
INSERT INTO `webman_curims_comp_auth` (`comp_name`, `login_name`, `group_name`) VALUES ('web_man_JSON',NULL,'COM_JSON'),
('web_man_JSON_authentication',NULL,'COM_JSON'),
('curims_lecturer_multirows_insert',NULL,'ADMIN'),
('curims_lecturer_multirows_update',NULL,'ADMIN'),
('curims_lecturer_multirows_delete',NULL,'ADMIN'),
('curims_lecturer_course_add',NULL,'ADMIN'),
('curims_lecturer_course_remove',NULL,'ADMIN'),
('curims_curriculum_multirows_insert',NULL,'ADMIN'),
('curims_curriculum_multirows_delete',NULL,'ADMIN'),
('curims_curriculum_multirows_update',NULL,'ADMIN'),
('curims_course_multirows_delete',NULL,'ADMIN'),
('curims_course_multirows_insert',NULL,'ADMIN'),
('curims_course_multirows_update',NULL,'ADMIN');
/*!40000 ALTER TABLE `webman_curims_comp_auth` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:50
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
-- Table structure for table `webman_curims_db_item_auth`
--

DROP TABLE IF EXISTS `webman_curims_db_item_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_db_item_auth` (
  `id_dbia` int(11) NOT NULL AUTO_INCREMENT,
  `login_name` varchar(50) DEFAULT NULL,
  `group_name` varchar(50) DEFAULT NULL,
  `table_name` varchar(50) DEFAULT NULL,
  `key_field_name` varchar(50) DEFAULT NULL,
  `key_field_value` varchar(50) DEFAULT NULL,
  `mode_insert` tinyint(1) DEFAULT NULL,
  `mode_update` tinyint(1) DEFAULT NULL,
  `mode_delete` tinyint(1) DEFAULT NULL,
  `set_by_login_name` varchar(15) DEFAULT NULL,
  `set_by_app_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_dbia`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_db_item_auth`
--

LOCK TABLES `webman_curims_db_item_auth` WRITE;
/*!40000 ALTER TABLE `webman_curims_db_item_auth` DISABLE KEYS */;
/*!40000 ALTER TABLE `webman_curims_db_item_auth` ENABLE KEYS */;
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
-- Table structure for table `webman_curims_dictionary_dyna_mod`
--

DROP TABLE IF EXISTS `webman_curims_dictionary_dyna_mod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_dictionary_dyna_mod` (
  `phrase_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `lang_id` smallint(6) NOT NULL,
  `dyna_mod_name` varchar(255) DEFAULT NULL,
  `phrase` varchar(255) DEFAULT NULL,
  `phrase_word_num` smallint(6) DEFAULT NULL,
  `phrase_translate` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`phrase_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_dictionary_dyna_mod`
--

LOCK TABLES `webman_curims_dictionary_dyna_mod` WRITE;
/*!40000 ALTER TABLE `webman_curims_dictionary_dyna_mod` DISABLE KEYS */;
/*!40000 ALTER TABLE `webman_curims_dictionary_dyna_mod` ENABLE KEYS */;
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
-- Table structure for table `webman_curims_dictionary_language`
--

DROP TABLE IF EXISTS `webman_curims_dictionary_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_dictionary_language` (
  `lang_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `language` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`lang_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_dictionary_language`
--

LOCK TABLES `webman_curims_dictionary_language` WRITE;
/*!40000 ALTER TABLE `webman_curims_dictionary_language` DISABLE KEYS */;
/*!40000 ALTER TABLE `webman_curims_dictionary_language` ENABLE KEYS */;
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
-- Table structure for table `webman_curims_dictionary_link`
--

DROP TABLE IF EXISTS `webman_curims_dictionary_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_dictionary_link` (
  `link_lang_id` smallint(6) NOT NULL,
  `link_id` smallint(6) NOT NULL,
  `lang_id` smallint(6) NOT NULL,
  `link_name_translate` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`link_lang_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_dictionary_link`
--

LOCK TABLES `webman_curims_dictionary_link` WRITE;
/*!40000 ALTER TABLE `webman_curims_dictionary_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `webman_curims_dictionary_link` ENABLE KEYS */;
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
-- Table structure for table `webman_curims_dyna_mod_param`
--

DROP TABLE IF EXISTS `webman_curims_dyna_mod_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_dyna_mod_param` (
  `dmp_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `link_ref_id` smallint(6) NOT NULL,
  `scdmr_id` smallint(6) NOT NULL,
  `dyna_mod_selector_id` smallint(6) NOT NULL,
  `param_name` varchar(255) DEFAULT NULL,
  `param_value` text DEFAULT NULL,
  PRIMARY KEY (`dmp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5317 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_dyna_mod_param`
--

LOCK TABLES `webman_curims_dyna_mod_param` WRITE;
/*!40000 ALTER TABLE `webman_curims_dyna_mod_param` DISABLE KEYS */;
INSERT INTO `webman_curims_dyna_mod_param` (`dmp_id`, `link_ref_id`, `scdmr_id`, `dyna_mod_selector_id`, `param_name`, `param_value`) VALUES (1,10000,-1,-1,'sql','select id_user, login_name, full_name, description, web_service_url from webman_curims_user order by full_name'),
(3,7555,-1,-1,'link_path_level','1'),
(975,-1,-1,173,'order_field_cgi_var','order_curims_curriculum'),
(976,-1,-1,173,'order_field_caption','Curriculum Code:Curriculum Name:Intake Session:Intake Semester:Intake Year:Plo:Created Time'),
(977,-1,-1,173,'order_field_name','curriculum_code:curriculum_name:intake_session:intake_semester:intake_year:plo:created_time'),
(978,-1,-1,173,'map_caption_field','Curriculum Code => curriculum_code, Curriculum Name => curriculum_name, Intake Session => intake_session, Intake Semester => intake_semester, Intake Year => intake_year, Plo => plo, Created Time => created_time'),
(979,-1,-1,173,'db_items_set_number_var','dbisn_curims_curriculum'),
(980,-1,-1,173,'dynamic_menu_items_set_number_var','dmisn_curims_curriculum'),
(981,-1,-1,173,'inl_var_name','inl_curims_curriculum'),
(982,-1,-1,173,'lsn_var_name','lsn_curims_curriculum'),
(983,-1,-1,173,'table_name','curims_curriculum'),
(984,-1,-1,174,'order_field_cgi_var','order_curims_curriculum_AFLS'),
(985,-1,-1,174,'order_field_caption','Curriculum Code:Curriculum Name:Intake Session:Intake Semester:Intake Year:Plo:Created Time'),
(986,-1,-1,174,'order_field_name','curriculum_code:curriculum_name:intake_session:intake_semester:intake_year:plo:created_time'),
(987,-1,-1,174,'map_caption_field','Curriculum Code => curriculum_code, Curriculum Name => curriculum_name, Intake Session => intake_session, Intake Semester => intake_semester, Intake Year => intake_year, Plo => plo, Created Time => created_time'),
(988,-1,-1,174,'db_items_set_number_var','dbisn_curims_curriculum_AFLS'),
(989,-1,-1,174,'dynamic_menu_items_set_number_var','dmisn_curims_curriculum_AFLS'),
(990,-1,-1,174,'inl_var_name','inl_curims_curriculum_AFLS'),
(991,-1,-1,174,'lsn_var_name','lsn_curims_curriculum_AFLS'),
(992,-1,-1,174,'link_path_additional_get_data','task=&button_submit='),
(993,-1,-1,174,'sql','select * from  where  not in (select  from  where =\'$cgi__\') order by $cgi_order_curims_curriculum_AFLS_'),
(994,-1,-1,175,'delete_keys_str','=\'$cgi__\''),
(995,-1,-1,175,'last_phase_cgi_data_reset','task=\'curims_curriculum_list\' button_submit'),
(2794,-1,-1,447,'sql','select * from curims_assesment where id_course_62base=\'$cgi_id_course_62base_\' order by $cgi_order_curims_assesment_'),
(4008,-1,-1,665,'sql','	select * from curims_elective where id_course_62base=\'$cgi_id_course_62base_\' order by $cgi_order_curims_elective_'),
(4009,-1,-1,665,'order_field_cgi_var','order_curims_elective'),
(4013,-1,-1,665,'order_field_caption','Course Code Elective:Course Name:Credit Hour	'),
(4014,-1,-1,665,'order_field_name','course_code_elective:course_name:credit_hour	'),
(4015,-1,-1,665,'map_caption_field','Course Code Elective =&amp;gt; course_code_elective, Course Name =&amp;gt; course_name, Credit Hour =&amp;gt; credit_hour	'),
(4016,-1,-1,665,'inl_var_name','inl_curims_elective'),
(4017,-1,-1,665,'lsn_var_name','lsn_curims_elective'),
(4018,-1,-1,665,'dynamic_menu_items_set_number_var','dmisn_curims_elective'),
(4019,-1,-1,665,'db_items_set_number_var','dmisn_curims_elective'),
(4021,-1,-1,665,'link_path_additional_get_data','task=&amp;amp;button_submit=	'),
(4136,-1,-1,685,'order_field_cgi_var','order_curims_curriculum'),
(4137,-1,-1,685,'order_field_caption','Curriculum Code:Curriculum Name:Intake Session:Intake Year:Intake Semester'),
(4138,-1,-1,685,'order_field_name','curriculum_code:curriculum_name:intake_session:intake_year:intake_semester'),
(4139,-1,-1,685,'map_caption_field','Curriculum Code => curriculum_code, Curriculum Name => curriculum_name, Intake Session => intake_session, Intake Year => intake_year, Intake Semester => intake_semester'),
(4140,-1,-1,685,'db_items_set_number_var','dbisn_curims_curriculum'),
(4141,-1,-1,685,'dynamic_menu_items_set_number_var','dmisn_curims_curriculum'),
(4142,-1,-1,685,'inl_var_name','inl_curims_curriculum'),
(4143,-1,-1,685,'lsn_var_name','lsn_curims_curriculum'),
(4144,-1,-1,685,'table_name','curims_curriculum'),
(4145,-1,-1,686,'table_name','curims_curriculum'),
(4146,-1,-1,686,'check_on_cgi_data','$db_curriculum_code $db_curriculum_name $db_intake_session $db_intake_year $db_intake_semester '),
(4147,-1,-1,686,'template_default_confirm','curims_curriculum_multirows_insert_confirm.html'),
(4148,-1,-1,687,'table_name','curims_curriculum'),
(4149,-1,-1,687,'check_on_cgi_data','$db_curriculum_code $db_curriculum_name $db_intake_session $db_intake_year $db_intake_semester '),
(4150,-1,-1,687,'template_default_confirm','curims_curriculum_multirows_update_confirm.html'),
(4151,-1,-1,687,'update_keys_str','id_curriculum_62base=\'$cgi_id_curriculum_62base_\''),
(4152,-1,-1,688,'table_name','curims_curriculum'),
(4153,-1,-1,688,'template_default','curims_curriculum_multirows_delete.html'),
(4154,-1,-1,688,'delete_keys_str','id_curriculum_62base=\'$cgi_id_curriculum_62base_\''),
(4191,-1,-1,693,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code	'),
(4192,-1,-1,693,'order_field_name','course_code:course_name:credit_hour:prerequisite_code	'),
(4193,-1,-1,693,'map_caption_field','Course Code =&gt; course_code, Course Name =&gt; course_name, Credit Hour =&gt; credit_hour, Prerequisite Code =&gt; prerequisite_code	'),
(4201,-1,-1,693,'link_path_additional_get_data','task=&amp;button_submit=	'),
(4221,-1,-1,695,'order_field_cgi_var','order_curims_course_AFLS	'),
(4222,-1,-1,695,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code	'),
(4223,-1,-1,695,'link_path_additional_get_data','task=&amp;button_submit='),
(4224,-1,-1,695,'order_field_name','course_code:course_name:credit_hour:prerequisite_code	'),
(4225,-1,-1,695,'map_caption_field','Course Code =&amp;gt; course_code, Course Name =&amp;gt; course_name, Credit Hour =&amp;gt; credit_hour, Prerequisite Code =&amp;gt; prerequisite_code	'),
(4226,-1,-1,695,'inl_var_name','inl_curims_course_AFLS'),
(4227,-1,-1,695,'lsn_var_name','lsn_curims_course_AFLS'),
(4228,-1,-1,695,'dynamic_menu_items_set_number_var','dmisn_curims_course_AFLS	'),
(4230,-1,-1,695,'db_items_set_number_var','dbisn_curims_course_AFLS'),
(4233,-1,-1,692,'sql','select t_view.*, t_med.* from curims_course t_view, curims_elective t_med where t_med.id_currcourse_62base =\'$cgi_id_currcourse_62base_\' and t_med.id_course_62base = t_view.id_course_62base order by $cgi_order_curims_course_'),
(4249,-1,-1,697,'order_field_cgi_var','order_curims_plo'),
(4250,-1,-1,697,'order_field_caption','Plo Code:Plo Tag:Plo Description'),
(4251,-1,-1,697,'order_field_name','plo_code:plo_tag:plo_description'),
(4252,-1,-1,697,'map_caption_field','Plo Code => plo_code, Plo Tag => plo_tag, Plo Description => plo_description'),
(4253,-1,-1,697,'db_items_set_number_var','dbisn_curims_plo'),
(4254,-1,-1,697,'dynamic_menu_items_set_number_var','dmisn_curims_plo'),
(4255,-1,-1,697,'inl_var_name','inl_curims_plo'),
(4256,-1,-1,697,'lsn_var_name','lsn_curims_plo'),
(4257,-1,-1,697,'sql','select * from curims_plo where id_curriculum_62base=\'$cgi_id_curriculum_62base_\' order by $cgi_order_curims_plo_'),
(4258,-1,-1,697,'link_path_additional_get_data','task=&button_submit='),
(4259,-1,-1,698,'table_name','curims_plo'),
(4260,-1,-1,698,'check_on_cgi_data','$db_plo_code '),
(4261,-1,-1,698,'template_default_confirm','curims_curriculum_plo_multirows_insert_confirm.html'),
(4263,-1,-1,698,'check_on_fields_duplication','plo_code&plo_tag&plo_description'),
(4264,-1,-1,698,'last_phase_cgi_data_reset','task=\'curims_curriculum_plo_list\' button_submit'),
(4265,-1,-1,698,'link_path_additional_get_data','task=&button_submit='),
(4266,-1,-1,699,'table_name','curims_plo'),
(4267,-1,-1,699,'check_on_cgi_data','$db_plo_code '),
(4268,-1,-1,699,'template_default_confirm','curims_curriculum_plo_multirows_update_confirm.html'),
(4269,-1,-1,699,'update_keys_str','id_plo_62base=\'$cgi_id_plo_62base_\''),
(4272,-1,-1,699,'last_phase_cgi_data_reset','task=\'curims_curriculum_plo_list\' button_submit'),
(4273,-1,-1,699,'link_path_additional_get_data','task=&button_submit='),
(4274,-1,-1,700,'table_name','curims_plo'),
(4275,-1,-1,700,'template_default','curims_curriculum_plo_multirows_delete.html'),
(4276,-1,-1,700,'delete_keys_str','id_plo_62base=\'$cgi_id_plo_62base_\''),
(4277,-1,-1,700,'last_phase_cgi_data_reset','task=\'curims_curriculum_plo_list\' button_submit'),
(4278,-1,-1,700,'link_path_additional_get_data','task=&button_submit='),
(4281,-1,-1,701,'order_field_cgi_var','order_curims_lecturer'),
(4282,-1,-1,701,'order_field_caption','Name:Office:Contact:Email'),
(4283,-1,-1,701,'order_field_name','name:office:contact:email'),
(4284,-1,-1,701,'map_caption_field','Name => name, Office => office, Contact => contact, Email => email'),
(4285,-1,-1,701,'db_items_set_number_var','dbisn_curims_lecturer'),
(4286,-1,-1,701,'dynamic_menu_items_set_number_var','dmisn_curims_lecturer'),
(4287,-1,-1,701,'inl_var_name','inl_curims_lecturer'),
(4288,-1,-1,701,'lsn_var_name','lsn_curims_lecturer'),
(4289,-1,-1,701,'table_name','curims_lecturer'),
(4290,-1,-1,702,'table_name','curims_lecturer'),
(4291,-1,-1,702,'check_on_cgi_data','$db_name '),
(4292,-1,-1,702,'template_default_confirm','curims_lecturer_multirows_insert_confirm.html'),
(4293,-1,-1,703,'table_name','curims_lecturer'),
(4294,-1,-1,703,'check_on_cgi_data','$db_name '),
(4295,-1,-1,703,'template_default_confirm','curims_lecturer_multirows_update_confirm.html'),
(4296,-1,-1,703,'update_keys_str','id_lecturer_62base=\'$cgi_id_lecturer_62base_\''),
(4297,-1,-1,704,'table_name','curims_lecturer'),
(4298,-1,-1,704,'template_default','curims_lecturer_multirows_delete.html'),
(4299,-1,-1,704,'delete_keys_str','id_lecturer_62base=\'$cgi_id_lecturer_62base_\''),
(4300,-1,-1,705,'table_name','curims_lecturer'),
(4301,-1,-1,705,'task','insert'),
(4302,-1,-1,705,'field_list','name office contact email '),
(4303,-1,-1,705,'template_default_confirm','curims_lecturer_text2db_insert_confirm.html'),
(4304,-1,-1,705,'key_field_name','email'),
(4305,-1,-1,706,'table_name','curims_lecturer'),
(4306,-1,-1,706,'task','update'),
(4307,-1,-1,706,'field_list','name office contact email '),
(4308,-1,-1,706,'template_default_confirm','curims_lecturer_text2db_update_confirm.html'),
(4309,-1,-1,706,'key_field_name','email'),
(4310,-1,-1,707,'table_name','curims_lecturer'),
(4311,-1,-1,707,'task','delete'),
(4312,-1,-1,707,'field_list','email'),
(4313,-1,-1,707,'template_default_confirm','curims_lecturer_text2db_delete_confirm.html'),
(4314,-1,-1,707,'key_field_name','email'),
(4315,-1,-1,708,'order_field_cgi_var','order_curims_course'),
(4316,-1,-1,708,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code'),
(4317,-1,-1,708,'order_field_name','course_code:course_name:credit_hour:prerequisite_code'),
(4318,-1,-1,708,'map_caption_field','Course Code => course_code, Course Name => course_name, Credit Hour => credit_hour, Prerequisite Code => prerequisite_code'),
(4319,-1,-1,708,'db_items_set_number_var','dbisn_curims_course'),
(4320,-1,-1,708,'dynamic_menu_items_set_number_var','dmisn_curims_course'),
(4321,-1,-1,708,'inl_var_name','inl_curims_course'),
(4322,-1,-1,708,'lsn_var_name','lsn_curims_course'),
(4323,-1,-1,708,'sql','select t_view.*, t_med.* from curims_course t_view, curims_course_lecturer t_med where t_med.id_lecturer_62base =\'$cgi_id_lecturer_62base_\' and t_med.id_course_62base = t_view.id_course_62base order by $cgi_order_curims_course_'),
(4324,-1,-1,708,'link_path_additional_get_data','task=&button_submit='),
(4325,-1,-1,709,'order_field_cgi_var','order_curims_course_AFLS'),
(4326,-1,-1,709,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code'),
(4327,-1,-1,709,'order_field_name','course_code:course_name:credit_hour:prerequisite_code'),
(4328,-1,-1,709,'map_caption_field','Course Code => course_code, Course Name => course_name, Credit Hour => credit_hour, Prerequisite Code => prerequisite_code'),
(4329,-1,-1,709,'db_items_set_number_var','dbisn_curims_course_AFLS'),
(4330,-1,-1,709,'dynamic_menu_items_set_number_var','dmisn_curims_course_AFLS'),
(4331,-1,-1,709,'inl_var_name','inl_curims_course_AFLS'),
(4332,-1,-1,709,'lsn_var_name','lsn_curims_course_AFLS'),
(4333,-1,-1,709,'link_path_additional_get_data','task=&button_submit='),
(4334,-1,-1,709,'sql','select * from curims_course where id_course_62base not in (select id_course_62base from curims_course_lecturer where id_lecturer_62base=\'$cgi_id_lecturer_62base_\') order by $cgi_order_curims_course_AFLS_'),
(4335,-1,-1,710,'table_name','curims_course_lecturer'),
(4336,-1,-1,710,'delete_keys_str','id_course_lecturer_62base=\'$cgi_id_course_lecturer_62base_\''),
(4337,-1,-1,710,'last_phase_cgi_data_reset','task=\'curims_lecturer_course_list\' button_submit'),
(4374,-1,-1,693,'order_field_cgi_var','	order_curims_course'),
(4375,-1,-1,693,'inl_var_name','inl_curims_course'),
(4376,-1,-1,693,'lsn_var_name','lsn_curims_course'),
(4377,-1,-1,693,'dynamic_menu_items_set_number_var','dmisn_curims_course'),
(4378,-1,-1,693,'db_items_set_number_var','dbisn_curims_course'),
(4383,-1,-1,693,'sql','select t_view.*, t_med.* from curims_course t_view, curims_elective t_med where t_med.id_currcourse_62base =\'$cgi_id_currcourse_62base_\' and t_med.id_course_62base = t_view.id_course_62base order by $cgi_order_curims_course_	'),
(4384,-1,-1,716,'table_name','curims_elective	'),
(4385,-1,-1,716,'delete_keys_str','id_elective_62base=\'$cgi_id_elective_62base_\'	'),
(4386,-1,-1,716,'last_phase_cgi_data_reset','task=\'curims_curriculum_course_elective_list\' button_submit	'),
(4388,-1,-1,695,'sql','select * from curims_course where id_course_62base not in (select id_course_62base from curims_elective where id_currcourse_62base=\'$cgi_id_currcourse_62base_\') order by $cgi_order_curims_course_'),
(4627,-1,-1,754,'sql','select t_view.*, t_med.* from curims_course t_view, curims_elective t_med where t_med.id_currcourse_62base =\'$cgi_id_currcourse_62base_\' and t_med.id_course_62base = t_view.id_course_62base order by $cgi_order_curims_course_'),
(4628,-1,-1,754,'order_field_cgi_var','order_curims_course'),
(4630,-1,-1,754,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code'),
(4631,-1,-1,754,'order_field_name','course_code:course_name:credit_hour:prerequisite_code'),
(4632,-1,-1,754,'map_caption_field','Course Code =&amp;gt; course_code, Course Name =&amp;gt; course_name, Credit Hour =&amp;gt; credit_hour, Prerequisite Code =&amp;gt; prerequisite_code'),
(4633,-1,-1,754,'inl_var_name','inl_curims_course'),
(4634,-1,-1,754,'lsn_var_name','lsn_curims_course'),
(4635,-1,-1,754,'dynamic_menu_items_set_number_var','dmisn_curims_course'),
(4636,-1,-1,754,'db_items_set_number_var','dbisn_curims_course'),
(4638,-1,-1,754,'link_path_additional_get_data','task=&amp;amp;button_submit='),
(4639,-1,-1,755,'sql','	select * from curims_course where id_course_62base not in (select id_course_62base from curims_elective where id_currcourse_62base=\'$cgi_id_currcourse_62base_\') order by $cgi_order_curims_course_'),
(4640,-1,-1,755,'filter_field_cgi_var','order_curims_course_AFLS'),
(4642,-1,-1,755,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code'),
(4643,-1,-1,755,'order_field_name','course_code:course_name:credit_hour:prerequisite_code'),
(4645,-1,-1,755,'map_caption_field','Course Code =&amp;amp;gt; course_code, Course Name =&amp;amp;gt; course_name, Credit Hour =&amp;amp;gt; credit_hour, Prerequisite Code =&amp;amp;gt; prerequisite_code'),
(4646,-1,-1,755,'inl_var_name','inl_curims_course_AFLS'),
(4647,-1,-1,755,'lsn_var_name','lsn_curims_course_AFLS'),
(4648,-1,-1,755,'dynamic_menu_items_set_number_var','dmisn_curims_course_AFLS'),
(4649,-1,-1,755,'db_items_set_number_var','dbisn_curims_course_AFLS'),
(4650,-1,-1,755,'link_path_additional_get_data','task=&amp;amp;button_submit='),
(4651,-1,-1,756,'table_name','	curims_elective'),
(4652,-1,-1,756,'delete_keys_str','id_elective_62base=\'$cgi_id_elective_62base_\''),
(4653,-1,-1,756,'last_phase_cgi_data_reset','	task=\'curims_curriculum_course_elective_list\' button_submit'),
(4654,-1,-1,757,'sql','	select t_view.*, t_med.* from curims_course t_view, curims_elective t_med where t_med.id_currcourse_62base =\'$cgi_id_currcourse_62base_\' and t_med.id_course_62base = t_view.id_course_62base order by $cgi_order_curims_course_'),
(4655,-1,-1,757,'order_field_cgi_var','	order_curims_course'),
(4656,-1,-1,757,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code'),
(4657,-1,-1,757,'order_field_name','course_code:course_name:credit_hour:prerequisite_code'),
(4658,-1,-1,757,'map_caption_field','	Course Code =&amp;amp;gt; course_code, Course Name =&amp;amp;gt; course_name, Credit Hour =&amp;amp;gt; credit_hour, Prerequisite Code =&amp;amp;gt; prerequisite_code'),
(4659,-1,-1,757,'inl_var_name','	inl_curims_course'),
(4660,-1,-1,757,'lsn_var_name','	lsn_curims_course'),
(4661,-1,-1,757,'dynamic_menu_items_set_number_var','	dmisn_curims_course'),
(4662,-1,-1,757,'db_items_set_number_var','dbisn_curims_course'),
(4664,-1,-1,757,'link_path_additional_get_data','	task=&amp;amp;amp;button_submit='),
(4665,-1,-1,758,'sql','	select * from curims_course where id_course_62base not in (select id_course_62base from curims_elective where id_currcourse_62base=\'$cgi_id_currcourse_62base_\') order by $cgi_order_curims_course_'),
(4666,-1,-1,758,'filter_field_cgi_var','	order_curims_course_AFLS'),
(4667,-1,-1,758,'order_field_caption','	Course Code:Course Name:Credit Hour:Prerequisite Code'),
(4668,-1,-1,758,'order_field_name','	course_code:course_name:credit_hour:prerequisite_code'),
(4669,-1,-1,758,'map_caption_field','	Course Code =&amp;amp;amp;gt; course_code, Course Name =&amp;amp;amp;gt; course_name, Credit Hour =&amp;amp;amp;gt; credit_hour, Prerequisite Code =&amp;amp;amp;gt; prerequisite_code'),
(4670,-1,-1,758,'inl_var_name','	inl_curims_course_AFLS'),
(4671,-1,-1,758,'lsn_var_name','	lsn_curims_course_AFLS'),
(4672,-1,-1,758,'dynamic_menu_items_set_number_var','	dmisn_curims_course_AFLS'),
(4673,-1,-1,758,'db_items_set_number_var','	dbisn_curims_course_AFLS'),
(4675,-1,-1,758,'link_path_additional_get_data','	task=&amp;amp;amp;button_submit='),
(4676,-1,-1,759,'table_name','	curims_elective'),
(4677,-1,-1,759,'delete_keys_str','	id_elective_62base=\'$cgi_id_elective_62base_\''),
(4679,-1,-1,759,'last_phase_cgi_data_reset','task=\'curims_curriculum_course_elective_list\' button_submit'),
(4730,-1,-1,765,'order_field_cgi_var','order_curims_course'),
(4731,-1,-1,765,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code'),
(4732,-1,-1,765,'order_field_name','course_code:course_name:credit_hour:prerequisite_code'),
(4733,-1,-1,765,'map_caption_field','Course Code => course_code, Course Name => course_name, Credit Hour => credit_hour, Prerequisite Code => prerequisite_code'),
(4734,-1,-1,765,'db_items_set_number_var','dbisn_curims_course'),
(4735,-1,-1,765,'dynamic_menu_items_set_number_var','dmisn_curims_course'),
(4736,-1,-1,765,'inl_var_name','inl_curims_course'),
(4737,-1,-1,765,'lsn_var_name','lsn_curims_course'),
(4738,-1,-1,765,'table_name','curims_course'),
(4739,-1,-1,766,'table_name','curims_course'),
(4741,-1,-1,766,'template_default_confirm','curims_course_multirows_insert_confirm.html'),
(4742,-1,-1,767,'table_name','curims_course'),
(4743,-1,-1,767,'check_on_cgi_data','$db_course_code $db_course_name $db_credit_hour '),
(4744,-1,-1,767,'template_default_confirm','curims_course_multirows_update_confirm.html'),
(4745,-1,-1,767,'update_keys_str','id_course_62base=\'$cgi_id_course_62base_\''),
(4746,-1,-1,768,'table_name','curims_course'),
(4747,-1,-1,768,'template_default','curims_course_multirows_delete.html'),
(4748,-1,-1,768,'delete_keys_str','id_course_62base=\'$cgi_id_course_62base_\''),
(4749,-1,-1,769,'order_field_cgi_var','order_curims_assesment'),
(4750,-1,-1,769,'order_field_caption','Type:Sequence:Name'),
(4751,-1,-1,769,'order_field_name','type:sequence:name'),
(4752,-1,-1,769,'map_caption_field','Type => type, Sequence => sequence, Name => name'),
(4753,-1,-1,769,'db_items_set_number_var','dbisn_curims_assesment'),
(4754,-1,-1,769,'dynamic_menu_items_set_number_var','dmisn_curims_assesment'),
(4755,-1,-1,769,'inl_var_name','inl_curims_assesment'),
(4756,-1,-1,769,'lsn_var_name','lsn_curims_assesment'),
(4757,-1,-1,769,'sql','select * from curims_assesment where id_course_62base=\'$cgi_id_course_62base_\' order by $cgi_order_curims_assesment_'),
(4758,-1,-1,769,'link_path_additional_get_data','task=&button_submit='),
(4766,-1,-1,771,'table_name','curims_assesment'),
(4767,-1,-1,771,'check_on_cgi_data','$db_type $db_sequence $db_name '),
(4768,-1,-1,771,'template_default_confirm','curims_course_assesment_multirows_update_confirm.html'),
(4769,-1,-1,771,'update_keys_str','id_assesment_62base=\'$cgi_id_assesment_62base_\''),
(4770,-1,-1,771,'check_on_fields_existence','id_assesment_62base => curims_assesplo'),
(4771,-1,-1,771,'check_on_fields_duplication','name'),
(4772,-1,-1,771,'last_phase_cgi_data_reset','task=\'curims_course_assesment_plo_link\' button_submit'),
(4773,-1,-1,771,'link_path_additional_get_data','task=&button_submit='),
(4774,-1,-1,772,'table_name','curims_assesment'),
(4775,-1,-1,772,'template_default','curims_course_assesment_multirows_delete.html'),
(4776,-1,-1,772,'delete_keys_str','id_assesment_62base=\'$cgi_id_assesment_62base_\''),
(4777,-1,-1,772,'last_phase_cgi_data_reset','task=\'curims_course_assesment_plo_link\' button_submit'),
(4778,-1,-1,772,'link_path_additional_get_data','task=&button_submit='),
(4807,-1,-1,777,'order_field_cgi_var','order_curims_curriculum'),
(4808,-1,-1,777,'order_field_caption','Curriculum Code:Curriculum Name:Intake Session:Intake Year:Intake Semester:Created At:Updated At'),
(4809,-1,-1,777,'order_field_name','curriculum_code:curriculum_name:intake_session:intake_year:intake_semester:created_at:updated_at'),
(4810,-1,-1,777,'map_caption_field','Curriculum Code => curriculum_code, Curriculum Name => curriculum_name, Intake Session => intake_session, Intake Year => intake_year, Intake Semester => intake_semester, Created At => created_at, Updated At => updated_at'),
(4811,-1,-1,777,'db_items_set_number_var','dbisn_curims_curriculum'),
(4812,-1,-1,777,'dynamic_menu_items_set_number_var','dmisn_curims_curriculum'),
(4813,-1,-1,777,'inl_var_name','inl_curims_curriculum'),
(4814,-1,-1,777,'lsn_var_name','lsn_curims_curriculum'),
(4816,-1,-1,777,'link_path_additional_get_data','task=&button_submit='),
(4817,-1,-1,778,'order_field_cgi_var','order_curims_topic'),
(4818,-1,-1,778,'order_field_caption','Session:Semester:Topic No:Title:Subtopic'),
(4819,-1,-1,778,'order_field_name','session:semester:topic_no:title:subtopic'),
(4820,-1,-1,778,'map_caption_field','Session => session, Semester => semester, Topic No => topic_no, Title => title, Subtopic => subtopic'),
(4821,-1,-1,778,'db_items_set_number_var','dbisn_curims_topic'),
(4822,-1,-1,778,'dynamic_menu_items_set_number_var','dmisn_curims_topic'),
(4823,-1,-1,778,'inl_var_name','inl_curims_topic'),
(4824,-1,-1,778,'lsn_var_name','lsn_curims_topic'),
(4825,-1,-1,778,'sql','select * from curims_topic where id_course_62base=\'$cgi_id_course_62base_\' order by $cgi_order_curims_topic_'),
(4826,-1,-1,779,'table_name','curims_topic'),
(4828,-1,-1,779,'template_default_confirm','curims_course_topic_multirows_insert_confirm.html'),
(4831,-1,-1,780,'table_name','curims_topic'),
(4833,-1,-1,780,'template_default_confirm','curims_course_topic_multirows_update_confirm.html'),
(4834,-1,-1,780,'update_keys_str','id_topic_62base=\'$cgi_id_topic_62base_\''),
(4836,-1,-1,780,'check_on_fields_duplication','title'),
(4837,-1,-1,781,'table_name','curims_topic'),
(4838,-1,-1,781,'template_default','curims_course_topic_multirows_delete.html'),
(4839,-1,-1,781,'delete_keys_str','id_topic_62base=\'$cgi_id_topic_62base_\''),
(4840,-1,-1,782,'order_field_cgi_var','order_curims_plo'),
(4841,-1,-1,782,'order_field_caption','Plo Code:Plo Tag:Plo Description'),
(4842,-1,-1,782,'order_field_name','plo_code:plo_tag:plo_description'),
(4843,-1,-1,782,'map_caption_field','Plo Code => plo_code, Plo Tag => plo_tag, Plo Description => plo_description'),
(4844,-1,-1,782,'db_items_set_number_var','dbisn_curims_plo'),
(4845,-1,-1,782,'dynamic_menu_items_set_number_var','dmisn_curims_plo'),
(4846,-1,-1,782,'inl_var_name','inl_curims_plo'),
(4847,-1,-1,782,'lsn_var_name','lsn_curims_plo'),
(4848,-1,-1,782,'sql','select t_view.*, t_med.* from curims_plo t_view, curims_assesplo t_med where t_med.id_assesment_62base =\'$cgi_id_assesment_62base_\' and t_med.id_plo_62base = t_view.id_plo_62base order by $cgi_order_curims_plo_'),
(4849,-1,-1,782,'link_path_additional_get_data','task=&button_submit='),
(4850,-1,-1,783,'order_field_cgi_var','order_curims_plo_AFLS'),
(4851,-1,-1,783,'order_field_caption','Plo Code:Plo Tag:Plo Description'),
(4852,-1,-1,783,'order_field_name','plo_code:plo_tag:plo_description'),
(4853,-1,-1,783,'map_caption_field','Plo Code => plo_code, Plo Tag => plo_tag, Plo Description => plo_description'),
(4854,-1,-1,783,'db_items_set_number_var','dbisn_curims_plo_AFLS'),
(4855,-1,-1,783,'dynamic_menu_items_set_number_var','dmisn_curims_plo_AFLS'),
(4856,-1,-1,783,'inl_var_name','inl_curims_plo_AFLS'),
(4857,-1,-1,783,'lsn_var_name','lsn_curims_plo_AFLS'),
(4858,-1,-1,783,'link_path_additional_get_data','task=&button_submit='),
(4859,-1,-1,783,'sql','select * from curims_plo where id_plo_62base not in (select id_plo_62base from curims_assesplo where id_assesment_62base=\'$cgi_id_assesment_62base_\') order by $cgi_order_curims_plo_AFLS_'),
(4860,-1,-1,784,'table_name','curims_assesplo'),
(4861,-1,-1,784,'delete_keys_str','id_assesplo_62base=\'$cgi_id_assesplo_62base_\''),
(4862,-1,-1,784,'last_phase_cgi_data_reset','task=\'curims_course_assesment_plo_list\' button_submit'),
(4887,-1,-1,779,'check_on_cgi_data','$db_session $db_semester $db_topic_no $db_title $db_subtopic'),
(4905,-1,-1,790,'order_field_cgi_var','order_curims_course'),
(4906,-1,-1,790,'order_field_name','	course_code:course_name:credit_hour:prerequisite_code'),
(4907,-1,-1,790,'map_caption_field','	Course Code =&gt; course_code, Course Name =&gt; course_name, Credit Hour =&gt; credit_hour, Prerequisite Code =&gt; prerequisite_code'),
(4912,-1,-1,790,'link_path_additional_get_data','	task=&amp;button_submit='),
(4913,-1,-1,790,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code'),
(4914,-1,-1,790,'inl_var_name','inl_curims_course'),
(4915,-1,-1,790,'lsn_var_name','lsn_curims_course'),
(4945,-1,-1,794,'order_field_cgi_var','order_curims_course'),
(4946,-1,-1,794,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code'),
(4947,-1,-1,794,'order_field_name','course_code:course_name:credit_hour:prerequisite_code'),
(4948,-1,-1,794,'map_caption_field','Course Code => course_code, Course Name => course_name, Credit Hour => credit_hour, Prerequisite Code => prerequisite_code'),
(4949,-1,-1,794,'db_items_set_number_var','dbisn_curims_course'),
(4950,-1,-1,794,'dynamic_menu_items_set_number_var','dmisn_curims_course'),
(4953,-1,-1,794,'link_path_additional_get_data','task=&button_submit='),
(4955,-1,-1,795,'order_field_cgi_var','order_curims_course_AFLS'),
(4956,-1,-1,795,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code'),
(4957,-1,-1,795,'order_field_name','course_code:course_name:credit_hour:prerequisite_code'),
(4958,-1,-1,795,'map_caption_field','Course Code => course_code, Course Name => course_name, Credit Hour => credit_hour, Prerequisite Code => prerequisite_code'),
(4959,-1,-1,795,'db_items_set_number_var','dbisn_curims_course_AFLS'),
(4960,-1,-1,795,'dynamic_menu_items_set_number_var','dmisn_curims_course_AFLS'),
(4961,-1,-1,795,'inl_var_name','inl_curims_course_AFLS'),
(4962,-1,-1,795,'lsn_var_name','lsn_curims_course_AFLS'),
(4963,-1,-1,795,'link_path_additional_get_data','task=&button_submit='),
(4964,-1,-1,795,'sql','select * from curims_course where id_course_62base not in (select id_course_62base from curims_currcourse where id_curriculum_62base=\'$cgi_id_curriculum_62base_\') order by $cgi_order_curims_course_AFLS_'),
(4968,-1,-1,796,'table_name','curims_currcourse'),
(4969,-1,-1,796,'delete_keys_str','id_currcourse_62base=\'$cgi_id_currcourse_62base_\''),
(4972,-1,-1,796,'last_phase_cgi_data_reset','task=\'curims_curriculum_course_list\' button_submit	'),
(4979,-1,-1,797,'sql','select t_view.*, t_med.* from curims_course t_view, curims_elective t_med where t_med.id_currcourse_62base =\'$cgi_id_currcourse_62base_\' and t_med.id_course_62base = t_view.id_course_62base order by $cgi_order_curims_course_'),
(4980,-1,-1,797,'order_field_cgi_var','order_curims_course'),
(4981,-1,-1,797,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code	'),
(4982,-1,-1,797,'order_field_name','course_code:course_name:credit_hour:prerequisite_code	'),
(4983,-1,-1,797,'map_caption_field','Course Code =&amp;gt; course_code, Course Name =&amp;gt; course_name, Credit Hour =&amp;gt; credit_hour, Prerequisite Code =&amp;gt; prerequisite_code	'),
(4985,-1,-1,797,'inl_var_name','inl_curims_course'),
(4986,-1,-1,797,'lsn_var_name','lsn_curims_course'),
(4987,-1,-1,797,'dynamic_menu_items_set_number_var','dmisn_curims_course'),
(4988,-1,-1,797,'db_items_set_number_var','dbisn_curims_course'),
(4989,-1,-1,797,'link_path_additional_get_data','task=&amp;amp;button_submit='),
(5001,-1,-1,799,'order_field_cgi_var','order_curims_curriculum'),
(5002,-1,-1,799,'table_name','curims_curriculum'),
(5012,-1,-1,799,'order_field_caption','Curriculum Code:Curriculum Name:Intake Session:Intake Year:Intake Semester	'),
(5020,-1,-1,799,'order_field_name','curriculum_code:curriculum_name:intake_session:intake_year:intake_semester	'),
(5077,-1,-1,803,'link_path_additional_get_data','task=&button_submit=&'),
(5127,-1,-1,819,'sql','select * from curims_schedule where id_topic_62base=\'$cgi_id_topic_62base_\' order by $cgi_order_curims_schedule_'),
(5128,-1,-1,819,'order_field_cgi_var','order_curims_schedule'),
(5129,-1,-1,819,'order_field_caption','Session:Semester:Week:Date Start:Date End:Info'),
(5130,-1,-1,819,'order_field_name','session:semester:week:date_start:date_end:info'),
(5131,-1,-1,819,'map_caption_field','Session =&gt; session, Semester =&gt; semester, Week =&gt; week, Date Start =&gt; date_start, Date End =&gt; date_end, Info =&gt; info'),
(5132,-1,-1,819,'inl_var_name','inl_curims_schedule'),
(5133,-1,-1,819,'lsn_var_name','lsn_curims_schedule'),
(5134,-1,-1,819,'dynamic_menu_items_set_number_var','dmisn_curims_schedule'),
(5135,-1,-1,819,'db_items_set_number_var','dbisn_curims_schedule'),
(5136,-1,-1,820,'table_name','curims_schedule'),
(5137,-1,-1,820,'check_on_cgi_data','$db_session $db_semester $db_week $db_date_start $db_date_end '),
(5138,-1,-1,820,'template_default_confirm','curims_course_topic_schedule_multirows_insert_confirm.html'),
(5139,-1,-1,821,'table_name','curims_schedule'),
(5140,-1,-1,821,'check_on_cgi_data','$db_session $db_semester $db_week $db_date_start $db_date_end '),
(5141,-1,-1,821,'template_default_confirm','curims_course_topic_schedule_multirows_update_confirm.html'),
(5142,-1,-1,821,'update_keys_str','id_schedule_62base=\'$cgi_id_schedule_62base_\''),
(5144,-1,-1,821,'check_on_fields_duplication','week'),
(5145,-1,-1,822,'template_default','curims_course_topic_schedule_multirows_delete.html'),
(5146,-1,-1,822,'table_name','curims_schedule'),
(5147,-1,-1,822,'delete_keys_str','id_schedule_62base=\'$cgi_id_schedule_62base_\''),
(5156,-1,-1,794,'sql','select t_view.*, t_med.* from curims_course t_view, curims_currcourse t_med where t_med.id_curriculum_62base = \'$cgi_id_curriculum_62base_\' and t_med.id_course_62base = t_view.id_course_62base order by t_med.year_taken ASC, t_med.semester_taken ASC'),
(5159,-1,-1,790,'sql','select curims_course.*, curims_currcourse.* from curims_course, curims_currcourse where curims_currcourse.id_curriculum_62base = \'$cgi_id_curriculum_62base_\' and curims_currcourse.id_course_62base = curims_course.id_course_62base order by curims_currcourse.year_taken ASC, curims_currcourse.semester_taken ASC'),
(5162,-1,-1,790,'dynamic_menu_items_set_number_var','dmisn_curims_course'),
(5163,-1,-1,790,'db_items_set_number_var','dbisn_curims_course'),
(5167,-1,-1,794,'inl_var_name','inl_curims_course'),
(5168,-1,-1,794,'lsn_var_name','lsn_curims_course'),
(5169,-1,-1,780,'check_on_cgi_data','$db_session $db_semester $db_topic_no $db_title $db_subtopic'),
(5202,-1,-1,803,'table_name','curims_course'),
(5203,-1,-1,803,'order_field_cgi_var','order_curims_course'),
(5217,4295,-1,-1,'template_default','template_main_minimalistic.html'),
(5218,7555,-1,-1,'template_default','template_dynamic_links_table_cols.html'),
(5219,-1,-1,829,'template_default_confirm','curims_course_assesment_multirows_insert_confirm.html'),
(5220,-1,-1,829,'table_name','curims_assesment'),
(5221,-1,-1,829,'check_on_cgi_data','$db_type $db_sequence $db_name'),
(5222,-1,-1,829,'check_on_fields_duplication','name'),
(5224,-1,-1,829,'link_path_additional_get_data','task=&amp;button_submit='),
(5226,-1,-1,829,'last_phase_cgi_data_reset','task=\'curims_course_assesment_plo_link\' button_submit'),
(5236,-1,-1,831,'table_name','curims_clo'),
(5237,-1,-1,831,'check_on_cgi_data','$db_clo_code '),
(5238,-1,-1,831,'template_default_confirm','curims_clo_multirows_insert_confirm.html'),
(5241,-1,-1,832,'table_name','curims_clo'),
(5242,-1,-1,832,'check_on_cgi_data','$db_clo_code '),
(5243,-1,-1,832,'template_default_confirm','curims_clo_multirows_update_confirm.html'),
(5244,-1,-1,832,'update_keys_str','id_clo_62base=\'$cgi_id_clo_62base_\''),
(5247,-1,-1,833,'table_name','curims_clo'),
(5248,-1,-1,833,'template_default','curims_clo_multirows_delete.html'),
(5249,-1,-1,833,'delete_keys_str','id_clo_62base=\'$cgi_id_clo_62base_\''),
(5250,-1,-1,834,'order_field_cgi_var','order_curims_plo'),
(5251,-1,-1,834,'order_field_caption','Plo Code:Plo Tag:Plo Description'),
(5252,-1,-1,834,'order_field_name','plo_code:plo_tag:plo_description'),
(5253,-1,-1,834,'map_caption_field','Plo Code => plo_code, Plo Tag => plo_tag, Plo Description => plo_description'),
(5254,-1,-1,834,'db_items_set_number_var','dbisn_curims_plo'),
(5255,-1,-1,834,'dynamic_menu_items_set_number_var','dmisn_curims_plo'),
(5256,-1,-1,834,'inl_var_name','inl_curims_plo'),
(5257,-1,-1,834,'lsn_var_name','lsn_curims_plo'),
(5258,-1,-1,834,'sql','select t_view.*, t_med.* from curims_plo t_view, curims_cloplo t_med where t_med.id_clo_62base =\'$cgi_id_clo_62base_\' and t_med.id_plo_62base = t_view.id_plo_62base order by $cgi_order_curims_plo_'),
(5259,-1,-1,834,'link_path_additional_get_data','task=&button_submit='),
(5260,-1,-1,835,'order_field_cgi_var','order_curims_plo_AFLS'),
(5261,-1,-1,835,'order_field_caption','Plo Code:Plo Tag:Plo Description'),
(5262,-1,-1,835,'order_field_name','plo_code:plo_tag:plo_description'),
(5263,-1,-1,835,'map_caption_field','Plo Code => plo_code, Plo Tag => plo_tag, Plo Description => plo_description'),
(5264,-1,-1,835,'db_items_set_number_var','dbisn_curims_plo_AFLS'),
(5265,-1,-1,835,'dynamic_menu_items_set_number_var','dmisn_curims_plo_AFLS'),
(5266,-1,-1,835,'inl_var_name','inl_curims_plo_AFLS'),
(5267,-1,-1,835,'lsn_var_name','lsn_curims_plo_AFLS'),
(5268,-1,-1,835,'link_path_additional_get_data','task=&button_submit='),
(5269,-1,-1,835,'sql','select * from curims_plo where id_plo_62base not in (select id_plo_62base from curims_cloplo where id_clo_62base=\'$cgi_id_clo_62base_\') order by $cgi_order_curims_plo_AFLS_'),
(5270,-1,-1,836,'table_name','curims_cloplo'),
(5271,-1,-1,836,'delete_keys_str','id_cloplo_62base=\'$cgi_id_cloplo_62base_\''),
(5272,-1,-1,836,'last_phase_cgi_data_reset','task=\'curims_clo_plo_list\' button_submit'),
(5275,-1,-1,837,'order_field_cgi_var','order_curims_clo'),
(5276,-1,-1,837,'order_field_caption','Clo Code:Clo Description'),
(5277,-1,-1,837,'order_field_name','clo_code:clo_description'),
(5278,-1,-1,837,'map_caption_field','Clo Code => clo_code, Clo Description => clo_description'),
(5279,-1,-1,837,'db_items_set_number_var','dbisn_curims_clo'),
(5280,-1,-1,837,'dynamic_menu_items_set_number_var','dmisn_curims_clo'),
(5281,-1,-1,837,'inl_var_name','inl_curims_clo'),
(5282,-1,-1,837,'lsn_var_name','lsn_curims_clo'),
(5286,-1,-1,837,'sql','select * from curims_clo where id_course_62base=\'$cgi_id_course_62base_\' order by $cgi_order_curims_clo_'),
(5287,-1,-1,831,'link_path_additional_get_data','task=&amp;button_submit='),
(5288,-1,-1,831,'last_phase_cgi_data_reset','task=\'curims_clo_plo_link\' button_submit'),
(5289,-1,-1,833,'link_path_additional_get_data','task=&amp;button_submit='),
(5290,-1,-1,833,'last_phase_cgi_data_reset','task=\'curims_clo_plo_link\' button_submit'),
(5291,-1,-1,832,'link_path_additional_get_data','task=&amp;button_submit='),
(5292,-1,-1,832,'last_phase_cgi_data_reset','task=\'curims_clo_plo_link\' button_submit'),
(5293,-1,-1,766,'check_on_cgi_data','$db_course_code $db_course_name $db_credit_hour $db_course_synopsys'),
(5297,-1,-1,839,'order_field_cgi_var','order_curims_course'),
(5298,-1,-1,839,'order_field_name','	course_code:course_name:credit_hour:prerequisite_code'),
(5299,-1,-1,839,'map_caption_field','	Course Code =&gt; course_code, Course Name =&gt; course_name, Credit Hour =&gt; credit_hour, Prerequisite Code =&gt; prerequisite_code'),
(5300,-1,-1,839,'link_path_additional_get_data','	task=&amp;button_submit='),
(5301,-1,-1,839,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code'),
(5302,-1,-1,839,'inl_var_name','inl_curims_course'),
(5303,-1,-1,839,'lsn_var_name','lsn_curims_course'),
(5304,-1,-1,839,'sql','select curims_course.*, curims_currcourse.* from curims_course, curims_currcourse where curims_currcourse.id_curriculum_62base = \'$cgi_id_curriculum_62base_\' and curims_currcourse.id_course_62base = curims_course.id_course_62base order by curims_currcourse.year_taken ASC, curims_currcourse.semester_taken ASC'),
(5305,-1,-1,839,'dynamic_menu_items_set_number_var','dmisn_curims_course'),
(5306,-1,-1,839,'db_items_set_number_var','dbisn_curims_course'),
(5307,-1,-1,840,'sql','select t_view.*, t_med.* from curims_course t_view, curims_elective t_med where t_med.id_currcourse_62base =\'$cgi_id_currcourse_62base_\' and t_med.id_course_62base = t_view.id_course_62base order by $cgi_order_curims_course_'),
(5308,-1,-1,840,'order_field_cgi_var','order_curims_course'),
(5309,-1,-1,840,'order_field_caption','Course Code:Course Name:Credit Hour:Prerequisite Code	'),
(5310,-1,-1,840,'order_field_name','course_code:course_name:credit_hour:prerequisite_code	'),
(5311,-1,-1,840,'map_caption_field','Course Code =&amp;gt; course_code, Course Name =&amp;gt; course_name, Credit Hour =&amp;gt; credit_hour, Prerequisite Code =&amp;gt; prerequisite_code	'),
(5312,-1,-1,840,'inl_var_name','inl_curims_course'),
(5313,-1,-1,840,'lsn_var_name','lsn_curims_course'),
(5314,-1,-1,840,'dynamic_menu_items_set_number_var','dmisn_curims_course'),
(5315,-1,-1,840,'db_items_set_number_var','dbisn_curims_course'),
(5316,-1,-1,840,'link_path_additional_get_data','task=&amp;amp;button_submit=');
/*!40000 ALTER TABLE `webman_curims_dyna_mod_param` ENABLE KEYS */;
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
-- Table structure for table `webman_curims_dyna_mod_param_global`
--

DROP TABLE IF EXISTS `webman_curims_dyna_mod_param_global`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_dyna_mod_param_global` (
  `dmpg_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `dyna_mod_name` varchar(255) NOT NULL,
  `dynamic_content_num` smallint(6) DEFAULT NULL,
  `dynamic_content_name` varchar(255) DEFAULT NULL,
  `param_name` varchar(255) DEFAULT NULL,
  `param_value` text DEFAULT NULL,
  PRIMARY KEY (`dmpg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_dyna_mod_param_global`
--

LOCK TABLES `webman_curims_dyna_mod_param_global` WRITE;
/*!40000 ALTER TABLE `webman_curims_dyna_mod_param_global` DISABLE KEYS */;
/*!40000 ALTER TABLE `webman_curims_dyna_mod_param_global` ENABLE KEYS */;
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
-- Table structure for table `webman_curims_group`
--

DROP TABLE IF EXISTS `webman_curims_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_group` (
  `id_group` binary(6) NOT NULL,
  `group_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_group`),
  UNIQUE KEY `idx_group_name` (`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_group`
--

LOCK TABLES `webman_curims_group` WRITE;
/*!40000 ALTER TABLE `webman_curims_group` DISABLE KEYS */;
INSERT INTO `webman_curims_group` (`id_group`, `group_name`, `description`) VALUES ('K3JUV1','ADMIN','Application Administrator'),
('kcCH1F','COM_JSON','JSON-based Service Users'),
('vTvijn','COURSE_OWNER','Course Owner');
/*!40000 ALTER TABLE `webman_curims_group` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:52
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
-- Table structure for table `webman_curims_hit_info`
--

DROP TABLE IF EXISTS `webman_curims_hit_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_hit_info` (
  `hit_id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(15) NOT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `method` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`hit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18013 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:52
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
-- Table structure for table `webman_curims_hit_info_content`
--

DROP TABLE IF EXISTS `webman_curims_hit_info_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_hit_info_content` (
  `hit_id` int(11) NOT NULL,
  `content` blob DEFAULT NULL,
  PRIMARY KEY (`hit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:52
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
-- Table structure for table `webman_curims_hit_info_query_string`
--

DROP TABLE IF EXISTS `webman_curims_hit_info_query_string`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_hit_info_query_string` (
  `hit_id` int(11) NOT NULL,
  `query_string` blob DEFAULT NULL,
  PRIMARY KEY (`hit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:52
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
-- Table structure for table `webman_curims_link_auth`
--

DROP TABLE IF EXISTS `webman_curims_link_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_link_auth` (
  `id_link_auth` int(11) NOT NULL AUTO_INCREMENT,
  `link_id` smallint(6) NOT NULL,
  `login_name` varchar(50) DEFAULT NULL,
  `group_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_link_auth`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_link_auth`
--

LOCK TABLES `webman_curims_link_auth` WRITE;
/*!40000 ALTER TABLE `webman_curims_link_auth` DISABLE KEYS */;
INSERT INTO `webman_curims_link_auth` (`id_link_auth`, `link_id`, `login_name`, `group_name`) VALUES (2,7,NULL,'ADMIN');
/*!40000 ALTER TABLE `webman_curims_link_auth` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:52
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
) ENGINE=InnoDB AUTO_INCREMENT=19563 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_link_reference`
--

LOCK TABLES `webman_curims_link_reference` WRITE;
/*!40000 ALTER TABLE `webman_curims_link_reference` DISABLE KEYS */;
INSERT INTO `webman_curims_link_reference` (`link_ref_id`, `link_id`, `dynamic_content_num`, `dynamic_content_name`, `ref_type`, `ref_name`, `blob_id`) VALUES (1448,6,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(1738,24,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(4295,1,-1,'','DYNAMIC_MODULE','webman_main',-1),
(5162,18,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(5273,34,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(5356,26,-1,'','DYNAMIC_MODULE','webman_main',-1),
(7555,1,-2,'link_main','DYNAMIC_MODULE','webman_dynamic_links',-1),
(10000,5,0,NULL,'DYNAMIC_MODULE','webman_JSON',-1),
(10001,4,0,NULL,'DYNAMIC_MODULE','webman_JSON_authentication',-1),
(13576,31,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(14412,7,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(16063,2,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(16845,27,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(18215,19,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(18326,42,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1);
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

-- Dump completed on 2025-07-01  3:04:52
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
-- Table structure for table `webman_curims_link_structure`
--

DROP TABLE IF EXISTS `webman_curims_link_structure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_link_structure` (
  `link_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `parent_id` smallint(6) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `sequence` smallint(6) DEFAULT NULL,
  `auto_selected` enum('NO','YES') DEFAULT NULL,
  `target_window` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`link_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_link_structure`
--

LOCK TABLES `webman_curims_link_structure` WRITE;
/*!40000 ALTER TABLE `webman_curims_link_structure` DISABLE KEYS */;
INSERT INTO `webman_curims_link_structure` (`link_id`, `parent_id`, `name`, `sequence`, `auto_selected`, `target_window`) VALUES (1,0,'Home',0,'YES',NULL),
(2,0,'json_entities_',1,'NO',NULL),
(3,0,'test_',2,'NO',NULL),
(4,2,'authentication',0,'NO',NULL),
(5,2,'users',1,'NO',NULL),
(6,1,'Dashboard',0,'YES',NULL),
(7,1,'Curriculum',1,'NO',''),
(14,1,'Logout',4,'NO',''),
(18,7,'Course',0,'NO',NULL),
(19,1,'Course',2,'NO',''),
(24,7,'Course List View',1,'NO',''),
(26,19,'CI Details',0,'NO',NULL),
(27,19,'Topic',1,'NO',NULL),
(31,1,'Lecturer',3,'NO',''),
(34,18,'Elective',0,'NO',''),
(42,19,'CLO',2,'NO','');
/*!40000 ALTER TABLE `webman_curims_link_structure` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:52
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
-- Table structure for table `webman_curims_session`
--

DROP TABLE IF EXISTS `webman_curims_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_session` (
  `session_id` varchar(15) NOT NULL,
  `login_name` varchar(50) DEFAULT NULL,
  `login_date` date DEFAULT NULL,
  `login_time` time DEFAULT NULL,
  `last_active_date` date DEFAULT NULL,
  `last_active_time` time DEFAULT NULL,
  `epoch_time` int(11) DEFAULT NULL,
  `idle_time` int(11) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `temp_table` smallint(6) DEFAULT NULL,
  `client_ip` varchar(50) DEFAULT NULL,
  `hits` smallint(6) DEFAULT NULL,
  `auth_status` varchar(15) DEFAULT 'LOCAL',
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:52
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
-- Table structure for table `webman_curims_session_info_daily`
--

DROP TABLE IF EXISTS `webman_curims_session_info_daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_session_info_daily` (
  `date` date NOT NULL,
  `day` smallint(6) NOT NULL,
  `day_abbr` varchar(10) DEFAULT NULL,
  `total_user` int(11) DEFAULT NULL,
  `total_login` int(11) DEFAULT NULL,
  `total_hits` int(11) DEFAULT NULL,
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:53
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
-- Table structure for table `webman_curims_session_info_monthly`
--

DROP TABLE IF EXISTS `webman_curims_session_info_monthly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_session_info_monthly` (
  `yearmonth` varchar(7) NOT NULL,
  `total_user` int(11) DEFAULT NULL,
  `total_login` int(11) DEFAULT NULL,
  `total_hits` int(11) DEFAULT NULL,
  PRIMARY KEY (`yearmonth`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_session_info_monthly`
--

LOCK TABLES `webman_curims_session_info_monthly` WRITE;
/*!40000 ALTER TABLE `webman_curims_session_info_monthly` DISABLE KEYS */;
/*!40000 ALTER TABLE `webman_curims_session_info_monthly` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:53
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
-- Table structure for table `webman_curims_static_content_dyna_mod_ref`
--

DROP TABLE IF EXISTS `webman_curims_static_content_dyna_mod_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_static_content_dyna_mod_ref` (
  `scdmr_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `blob_id` smallint(6) NOT NULL,
  `dynamic_content_name` varchar(255) NOT NULL,
  `dyna_mod_name` varchar(255) NOT NULL,
  PRIMARY KEY (`scdmr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_static_content_dyna_mod_ref`
--

LOCK TABLES `webman_curims_static_content_dyna_mod_ref` WRITE;
/*!40000 ALTER TABLE `webman_curims_static_content_dyna_mod_ref` DISABLE KEYS */;
/*!40000 ALTER TABLE `webman_curims_static_content_dyna_mod_ref` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:53
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
-- Table structure for table `webman_curims_user`
--

DROP TABLE IF EXISTS `webman_curims_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_user` (
  `id_user` binary(6) NOT NULL,
  `login_name` varchar(50) NOT NULL,
  `password` varchar(50) DEFAULT NULL,
  `full_name` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `web_service_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_user`),
  UNIQUE KEY `idx_login_name` (`login_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_user`
--

LOCK TABLES `webman_curims_user` WRITE;
/*!40000 ALTER TABLE `webman_curims_user` DISABLE KEYS */;
INSERT INTO `webman_curims_user` (`id_user`, `login_name`, `password`, `full_name`, `description`, `web_service_url`) VALUES ('I6SlZK','razak','razak','Mohd Razak','Course Owner',NULL),
('h3xjcf','guest','guest','Anonymous User','Guest',NULL),
('sHkacg','thoriq','thoriq','MUHAMMAD THORIQ BIN KAHAIRI','Student',NULL),
('sO9JZ9','admin','admin','Application Administrator','Administrator',NULL);
/*!40000 ALTER TABLE `webman_curims_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:53
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
-- Table structure for table `webman_curims_user_group`
--

DROP TABLE IF EXISTS `webman_curims_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webman_curims_user_group` (
  `id_user_group` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `login_name` varchar(50) DEFAULT NULL,
  `group_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_user_group`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_user_group`
--

LOCK TABLES `webman_curims_user_group` WRITE;
/*!40000 ALTER TABLE `webman_curims_user_group` DISABLE KEYS */;
INSERT INTO `webman_curims_user_group` (`id_user_group`, `login_name`, `group_name`) VALUES (1,'admin','ADMIN'),
(2,'admin','COM_JSON'),
(3,'razak','COURSE_OWNER');
/*!40000 ALTER TABLE `webman_curims_user_group` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-07-01  3:04:53
