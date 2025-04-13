#! /usr/bin/perl

unshift (@INC, "../../../pm/core");

use DBI;
require Text_DB_Map;

my $dbi_conn = DBI->connect("DBI:mysql:dbname=db_qbs:localhost", "qbs", "qbs");

my $txt2db = new Text_DB_Map;

$txt2db->set_Text_File_Name("test_data_insert.txt");
#$txt2db->set_Text_File_Name("test_data_update.txt");

#my $text_content = "| Mohd Razak Samingan | 37 | 20 |\n| Suriati Sadimon     | 54 | 32 |";
#my $text_content = "Mohd Razak Samingan \t37 \t20\nSuriati Sadimon     \t54 \t32";
#$txt2db->set_Text_File_Content($text_content);

$txt2db->set_Spliter_Column("\t");
$txt2db->set_Conn($dbi_conn);
$txt2db->set_Table_Name("qbs_multi_row_item");

$txt2db->set_Key_Field_Name("id_qbs_multi_row_item_62base");
$txt2db->set_Key_Field_Type("62Base");

$txt2db->set_Field_List(["name", "course_work", "final_exam"]);
$txt2db->insert_Row;

#$txt2db->set_Field_List(["id_qbs_multi_row_item_62base", "name", "course_work", "final_exam"]);
#$txt2db->update_Row;


### print back item rows being insert/update
my $tld = $txt2db->get_TLD;
print $tld->get_Table_List;