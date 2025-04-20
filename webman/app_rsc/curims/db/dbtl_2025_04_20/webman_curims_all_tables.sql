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

-- Dump completed on 2025-04-20 16:31:41
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

-- Dump completed on 2025-04-20 16:31:41
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

-- Dump completed on 2025-04-20 16:31:41
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

-- Dump completed on 2025-04-20 16:31:41
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

-- Dump completed on 2025-04-20 16:31:42
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
) ENGINE=InnoDB AUTO_INCREMENT=6952 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-04-20 16:31:42
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

-- Dump completed on 2025-04-20 16:31:42
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

-- Dump completed on 2025-04-20 16:31:42
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

-- Dump completed on 2025-04-20 16:31:42
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

-- Dump completed on 2025-04-20 16:31:43
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

-- Dump completed on 2025-04-20 16:31:43
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

-- Dump completed on 2025-04-20 16:31:43
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
) ENGINE=InnoDB AUTO_INCREMENT=285 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
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
(82,-1,-1,8,'order_field_cgi_var','order_curims_subject'),
(86,-1,-1,8,'db_items_set_number_var','dbisn_curims_subject'),
(87,-1,-1,8,'dynamic_menu_items_set_number_var','dmisn_curims_subject'),
(88,-1,-1,8,'inl_var_name','inl_curims_subject'),
(89,-1,-1,8,'lsn_var_name','lsn_curims_subject'),
(90,-1,-1,8,'table_name','curims_subject'),
(91,-1,-1,9,'table_name','curims_subject'),
(92,-1,-1,9,'check_on_cgi_data','$db_nama_subjek $db_kredit $db_tahun_ambil $db_semester_ambil $db_pilihan_elektif '),
(93,-1,-1,9,'template_default_confirm','curims_subject_multirows_insert_confirm.html'),
(94,-1,-1,10,'table_name','curims_subject'),
(95,-1,-1,10,'check_on_cgi_data','$db_nama_subjek $db_kredit $db_tahun_ambil $db_semester_ambil $db_pilihan_elektif '),
(96,-1,-1,10,'template_default_confirm','curims_subject_multirows_update_confirm.html'),
(97,-1,-1,10,'update_keys_str','id_subjek=\'$cgi_id_subjek_\''),
(98,-1,-1,11,'table_name','curims_subject'),
(99,-1,-1,11,'template_default','curims_subject_multirows_delete.html'),
(100,-1,-1,11,'delete_keys_str','id_subjek=\'$cgi_id_subjek_\''),
(101,-1,-1,12,'table_name','curims_subject'),
(102,-1,-1,12,'task','insert'),
(103,-1,-1,12,'field_list','nama_subjek kredit tahun_ambil semester_ambil ci pilihan_elektif '),
(104,-1,-1,12,'template_default_confirm','curims_subject_text2db_insert_confirm.html'),
(105,-1,-1,12,'key_field_name','id_subjek'),
(106,-1,-1,13,'table_name','curims_subject'),
(107,-1,-1,13,'task','update'),
(108,-1,-1,13,'field_list','nama_subjek kredit tahun_ambil semester_ambil ci pilihan_elektif '),
(109,-1,-1,13,'template_default_confirm','curims_subject_text2db_update_confirm.html'),
(110,-1,-1,13,'key_field_name','id_subjek'),
(111,-1,-1,14,'table_name','curims_subject'),
(112,-1,-1,14,'task','delete'),
(113,-1,-1,14,'field_list','id_subjek'),
(114,-1,-1,14,'template_default_confirm','curims_subject_text2db_delete_confirm.html'),
(115,-1,-1,14,'key_field_name','id_subjek'),
(125,-1,-1,15,'order_field_cgi_var','order_curims_subject'),
(126,-1,-1,15,'order_field_caption','Kod Subjek:Nama Subjek:Kredit:Tahun Ambil:Semester Ambil:Ci:Pilihan Elektif:Wmf Date Created:Wmf Time Created'),
(127,-1,-1,15,'order_field_name','kod_subjek:nama_subjek:kredit:tahun_ambil:semester_ambil:ci:pilihan_elektif:wmf_date_created:wmf_time_created'),
(128,-1,-1,15,'map_caption_field','Kod Subjek => kod_subjek, Nama Subjek => nama_subjek, Kredit => kredit, Tahun Ambil => tahun_ambil, Semester Ambil => semester_ambil, Ci => ci, Pilihan Elektif => pilihan_elektif, Wmf Date Created => wmf_date_created, Wmf Time Created => wmf_time_created'),
(129,-1,-1,15,'db_items_set_number_var','dbisn_curims_subject'),
(130,-1,-1,15,'dynamic_menu_items_set_number_var','dmisn_curims_subject'),
(131,-1,-1,15,'inl_var_name','inl_curims_subject'),
(132,-1,-1,15,'lsn_var_name','lsn_curims_subject'),
(133,-1,-1,15,'table_name','curims_subject'),
(134,-1,-1,8,'order_field_caption','Kod Subjek:Nama Subjek:Kredit:Tahun Ambil:Semester Ambil:CI:Pilihan Elektif: Wmf Date Created: Wmf Time Created'),
(135,-1,-1,8,'order_field_name','kod_subjek:nama_subjek:kredit:tahun_ambil:semester_ambil:ci:pilihan_elektif:wmf_date_created:wmf_time_created'),
(136,-1,-1,8,'map_caption_field','Kod Subjek =&amp;gt; kod_subjek, Nama Subjek =&amp;amp;gt; nama_subjek, Kredit =&amp;amp;gt; kredit, Tahun Ambil =&amp;amp;gt; tahun_ambil, Semester Ambil =&amp;amp;gt; semester_ambil, CI =&amp;amp;gt; ci, Pilihan Elektif =&amp;amp;gt; pilihan_elektif, Wmf Date Created =&amp;gt; wmf_date_created, Wmf Time Created =&amp;gt; wmf_time_created'),
(246,-1,-1,35,'order_field_cgi_var','order_curims_curriculum'),
(247,-1,-1,35,'order_field_caption','Nama Kurikulum:Kod Kurikulum:Sesi Masuk:Semester Masuk:Tahun Masuk:Plo:Wmf Date Created:Wmf Time Created'),
(248,-1,-1,35,'order_field_name','nama_kurikulum:kod_kurikulum:sesi_masuk:semester_masuk:tahun_masuk:PLO:wmf_date_created:wmf_time_created'),
(249,-1,-1,35,'map_caption_field','Nama Kurikulum => nama_kurikulum, Kod Kurikulum => kod_kurikulum, Sesi Masuk => sesi_masuk, Semester Masuk => semester_masuk, Tahun Masuk => tahun_masuk, Plo => PLO, Wmf Date Created => wmf_date_created, Wmf Time Created => wmf_time_created'),
(250,-1,-1,35,'db_items_set_number_var','dbisn_curims_curriculum'),
(251,-1,-1,35,'dynamic_menu_items_set_number_var','dmisn_curims_curriculum'),
(252,-1,-1,35,'inl_var_name','inl_curims_curriculum'),
(253,-1,-1,35,'lsn_var_name','lsn_curims_curriculum'),
(254,-1,-1,35,'table_name','curims_curriculum'),
(255,-1,-1,36,'table_name','curims_curriculum'),
(256,-1,-1,36,'template_default_confirm','curims_curriculum_multirows_insert_confirm.html'),
(257,-1,-1,37,'table_name','curims_curriculum'),
(258,-1,-1,37,'template_default_confirm','curims_curriculum_multirows_update_confirm.html'),
(259,-1,-1,37,'update_keys_str','id_curriculum_62base=\'$cgi_id_curriculum_62base_\''),
(260,-1,-1,38,'table_name','curims_curriculum'),
(261,-1,-1,38,'template_default','curims_curriculum_multirows_delete.html'),
(262,-1,-1,38,'delete_keys_str','id_curriculum_62base=\'$cgi_id_curriculum_62base_\''),
(263,-1,-1,39,'order_field_cgi_var','order_curims_subject'),
(264,-1,-1,39,'order_field_caption','Kod Subjek:Nama Subjek:Kredit:Tahun Ambil:Semester Ambil:Ci:Pilihan Elektif:Wmf Date Created:Wmf Time Created'),
(265,-1,-1,39,'order_field_name','kod_subjek:nama_subjek:kredit:tahun_ambil:semester_ambil:ci:pilihan_elektif:wmf_date_created:wmf_time_created'),
(266,-1,-1,39,'map_caption_field','Kod Subjek => kod_subjek, Nama Subjek => nama_subjek, Kredit => kredit, Tahun Ambil => tahun_ambil, Semester Ambil => semester_ambil, Ci => ci, Pilihan Elektif => pilihan_elektif, Wmf Date Created => wmf_date_created, Wmf Time Created => wmf_time_created'),
(267,-1,-1,39,'db_items_set_number_var','dbisn_curims_subject'),
(268,-1,-1,39,'dynamic_menu_items_set_number_var','dmisn_curims_subject'),
(269,-1,-1,39,'inl_var_name','inl_curims_subject'),
(270,-1,-1,39,'lsn_var_name','lsn_curims_subject'),
(271,-1,-1,39,'sql','select t_view.*, t_med.* from curims_subject t_view, curims_currsubject t_med where t_med.id_curriculum_62base =\'$cgi_id_curriculum_62base_\' and t_med.id_subject_62base = t_view.id_subject_62base order by $cgi_order_curims_subject_'),
(272,-1,-1,40,'order_field_cgi_var','order_curims_subject_AFLS'),
(273,-1,-1,40,'order_field_caption','Kod Subjek:Nama Subjek:Kredit:Tahun Ambil:Semester Ambil:Ci:Pilihan Elektif:Wmf Date Created:Wmf Time Created'),
(274,-1,-1,40,'order_field_name','kod_subjek:nama_subjek:kredit:tahun_ambil:semester_ambil:ci:pilihan_elektif:wmf_date_created:wmf_time_created'),
(275,-1,-1,40,'map_caption_field','Kod Subjek => kod_subjek, Nama Subjek => nama_subjek, Kredit => kredit, Tahun Ambil => tahun_ambil, Semester Ambil => semester_ambil, Ci => ci, Pilihan Elektif => pilihan_elektif, Wmf Date Created => wmf_date_created, Wmf Time Created => wmf_time_created'),
(276,-1,-1,40,'db_items_set_number_var','dbisn_curims_subject_AFLS'),
(277,-1,-1,40,'dynamic_menu_items_set_number_var','dmisn_curims_subject_AFLS'),
(278,-1,-1,40,'inl_var_name','inl_curims_subject_AFLS'),
(279,-1,-1,40,'lsn_var_name','lsn_curims_subject_AFLS'),
(280,-1,-1,40,'link_path_additional_get_data','task=&button_submit='),
(281,-1,-1,40,'sql','select * from curims_subject where id_subject_62base not in (select id_subject_62base from curims_currsubject where id_curriculum_62base=\'$cgi_id_curriculum_62base_\') order by $cgi_order_curims_subject_AFLS_'),
(282,-1,-1,41,'table_name','curims_currsubject'),
(283,-1,-1,41,'delete_keys_str','id_currsubject_62base=\'$cgi_id_currsubject_62base_\''),
(284,-1,-1,41,'last_phase_cgi_data_reset','task=\'curims_curriculum_subject_list\' button_submit');
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

