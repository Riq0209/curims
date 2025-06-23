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

-- Dump completed on 2025-05-18 12:33:59
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

-- Dump completed on 2025-05-18 12:33:59
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

-- Dump completed on 2025-05-18 12:33:59
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

-- Dump completed on 2025-05-18 12:34:00
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

-- Dump completed on 2025-05-18 12:34:00
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
) ENGINE=InnoDB AUTO_INCREMENT=40810 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-05-18 12:34:00
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
('web_man_JSON_authentication',NULL,'COM_JSON');
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

-- Dump completed on 2025-05-18 12:34:00
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

-- Dump completed on 2025-05-18 12:34:00
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

-- Dump completed on 2025-05-18 12:34:00
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

-- Dump completed on 2025-05-18 12:34:00
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

-- Dump completed on 2025-05-18 12:34:01
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

-- Dump completed on 2025-05-18 12:34:01
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
) ENGINE=InnoDB AUTO_INCREMENT=1482 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_dyna_mod_param`
--

LOCK TABLES `webman_curims_dyna_mod_param` WRITE;
/*!40000 ALTER TABLE `webman_curims_dyna_mod_param` DISABLE KEYS */;
INSERT INTO `webman_curims_dyna_mod_param` (`dmp_id`, `link_ref_id`, `scdmr_id`, `dyna_mod_selector_id`, `param_name`, `param_value`) VALUES (1,10000,-1,-1,'sql','select id_user, login_name, full_name, description, web_service_url from webman_curims_user order by full_name'),
(3,7555,-1,-1,'link_path_level','1'),
(4,7555,-1,-1,'link_separator_tag','|'),
(12,1167,-1,-1,'html_content','<center><h2>Welcome to CURIMS</h2>'),
(34,4295,-1,-1,'template_default','template_main.html'),
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
(1374,-1,-1,242,'order_field_cgi_var','order_curims_course'),
(1375,-1,-1,242,'order_field_caption','Course Code:Course Name:Credit Hour:Ci:Created Date:Created Time'),
(1376,-1,-1,242,'order_field_name','course_code:course_name:credit_hour:ci:created_date:created_time'),
(1377,-1,-1,242,'map_caption_field','Course Code => course_code, Course Name => course_name, Credit Hour => credit_hour, Ci => ci, Created Date => created_date, Created Time => created_time'),
(1378,-1,-1,242,'db_items_set_number_var','dbisn_curims_course'),
(1379,-1,-1,242,'dynamic_menu_items_set_number_var','dmisn_curims_course'),
(1380,-1,-1,242,'inl_var_name','inl_curims_course'),
(1381,-1,-1,242,'lsn_var_name','lsn_curims_course'),
(1382,-1,-1,242,'table_name','curims_course'),
(1383,-1,-1,243,'table_name','curims_course'),
(1384,-1,-1,243,'check_on_cgi_data','$db_course_code $db_course_name $db_credit_hour '),
(1385,-1,-1,243,'template_default_confirm','curims_course_multirows_insert_confirm.html'),
(1386,-1,-1,244,'table_name','curims_course'),
(1387,-1,-1,244,'check_on_cgi_data','$db_course_code $db_course_name $db_credit_hour '),
(1388,-1,-1,244,'template_default_confirm','curims_course_multirows_update_confirm.html'),
(1389,-1,-1,244,'update_keys_str','id_course_62base=\'$cgi_id_course_62base_\''),
(1390,-1,-1,245,'table_name','curims_course'),
(1391,-1,-1,245,'template_default','curims_course_multirows_delete.html'),
(1392,-1,-1,245,'delete_keys_str','id_course_62base=\'$cgi_id_course_62base_\''),
(1393,-1,-1,246,'order_field_cgi_var','order_curims_plo'),
(1394,-1,-1,246,'order_field_caption','Plo Code:Plo Description:Created Date:Created Time'),
(1395,-1,-1,246,'order_field_name','plo_code:plo_description:created_date:created_time'),
(1396,-1,-1,246,'map_caption_field','Plo Code => plo_code, Plo Description => plo_description, Created Date => created_date, Created Time => created_time'),
(1397,-1,-1,246,'db_items_set_number_var','dbisn_curims_plo'),
(1398,-1,-1,246,'dynamic_menu_items_set_number_var','dmisn_curims_plo'),
(1399,-1,-1,246,'inl_var_name','inl_curims_plo'),
(1400,-1,-1,246,'lsn_var_name','lsn_curims_plo'),
(1401,-1,-1,246,'table_name','curims_plo'),
(1402,-1,-1,247,'table_name','curims_plo'),
(1403,-1,-1,247,'check_on_cgi_data','$db_plo_code '),
(1404,-1,-1,247,'template_default_confirm','curims_plo_multirows_insert_confirm.html'),
(1405,-1,-1,248,'table_name','curims_plo'),
(1406,-1,-1,248,'check_on_cgi_data','$db_plo_code '),
(1407,-1,-1,248,'template_default_confirm','curims_plo_multirows_update_confirm.html'),
(1408,-1,-1,248,'update_keys_str','id_plo_62base=\'$cgi_id_plo_62base_\''),
(1409,-1,-1,249,'table_name','curims_plo'),
(1410,-1,-1,249,'template_default','curims_plo_multirows_delete.html'),
(1411,-1,-1,249,'delete_keys_str','id_plo_62base=\'$cgi_id_plo_62base_\''),
(1412,-1,-1,250,'order_field_cgi_var','order_curims_curriculum'),
(1413,-1,-1,250,'order_field_caption','Curriculum Code:Curriculum Name:Intake Session:Intake Year:Intake Semester:Created Date:Created Time'),
(1414,-1,-1,250,'order_field_name','curriculum_code:curriculum_name:intake_session:intake_year:intake_semester:created_date:created_time'),
(1415,-1,-1,250,'map_caption_field','Curriculum Code => curriculum_code, Curriculum Name => curriculum_name, Intake Session => intake_session, Intake Year => intake_year, Intake Semester => intake_semester, Created Date => created_date, Created Time => created_time'),
(1416,-1,-1,250,'db_items_set_number_var','dbisn_curims_curriculum'),
(1417,-1,-1,250,'dynamic_menu_items_set_number_var','dmisn_curims_curriculum'),
(1418,-1,-1,250,'inl_var_name','inl_curims_curriculum'),
(1419,-1,-1,250,'lsn_var_name','lsn_curims_curriculum'),
(1420,-1,-1,250,'table_name','curims_curriculum'),
(1421,-1,-1,251,'table_name','curims_curriculum'),
(1422,-1,-1,251,'template_default_confirm','curims_curriculum_multirows_insert_confirm.html'),
(1423,-1,-1,252,'table_name','curims_curriculum'),
(1424,-1,-1,252,'template_default_confirm','curims_curriculum_multirows_update_confirm.html'),
(1425,-1,-1,252,'update_keys_str','id_curriculum_62base=\'$cgi_id_curriculum_62base_\''),
(1426,-1,-1,253,'table_name','curims_curriculum'),
(1427,-1,-1,253,'template_default','curims_curriculum_multirows_delete.html'),
(1428,-1,-1,253,'delete_keys_str','id_curriculum_62base=\'$cgi_id_curriculum_62base_\''),
(1429,-1,-1,254,'order_field_cgi_var','order_curims_course'),
(1430,-1,-1,254,'order_field_caption','Course Code:Course Name:Credit Hour:Ci:Created Date:Created Time'),
(1431,-1,-1,254,'order_field_name','course_code:course_name:credit_hour:ci:created_date:created_time'),
(1432,-1,-1,254,'map_caption_field','Course Code => course_code, Course Name => course_name, Credit Hour => credit_hour, Ci => ci, Created Date => created_date, Created Time => created_time'),
(1433,-1,-1,254,'db_items_set_number_var','dbisn_curims_course'),
(1434,-1,-1,254,'dynamic_menu_items_set_number_var','dmisn_curims_course'),
(1435,-1,-1,254,'inl_var_name','inl_curims_course'),
(1436,-1,-1,254,'lsn_var_name','lsn_curims_course'),
(1437,-1,-1,254,'sql','select t_view.*, t_med.* from curims_course t_view, curims_currcourse t_med where t_med.id_curriculum_62base =\'$cgi_id_curriculum_62base_\' and t_med.id_course_62base = t_view.id_course_62base order by $cgi_order_curims_course_'),
(1438,-1,-1,255,'order_field_cgi_var','order_curims_course_AFLS'),
(1439,-1,-1,255,'order_field_caption','Course Code:Course Name:Credit Hour:Ci:Created Date:Created Time'),
(1440,-1,-1,255,'order_field_name','course_code:course_name:credit_hour:ci:created_date:created_time'),
(1441,-1,-1,255,'map_caption_field','Course Code => course_code, Course Name => course_name, Credit Hour => credit_hour, Ci => ci, Created Date => created_date, Created Time => created_time'),
(1442,-1,-1,255,'db_items_set_number_var','dbisn_curims_course_AFLS'),
(1443,-1,-1,255,'dynamic_menu_items_set_number_var','dmisn_curims_course_AFLS'),
(1444,-1,-1,255,'inl_var_name','inl_curims_course_AFLS'),
(1445,-1,-1,255,'lsn_var_name','lsn_curims_course_AFLS'),
(1446,-1,-1,255,'link_path_additional_get_data','task=&button_submit='),
(1447,-1,-1,255,'sql','select * from curims_course where id_course_62base not in (select id_course_62base from curims_currcourse where id_curriculum_62base=\'$cgi_id_curriculum_62base_\') order by $cgi_order_curims_course_AFLS_'),
(1448,-1,-1,256,'table_name','curims_currcourse'),
(1449,-1,-1,256,'delete_keys_str','id_currcourse_62base=\'$cgi_id_currcourse_62base_\''),
(1450,-1,-1,256,'last_phase_cgi_data_reset','task=\'curims_curriculum_course_list\' button_submit'),
(1451,-1,-1,257,'order_field_cgi_var','order_curims_curriculum_details'),
(1452,-1,-1,257,'order_field_caption','Created Date:Created Time'),
(1453,-1,-1,257,'order_field_name','created_date:created_time'),
(1454,-1,-1,257,'map_caption_field','Created Date => created_date, Created Time => created_time'),
(1455,-1,-1,257,'db_items_set_number_var','dbisn_curims_curriculum_details'),
(1456,-1,-1,257,'dynamic_menu_items_set_number_var','dmisn_curims_curriculum_details'),
(1457,-1,-1,257,'inl_var_name','inl_curims_curriculum_details'),
(1458,-1,-1,257,'lsn_var_name','lsn_curims_curriculum_details'),
(1459,-1,-1,257,'sql','select * from curims_curriculum_details where id_curriculum_62base=\'$cgi_id_curriculum_62base_\' order by $cgi_order_curims_curriculum_details_'),
(1460,-1,-1,258,'order_field_cgi_var','order_curims_plo'),
(1461,-1,-1,258,'order_field_caption','Plo Code:Plo Description:Created Date:Created Time'),
(1462,-1,-1,258,'order_field_name','plo_code:plo_description:created_date:created_time'),
(1463,-1,-1,258,'map_caption_field','Plo Code => plo_code, Plo Description => plo_description, Created Date => created_date, Created Time => created_time'),
(1464,-1,-1,258,'db_items_set_number_var','dbisn_curims_plo'),
(1465,-1,-1,258,'dynamic_menu_items_set_number_var','dmisn_curims_plo'),
(1466,-1,-1,258,'inl_var_name','inl_curims_plo'),
(1467,-1,-1,258,'lsn_var_name','lsn_curims_plo'),
(1468,-1,-1,258,'sql','select t_view.*, t_med.* from curims_plo t_view, curims_currplo t_med where t_med.id_curriculum_62base =\'$cgi_id_curriculum_62base_\' and t_med.id_plo_62base = t_view.id_plo_62base order by $cgi_order_curims_plo_'),
(1469,-1,-1,259,'order_field_cgi_var','order_curims_plo_AFLS'),
(1470,-1,-1,259,'order_field_caption','Plo Code:Plo Description:Created Date:Created Time'),
(1471,-1,-1,259,'order_field_name','plo_code:plo_description:created_date:created_time'),
(1472,-1,-1,259,'map_caption_field','Plo Code => plo_code, Plo Description => plo_description, Created Date => created_date, Created Time => created_time'),
(1473,-1,-1,259,'db_items_set_number_var','dbisn_curims_plo_AFLS'),
(1474,-1,-1,259,'dynamic_menu_items_set_number_var','dmisn_curims_plo_AFLS'),
(1475,-1,-1,259,'inl_var_name','inl_curims_plo_AFLS'),
(1476,-1,-1,259,'lsn_var_name','lsn_curims_plo_AFLS'),
(1477,-1,-1,259,'link_path_additional_get_data','task=&button_submit='),
(1478,-1,-1,259,'sql','select * from curims_plo where id_plo_62base not in (select id_plo_62base from curims_currplo where id_curriculum_62base=\'$cgi_id_curriculum_62base_\') order by $cgi_order_curims_plo_AFLS_'),
(1479,-1,-1,260,'table_name','curims_currplo'),
(1480,-1,-1,260,'delete_keys_str','id_currplo_62base=\'$cgi_id_currplo_62base_\''),
(1481,-1,-1,260,'last_phase_cgi_data_reset','task=\'curims_curriculum_plo_list\' button_submit');
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

-- Dump completed on 2025-05-18 12:34:01
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

-- Dump completed on 2025-05-18 12:34:01
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

-- Dump completed on 2025-05-18 12:34:01
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
('kcCH1F','COM_JSON','JSON-based Service Users');
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

-- Dump completed on 2025-05-18 12:34:01
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
) ENGINE=InnoDB AUTO_INCREMENT=2753 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-05-18 12:34:01
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

-- Dump completed on 2025-05-18 12:34:02
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

-- Dump completed on 2025-05-18 12:34:02
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_link_auth`
--

