package web_man_admin_link_structure_update_reference;

use CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_link_structure;
use web_man_admin_content_uploader;
use web_man_admin_blob_prefered_list;
use web_man_admin_dyna_mod_utils;

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{root_blob_id} = undef;
    
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
    
    $this->SUPER::run_Task;    
    
    my $task = $cgi->param("task");
    my $link_ref_id = $cgi->param("link_ref_id");
    my $ref_type = $cgi->param("\$db_ref_type");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my @file_name = $cgi->upl_File_Name;
    
    if ($ref_type eq "STATIC_FILE") {
        $cgi->set_Param_Val("\$db_ref_name", $file_name[0]);
        
    } elsif ($ref_type eq "MAIN_DYNAMIC_MODULE") {
        if (!$cgi->set_Param_Val("\$db_dynamic_content_num", "-1")) {
            $cgi->add_Param("\$db_dynamic_content_num", "-1")
        }
        
        if (!$cgi->set_Param_Val("\$db_ref_type", "DYNAMIC_MODULE")) {
            $cgi->add_Param("\$db_ref_type", "DYNAMIC_MODULE");
        }
        
        if (!$cgi->set_Param_Val("\$db_ref_name", "webman_main")) {
            $cgi->add_Param("\$db_ref_name", "webman_main")
        }
        
        $cgi->push_Param("\$db_dynamic_content_name", "");
    }
    
    my $link_id = $cgi->param("child_link_id");
    my $dynamic_content_num = $cgi->param("\$db_dynamic_content_num");
    my $dynamic_content_name = $cgi->param("\$db_dynamic_content_name");
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    $dbu->set_Table($pre_table_name . "link_reference");

    my $found_duplicate = 0;
    
    #print "$link_id - $dynamic_content_num - $dynamic_content_name <br>\n";

    if ($dynamic_content_name eq "") { ### 15/01/2009
        $found_duplicate = $dbu->find_Item("link_id dynamic_content_num", "$link_id $dynamic_content_num");  ### method 1
    
    } else {
        $cgi->set_Param_Val("\$db_dynamic_content_num", "-2");
        $found_duplicate = $dbu->find_Item("link_id dynamic_content_name", "$link_id $dynamic_content_name"); ### 09/01/2009
    }

    my $valid_add = 1;
    my $valid_change_id = 1;
    
    if ($found_duplicate) { 
        $valid_add = 0;
        $valid_change_id = 0;
    }
    
    if ($cgi->param("\$db_ref_name") eq "") { $valid_add = 0; }
    
    if ($task eq "update_ref_phase2_add" && $valid_add) {
        $link_ref_id = $dbu->get_Unique_Random_Num("link_ref_id", "1000", "9999");
        $cgi->set_Param_Val("\$db_link_ref_id", $link_ref_id);
        
        if ($ref_type eq "STATIC_FILE") {
            #print "Try to upload with \$link_ref_id = $link_ref_id<br>";
            
            my $web_man_acu = new web_man_admin_content_uploader;
            
            $web_man_acu->set_CGI($cgi);
            $web_man_acu->set_DBI_Conn($db_conn); ### option 2
            $web_man_acu->set_Owner_Entity($link_ref_id, "link_reference");
            $web_man_acu->set_Exceptional_DB_Fields("\$db_link_ref_id \$db_link_id \$db_dynamic_content_name  \$db_dynamic_content_num \$db_dynamic_content_num2 \$db_ref_type \$db_ref_name");
            $web_man_acu->run_Task; ### this will automaticaly set $db_blob_id CGI variable
            
            $this->{root_blob_id} = $web_man_acu->get_Root_BLOB_ID;
            
        } else {
            if (!$cgi->set_Param_Val("\$db_blob_id", -1)) { $cgi->add_Param("\$db_blob_id", -1); }
        }
        
        my $htmldb = new HTML_DB_Map;

        $htmldb->set_CGI($cgi);
        $htmldb->set_DBI_Conn($db_conn);
        $htmldb->set_Table($pre_table_name . "link_reference");
        $htmldb->set_Exceptional_Fields("\$db_dynamic_content_num2 \$db_filename \$db_extension \$db_upload_time \$db_upload_date \$db_mime_type \$db_owner_entity_id \$db_owner_entity_name \$db_content");
        
        $htmldb->insert_Table;
        
        #print "SQL = " . $htmldb->get_SQL . "<br>\n";
        
    } elsif ($task eq "update_ref_phase2_delete") {
        $dbu->set_Table($pre_table_name . "link_reference");
        
        my $blob_id = $dbu->get_Item("blob_id", "link_ref_id", "$link_ref_id");
        
        $dbu->delete_Item("link_ref_id", "$link_ref_id");
        
        ### 09/07/2009 start
        
        if ($blob_id > 0) { ### ref_type is STATIC_FILE
            my $owner_entity_id = $link_ref_id;
            
            $dbu->set_Table($pre_table_name . "blob_info");
            
            my @ahr = $dbu->get_Items("blob_id", "owner_entity_id owner_entity_name", 
                                      "$owner_entity_id link_reference", undef, undef);
                                      
            #$cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
                                      
            my $blob_id_in = undef;
            
            foreach my $item (@ahr) {
                $blob_id_in .= "'" . $item->{blob_id} . "', ";
            }
            
            $blob_id_in =~ s/, $//;
            
            #$cgi->add_Debug_Text("\$blob_id_in = $blob_id_in", __FILE__, __LINE__, "TRACING");
            
            $dbu->set_Keys_Str("blob_id in ($blob_id_in)");
            
            $dbu->set_Table($pre_table_name . "blob_info");
            $dbu->delete_Item(undef, undef);
            
            $dbu->set_Table($pre_table_name . "blob_content");
            $dbu->delete_Item(undef, undef);
            
            $dbu->set_Table($pre_table_name . "blob_parent_info");
            $dbu->delete_Item(undef, undef);
            
            $dbu->set_Keys_Str(undef);
            
            $dbu->set_Table($pre_table_name . "static_content_dyna_mod_ref");
            
            my @ahr = $dbu->get_Items("scdmr_id", "blob_id", "$blob_id", undef, undef);
            
            $dbu->delete_Item("blob_id", "$blob_id");
            
            foreach my $item (@ahr) {
                my $scdmr_id = $item->{scdmr_id};
                
                if ($scdmr_id ne "") {
                    $dbu->set_Table($pre_table_name . "dyna_mod_param");
                    $dbu->delete_Item("scdmr_id", "$scdmr_id");
                }
            }
            
        } else { ### ref_type is DYNAMIC_MODULE
            $dbu->set_Table($pre_table_name . "dyna_mod_param");
            $dbu->delete_Item("link_ref_id", "$link_ref_id");
            
            $dbu->set_Table($pre_table_name . "dyna_mod_selector");
            
            my @ahr = $dbu->get_Items("dyna_mod_selector_id", "link_ref_id", "$link_ref_id", undef, undef);
            
            $dbu->delete_Item("link_ref_id", "$link_ref_id");
            
            foreach my $item (@ahr) {
                my $dyna_mod_selector_id = $item->{dyna_mod_selector_id};
                
                if ($dyna_mod_selector_id ne "") {
                    $dbu->set_Table($pre_table_name . "dyna_mod_param");
                    $dbu->delete_Item("dyna_mod_selector_id", "$dyna_mod_selector_id");
                }
            }
            
        }
        
        ### 09/07/2009 end
        
    } elsif ($task eq "update_ref_phase3_add") {
        #print "<p>try to store blob: $link_ref_id</p>";
        
        $cgi->set_Param_Val("\$db_link_ref_id", $link_ref_id);
        
        my $web_man_acu = new web_man_admin_content_uploader;

        $web_man_acu->set_CGI($cgi);
        $web_man_acu->set_DBI_Conn($db_conn); ### option 2
        $web_man_acu->set_Owner_Entity($link_ref_id, "link_reference");
        $web_man_acu->set_Exceptional_DB_Fields("\$db_link_id \$db_dynamic_content_num \$db_ref_type \$db_ref_name");
        $web_man_acu->run_Task; ### this will automaticaly set $db_blob_id CGI variable
        
        $this->{root_blob_id} = $web_man_acu->get_Root_BLOB_ID;
        
    } elsif ($task eq "update_ref_phase2_copy_param") {
        my $item = undef;
        my @ahr = undef;
        
        my $link_ref_id = $cgi->param("link_ref_id");
        my $link_ref_id_copy = $cgi->param("link_ref_id_copy");
        my $dyna_mod_selector_id_copy = $cgi->param("dyna_mod_selector_id_copy");
        
        my $param_name = undef;
        my $param_value = undef;
        
        if ($link_ref_id_copy != -1) {
            #print "Try to copy from $link_ref_id_copy to $link_ref_id <br> \n";

            $dbu->set_Table($pre_table_name . "dyna_mod_param");

            my @ahr = $dbu->get_Items("param_name param_value", 
                                      "link_ref_id", "$link_ref_id_copy", 
                                      undef, undef);

            #print $dbu->get_SQL, "<br>\n";

            $dbu->delete_Item("link_ref_id", "$link_ref_id");

            foreach $item (@ahr) {
                $param_name = $item->{param_name};
                $param_value = $item->{param_value};

                $param_value =~ s/ /\\ /g;

                #print "$link_ref_id $param_name $param_value <br>\n";

                $dbu->insert_Row("link_ref_id param_name param_value scdmr_id dyna_mod_selector_id", "$link_ref_id $param_name $param_value -1 -1");
            }
            
        } elsif ($dyna_mod_selector_id_copy != -1) {
            #print "Try to copy from $dyna_mod_selector_id_copy to $link_ref_id <br> \n";

            $dbu->set_Table($pre_table_name . "dyna_mod_param");

            my @ahr = $dbu->get_Items("param_name param_value", 
                                      "dyna_mod_selector_id", "$dyna_mod_selector_id_copy", 
                                      undef, undef);

            #print $dbu->get_SQL, "<br>\n";

            $dbu->delete_Item("link_ref_id", "$link_ref_id");

            foreach $item (@ahr) {
                $param_name = $item->{param_name};
                $param_value = $item->{param_value};

                $param_value =~ s/ /\\ /g;

                #print "$link_ref_id $param_name $param_value <br>\n";

                $dbu->insert_Row("link_ref_id param_name param_value scdmr_id dyna_mod_selector_id", "$link_ref_id $param_name $param_value -1 -1");
            }        
        }
        
    } elsif ($task eq "update_ref_phase2_change_id") {
        my $link_ref_id = $cgi->param("link_ref_id");
        
        if ($valid_change_id) {
            #print "Try to change dynamic content ID reference for link_ref_id = $link_ref_id <br> \n";

            my $htmldb = new HTML_DB_Map;

            $htmldb->set_CGI($cgi);
            $htmldb->set_DBI_Conn($db_conn);
            $htmldb->set_Table($pre_table_name . "link_reference");        

            $htmldb->update_Table("link_ref_id", "$link_ref_id");
        }
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_link_structure_update_reference.html");
    
    $this->SUPER::process_Content;
}

