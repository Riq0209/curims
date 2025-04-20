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
