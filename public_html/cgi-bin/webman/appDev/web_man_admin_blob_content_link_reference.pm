package web_man_admin_blob_content_link_reference;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_blob_content_separator;

use web_man_admin_blob_content_reload;
use web_man_admin_blob_content_delete;
use web_man_admin_blob_content_upload;

use web_man_admin_blob_content_dyna_ref;
use web_man_admin_blob_content_dyna_ref_param;
use web_man_admin_blob_content_dyna_ref_param_copy;

my %ext_mime = ("doc"=>"application/msword", "class"=>"application/octet-stream",
                "pdf"=>"application/pdf", "xls"=>"application/vnd.ms-excel", 
                "ppt"=>"application/vnd.ms-powerpoint", "swf"=>"application/x-shockwave-flash",
                "zip"=>"application/zip", "gif"=>"image/gif", "jpg"=>"image/jpeg", "png"=>"image/png",
                "htm"=>"text/html", "html"=>"text/html", "txt"=>"text/plain", "mpg"=>"video/mpeg");

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{dbr_num} = undef;
    $this->{dbr_set_num} = undef;
    $this->{cdbr_set_num} = undef;
    
    $this->{current_blob_id} = undef;
    
    $this->{sort_link_name} = undef;
    $this->{sort_field} = undef;
    
    $this->{sort_link_name_old} = undef;
    $this->{sort_field_old} = undef;
    
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
    
    my $time_ISO = $this->get_Time_ISO;
    my $today_ISO = $this->get_Today_ISO;
    
    my $task = $cgi->param("task");
    my $submit = $cgi->param("submit");
    
    $this->{pre_table_name} = "webman_" . $cgi->param("app_name") . "_";
    
    #print "\$this->{pre_table_name} = $this->{pre_table_name} <br>";
    #print "\$task = $task : \$submit = $submit <br>";
    
    my $component = undef;
    
    if ($task eq "reload_phase2" || 
        ($task eq "reload_phase3" && $submit eq "Continue")) {
        
        $component = new web_man_admin_blob_content_reload;

        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2
        
        $component->run_Task;
        
        $this->{child_interface} = $component->get_Child_Interface;
        
        if ($this->{child_interface} ne undef) {
            $cgi->set_Param_Val("mode", "reload");
        }
        
    } elsif ($task eq "reload_phase4") {
        print "Try to upload files <br>";
        
        $cgi->set_Param_Val("mode", "");
        
        my @file_name = $cgi->upl_File_Name;
        my @file_content = $cgi->upl_File_Content;
    
        my $num_of_files = @file_name;
        
        #print "<p>file_name = $file_name[0]</p>";
    
        my $dbu = new DB_Utilities;
        $dbu->set_DBI_Conn($db_conn);

        my $htmldb = new HTML_DB_Map;
        $htmldb->set_CGI($cgi);
        $htmldb->set_DBI_Conn($db_conn);

        my $i = 0;
        my $new_blob_id = undef;
        my $exist = undef;
        my @file_name_ext = undef;
        my $link_name = undef;
        
        my $blob_id = $cgi->param("blob_id");
        $dbu->set_Table($this->{pre_table_name} . "blob_info");
        
        my $owner_entity_id = $dbu->get_Item("owner_entity_id", "blob_id", "$blob_id");
        my $owner_entity_name = "link_reference";
        
        my @blob_html_obj = undef;
        my $found_new_blob = 0;

        for ($i = 0; $i < $num_of_files; $i++) {
            $exist = 1;

            while ($exist) {
                $rn1 = int rand 9; $rn2 = int rand 10;
                $rn3 = int rand 10; $rn4 = int rand 10;

                $rn1 = $rn1 + 1;

                $new_blob_id = $rn1 . $rn2 . $rn3 . $rn4;

                $dbu->set_Table($this->{pre_table_name} . "blob_info");

                $exist = $dbu->find_Item("blob_id", "$new_blob_id");
            }
            
            if ($owner_entity_id ne "" && $owner_entity_name ne "" &&
                $file_name[$i] ne "" && $file_content[$i] ne "") {

                my $htmlos = new HTML_Object_Separator;

                @file_name_ext = split(/\./,$file_name[$i]);

                if (uc($file_name_ext[1]) eq "HTML" || uc($file_name_ext[1]) eq "HTM") {

                    $dbu->set_Table($this->{pre_table_name} . "link_structure");
                    $link_name = $dbu->get_Item("name", "link_id", $owner_entity_id);
                    $link_name =~ s/ /+/g;
                    $link_name =~ s/&/\%26/g;

                    $htmlos->set_Owner_Entity($owner_entity_id, $owner_entity_name);
                    $htmlos->set_Doc_Content($file_content[$i]);
                    $htmlos->set_Caller_CGI_GET_Data("link_name=$link_name&link_id=$owner_entity_id&dmisn=1");
                    $htmlos->add_CGI_Get_Data("app_name=" . $cgi->param("app_name"));

                    $file_content[$i] = $htmlos->get_Doc_Content_BLOB_Prefered;
                    
                    @blob_html_obj = $htmlos->get_HTML_Object_BLOB_Prefered;
                    
                    if ($blob_html_obj[0] ne undef) {
                        $found_new_blob = 1;
                    }
                }


                $cgi->set_Param_Val("\$db_blob_id", $new_blob_id);

                $cgi->set_Param_Val("\$db_filename", $file_name_ext[0]);
                $cgi->set_Param_Val("\$db_extension", $file_name_ext[1]);

                $cgi->set_Param_Val("\$db_upload_time", $time_ISO);
                $cgi->set_Param_Val("\$db_upload_date", $today_ISO);

                $cgi->set_Param_Val("\$db_mime_type", $ext_mime{$file_name_ext[1]});

                $cgi->set_Param_Val("\$db_owner_entity_id", $owner_entity_id);
                $cgi->set_Param_Val("\$db_owner_entity_name", $owner_entity_name);

                $cgi->set_Param_Val("\$db_content", $file_content[$i]);

                #print "<p>Try run task </p><pre>$new_blob_id - $file_name_ext[0] - $file_name_ext[1] - $ext_mime{$file_name_ext[1]}</pre>";

                $htmldb->set_Table($this->{pre_table_name} . "blob_info");
                $htmldb->set_Exceptional_Fields("\$db_content ");
                $htmldb->insert_Table;
                #print "$owner_entity_id : $owner_entity_name <br>";

                $htmldb->set_Table($this->{pre_table_name} . "blob_content");
                $htmldb->set_Exceptional_Fields("\$db_filename \$db_extension \$db_upload_time \$db_upload_date \$db_mime_type \$db_owner_entity_id \$db_owner_entity_name");
                $htmldb->insert_Table;
                #print "$owner_entity_id : $owner_entity_name <br>";

            }
        } 
        
        if ($found_new_blob) {
            #print "Found new blob content <br>";
            
            $cgi->set_Param_Val("mode", "reload");
            
            #print "\$cgi->param(\"mode\") = " . $cgi->param("mode") . "<br>";
        }
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->{current_blob_id} = $cgi->param("current_blob_id");
    
    $this->{cdbr_set_num} = $cgi->param("cdbr_set_num");
    
    $this->{sort_link_name} = $cgi->param("sort_link_name");
    $this->{sort_field} = $cgi->param("sort_field");
        
    $this->{sort_link_name_old} = $cgi->param("sort_link_name_old");
    $this->{sort_field_old} = $cgi->param("sort_field_old");
    
    if ($this->{cdbr_set_num} eq "") { $this->{cdbr_set_num} = 1; }
    
    if ($this->{sort_link_name} eq "") { $this->{sort_link_name} = "Link Name"; }
    if ($this->{sort_field} eq "") { $this->{sort_field} = "ls.name, bi.filename, bi.extension"; }
    
    if ($this->{current_blob_id} eq "" && $this->{sort_link_name_old} ne "") {
        #print "Using old sort properties: $this->{sort_link_name_old}-$this->{sort_field_old}<br>";
        
        $this->{sort_link_name} = $this->{sort_link_name_old};
        $this->{sort_field} = $this->{sort_field_old};
        
        $cgi->set_Param_Val("sort_link_name", $this->{sort_link_name_old});
        $cgi->set_Param_Val("sort_field", $this->{sort_field_old});
    }
    
    if ($cgi->param("mode") eq "") {
        $this->set_Template_File("./template_admin_blob_content_link_reference.html");
        
    } elsif($cgi->param("mode") eq "reload") {
        $this->set_Template_File("./template_admin_blob_content_link_reference_reload.html");
        
    } elsif($cgi->param("mode") eq "dyna_ref") {
        $this->set_Template_File("./template_admin_blob_content_link_reference_dyna_ref.html");
        
    } elsif ($cgi->param("mode") eq "dyna_ref_param" || $cgi->param("mode") eq "dyna_ref_param_copy") {
        $this->set_Template_File("./template_admin_blob_content_link_reference_dyna_ref_param.html");
    }
    
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
    
    my $caller_get_data = undef;
    
    $caller_get_data = $cgi->generate_GET_Data("sort_link_name_old sort_field_old sort_link_name sort_field 
                                                cdbr_set_num_dmisn cdbr_set_num 
                                                blob_content_link_name blob_content_dmisn link_name dmisn app_name");
    
    my $parent_ref = undef;
    my $link_ref = "<a href=\"index.cgi?$caller_get_data\"><font color=\"#0099FF\">Link Reference</font></a>";
    
    if ($this->{current_blob_id} eq "") {
        if($cgi->param("mode") eq "reload") {
            $te_content =~ s/\$LINK_PATH_/BLOB Content Management > $link_ref/;
        } else {
            $te_content =~ s/\$LINK_PATH_//;
        }
        
    } else {
        
        my $dbu = new DB_Utilities;

        $dbu->set_DBI_Conn($db_conn); ### option 1
        $dbu->set_Table($this->{pre_table_name} . "blob_info");

        my $filename = $dbu->get_Item("filename", "blob_id", $this->{current_blob_id}) . 
                       "." .
                       $dbu->get_Item("extension", "blob_id", $this->{current_blob_id});
                       
        $dbu->set_Table($this->{pre_table_name} . "blob_parent_info");
        
        
        
        my $parent_blob_id = $dbu->get_Item("parent_blob_id", "blob_id", $this->{current_blob_id});
        
        #print "\$parent_blob_id = $parent_blob_id<br>\n";
        
        if ($parent_blob_id != 0) {
            $parent_ref = "<a href=\"index.cgi?$caller_get_data&current_blob_id=$parent_blob_id\"><font color=\"#0099FF\">*</font></a>";
        }
                       
        
        
        if($cgi->param("mode") eq "reload") {
            $caller_get_data = $cgi->generate_GET_Data("app_name current_blob_id sort_link_name_old sort_field_old
                                                        sort_link_name sort_field cdbr_set_num_dmisn cdbr_set_num 
                                                        blob_content_link_name blob_content_dmisn link_name dmisn");
                                                                
            $filename = "<a href=\"index.cgi?$caller_get_data\"><font color=\"#0099FF\">$filename</font></a>";
        }


        
        if ($parent_ref eq undef) {
            $te_content =~ s/\$LINK_PATH_/BLOB Content Management > $link_ref > $filename/;
            
        } else {
            $te_content =~ s/\$LINK_PATH_/BLOB Content Management > $link_ref > $parent_ref > $filename/;
        }
    }
    
    
    if($cgi->param("mode") eq "dyna_ref_param" || $cgi->param("mode") eq "dyna_ref_param_copy") {
        $caller_get_data = $cgi->generate_GET_Data("sort_link_name_old sort_field_old sort_link_name sort_field 
                                                    cdbr_set_num cdbr_set_num_dmisn 
                                                    link_name dmisn app_name current_blob_id");
        
        my $dyna_mod_name = $cgi->param("dyna_mod_name");
        my $dynamic_content_num = $cgi->param("dynamic_content_num");
        
        $te_content =~ s/\$caller_get_data_/$caller_get_data/;
        $te_content =~ s/\$dyna_mod_name_/$dyna_mod_name/;
        $te_content =~ s/\$dynamic_content_num_/$dynamic_content_num/;
    }
    
    $this->add_Content($te_content);
    
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $component = undef;
    
    if($cgi->param("mode") eq "reload") {
        if ($this->{child_interface} eq undef) {
            $component = new web_man_admin_blob_content_reload;
        
            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn); ### option 2

            $component->run_Task;
            
            $this->{child_interface} = $component->get_Child_Interface;
                    
            if ($this->{child_interface} ne undef) {
                $this->add_Content($this->{child_interface});
            
            } else {
                $component->process_Content;
                $te_content = $component->get_Content;
                $this->add_Content($te_content);
            }
            
        } else {
            $this->add_Content($this->{child_interface});
        }
        
    } elsif ($cgi->param("mode") eq "dyna_ref") {
        $component = new web_man_admin_blob_content_dyna_ref;
                
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2
        
        $component->run_Task;
        $component->process_Content;
        
        $te_content = $component->get_Content;
        
        $this->add_Content($te_content);
        
    } elsif ($cgi->param("mode") eq "dyna_ref_param") {
        $component = new web_man_admin_blob_content_dyna_ref_param;
                
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2
        
        $component->run_Task;
        $component->process_Content;
        
        $te_content = $component->get_Content;
        
        $this->add_Content($te_content);
        
    } elsif ($cgi->param("mode") eq "dyna_ref_param_copy") {
        $component = new web_man_admin_blob_content_dyna_ref_param_copy;
                
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2
        
        $component->run_Task;
        $component->process_Content;
        
        $te_content = $component->get_Content;
        
        $this->add_Content($te_content);
    }
}


sub process_DBHTML { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    #print "\$this->{pre_table_name} = $this->{pre_table_name} <br>";
    #print "\$this->{current_blob_id} = $this->{current_blob_id} <br>";
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn); ### option 1
    
    
    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    
    if ($this->{current_blob_id} eq "") {
        $dbihtml->set_SQL("select ls.name, bi.filename, bi.extension, bi.upload_date, bi.upload_time, bi.blob_id from " . 
                          $this->{pre_table_name} . "blob_info bi, " . 
                          $this->{pre_table_name} . "link_reference lr, " . 
                          $this->{pre_table_name} . "link_structure ls " .
                          "where lr.blob_id=bi.blob_id and ls.link_id=lr.link_id 
                          order by ". $this->{sort_field});
                   
    } else {
        if ($this->{sort_field} eq "ls.name, bi.filename, bi.extension") {
            $this->{sort_field} = "bi.filename, bi.extension";
        }

        $dbu->set_Table($this->{pre_table_name} . "link_reference");
        
        my $link_ref_id = $dbu->get_Item("link_ref_id", "blob_id", $this->{current_blob_id});
        
        if ($link_ref_id ne "") {
            $dbihtml->set_SQL("select bi.filename, bi.extension, bi.upload_date, bi.upload_time, bi.blob_id 
                              from " . $this->{pre_table_name} . "blob_info bi where bi.owner_entity_id=$link_ref_id and bi.blob_id not in ($this->{current_blob_id}) 
                              order by " . $this->{sort_field});
        }
    }
                       
    $dbihtml->set_HTML_Code($te_content);
    
    if ($this->{current_blob_id} eq "") {
        $dbihtml->set_Items_View_Num(20); ### option 1
        
    } else {
        $this->{cdbr_set_num} = 1;
        $dbihtml->set_Items_View_Num(100);
    }
    
    $dbihtml->set_Items_Set_Num($this->{cdbr_set_num});  ### option 2
    
    my $tld = $dbihtml->get_Table_List_Data;
    
    #print $tld->get_Table_List;
    
    my $db_items_num = $dbihtml->get_Items_Num;
    
    if ($db_items_num > 0) {
    
        my $i = 0;
        my $get_fmt_filename = undef;
        my $caller_get_data = undef;
        my $current_row_color = "#FEF3E7";

        $caller_get_data = $cgi->generate_GET_Data("sort_link_name sort_field 
                                                   cdbr_set_num_dmisn cdbr_set_num 
                                                   blob_content_link_name blob_content_dmisn link_name dmisn app_name");
        $tld->add_Column("list_num");
        $tld->add_Column("type");
        $tld->add_Column("get_fmt_filename");
        $tld->add_Column("row_color");
        $tld->add_Column("dyna_ref");

        for ($i = 0; $i < $tld->get_Row_Num; $i++) {
            $get_fmt_filename = $tld->get_Data($i, "filename");

            $get_fmt_filename =~ s/ /+/g;
            $get_fmt_filename =~ s/&/%26/g;

            $tld->set_Data($i, "list_num", $i + 1 + ($this->{cdbr_set_num} - 1) * 5);
            $tld->set_Data($i, "type", uc($tld->get_Data($i, "extension")));
            $tld->set_Data($i, "get_fmt_filename", $get_fmt_filename);
            $tld->set_Data($i, "row_color", $current_row_color);

            if ($current_row_color eq "#FEF3E7") {
                $current_row_color = "#EEEEEE";

            } else {
                $current_row_color = "#FEF3E7";
            }

            $dbu->set_Table($this->{pre_table_name} . "link_reference");
            my $link_ref_id = $dbu->get_Item("link_ref_id", "blob_id", $tld->get_Data($i, "blob_id"));

            $dbu->set_Table($this->{pre_table_name} . "blob_info");
            my $file_num = $dbu->count_Item("owner_entity_id owner_entity_name", "$link_ref_id link_reference");

            my $ext = lc($tld->get_Data($i, "extension"));

            #print "\$ext = $ext \$file_num = $file_num \$link_ref_id = $link_ref_id <br>";

            if (($ext eq "html" || $ext eq "htm") && $file_num > 1) {

                $tld->set_Data($i, "filename", "<font color=\"#0099FF\">" . 
                                   $tld->get_Data($i, "filename") . 
                                   "." . 
                                   $tld->get_Data($i, "extension") . 
                                   "</font>");

                $tld->set_Data_Get_Link($i, "filename", "index.cgi?$caller_get_data&current_blob_id=" . $tld->get_Data($i, "blob_id"));

            } else {
                $tld->set_Data($i, "filename", $tld->get_Data($i, "filename") . 
                                   "." . 
                                   $tld->get_Data($i, "extension"));
            }


            if (($ext eq "html" || $ext eq "htm") && $this->found_Dynamic_Content($tld->get_Data($i, "blob_id"))) {
                my $link_color = "#0099FF";
                my $dyna_ref_status = $this->found_Dyna_Mod_Ref($tld->get_Data($i, "blob_id"));
                
                if ($dyna_ref_status eq "found_dyna_mod_ref") {
                    $link_color = "#FF0000";
                    
                } elsif($dyna_ref_status eq "found_dyna_mod_ref_param") {
                    $link_color = "#00AA00";
                }
                
                $tld->set_Data($i, "dyna_ref", "<font color=\"$link_color\">Dynamic Ref.</font>");
                $tld->set_Data_Get_Link($i, "dyna_ref", "index.cgi?$caller_get_data&mode=dyna_ref&current_blob_id=" . $tld->get_Data($i, "blob_id"));

            } else {
                $tld->set_Data($i, "dyna_ref", "Dynamic Ref.");
            }
        }

        $this->{dbr_num} = $dbihtml->get_Items_Num;       ### option 3
        $this->{dbr_set_num} = $dbihtml->get_Total_Items_Set_Num; ### option 4

        my $tldhtml = new TLD_HTML_Map;

        $tldhtml->set_Table_List_Data($tld);
        $tldhtml->set_HTML_Code($te_content);

        my $html_result = $tldhtml->get_HTML_Code;

        $dbu->set_Table($this->{pre_table_name} . "link_reference");    
        my $link_id = $dbu->get_Item("link_id", "blob_id", $this->{current_blob_id});

        $dbu->set_Table($this->{pre_table_name} . "link_structure");    
        my $link_name = $dbu->get_Item("name", "link_id", $link_id);

        $html_result =~ s/\$tld_name_/$link_name/g;

        $caller_get_data = $cgi->generate_GET_Data("current_blob_id sort_link_name_old sort_field_old sort_link_name sort_field 
                                                   cdbr_set_num_dmisn cdbr_set_num 
                                                   blob_content_link_name blob_content_dmisn link_name dmisn app_name");

        $html_result =~ s/\$caller_get_data_/$caller_get_data/g;

        my $app_name = $cgi->param("app_name");

        $html_result =~ s/\$app_name_/$app_name/g;

        $this->add_Content($html_result);

        #print $tld->get_Table_List;
    }
}


sub process_MENU { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $cdbr_set_num_dmisn = $cgi->param("cdbr_set_num_dmisn");
    
    if ($cdbr_set_num_dmisn eq "" || $this->{current_blob_id} ne "") { 
        $cdbr_set_num_dmisn = 1; 
    }
    
    if ($te_type_num == 0) {
        my $caller_get_data = undef;
        
        if ($this->{current_blob_id} eq "") {
            $caller_get_data = $cgi->generate_GET_Data("current_blob_id cdbr_set_num_dmisn cdbr_set_num blob_content_link_name blob_content_dmisn link_name dmisn app_name");
        } else {
            $caller_get_data = $cgi->generate_GET_Data("sort_link_name_old sort_field_old current_blob_id cdbr_set_num_dmisn cdbr_set_num blob_content_link_name blob_content_dmisn link_name dmisn app_name");
            
            if ($this->{sort_link_name_old} eq "") {
                my $sort_link_name = $this->{sort_link_name};
                my $sort_field = $this->{sort_field};
                
                $sort_link_name =~ s/ /+/g;
                $sort_field =~ s/ /+/g;
                
                $caller_get_data = "sort_link_name_old=" . $sort_link_name . 
                                   "&sort_field_old=". $sort_field . 
                                   "&$caller_get_data";
            }
        }
        
        my @menu_items = ("Link Name", "File Name", "Type", "Upload Date/Time");

        my @menu_links = ("index.cgi?$caller_get_data&sort_link_name=Link+Name&sort_field=ls.name,+bi.filename,+bi.extension", 
                  "index.cgi?$caller_get_data&sort_link_name=File+Name&sort_field=bi.filename,+bi.extension",
                  "index.cgi?$caller_get_data&sort_link_name=Type&sort_field=bi.extension,+bi.filename",
                  "index.cgi?$caller_get_data&sort_link_name=Upload+Date/Time&sort_field=bi.upload_date+desc,+bi.upload_time+desc");
        
        my $html_menu = new HTML_Link_Menu;

        $html_menu->set_Menu_Template_Content($te_content);
        $html_menu->set_Menu_Items(@menu_items);
        $html_menu->set_Menu_Links(@menu_links);
        #$html_menu->add_GET_Data_Links_Source($...);
        $html_menu->set_Active_Menu_Item($this->{sort_link_name});
        $html_menu->set_Non_Selected_Link_Color("#0099FF");
    
        $te_content = $html_menu->get_Menu;
        
    } else {
        my $caller_get_data = $cgi->generate_GET_Data("current_blob_id sort_link_name sort_field blob_content_link_name blob_content_dmisn link_name dmisn app_name");
        
        my @menu_items = undef;
        my @menu_links= ("", "");

        my $i = 0;

        for ($i = 1; $i <= $this->{dbr_set_num}; $i++) {
            $menu_items[$i - 1] = $i;
        }

        my $html_menu = new HTML_Link_Menu_Paginate;

        $html_menu->set_Menu_Template_Content($te_content);
        $html_menu->set_Items_View_Num(3);
        $html_menu->set_Items_Set_Num($cdbr_set_num_dmisn);

        $html_menu->set_Menu_Items(@menu_items);
        $html_menu->set_Menu_Links(@menu_links);

        $html_menu->set_Auto_Menu_Links("index.cgi", "cdbr_set_num", "cdbr_set_num_dmisn");
        $html_menu->set_Active_Menu_Item($this->{cdbr_set_num});

        $html_menu->set_Separator_Tag("|");
        $html_menu->set_Next_Tag(">>");
        $html_menu->set_Previous_Tag("<<");
        $html_menu->set_Non_Selected_Link_Color("#0099FF");

        $html_menu->add_GET_Data_Links_Source($caller_get_data);

        $te_content = $html_menu->get_Menu;
    }
    
    $this->add_Content($te_content);
}

sub found_Dynamic_Content {
    my $this = shift @_;
    
    my $blob_id = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    if ($blob_id ne "") {
        my $dbu = new DB_Utilities;
        
        $dbu->set_DBI_Conn($db_conn);
        $dbu->set_Table($this->{pre_table_name} . "blob_content");
        
        my $html_content = $dbu->get_Item("content", "blob_id", "$blob_id");
        
        if ($html_content =~ /<\!-- dynamic_content_ .*\/\/-->/) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

sub found_Dyna_Mod_Ref {
    my $this = shift @_;
    
    my $blob_id = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    if ($blob_id ne "") {
        my $dbu = new DB_Utilities;
        
        $dbu->set_DBI_Conn($db_conn);
        $dbu->set_Table($this->{pre_table_name} . "static_content_dyna_mod_ref");
        
        my $scdmr_id = $dbu->get_Item("scdmr_id", "blob_id", "$blob_id");
        
        if ($scdmr_id ne "") {
            $dbu->set_Table($this->{pre_table_name} . "dyna_mod_param");
            
            my $param_name = $dbu->get_Item("param_name", "scdmr_id", "$scdmr_id");
            
            if ($param_name ne "") {
                return "found_dyna_mod_ref_param";
            }
            
            return "found_dyna_mod_ref";
            
        } else {
            return "not_found";
        }
        
    } else {
        return "not_found";
    }
}

1;