-- Dump completed on 2025-04-20 16:31:43
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

-- Dump completed on 2025-04-20 16:31:43
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
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webman_curims_dyna_mod_selector`
--

LOCK TABLES `webman_curims_dyna_mod_selector` WRITE;
/*!40000 ALTER TABLE `webman_curims_dyna_mod_selector` DISABLE KEYS */;
INSERT INTO `webman_curims_dyna_mod_selector` (`dyna_mod_selector_id`, `link_ref_id`, `parent_id`, `cgi_param`, `cgi_value`, `dyna_mod_name`) VALUES (8,15852,NULL,'task','','curims_subject_list'),
(9,15852,NULL,'task','curims_subject_multirows_insert','curims_subject_multirows_insert'),
(10,15852,NULL,'task','curims_subject_multirows_update','curims_subject_multirows_update'),
(11,15852,NULL,'task','curims_subject_multirows_delete','curims_subject_multirows_delete'),
(12,15852,NULL,'task','curims_subject_text2db_insert','curims_subject_text2db_insert'),
(13,15852,NULL,'task','curims_subject_text2db_update','curims_subject_text2db_update'),
(14,15852,NULL,'task','curims_subject_text2db_delete','curims_subject_text2db_delete'),
(15,15852,NULL,'task','','curims_subject_curriculum_link'),
(35,11933,NULL,'task','','curims_curriculum_subject_link'),
(36,11933,NULL,'task','curims_curriculum_multirows_insert','curims_curriculum_multirows_insert'),
(37,11933,NULL,'task','curims_curriculum_multirows_update','curims_curriculum_multirows_update'),
(38,11933,NULL,'task','curims_curriculum_multirows_delete','curims_curriculum_multirows_delete'),
(39,14941,NULL,'task','','curims_curriculum_subject_list'),
(40,14941,NULL,'task','curims_curriculum_subject_add','curims_curriculum_subject_add'),
(41,14941,NULL,'task','curims_curriculum_subject_remove','curims_curriculum_subject_remove');
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

-- Dump completed on 2025-04-20 16:31:44
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

-- Dump completed on 2025-04-20 16:31:44
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
) ENGINE=InnoDB AUTO_INCREMENT=681 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-04-20 16:31:44
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

-- Dump completed on 2025-04-20 16:31:44
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

-- Dump completed on 2025-04-20 16:31:44
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

-- Dump completed on 2025-04-20 16:31:44
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
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
(8,1,'Subject',2,'NO',''),
(9,1,'Admin',3,'NO',''),
(10,1,'Logout',4,'NO',''),
(12,7,'Add Subject',0,'NO','');
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

-- Dump completed on 2025-04-20 16:31:45
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

-- Dump completed on 2025-04-20 16:31:45
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

-- Dump completed on 2025-04-20 16:31:45
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

-- Dump completed on 2025-04-20 16:31:45
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

-- Dump completed on 2025-04-20 16:31:45
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

-- Dump completed on 2025-04-20 16:31:46
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

-- Dump completed on 2025-04-20 16:31:46
