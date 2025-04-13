package web_man_admin_blob_content_reload;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_blob_content_separator;
use web_man_admin_blob_content_delete;
use web_man_admin_blob_content_upload;

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{current_blob_id} = undef;
    
    $this->{child_interface} = undef;
    
    $this->{pre_table_name} = undef;
    
    bless $this, $type;
    
    return $this;
}

sub get_Name {
    my $this = shift @_;
    
    return __PACKAGE__;
}

sub get_Name_Full {
    my $this = shift @_;
    
    return $this->SUPER::get_Name_Full . "::" . __PACKAGE__;
}

sub run_Task {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    if ($cgi->param("trace_module")) {
        print "<b>" . $this->get_Name_Full . "</b><br />\n";
    }    
    
    my $task = $cgi->param("task");
    my $blob_id = $cgi->param("blob_id");
    my $app_name = $cgi->param("app_name");
    my $submit = $cgi->param("submit");
    
    $this->{pre_table_name} = "webman_" . $app_name  . "_";
    
    my @file_name = undef;
    my @file_content = undef;
    
    my $htmldb = new HTML_DB_Map;
    
    $htmldb->set_CGI($cgi);
    $htmldb->set_DBI_Conn($db_conn);
    
    my $dbu = new DB_Utilities; 
    $dbu->set_DBI_Conn($db_conn); ### option 1
    
    if ($task eq "reload_phase2" || $task eq "reload_phase4") {
        @file_name = $cgi->upl_File_Name;
        @file_content = $cgi->upl_File_Content;
        
    } elsif ($task eq "reload_phase3") {
        
        $dbu->set_Table($this->{pre_table_name} . "blob_content_temp");
        
        $file_name[0] = $dbu->get_Item("filename", "blob_id", $blob_id) .
                        "." .
                        $dbu->get_Item("extension", "blob_id", $blob_id);
                        
        $file_content[0] = $dbu->get_Item("content", "blob_id", $blob_id);
        
        print "\$file_name[0] = $file_name[0] <br>";
        #print "\$file_content[0] = $file_content[0] <br>";
    }
    
    
    
    $dbu->set_Table($this->{pre_table_name} . "blob_info");
    
    my $blob_file_name = $dbu->get_Item("filename", "blob_id", "$blob_id") .
                         "." .
                         $dbu->get_Item("extension", "blob_id", "$blob_id");
                         
    my $file_ext = $dbu->get_Item("extension", "blob_id", "$blob_id");
    my $owner_entity_id = $dbu->get_Item("owner_entity_id", "blob_id", "$blob_id");
    
    #print "\$owner_entity_id = $owner_entity_id <br>\n";
    
    $dbu->set_Table($this->{pre_table_name} . "link_reference");
    my $link_id = $dbu->get_Item("link_id", "link_ref_id", "$owner_entity_id");
    
    $dbu->set_Table($this->{pre_table_name} . "link_structure");
    my $link_name = $dbu->get_Item("name", "link_id", "$link_id");
    
    my $link_name_get_fmt = $link_name;
    
    $link_name_get_fmt =~ s/ /\+/g;
    $link_name_get_fmt =~ s/\&/\%26/g;
    
    #print "\$link_name_get_fmt = $link_name_get_fmt <br>\n";
                         
    #print "$file_name[0] : $blob_file_name <br>";
    
    if($blob_id ne "" && $file_name[0] eq $blob_file_name && $task ne "reload_phase4") {
            
        #print "Try to reload:  $file_name[0] = $blob_id : \$task = $task : \$submit = $submit<br>";
        
        if (uc($file_ext) eq "HTM" || uc($file_ext) eq "HTML") {
            if ($task eq "reload_phase3") {
                my $web_man_bcs = new web_man_admin_blob_content_separator;
                        
                $web_man_bcs->set_HTML_BLOB_Content($file_content[0]);
                $file_content[0] = $web_man_bcs->get_HTML_Code;
            }
            
            my $htmlos = new HTML_Object_Separator;
                    
            $htmlos->set_Doc_Content($file_content[0]);
            $htmlos->set_Owner_Entity("$owner_entity_id", "link_reference");
            $htmlos->set_Caller_CGI_GET_Data("session_id=\$cgi_session_id_&link_name=$link_name_get_fmt&link_id=$link_id&dmisn=1");
            $htmlos->add_CGI_Get_Data("app_name=$app_name");
            #$htmlos->set_BLOB_Printer_Script("web_man_blob_content_printer_v2.cgi");
            
            $file_content[0] = $htmlos->get_Doc_Content_BLOB_Prefered;
            my @html_obj_blob_prefered = $htmlos->get_HTML_Object_BLOB_Prefered;
            
            $dbu->set_Table($this->{pre_table_name} . "blob_content");
            my $file_content_old = $dbu->get_Item("content", "blob_id", "$blob_id");
            
            my $web_man_bcs2 = new web_man_admin_blob_content_separator;
            
            $web_man_bcs2->set_HTML_BLOB_Content($file_content_old);
            $file_content_old = $web_man_bcs2->get_HTML_Code;
            
            $htmlos->reset;
            $htmlos->set_Doc_Content($file_content_old);
            $htmlos->set_Owner_Entity("$owner_entity_id", "link_reference");
            $htmlos->set_Caller_CGI_GET_Data("link_name=$link_name_get_fmt&link_id=$link_id&dmisn=1");
            $htmlos->add_CGI_Get_Data("app_name=$app_name");
                        
            my @html_obj_blob_prefered_old = $htmlos->get_HTML_Object_BLOB_Prefered;
            
            #print "$file_content_old <br>";
            #print "$file_content[0] <br>";
            
            if($task eq "reload_phase2") {
                my $web_man_bcd = new web_man_admin_blob_content_delete;
                $web_man_bcd->set_CGI($cgi);
                $web_man_bcd->set_DBI_Conn($db_conn);

                $web_man_bcd->set_Owner_Entity("$owner_entity_id", "link_reference");
                $web_man_bcd->set_Old_BLOB_Prefered_List(@html_obj_blob_prefered_old);
                $web_man_bcd->set_New_BLOB_Prefered_List(@html_obj_blob_prefered);
                $web_man_bcd->run_Task;
                $web_man_bcd->process_Content;

                if ($web_man_bcd->get_Deleted_BLOB_ID ne undef) {
                    $this->{child_interface} = $web_man_bcd->get_Content;
                    
                    ### insert file into blob_content_temp
                    
                    $cgi->set_Param_Val("\$db_blob_id", "$blob_id");
                    $cgi->set_Param_Val("\$db_content", "$file_content[0]");
                    $cgi->set_Param_Val("\$db_owner_entity_id", "$owner_entity_id");
                    $cgi->set_Param_Val("\$db_owner_entity_name", "link_reference");
                    
                    $dbu->set_Table($this->{pre_table_name} . "blob_info");
                    
                    $cgi->set_Param_Val("\$db_filename", $dbu->get_Item("filename", "blob_id", "$blob_id"));
                    #print "SQL: " . $dbu->get_SQL . "<br>\n";
                    
                    $cgi->set_Param_Val("\$db_extension", $dbu->get_Item("extension", "blob_id", "$blob_id"));
                    #print "SQL: " . $dbu->get_SQL . "<br>\n";
                    
                    #print "\$db_blob_id = " . $cgi->param("\$db_blob_id") . "<br>\n";
                    #print "\$db_filename = " . $cgi->param("\$db_filename") . "<br>\n";
                    #print "\$db_extension = " . $cgi->param("\$db_extension") . "<br>\n";
                    
                    $htmldb->set_Table($this->{pre_table_name} . "blob_content_temp");
                    $htmldb->insert_Table; 
                    
                    #print "SQL: " . $htmldb->get_SQL . "<br>\n";
                    
                } else {
                    $this->reload_File($blob_id, $file_content[0]);
                    
                    my $web_man_bcu = new web_man_admin_blob_content_upload;
                    $web_man_bcu->set_CGI($cgi);
                    $web_man_bcu->set_DBI_Conn($db_conn);

                    $web_man_bcu->set_Owner_Entity("$owner_entity_id", "link_reference");
                    $web_man_bcu->set_Old_BLOB_Prefered_List(@html_obj_blob_prefered_old);
                    $web_man_bcu->set_New_BLOB_Prefered_List(@html_obj_blob_prefered);
                    $web_man_bcu->run_Task;
                    $web_man_bcu->process_Content;

                    if ($web_man_bcu->get_Upload_Files ne undef) {
                        $this->{child_interface} = $web_man_bcu->get_Content;
                    }
                }
                
                
            } elsif($task eq "reload_phase3") {
            
                print "Enter reload_phase3 <br>";
                
                if ($submit eq "Continue") {
                    ### delete existing BLOB content from blob_info and blob_content
                    my @delete_blob_id_list = split(/,/, $cgi->param("delete_blob_id_list"));
                
                    my $i = 0;
                    
                    for ($i = 0; $i < @delete_blob_id_list; $i++) {
                        $dbu->set_Table($this->{pre_table_name} . "blob_info");
                        $dbu->delete_Item("blob_id", "$delete_blob_id_list[$i]");
                    
                        $dbu->set_Table($this->{pre_table_name} . "blob_content");
                        $dbu->delete_Item("blob_id", "$delete_blob_id_list[$i]");
                    }
                
                
                    ### copy new reload file from blob_content_temp into blob_content 
                    
                    $dbu->set_Table($this->{pre_table_name} . "blob_content");
                    $dbu->delete_Item("blob_id", "$blob_id");
                    
                    $dbu->set_Table($this->{pre_table_name} . "blob_content_temp");
                    $cgi->set_Param_Val("\$db_content", $dbu->get_Item("content","blob_id", "$blob_id"));
                    $cgi->set_Param_Val("\$db_blob_id", $blob_id);
                    
                    $htmldb->set_Table($this->{pre_table_name} . "blob_content");
                    $htmldb->insert_Table;
                    
                    ### continue with possible file upload

                    my $web_man_bcu = new web_man_admin_blob_content_upload;
                    $web_man_bcu->set_CGI($cgi);
                    $web_man_bcu->set_DBI_Conn($db_conn);

                    $web_man_bcu->set_Owner_Entity("$owner_entity_id", "link_reference");
                    $web_man_bcu->set_Old_BLOB_Prefered_List(@html_obj_blob_prefered_old);
                    $web_man_bcu->set_New_BLOB_Prefered_List(@html_obj_blob_prefered);
                    $web_man_bcu->run_Task;
                    $web_man_bcu->process_Content;

                    if ($web_man_bcu->get_Upload_Files ne undef) {
                        $this->{child_interface} = $web_man_bcu->get_Content;

                    } else {
                        $cgi->set_Param_Val("mode", "");
                    }
                    
                } else {
                    $cgi->set_Param_Val("mode", "");
                }
                
                ### remove new reload file from blob_content_temp
                $dbu->set_Table($this->{pre_table_name} . "blob_content_temp");
                $dbu->delete_Item("blob_id", "$blob_id");
            }
            
        } else {
            $this->reload_File($blob_id, $file_content[0]);
        }
        
    } elsif($task eq "reload_phase4") {
        my @file_name_ext = undef;
        my $i = 0;
        my $j = 0;
        my $blob_prefered_count = 0;
        my @html_obj_blob_prefered = undef;
                            
        for ($i = 0; $i < @file_name; $i++) {
        
            print "File name for subsequent upload = $file_name[$i] <br>";

            @file_name_ext = split(/\./,$file_name[$i]);

            if (uc($file_name_ext[1]) eq "HTML" || uc($file_name_ext[1]) eq "HTM") {

                my $htmlos = new HTML_Object_Separator;

                $htmlos->set_Doc_Content($file_content[$i]);
                $htmlos->set_Owner_Entity("$owner_entity_id", "link_reference");
                $htmlos->set_Caller_CGI_GET_Data("link_name=$link_name_get_fmt&link_id=$owner_entity_id&dmisn=1");
                $htmlos->add_CGI_Get_Data("app_name=$app_name");

                my @temp_html_obj_blob_prefered = $htmlos->get_HTML_Object_BLOB_Prefered;

                #print "\$html_obj_blob_prefered[0]->get_Object_Reference_Name = " . $html_obj_blob_prefered[0]->get_Object_Reference_Name . "<br>";
                
                if ($temp_html_obj_blob_prefered[0] ne undef) {
                    for ($j = 0; $j < @temp_html_obj_blob_prefered; $j++) {
                        $html_obj_blob_prefered[$blob_prefered_count] = $temp_html_obj_blob_prefered[$j];
                        $blob_prefered_count++;
                    }
                }
            }
        }
        
        my $web_man_bcu = new web_man_admin_blob_content_upload;
        $web_man_bcu->set_CGI($cgi);
        $web_man_bcu->set_DBI_Conn($db_conn);

        $web_man_bcu->set_Owner_Entity("$owner_entity_id", "link_reference");
        $web_man_bcu->set_Old_BLOB_Prefered_List(undef);
        $web_man_bcu->set_New_BLOB_Prefered_List(@html_obj_blob_prefered);
        $web_man_bcu->run_Task;
        $web_man_bcu->process_Content;

        #print "Arrive critical point1 <br>";

        if ($web_man_bcu->get_Upload_Files ne undef) {
            #print "Arrive critical point2 <br>";
            $this->{child_interface} = $web_man_bcu->get_Content;

            $cgi->set_Param_Val("mode", "reload");
        }
    } else {
        $cgi->set_Param_Val("mode", "reload");
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->{current_blob_id} = $cgi->param("current_blob_id");
    
    $this->set_Template_File("./template_admin_blob_content_reload.html");
    
    $this->SUPER::process_Content;
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $hpd = $cgi->generate_Hidden_POST_Data("\$filename blob_id current_blob_id sort_link_name_old sort_field_old
                                              sort_link_name sort_field cdbr_set_num_dmisn cdbr_set_num 
                                              blob_content_link_name blob_content_dmisn link_name dmisn app_name");
    
    $this->add_Content($hpd);
}

sub process_DATAHTML { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;

    my $data_HTML = new Data_HTML_Map;
    
    $data_HTML->set_CGI($cgi);
    $data_HTML->set_HTML_Code($te_content);
    
    $te_content = $data_HTML->get_HTML_Code;
    
    $this->add_Content($te_content);
}

sub get_Child_Interface {
    my $this = shift @_;
    
    return $this->{child_interface};
}

sub reload_File {
    my $this = shift @_;
    
    my $blob_id = shift @_;
    my $file_content = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn); ### option 1
    
    $dbu->set_Table($this->{pre_table_name} . "blob_content");
    $dbu->delete_Item("blob_id", "$blob_id"); ### first is to delete current blob content

    my $htmldb = new HTML_DB_Map;

    $cgi->set_Param_Val("\$db_blob_id", "$blob_id");
    $cgi->set_Param_Val("\$db_content", "$file_content");

    $htmldb->set_CGI($cgi);
    $htmldb->set_DBI_Conn($db_conn);
    
    $htmldb->set_Table($this->{pre_table_name} . "blob_content");
    $htmldb->set_Exceptional_Fields("\$db_filename \$db_extension \$db_owner_entity_id \$db_owner_entity_name");

    $htmldb->insert_Table; ### second is to insert new BLOB content

    my $time_ISO = $this->get_Time_ISO;
    my $today_ISO = $this->get_Today_ISO;

    $dbu->set_Table($this->{pre_table_name} . "blob_info");
    $dbu->update_Item("upload_time", "$time_ISO", "blob_id", "$blob_id");  ### third is to update
    $dbu->update_Item("upload_date", "$today_ISO", "blob_id", "$blob_id"); ### date and time in blob_info
}

1;