sub process_VIEW { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn app_name");
    my $caller_get_data2 = $this->generate_GET_Data("app_name");
    
    my $link_struct_id = $cgi->param("link_struct_id");
    my $child_link_id = $cgi->param("child_link_id");
    
    my @link_path = undef;
    my $link_path_info = undef;
    
    $te_content =~ s/Root/<a href="index.cgi?$caller_get_data"><font color="#0099FF">Root<\/font><\/a>/;
    
    #if ($link_struct_id == 0) {
    #   $te_content =~ s/LINK_PATH_//;
        
    #} else {
        my $web_man_als = new web_man_admin_link_structure;

        $web_man_als->set_CGI($cgi);
        $web_man_als->set_DBI_Conn($db_conn);
        $web_man_als->set_Activate_Last_Path(1);
        
        @link_path = $web_man_als->get_Link_Path($child_link_id);
        $link_path_info = $web_man_als->generate_Link_Path_Info("index.cgi", "$caller_get_data2", @link_path);
        
        $te_content =~ s/LINK_PATH_/$link_path_info/;
    #}
    
    $te_content =~ s/child_link_id_/$child_link_id/;
    
    $this->add_Content($te_content);
    
}

sub process_DBHTML { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn app_name link_struct_id child_link_id");
    
    my $link_struct_id = $cgi->param("link_struct_id");
    my $child_link_id = $cgi->param("child_link_id");
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $script_ref = "index.cgi?$caller_get_data";
    
    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_HTML_Code($te_content);

    $dbihtml->set_SQL("select * from $pre_table_name" . "link_structure where link_id='$child_link_id'");
        
    $te_content = $dbihtml->get_HTML_Code;
    
    my $db_items_num = $dbihtml->get_Items_Num;
    
    if ($db_items_num ne "") {
        #$this->add_Content($te_content);
    }
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn app_name link_struct_id child_link_id");
    
    my $link_struct_id = $cgi->param("link_struct_id");
    my $child_link_id = $cgi->param("child_link_id");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $script_ref = "index.cgi?$caller_get_data";
    
    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_HTML_Code($te_content);
    
    $dbihtml->set_SQL("select * from $pre_table_name" . "link_reference where link_id='$child_link_id' order by dynamic_content_num");
        
    my $tld = $dbihtml->get_Table_List_Data;
    
    my $db_items_num = $dbihtml->get_Items_Num;
    
    if ($db_items_num > 0) {
        my $dbu = new DB_Utilities;

        $dbu->set_DBI_Conn($db_conn); ### option 1
        
        $tld->add_Column("operation");
        
        my $i = 0;
        my $operations = undef;
        
        my $get_link_set_param = undef;
        my $operation_set_param = "Set Param";
        my $current_set_param_num = 0;
        
        my $get_link_copy_param = undef;
        my $operation_copy_param = "Copy Param";
        
        my $get_link_change_id = undef; ### 16/01/2009
        my $operation_change_id = "Change ID";
        
        my $get_link_delete = undef;
        my $operation_delete = "<font color=\"#0099FF\">Delete</font>";
        
        my ($link_ref_id, $ref_name, $ref_type, $owner_entity_id, $extension)  = undef;
        
        for ($i = 0; $i < $db_items_num; $i++) {            
            $link_ref_id = $tld->get_Data($i, "link_ref_id");
            $ref_name = $tld->get_Data($i, "ref_name");
            $ref_type = $tld->get_Data($i, "ref_type");
            $dynamic_content_num = $tld->get_Data($i, "dynamic_content_num");
            $dynamic_content_name = $tld->get_Data($i, "dynamic_content_name");
            
            $operations  = "";
            
            $dbu->set_Table($pre_table_name . "dyna_mod_param");
            $current_set_param_num = $dbu->count_Item("link_ref_id", $tld->get_Data($i, "link_ref_id"), undef);

            if ($current_set_param_num < 10) {
                $current_set_param_num = "0" . $current_set_param_num;
            }
            
            if ($ref_name =~ /\./) {
                $get_link = "../" .  $cgi->param("app_name") . "/index_blob_content_printer_v2.cgi?" . 
                            "blob_id=" . $tld->get_Data($i, "blob_id") . "&" . "app_name=" . $cgi->param("app_name");
                $tld->set_Data_Get_Link($i, "ref_name", $get_link, "_blank");
                
                $tld->set_Data($i, "ref_name", "<font color=\"#0099FF\">$ref_name</font>");
                
                $operations .= "$operation_set_param [$current_set_param_num] | ";
                $operations .= "$operation_copy_param | ";
                
            } else {
                if ($ref_name eq "webman_main") {
                    $ref_type = "MAIN_CONTROLLER";
                    $tld->set_Data($i, "ref_type", $ref_type);
                }
                
                $get_link_set_param = "$script_ref&task=update_dyna_mod_phase1&link_ref_id=$link_ref_id&\$ref_name=$ref_name&\$ref_type=$ref_type" . 
                                      "&\$dynamic_content_num=" . $tld->get_Data($i, "dynamic_content_num");
                                      
                $get_link_copy_param = "$script_ref&task=update_ref_phase1_copy_param&link_ref_id=$link_ref_id&\$ref_name=$ref_name&\$ref_type=$ref_type" . 
                                       "&\$dynamic_content_num=" . $tld->get_Data($i, "dynamic_content_num");
                                      
                $operations .= "<a href=\"$get_link_set_param\"><font color=\"#0099FF\">$operation_set_param</a></font> <font color=\"#0099FF\">[$current_set_param_num]</font> | ";
                $operations .= "<a href=\"$get_link_copy_param\"><font color=\"#0099FF\">$operation_copy_param</a></font> | ";
                
                if ($ref_name eq "webman_component_selector") {
                    ### update_ref_phase1_csl: csl stand for component selection logic
                    
                    $get_link = "$script_ref&task=update_ref_phase1_csl&link_ref_id=$link_ref_id&\$ref_name=$ref_name" . 
                                "&\$dynamic_content_num=" . $tld->get_Data($i, "dynamic_content_num");
                                         
                    $tld->set_Data_Get_Link($i, "ref_name", $get_link, "");
                    $tld->set_Data($i, "ref_name", "<font color=\"#0099FF\">$ref_name</font>"); 
                }
            }
            
            if ($ref_name eq "webman_main") {
                $operations .= "$operation_change_id | ";
                
                
                
            } else {
                $get_link_change_id = "$script_ref&task=update_ref_phase1_change_id&link_ref_id=$link_ref_id&\$ref_name=$ref_name&\$dynamic_content_num=$dynamic_content_num&\$dynamic_content_name=$dynamic_content_name";
                $operations        .= "<a href=\"$get_link_change_id\"><font color=\"#0099FF\">$operation_change_id</font></a> | ";
            }
            
            $get_link_delete = "$script_ref&task=update_ref_phase2_delete&link_ref_id=" . $tld->get_Data($i, "link_ref_id");
            $operations     .= "<a href=\"$get_link_delete\">$operation_delete</a>";
            
            $tld->set_Data($i, "operation", $operations);                       
        }
        
        my $tldhtml = new TLD_HTML_Map;
            
        $tldhtml->set_Table_List_Data($tld);
        $tldhtml->set_HTML_Code($te_content);
            
        my $html_result = $tldhtml->get_HTML_Code;
            
        $this->add_Content($html_result);
        
        #print $tld->get_Table_List;
    }
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $task = $cgi->param("task");
    my $ref_type = $cgi->param("\$db_ref_type");
    my $child_link_id = $cgi->param("child_link_id");
    
    my $link_ref_id = undef;
    
    $link_ref_id = $cgi->param("\$db_link_ref_id");
    
    if ($link_ref_id eq "") {
        $link_ref_id = $cgi->param("link_ref_id");
    }
    
    
    my @file_name = $cgi->upl_File_Name;
    
    if ($te_type_num == 0) {
        my $hpd = $this->generate_Hidden_POST_Data("link_name dmisn app_name app_dir link_struct_id child_link_id");
    
        $this->add_Content($hpd);
        
    } else {
        my $html_uploaded = 0;
        my @file_name_info = undef;
        
        for ($i = 0; $i < @file_name; $i++) {
            if ($file_name[$i] ne "") {
                @file_name_info = split(/\./, $file_name[$i]);
        
                $file_name_info[@file_name_info - 1] =~ s/htm/HTM/i;
                $file_name_info[@file_name_info - 1] =~ s/l/L/i;
        
                if ($file_name_info[@file_name_info - 1] eq "HTM" ||
                    $file_name_info[@file_name_info - 1] eq "HTML") {
                    $html_uploaded = 1;
                }
            }
        }
        
        if ($html_uploaded) {
            my $web_man_abpl = new web_man_admin_blob_prefered_list;

            $web_man_abpl->set_CGI($cgi);
            $web_man_abpl->set_DBI_Conn($db_conn); ### option 2
            
            $web_man_abpl->set_Hidden_POST_Data("task link_ref_id", "update_ref_phase3_add", "$link_ref_id"); 
            $web_man_abpl->set_Generated_Hidden_POST_Data("link_name dmisn app_name link_struct_id child_link_id");

            $web_man_abpl->run_Task;
            $web_man_abpl->process_Content;

            my $content = $web_man_abpl->get_Content;
            
            $content =~ s/\$root_filename_blob_id_/$this->{root_blob_id}/;

            $this->add_Content($content);
        }
    }
    
}

