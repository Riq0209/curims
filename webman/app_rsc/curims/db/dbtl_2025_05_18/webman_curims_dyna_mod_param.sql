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

-- Dump completed on 2025-05-18  2:56:31
