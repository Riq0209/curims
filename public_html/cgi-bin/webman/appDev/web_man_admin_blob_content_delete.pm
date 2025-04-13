package web_man_admin_blob_content_delete;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_blob_content_separator;

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{old_blob_prefered_obj} = undef;
    $this->{new_blob_prefered_obj} = undef;
    $this->{deleted_blob_id} = undef;
    
    $this->{owner_entity_id} = undef;
    $this->{owner_entity_name} = undef;
    
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
    
    my $array_ref1 = $this->{old_blob_prefered_obj};
    my $array_ref2 = $this->{new_blob_prefered_obj};
    
    my @old_html_obj = @{$array_ref1};
    my @new_html_obj = @{$array_ref2};
    
    $this->{pre_table_name} = "webman_" . $cgi->param("app_name") . "_";
    
    my @ref_name = undef;
    my $deleted_blob_count = 0;
    my @deleted_blob_id = undef;
    my @child_deleted_blob_id = undef;
    my @filtered_deleted_blob_id = undef;
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table($this->{pre_table_name} . "blob_info");
    
    my $i = 0;
    my $j = 0;
    my $found = undef;
    my $blob_id = undef;
    
    if ($old_html_obj[0] ne undef && $new_html_obj[0] ne undef) {
        for ($i = 0; $i < @old_html_obj; $i++) {
            
            $found = 0;
            
            for ($j = 0; $j < @new_html_obj; $j++) {
                if ($old_html_obj[$i]->get_Object_Reference_Name eq $new_html_obj[$j]->get_Object_Reference_Name) {
                    $found = 1;
                }
            }
            
            if (!$found) {
                @ref_name = split(/\./, $old_html_obj[$i]->get_Object_Reference_Name);
                
                $blob_id = $dbu->get_Item("blob_id", 
                              "filename extension owner_entity_id owner_entity_name", 
                              "$ref_name[0] $ref_name[1] " . $this->{owner_entity_id} . " " . $this->{owner_entity_name});
                                            
                if ($blob_id ne "") {
                    $deleted_blob_id[$deleted_blob_count] = $blob_id;
                    $deleted_blob_count++;
                
                    #print "delete old[$i]. " . $old_html_obj[$i]->get_Object_Reference_Name . "-" . $deleted_blob_id[$deleted_blob_count-1] ."<br>";
                }
            }
        }
        
    } elsif ($old_html_obj[0] ne undef && $new_html_obj[0] eq undef) {
        #print "Delete all old BLOB object refer to current HTML Doc.<br>";
        
        for ($i = 0; $i < @old_html_obj; $i++) {
            @ref_name = split(/\./, $old_html_obj[$i]->get_Object_Reference_Name);

            $blob_id = $dbu->get_Item("blob_id", 
                          "filename extension owner_entity_id owner_entity_name", 
                          "$ref_name[0] $ref_name[1] " . $this->{owner_entity_id} . " " . $this->{owner_entity_name});

            if ($blob_id ne "") {
                $deleted_blob_id[$deleted_blob_count] = $blob_id;
                $deleted_blob_count++;

                #print "delete old[$i]. " . $old_html_obj[$i]->get_Object_Reference_Name . "-" . $deleted_blob_id[$deleted_blob_count-1] ."<br>";
            }
        }
    }
    
    if ($deleted_blob_count > 0) {
        @child_deleted_blob_id = $this->get_Child_BLOB_ID(@deleted_blob_id);
        
        while ($child_deleted_blob_id[0] ne "") {
            for ($i = 0; $i < @child_deleted_blob_id; $i++) {
                $deleted_blob_id[$deleted_blob_count] = $child_deleted_blob_id[$i];
                $deleted_blob_count++;
            }
            
            @child_deleted_blob_id = $this->get_Child_BLOB_ID(@child_deleted_blob_id);
        }
        
        @filtered_deleted_blob_id = $this->other_Dependencies_Filter(@deleted_blob_id);
        
        $this->{deleted_blob_id} = \@filtered_deleted_blob_id;
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->{current_blob_id} = $cgi->param("current_blob_id");
    
    $this->set_Template_File("./template_admin_blob_content_delete.html");
    
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
    
    my @deleted_blob_id = $this->get_Deleted_BLOB_ID;
    
    if (@deleted_blob_id ne undef) {
        my $i = 0;
        my $delete_blob_id_list = undef;
        
        for ($i = 0; $i < @deleted_blob_id; $i++) {
            $delete_blob_id_list .= "$deleted_blob_id[$i],";
        }
        
        $delete_blob_id_list .= "0";
        
        $te_content =~ s/\$delete_blob_id_list_/$delete_blob_id_list/;  
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

sub process_DBHTML { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $app_name = $cgi->param("app_name");
    
    if ($this->{deleted_blob_id} ne undef) {
        my $array_ref = $this->{deleted_blob_id};
    
        my @deleted_blob_id = @{$array_ref};
    
        my $sql = "select * from " . $this->{pre_table_name} . "blob_info where blob_id in (";
    
        my $i = 0;
    
        for ($i = 0; $i < @deleted_blob_id; $i++) {
            $sql .= "'$deleted_blob_id[$i]', ";
        }
        
        $sql .= "'0') order by filename";
        
        my $dbihtml = new DBI_HTML_Map;
        
        $dbihtml->set_DBI_Conn($db_conn);
        $dbihtml->set_SQL($sql);
        $dbihtml->set_HTML_Code($te_content);
        
        $te_content = $dbihtml->get_HTML_Code;
        
        $te_content =~ s/\$app_name_/$app_name/g;
    
        $this->add_Content($te_content);
        
        #print "sql = $sql <br>";
    }
}

sub set_Owner_Entity {
    my $this = shift @_;
    
    $this->{owner_entity_id} = shift @_;
    $this->{owner_entity_name} = shift @_;
}

sub set_Old_BLOB_Prefered_List {
    my $this = shift @_;
    
    my @html_obj_array = @_;
    
    $this->{old_blob_prefered_obj} = \@html_obj_array;
}

sub set_New_BLOB_Prefered_List {
    my $this = shift @_;
    
    my @html_obj_array = @_;
    
    $this->{new_blob_prefered_obj} = \@html_obj_array;
}

sub get_Deleted_BLOB_ID {
    my $this = shift @_;
    
    if ($this->{deleted_blob_id} ne undef) {
        my $array_ref = $this->{deleted_blob_id};
        
        my @deleted_blob_id = @{$array_ref};
        
        return @deleted_blob_id;
        
    } else {
        return undef;
    }
}

sub get_Child_BLOB_ID {
    my $this = shift @_;
    
    my @deleted_blob_id = @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $dbu = new DB_Utilities;
        
    $dbu->set_DBI_Conn($db_conn);
        
    my $i = 0;
    my $j = 0;
    my $file_ext  = undef;
    my $file_content = undef;
    
    my @html_obj_blob_list = undef;
    my @ref_name = undef;
    my @temp_array = undef;
    my $child_file_name = undef;
    my $child_file_ext = undef;
    my $counter = 0;
    my $temp_blob_id = undef;
    my @child_deleted_blob_id = undef;
    
    my $web_man_bcs = new web_man_admin_blob_content_separator;
    
    if ($deleted_blob_id[0] eq "") {
        return undef;
    }
    
    for ($i = 0; $i < @deleted_blob_id; $i++) {
        #print "\$deleted_blob_id[$i] = $deleted_blob_id[$i] <br>";
    
        $dbu->set_Table($this->{pre_table_name} . "blob_info");
        $file_ext = $dbu->get_Item("extension", "blob_id", "$deleted_blob_id[$i]");
        
        if (uc($file_ext) eq "HTML" || uc($file_ext) eq "HTM") {
            $dbu->set_Table($this->{pre_table_name} . "blob_content");
            $file_content = $dbu->get_Item("content", "blob_id", "$deleted_blob_id[$i]");                   
            
            $web_man_bcs->set_HTML_BLOB_Content($file_content);
            @html_obj_blob_list = $web_man_bcs->get_HTML_Object_BLOB_Prefered;
            
            if ($html_obj_blob_list[0] ne undef) {
                print "It has blob prefered <br>\n";
                
                for ($j = 0; $j < @html_obj_blob_list; $j++) {
                    #print "get_Embedded_BLOB_Filename: " . $html_obj_blob_list[$j]->get_Embedded_BLOB_Filename . "<br>\n";

                    @ref_name = split(/\./, $html_obj_blob_list[$j]->get_Embedded_BLOB_Filename);

                    $child_file_name = $ref_name[0];
                    $child_file_ext = $ref_name[1];
                        
                    print "\$child_file_name = $child_file_name <br>\n";
                    print "\$child_file_ext = $child_file_ext <br>\n";

                    $dbu->set_Table($this->{pre_table_name} . "blob_info");
                    $temp_blob_id = $dbu->get_Item("blob_id", 
                                                   "filename extension owner_entity_id owner_entity_name", 
                                                   "$child_file_name $child_file_ext " . $this->{owner_entity_id} . " " . $this->{owner_entity_name});
                                              
                    if ($this->not_In_List($temp_blob_id, @deleted_blob_id) && 
                        $this->not_In_List($temp_blob_id, @child_deleted_blob_id)) {
                        
                        $child_deleted_blob_id[$counter] = $temp_blob_id;
                        $counter++;
                        
                        print "\$child_deleted_blob_id[$counter] = $child_deleted_blob_id[$counter]<br>";
                    }
                }
                
            } 
        }
    }
    
    return @child_deleted_blob_id;
}

sub other_Dependencies_Filter {
    my $this = shift @_;
    
    my @deleted_blob_id = @_;
    
    my @deleted_blob_id_filtered = undef;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $reload_blob_id = $cgi->param("blob_id");
    my @file_content = $cgi->upl_File_Content;
    
    my $dbu = new DB_Utilities;
        
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table($this->{pre_table_name} . "blob_info");
    
    my $counter = 0;
    my @involved_filter_blob_id = undef;
    my @candidate_blob_id = $dbu->get_Items("blob_id", 
                                            "owner_entity_id owner_entity_name", 
                                            $this->{owner_entity_id} . " " . $this->{owner_entity_name});
                                            
    my $i = 0;
    my $j = 0;
    my $file_name = undef;
    my $ext = undef;
                            
    for ($i = 0; $i < @candidate_blob_id; $i++) {
        if ($this->not_In_List($candidate_blob_id[$i]->{blob_id}, @deleted_blob_id)) {
            
            $file_name = $dbu->get_Item("filename", "blob_id", $candidate_blob_id[$i]->{blob_id});
            $ext = $dbu->get_Item("extension", "blob_id", $candidate_blob_id[$i]->{blob_id});
            
            if (uc($ext) eq "HTM" || uc($ext) eq "HTML") {
                #print "BLOB ID " . $candidate_blob_id[$i]->{blob_id} . " ($file_name.$ext) will act as filter<br>";
                
                $involved_filter_blob_id[$counter] = $candidate_blob_id[$i]->{blob_id};
                $counter++;
            }
        }
    }
    
    $dbu->set_Table($this->{pre_table_name} . "blob_content");
    
    my $temp_html_code = undef;
    my $web_man_bcs = new web_man_admin_blob_content_separator;
    my $htmlos = new HTML_Object_Separator;
    
    $counter = 0;
    my $exclude = 0;
    for ($i = 0; $i < @deleted_blob_id; $i++) {
    
        for ($j = 0; $j < @involved_filter_blob_id; $j++) {
        
            if ($involved_filter_blob_id[$j] == $reload_blob_id) { ### use content from new files 
                $web_man_bcs->set_HTML_BLOB_Content($file_content[0]);
                
            } else { ### use content from DB
                $web_man_bcs->set_HTML_BLOB_Content($dbu->get_Item("content", "blob_id", $involved_filter_blob_id[$j]));
            }
                    
            $htmlos->set_Doc_Content($web_man_bcs->get_HTML_Code);
            
            #print "$deleted_blob_id[$i] : BLOB ID $involved_filter_blob_id[$j] will act as filter : " . 
            #       $this->ref_Name_Is_Used($deleted_blob_id[$i], $htmlos->get_HTML_Object_BLOB_Prefered) . "<br>";
                  
            if ($this->ref_Name_Is_Used($deleted_blob_id[$i], $htmlos->get_HTML_Object_BLOB_Prefered)) {
                $exclude = 1;
            }
            
            $web_man_bcs->reset;
            $htmlos->reset;
            
        }
        
        if (!$exclude) {
            $deleted_blob_id_filtered[$counter] = $deleted_blob_id[$i];
            $counter++;
        }
        
        $exclude = 0;
    }
    
    return @deleted_blob_id_filtered;
}

sub not_In_List {
    my $this = shift @_;
        
    my $test_list = shift @_;
    my @list = @_;
    
    my $i = 0;
    
    for ($i = 0; $i < @list; $i++) {
        if ($list[$i] == $test_list) {
            return 0;
        }
    }
    
    return 1;
}

sub ref_Name_Is_Used {
    my $this = shift @_;
    
    my $deleted_blob_id = shift @_;
    my @html_obj = @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $dbu = new DB_Utilities;
        
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table($this->{pre_table_name} . "blob_info");
    
    my $delete_ref_name = $dbu->get_Item("filename", "blob_id", "$deleted_blob_id") .
                          "." .
                          $dbu->get_Item("extension", "blob_id", "$deleted_blob_id");
    
    my $i = 0;
    my $html_obj_ref_name = undef;
    
    for ($i = 0; $i < @html_obj; $i++) {
        
        $html_obj_ref_name = $html_obj[$i]->get_Object_Reference_Name;
        
        if ($html_obj_ref_name eq $delete_ref_name) {
            #print "$delete_ref_name -> have dependencies <br>\n";
            return 1;
            
        }
        
        #print "$html_obj_ref_name --- $delete_ref_name<br>";
    }
    
    #print "###################################<br>\n";
    
    #print "$delete_ref_name -> don't have dependencies <br>\n";
    
    return 0;
    
}

1;