sub process_SELECT { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    my $s_opt = new Select_Option;
    
    if ($te_type_name eq "dynamic_content_num") {
        $s_opt->set_Values("", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10");
        
    } elsif ($te_type_name eq "dynamic_content_name") {
        my $script_filename = $ENV{SCRIPT_FILENAME};
        my @array = split(/\//, $script_filename);
        
        my $app_cgi_dir = undef;
        
        for ($i = 0; $i < @array - 2; $i++) {
            $app_dir .= "$array[$i]/";
        }
        
        $app_dir .= $cgi->param("app_name") . "/";
        
        my $template_file = $this->check_Main_Controller_Template;
        
        if ($template_file eq "template_default.html") {
            if (-e $app_dir . "template_" . $cgi->param("app_name") . ".html") {
                $template_file = "template_" . $cgi->param("app_name") . ".html";
                
            } elsif (-e $app_dir . $cgi->param("app_name") . ".html") {
                $template_file = $cgi->param("app_name") . ".html";
            }
            
            #$cgi->add_Debug_Text($app_dir . "template_" . $cgi->param("app_name") . ".html", __FILE__, __LINE__);
        }
        
        $template_file = $app_dir . $template_file;
        
        #$cgi->add_Debug_Text("\$template_file = $template_file", __FILE__, __LINE__);
        
        my $te_extractor = new Template_Element_Extractor;
        my @te_list = $te_extractor->get_Template_Element($template_file);
        
        my @s_opt_vals = ("");
        
        for (my $i = 0; $i < @te_list; $i++) {
            my $te_type = $te_list[$i]->get_Type;
            
            if ($te_type eq "DYNAMIC") {
                push(@s_opt_vals, $te_list[$i]->get_Name);
            }
        }
        
        $s_opt->set_Values(@s_opt_vals);
        
    } elsif($te_type_name eq "ref_name") {
        my $script_filename = $ENV{SCRIPT_FILENAME};
        my @array = split(/\//, $script_filename);
        
        my $app_dir = undef;
        
        for ($i = 0; $i < @array - 5; $i++) {
            $app_dir .= "$array[$i]/";
        }
        
        $app_dir .=  "webman/pm/apps/" . $cgi->param("app_name");
        
        #print "\$app_dir = $app_dir<br />\n";
        
        my $web_man_admu = new web_man_admin_dyna_mod_utils;
    
        $web_man_admu->set_DBI_Conn($db_conn);
        
        my @webman_dyna_mod_app = $web_man_admu->get_Valid_Webman_CGI_Component($app_dir);
        my @webman_dyna_mod_std = $web_man_admu->get_Valid_Webman_CGI_Component("../../../../webman/pm/comp");
        
        #print "\@webman_dyna_mod_app = @webman_dyna_mod_app <br>\n";
        #print "\@webman_dyna_mod_std = @webman_dyna_mod_std <br>\n";
    
        my @webman_dyna_mod_filtered = undef;
        my $counter = 0;
        
        for (my $i = 0; $i < @webman_dyna_mod_app; $i++) {
            if ($webman_dyna_mod_app[$i] ne $cgi->param("app_name")) {
                $webman_dyna_mod_filtered[$counter] = $webman_dyna_mod_app[$i];
                $counter++;
            }
        }
        
        for (my $i = 0; $i < @webman_dyna_mod_std; $i++) {
            if ($webman_dyna_mod_std[$i] ne "webman_main" && 
                $webman_dyna_mod_std[$i] ne "webman_init" &&
                $webman_dyna_mod_std[$i] ne "webman_component_init") {
                
                $webman_dyna_mod_filtered[$counter] = $webman_dyna_mod_std[$i];
                $counter++;
            }
        }        
    
        $s_opt->set_Values(@webman_dyna_mod_filtered);
    }
    
    $this->add_Content($s_opt->get_Selection);
}

sub check_Main_Controller_Template {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    
    my $app_name = $cgi->param("app_name");
    my $link_id = $cgi->param("child_link_id");
    
    my $app_main_controller = "webman_main";
    
    my $dbu = new DB_Utilities;
        
    $dbu->set_DBI_Conn($db_conn);
    
    while ($link_id > 0) {
        $dbu->set_Table("webman_" . $app_name . "_link_reference");

        my $link_ref_id = $dbu->get_Item("link_ref_id", "link_id ref_type ref_name", "$link_id DYNAMIC_MODULE $app_main_controller");
        
        #$cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__);
        #$cgi->add_Debug_Text("\$link_id = $link_id", __FILE__, __LINE__);
        #$cgi->add_Debug_Text("\$link_ref_id = $link_ref_id", __FILE__, __LINE__);

        if ($link_ref_id ne "") {
            $dbu->set_Table("webman_" . $app_name . "_dyna_mod_param");

            my $template_file = $dbu->get_Item("param_value", "link_ref_id param_name", "$link_ref_id template_default");

            if ($template_file ne "") {
                return $template_file;
            }
        }

        $dbu->set_Table("webman_" . $app_name . "_link_structure");
        $link_id = $dbu->get_Item("parent_id", "link_id", "$link_id");
    }
    
    return "template_default.html";
}

1;