LOCK TABLES `webman_curims_link_auth` WRITE;
/*!40000 ALTER TABLE `webman_curims_link_auth` DISABLE KEYS */;
INSERT INTO `webman_curims_link_auth` (`id_link_auth`, `link_id`, `login_name`, `group_name`) VALUES (1,9,'admin',NULL);
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

-- Dump completed on 2025-05-18 12:34:02
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
INSERT INTO `webman_curims_link_reference` (`link_ref_id`, `link_id`, `dynamic_content_num`, `dynamic_content_name`, `ref_type`, `ref_name`, `blob_id`) VALUES (1167,6,-2,'content_main','DYNAMIC_MODULE','webman_HTML_printer',-1),
(4295,1,-1,'','DYNAMIC_MODULE','webman_main',-1),
(7555,1,-2,'link_main','DYNAMIC_MODULE','webman_dynamic_links',-1),
(10000,5,0,NULL,'DYNAMIC_MODULE','webman_JSON',-1),
(10001,4,0,NULL,'DYNAMIC_MODULE','webman_JSON_authentication',-1),
(10239,19,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(10897,20,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(14822,21,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(15376,22,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(16063,2,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(16283,18,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1),
(17529,7,-2,'content_main','DYNAMIC_MODULE','webman_component_selector',-1);
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

-- Dump completed on 2025-05-18 12:34:02
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
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
(9,1,'Admin',4,'NO',''),
(14,1,'Logout',5,'NO',''),
(18,7,'Add Course',0,'NO',NULL),
(19,1,'Course',3,'NO',''),
(20,7,'Curriculum Details',1,'NO',''),
(21,1,'PLO',2,'NO',''),
(22,7,'Add PLO',2,'NO',''),
(23,7,'Curriculum Course List',3,'NO',''),
(24,7,'Course List View',4,'NO',''),
(25,7,'Curriculum PLO List',5,'NO',''),
(26,19,'CI',0,'NO','');
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

-- Dump completed on 2025-05-18 12:34:02
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

-- Dump completed on 2025-05-18 12:34:02
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

-- Dump completed on 2025-05-18 12:34:02
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

-- Dump completed on 2025-05-18 12:34:03
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

-- Dump completed on 2025-05-18 12:34:03
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
INSERT INTO `webman_curims_user` (`id_user`, `login_name`, `password`, `full_name`, `description`, `web_service_url`) VALUES ('h3xjcf','guest','guest','Anonymous User','Guest',NULL),
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

-- Dump completed on 2025-05-18 12:34:03
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_user_group`
--

LOCK TABLES `webman_curims_user_group` WRITE;
/*!40000 ALTER TABLE `webman_curims_user_group` DISABLE KEYS */;
INSERT INTO `webman_curims_user_group` (`id_user_group`, `login_name`, `group_name`) VALUES (1,'admin','ADMIN'),
(2,'admin','COM_JSON');
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

-- Dump completed on 2025-05-18 12:34:03
