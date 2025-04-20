package Webman_Template_Generator;

use Cwd;

sub new {
    my $class = shift @_;
    
    my $init_ref = shift @_;
    my $dbu = shift @_;
    my $arg = shift @_;
    
    my $this = {};
    
    $this->{wmct} = $init_ref->{wmct};
    $this->{app_name} = $init_ref->{app_name};
    $this->{table_name} = $init_ref->{table_name};
    $this->{dbts} = $init_ref->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    $this->{dbt_schema} = $init_ref->{dbt_schema};
    $this->{dbt_med_schema} = $init_ref->{dbt_med_schema};
    $this->{dbt_med_schema_act} = $init_ref->{dbt_med_schema_act};
    
    $this->{dbu} = $dbu;
    $this->{arg} = $arg;
    
    $this->{app_path_template} = $this->{wmct}->{"dir_web_cgi"} . "/$this->{app_name}/";
    
    bless $this, $class;
    
    return $this;
}

sub get_Name {
    my $this = shift @_;
    
    return __PACKAGE__;
}

sub get_Name_Full {
    my $this = shift @_;
    
    return __PACKAGE__;
}

sub process_DBTS_Info {
    my $this = shift @_;
    
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    
    my $codegen_input = $this->{arg}->{codegen_input};
    my $codegen_input_rec = $this->{arg}->{codegen_input_rec};
    
    my $primary_key = undef;
    my $primary_key_extra = undef;
    my @view_fields = ();
    
    print "\n### Process DBTS for table $this->{table_name} to generate view templates.\n\n";
    
    my $idx = 0;
    
    foreach my $item (@{$dbts}) {
        print "[$idx] $item->{field_name} - $item->{field_type} - $item->{field_length} - $item->{can_null} - $item->{key} - $item->{default_value} - $item->{is_auto_increment}\n";
        
        $idx++;
        
        if ($item->{key} eq "PRI") {
            if ($primary_key eq "") {
                $primary_key = $item->{field_name};
                
            } else {
                $primary_key_extra .= "$item->{field_name} ";
            }
        }
        
        if ($item->{field_name} =~ /^id_/) {
        
        } else {
            push(@view_fields, $item);
        }
    }
    
    $this->{primary_key} = $primary_key;
    $this->{primary_key_extra} = $primary_key_extra;
    $this->{view_fields} = \@view_fields;
    
    my $field_num = @view_fields;
    
    my $choice = undef;
    print "\n";
    print "All fields which name start with 'id_*' will not be treated as a view elements.\n";
    print "The table has the total of $field_num fields to be viewed.\n\n";
    
    if ($codegen_input->[0]->{current_idx} > 0) {
        print "Exclude more fields from being viewed [y/n]: ";
        print $codegen_input->[$codegen_input->[0]->{current_idx}] . "\n";

        $choice = $codegen_input->[$codegen_input->[0]->{current_idx}];
        $codegen_input->[0]->{current_idx}++;
    }
    
    while ($choice ne "y" && $choice ne "n") {
        print "Exclude more fields from being viewed [y/n]: ";

        $choice = <STDIN>;
        $choice =~ s/\n//;
        $choice =~ s/\r//;
    }

    push(@{$codegen_input_rec}, "### Exclude more fields from being viewed [y/n]:");
    push(@{$codegen_input_rec}, $choice);
    
    if ($choice eq "y") {
        $this->set_Excluded_Fields;
    }
}

sub generate_DBI_Search_Form {
    my $this = shift @_;
    
    my $opr_type = shift @_;
    my $template_file = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    
    my $primary_key = $this->{primary_key};
    my @view_fields = @{$this->{view_fields}};
    
    my @kfs_list = split(/ /, $this->{arg}->{key_field_search});
    
    my $kfs_str = $this->{arg}->{key_field_search};
       $kfs_str =~ s/ /_/g;
    
    my $code_tmplt_filename = "template_webman_db_item_search.html";
    
    ### 21/10/2011 
    ### New implementation of webman_db_item_search.pm module 
    ### make the next marked lines of code unnecessary.
    #if ($this->{arg}->{dbi_handling_opt} == 8) {
    #    $code_tmplt_filename = "template_webman_db_item_search_UD.html";
    #}
    
    if (open(MYFILE, "./rsc/code_template/$code_tmplt_filename")) {
        my $table_name_struct = $this->get_Table_Name_Struct;
        
        my $template_content = undef;
        my $template_filename .= $table_name_struct . "_search.html";
        
        if (defined($this->{arg}->{mod_name_search})) {
            $template_filename = $this->{arg}->{mod_name_search};
            $template_filename =~ s/\.pm$/\.html/;
        }
        
        ### 21/10/2011 
        ### New implementation of webman_db_item_search.pm module 
        ### make the next marked lines of code unnecessary.
        #my $task_update = $this->refine_Part_Name($table_name_struct . "_" . $kfs_str . "_update");
        #my $task_delete = $this->refine_Part_Name($table_name_struct . "_" . $kfs_str . "_delete");
        
        my @file_content = <MYFILE>;
        my $fe_row_start = 0; ### fe_row stand for form element row
        my $fe_row_str = undef;
        
        foreach my $line (@file_content) {
        
            if ($line =~ /<!-- start_cgihtml_ name=fe_update_delete/) {
                $fe_row_start = 1;
                $template_content .= $line;
                $line = "";
            }
            
            if ($line =~ /<!-- end_cgihtml_/  && $fe_row_start) {
                foreach my $kfs (@kfs_list) {
                    my $caption = $kfs;
                    
                    $caption =~ s/_/ /g;
                    $caption =~ s/(\w+)/\u\L$1/g;

                    my $tmp_str = $fe_row_str;

                    $tmp_str =~ s/__key_field_search_caption__/$caption/;
                    $tmp_str =~ s/__key_field_search_name__/$kfs/g;

                    $template_content .= $tmp_str;
                }
                
                $fe_row_start = 0;
                $template_content .= $line;
                $line = "";                
            }
            
            if ($fe_row_start) {
                $fe_row_str .= $line;
                
            } else {
                ### 21/10/2011 
                ### New implementation of webman_db_item_search.pm module 
                ### make the next marked lines of code unnecessary.
                #$line =~ s/__task_update__/$task_update/;
                #$line =~ s/__task_delete__/$task_delete/;
                
                if ($line =~ /__text2db_link__/) {
                    my $task = $table_name_struct . "_text2db_updatedelete";

                    my $txt2bd_link  = "<!-- start_cgihtml_ //-->\n";
                       $txt2bd_link .= "<a href=\"index.cgi?link_id=\$cgi_link_id_&task=$task\">Upload Text File</a>\n";
                       $txt2bd_link .= "<!-- end_cgihtml_ //-->\n";

                    if ($this->{arg}->{dbi_txt2db_opt}) {
                        $line =~ s/__text2db_link__/$txt2bd_link/;

                    } else {
                        $line =~ s/__text2db_link__//;
                    }
                }            

                $template_content .= $line;
            }
        }
        
        close(MYFILE);
        
        if ($this->{arg}->{test_mode}) {
            $template_filename =~ s/^template_/template_test_/;
        }        
        
        my $file_name = $this->save_Template_File_Option($template_content, $template_filename);
        
        $this->{arg}->{tmplt_name_search} = $file_name; 
    }
    
    return $this->{arg}->{key_field_search};
}

sub generate_DBI_View {
    my $this = shift @_;
    my $view_title = shift @_;
    my $list_row_mode = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    my $dbt_med_schema = $this->{dbt_med_schema};
    
    my $table_info = $this->{arg}->{table_info};
    
    my $primary_key = $this->{primary_key}; 
    my @view_fields = @{$this->{view_fields}};
    
    my $pk_med_table = undef;
    
    my $code_template_file = "template_webman_db_item_view.html";
    
    if ($list_row_mode) {
        #$code_template_file = "template_webman_db_item_view_list.html";
        $code_template_file = "template_webman_db_item_view_list_dynamic.html";
    }
    
    if (open(MYFILE, "./rsc/code_template/$code_template_file")) {
        my $table_name_struct = $this->get_Table_Name_Struct;
        
        my $template_content = undef;   
        my $template_filename .= $table_name_struct;
        
        if ($this->{arg}->{dbi_handling_opt} > 4) {
            if (defined($this->{arg}->{mod_name_search})) {
                $template_filename = $this->{arg}->{mod_name_search};
                $template_filename =~ s/_search\.pm$/_found\.html/;
                
            } else {  
                $template_filename .= "_found.html";
            }
            
        } else {
            $template_filename .= "_view.html";
        }
        
        my $test_mode = "";
        
        if ($this->{arg}->{test_mode}) {
            $test_mode = "test_"
        }
        
        ### Database item view template is used for displaying search result 
        ### and provide links for update/delete operations.
        my $link_update = "index.cgi?link_id=\$cgi_link_id_&task=";
        my $link_delete = "index.cgi?link_id=\$cgi_link_id_&task=";
        
        if ($this->{arg}->{dbi_handling_opt} == 5 || 
            $this->{arg}->{dbi_handling_opt} == 6 || 
            $this->{arg}->{dbi_handling_opt} == 8) {
            my $task_base_name = $this->{arg}->{mod_name_search};
               $task_base_name =~ s/_search\.pm$//;
               
            $link_update .= $task_base_name . "_update";
            $link_delete .= $task_base_name . "_delete";
        }
        
        #######################################################################
        
        my @file_content = <MYFILE>;
        
        foreach my $line (@file_content) {
            if ($line =~ /__view_title__/) {
                my $temp_line = $line;
                
                $temp_line =~ s/__view_title__/$view_title/;
                $template_content .= $temp_line;    
                
            } elsif ($line =~ /__field_caption__/ && $line =~ /__field_name__/) {
                foreach my $item (@view_fields) {
                    if (!$this->{field_name_exclude}->{$item->{field_name}}) {
                        my $temp_line = $line;
                        
                        my $caption = $item->{field_name};
                           $caption =~ s/_/ /g;
                           $caption =~ s/(\w+)/\u\L$1/g;
                           
                        $temp_line =~ s/__field_caption__/$caption/;
                        $temp_line =~ s/__field_name__/$item->{field_name}/;
                        
                        $template_content .= $temp_line;
                    }
                    
                    
                    ### next is to add lines for extra fields as popup info. 
                    ### element if it's set by developers 
                    ### ???
                }
                
                if ($this->{arg}->{dbi_handling_opt} == 8) {
                    $template_content .= "  <!-- start_cgihtml_ //-->\n";
                    $template_content .= "  <tr>\n    <th align=\"right\">Operations:</th>\n    <td align=\"center\">\n      <a href=\"$link_update\">Update</a>\n      |\n      <a href=\"$link_delete\">Delete</a>\n    </td>\n  </tr>\n";
                    $template_content .= "  <!-- end_cgihtml_ //-->\n";
                }
                
            } elsif ($line =~ /__field_caption_cols__/) { ### $list_row_mode is true
                foreach my $item (@view_fields) {
                    if (!$this->{field_name_exclude}->{$item->{field_name}}) {
                        my $temp_line = $line;
                        
                        my $caption = $item->{field_name};
                           $caption =~ s/_/ /g;
                           $caption =~ s/(\w+)/\u\L$1/g;
                           
                        $temp_line =~ s/__field_caption_cols__/<th>$caption<\/th>/;
                     
                        $template_content .= $temp_line;
                    }
                 }
                 
                if ($this->{arg}->{dbi_handling_opt} == 5 || 
                    $this->{arg}->{dbi_handling_opt} == 6 || 
                    $this->{arg}->{dbi_handling_opt} == 8) {
                    $template_content .= "<th>Operation(s)</th>";
                }
            
            } elsif ($line =~ /__field_name_cols__/) { ### $list_row_mode is true
                foreach my $item (@view_fields) {
                    if (!$this->{field_name_exclude}->{$item->{field_name}}) {
                        my $temp_line = $line;
                        
                        my $tld_field_name = "\$tld_" . $item->{field_name} . "_";
                        
                        $temp_line =~ s/__field_name_cols__/<td>$tld_field_name<\/td>/;
                        
                        $template_content .= $temp_line;                        
                    }
                 }
                
                if ($this->{arg}->{dbi_handling_opt} == 5) {
                    my $pk_var_val = $this->{primary_key} . "=\$tld_" . $this->{primary_key} . "_";
                    
                    $template_content .= "    <!-- start_cgihtml_ //-->\n" .
                                         "    <td align=\"center\">\n" .
                                         "      <a href=\"$link_update&$pk_var_val\">Update</a>\n" .
                                         "    </td>\n" . 
                                         "    <!-- end_cgihtml_ //-->\n";
                                
                } elsif ($this->{arg}->{dbi_handling_opt} == 6) {
                    my $pk_var_val = $this->{primary_key} . "=\$tld_" . $this->{primary_key} . "_";
                    
                    $template_content .= "    <!-- start_cgihtml_ //-->\n" .
                                         "    <td align=\"center\">\n" .
                                         "      <a href=\"$link_delete&$pk_var_val\">Delete</a>\n" .
                                         "    </td>\n" . 
                                         "    <!-- end_cgihtml_ //-->\n"; 
                                         
                } elsif ($this->{arg}->{dbi_handling_opt} == 8) {
                    my $pk_var_val = $this->{primary_key} . "=\$tld_" . $this->{primary_key} . "_";
                    
                    $template_content .= "    <!-- start_cgihtml_ //-->\n" .
                                         "    <td align=\"center\">\n" .
                                         "      <a href=\"$link_update&$pk_var_val\">Update</a>\n" .
                                         "      |\n" .
                                         "      <a href=\"$link_delete&$pk_var_val\">Delete</a>\n" .
                                         "    </td>\n" . 
                                         "    <!-- end_cgihtml_ //-->\n";
                }
                 
            } else {
                $template_content .= $line;
            }

        }
        
        close(MYFILE);
        
        if ($this->{arg}->{test_mode}) {
            $template_filename =~ s/^template_/template_test_/;
        }
        
        if ($list_row_mode) {
            if ($this->{arg}->{dbi_handling_opt} == 5) {
                $template_filename =~ s/\.html$/_LFU\.html/; ### found list for update
                
            } elsif ($this->{arg}->{dbi_handling_opt} == 6) {
                $template_filename =~ s/\.html$/_LFD\.html/; ### found list for delete
                
            } elsif ($this->{arg}->{dbi_handling_opt} == 8) {
                $template_filename =~ s/\.html$/_LFUD\.html/; ### found list for update/delete
                
            } else {
                $template_filename =~ s/\.html$/_list\.html/;
            }
        }
        
        my $file_name = $this->save_Template_File_Option($template_content, $template_filename); 
        
        $this->{arg}->{tmplt_name_view} = $file_name;
    }
}

sub generate_DBI_List_Dynamic {
    my $this = shift @_;
    
    my $key_field_list = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    my $dbt_med_schema = $this->{dbt_med_schema};
    my $dbt_med_schema_act = $this->{dbt_med_schema_act};    
    
    #$this->{wmct}->debug(__FILE__, __LINE__, "$table_name : \$dbt_med_schema_act = $dbt_med_schema_act\n");  
    
    my $mtp = $this->{arg}->{map_table_parent};
    
    my $table_info = $this->{arg}->{table_info};
    
    my $table_name_parent = $table_info->{parent};
    
    ### $table_name_mediator might be equal to undef if $table_name is 
    ### linked to parent table via sub type table that act as a mediator
    my $table_name_mediator = $table_info->{via_mediator};
 
    #$this->{wmct}->debug(__FILE__, __LINE__, "\$table_name_parent =$table_name_parent : \$table_name = $table_name : \$table_name_mediator = $table_name_mediator\n");
    
    my $primary_key = $this->{primary_key}; 
    my @view_fields = @{$this->{view_fields}};
    my @view_fields_mediator = ();

    
    my $pk_med_table = undef;
    
    my $code_template_file = "template_webman_db_item_list_dynamic.html";
    
    if ($this->{arg}->{dbi_handling_opt} == 1) {
        $code_template_file = "template_webman_db_item_list_dynamic_classic.html";
    }
    
    if ($this->{arg}->{dbi_handling_opt} == 2) {
        if ($this->{arg}->{dbi_multi_row_opt} == 2 || $this->{arg}->{dbi_multi_row_opt} == 3) {
            $code_template_file = "template_webman_db_item_list_dynamic_IUD_MR.html";
            
        } else {
            $code_template_file = "template_webman_db_item_list_dynamic_IUD.html";
        }
    }
    
    if ($this->{arg}->{dbi_handling_opt} == 3) {
        $code_template_file = "template_webman_db_item_list_dynamic_AFL.html";
  
        $pk_med_table = $dbt_med_schema->{$table_name_mediator}->[0]->{pk};
        
        if ($pk_med_table eq "") {
            ### try to check if tables are interconnected via acting mediator table
            foreach my $tbl_rel (@{$dbt_schema->{$table_name_parent}}) {
                if ($dbt_med_schema_act->{$tbl_rel->{bound_name}} ne "") {
                    foreach my $item_med (@{$dbt_med_schema_act->{$tbl_rel->{bound_name}}}) {
                        if ($item_med->{bound_name} eq $table_name) {
                            $table_name_mediator = $tbl_rel->{bound_name};
                            $pk_med_table = $item_med->{pk};
                        }
                    }
                }
            }
        }        
    }
    
    #$this->{wmct}->debug(__FILE__, __LINE__, "\$table_name_parent =$table_name_parent : \$table_name = $table_name : \$table_name_mediator = $table_name_mediator\n");
    
    if (open(MYFILE, "./rsc/code_template/$code_template_file")) {
        my $table_name_struct = $this->get_Table_Name_Struct;
        
        my $template_content = undef;        
        
        my $template_filename .= $table_name_struct . "_list.html";
 
        my $task_insert = $table_name_struct . "_insert";
        my $task_update = $table_name_struct . "_insert";
        my $task_delete = $table_name_struct . "_insert";
        my $task_add = $table_name_struct . "_insert";
        my $task_remove = $table_name_struct . "_insert";
        
        if (defined($this->{arg}->{mod_name_list})) {
            $template_filename = $this->{arg}->{mod_name_list};
            $template_filename =~ s/\.pm$/\.html/;
        }
        
        if (defined($this->{arg}->{mod_name_insert})) {
            $task_insert = $this->{arg}->{mod_name_insert};
            $task_insert =~ s/\.pm$//;
        }
        
        if (defined($this->{arg}->{mod_name_update})) {
            $task_update = $this->{arg}->{mod_name_update};
            $task_update =~ s/\.pm$//;
        } 
        
        if (defined($this->{arg}->{mod_name_delete})) {
            $task_delete = $this->{arg}->{mod_name_delete};
            $task_delete =~ s/\.pm$//;
        } 
        
        if (defined($this->{arg}->{mod_name_add})) {
            $task_add = $this->{arg}->{mod_name_add};
            $task_add =~ s/\.pm$//;
        }
        
        if (defined($this->{arg}->{mod_name_remove})) {
            $task_remove = $this->{arg}->{mod_name_remove};
            $task_remove =~ s/\.pm$//;
        }        
        
        my $test_mode = "";
        
        if ($this->{arg}->{test_mode}) {
            $test_mode = "test_"
        }
        
        #######################################################################
        
        my $filter_part_start = 0;
        my $filter_part_str = undef;
        my $parent_table = $mtp->{$this->{arg}->{table_name}};
        
        my @file_content = <MYFILE>;
        
        foreach my $line (@file_content) {            
            if ($line =~ /__parent_item_key_info__/) {
                my $temp_line = $line;  
                
                if ($parent_table ne "") {
                    my %map_table_UK = $this->get_Map_Table_UK;

                    if ($map_table_UK{$parent_table} ne "") {
                        my $cgi_pattern_name = "\$cgi_" . $map_table_UK{$parent_table} . "_";
                        
                        $temp_line =~ s/__parent_item_key_info__/$cgi_pattern_name/;
                        $template_content .= $temp_line;
                        
                    } else {
                            $template_content .= "<b>???</b>";
                    }
                }
                
            } elsif ($line =~ /__list_title__/) {
                my $temp_line = $line;
                my $list_title = "List";

                if ($this->{arg}->{dbi_handling_opt} == 1 || $this->{arg}->{dbi_handling_opt} == 2) {
                    if ($parent_table ne "") {
                        my %map_table_UK = $this->get_Map_Table_UK;

                        if ($map_table_UK{$parent_table} ne "") {
                            my $cgi_pattern_name = "\$cgi_" . $map_table_UK{$parent_table} . "_";

                            $list_title = "<!-- start_cgihtml_ //-->\n<b>$cgi_pattern_name</b>\n<!-- end_cgihtml_ //-->";

                        } else {
                            $list_title = "<b>???</b>";
                        }
                    }   
                    
                } elsif ($this->{arg}->{dbi_handling_opt} == 3) {
                    $list_title = $this->{arg}->{table_name};
                    
                    $list_title =~ s/^[a-z]+_//;
                    $list_title =~ s/_/ /;
                    $list_title =~ s/(\w+)/\u\L$1/g;
                    
                    $list_title .= "\n&gt;\n List";
                }
                
                $temp_line =~ s/__list_title__/$list_title/;
                $template_content .= $temp_line;
            
            } elsif ($line =~ /__menu_item__/) {
                my $num = 0;
                
                foreach my $item (@view_fields) {
                    if (!$this->{field_name_exclude}->{$item->{field_name}}) {
                        my $temp_line = $line;
                        my $new_line = "<th>menu_item" . $num. "_</th>";

                        $temp_line =~ s/__menu_item__/$new_line/;
                        $template_content .= $temp_line;

                        $num++;
                    }
                }
                
                ### put other fields from mediator table
                if ($this->{arg}->{dbi_handling_opt} == 3 && $table_name_mediator ne "") {
                    $this->{dbu}->set_Table($table_name_mediator);
                    my @ahr = $this->{dbu}->get_Table_Structure;

                    foreach my $item (@ahr) {
                        if (!($item->{field_name} =~ /^id_/)) {
                            my $temp_line = $line;
                            
                            my $field_title = $item->{field_name};
                               $field_title =~ s/_/ /;
                               $field_title =~ s/(\w+)/\u\L$1/g;
                               
                            my $new_line = "<th>$field_title</th>";

                            $temp_line =~ s/__menu_item__/$new_line/;
                            $template_content .= $temp_line;
                        
                            push(@view_fields_mediator, $item->{field_name});
                        }     
                    }
                }                
                
                #print "\$dbt_schema = $dbt_schema\n";
                
                if ($dbt_schema ne "") {
                    foreach my $tbl_rel (@{$dbt_schema->{$table_name}}) {
                        if ($tbl_rel->{generate_code}) {
                            if ($tbl_rel->{bound_type} ne "mediator") {
                                my $bnd_tbl_name = $tbl_rel->{bound_name};
                                   $bnd_tbl_name =~ s/^[a-z]+_//;
                                   $bnd_tbl_name =~ s/^_//;
                                   $bnd_tbl_name =~ s/_/ /;

                                my $caption = $bnd_tbl_name;
                                   $caption =~ s/(\w+)/\u\L$1/g;

                                my $temp_line = $line;
                                my $new_line = "<th>$caption</th>";

                                $temp_line =~ s/__menu_item__/$new_line/;
                                $template_content .= $temp_line;
                                
                            } else { ### trace other sub tables connected via current mediator table
                                foreach my $item_med (@{$dbt_med_schema->{$tbl_rel->{bound_name}}}) {
                                    if ($item_med->{generate_code}) {
                                        my $bnd_tbl_name = $item_med->{bound_name};   
                                           $bnd_tbl_name =~ s/^[a-z]+_//;
                                           $bnd_tbl_name =~ s/^_//;
                                           $bnd_tbl_name =~ s/_/ /;

                                        my $caption = $bnd_tbl_name;
                                           $caption =~ s/(\w+)/\u\L$1/g;                                        
                                        
                                        my $temp_line = $line;
                                        my $new_line = "<th>$caption</th>";
                                        
                                        $temp_line =~ s/__menu_item__/$new_line/;
                                        $template_content .= $temp_line;
                                    }
                                }
                            }
                        }
                        
                        ### check acting mediator schema
                        print "\$tbl_rel->{bound_name} = $tbl_rel->{bound_name}\n";
                        print "\$dbt_med_schema_act = $dbt_med_schema_act\n";
                        print "\$dbt_med_schema_act->{$tbl_rel->{bound_name}} = $dbt_med_schema_act->{$tbl_rel->{bound_name}}\n";                        
                        if ($dbt_med_schema_act->{$tbl_rel->{bound_name}} ne "") {
                            foreach my $item_med (@{$dbt_med_schema_act->{$tbl_rel->{bound_name}}}) {
                                if ($item_med->{dbt_schema_key} eq $table_name) {
                                    my $bnd_tbl_name = $item_med->{bound_name};   
                                       $bnd_tbl_name =~ s/^[a-z]+_//;
                                       $bnd_tbl_name =~ s/^_//;
                                       $bnd_tbl_name =~ s/_/ /;

                                    my $caption = $bnd_tbl_name;
                                       $caption =~ s/(\w+)/\u\L$1/g;                                        

                                    my $temp_line = $line;
                                    my $new_line = "<th>$caption</th>";

                                    $temp_line =~ s/__menu_item__/$new_line/;
                                    $template_content .= $temp_line;
                                }
                            }                         
                        }
                    }                    
                }
                
            } elsif ($line =~ /__field_name__/) { 
                foreach my $item (@view_fields) {
                    if (!$this->{field_name_exclude}->{$item->{field_name}}) {
                        my $temp_line = $line;
                        my $new_line = "<td>\$tld_" . $item->{field_name} . "_</td>";

                        $temp_line =~ s/__field_name__/$new_line/;
                        $template_content .= $temp_line;
                    }
                    
                    
                    ### next is to add lines for extra fields as popup info. 
                    ### element if it's set by developers 
                    
                }
                
                ### get other fields from mediator table
                if (@view_fields_mediator) {
                    foreach my $field (@view_fields_mediator) {
                        my $temp_line = $line;
                        my $new_line = "<td>\$tld_" . $field . "_</td>";
                        
                        $temp_line =~ s/__field_name__/$new_line/;
                        $template_content .= $temp_line;
                    }
                }                
                
                if ($dbt_schema ne "") {
                    foreach my $tbl_rel (@{$dbt_schema->{$table_name}}) {
                        if ($tbl_rel->{generate_code}) {                            
                            if ($tbl_rel->{bound_type} ne "mediator") {
                                my $bnd_tbl_name = $tbl_rel->{bound_name};
                                my $bnd_key = $tbl_rel->{bound_key};

                                my $link_get_data = "link_id=__link_id_" . $bnd_tbl_name . "__&$bnd_key=\$tld_$bnd_key" . "_";

                                my $temp_line = $line;
                                my $new_line = "<td><a href=\"index.cgi?$link_get_data\">\$tld_" . $bnd_tbl_name . "_</a></td>";

                                $temp_line =~ s/__field_name__/$new_line/;
                                $template_content .= $temp_line;
                                
                            } else { ### trace other sub tables connected via current mediator table
                                foreach my $item_med (@{$dbt_med_schema->{$tbl_rel->{bound_name}}}) {
                                    if ($item_med->{generate_code}) {
                                        my $bnd_tbl_name = $item_med->{bound_name};
                                        my $bnd_key = $tbl_rel->{bound_key};

                                        my $link_get_data = "link_id=__link_id_" . $bnd_tbl_name . "__&$bnd_key=\$tld_$bnd_key" . "_";

                                        my $temp_line = $line;
                                        my $new_line = "<td><a href=\"index.cgi?$link_get_data\">\$tld_" . $bnd_tbl_name . "_</a></td>";

                                        $temp_line =~ s/__field_name__/$new_line/;
                                        $template_content .= $temp_line;                                        
                                    }
                                }
                            
                            }
                        }
                        
                        ### check acting mediator schema
                        if ($dbt_med_schema_act->{$tbl_rel->{bound_name}} ne "") {
                            foreach my $item_med (@{$dbt_med_schema_act->{$tbl_rel->{bound_name}}}) {
                                if ($item_med->{dbt_schema_key} eq $table_name) {
                                    my $bnd_tbl_name = $item_med->{bound_name};
                                    my $bnd_key = $tbl_rel->{bound_key};

                                    my $link_get_data = "link_id=__link_id_" . $bnd_tbl_name . "__&$bnd_key=\$tld_$bnd_key" . "_";

                                    my $temp_line = $line;
                                    my $new_line = "<td><a href=\"index.cgi?$link_get_data\">\$tld_" . $bnd_tbl_name . "_</a></td>";

                                    $temp_line =~ s/__field_name__/$new_line/;
                                    $template_content .= $temp_line;
                                }
                            }                         
                        }                        
                    }                    
                } 
                
            } elsif ($line =~ /__update_key_field__/) {
                $line =~ s/__update_key_field__/$primary_key/g;
                
                if ($line =~ /__table_name__/) {
                    $line =~ s/__table_name__/$table_name/g;
                }
                
                $template_content .= $line;
                
            } elsif ($line =~ /__field_blank__/) {
                my $new_line = "<td>...</td>";
                
                my $col_total = 0;
                
                foreach my $item (@view_fields) {
                    if (!$this->{field_name_exclude}->{$item->{field_name}}) {
                        $col_total++;
                    }
                }
                
                foreach my $tbl_rel (@{$dbt_schema->{$table_name}}) {
                    if ($tbl_rel->{generate_code}) {
                        $col_total++;
                    }
                    
                    ### check acting mediator schema
                    if ($dbt_med_schema_act->{$tbl_rel->{bound_name}} ne "") {
                        foreach my $item_med (@{$dbt_med_schema_act->{$tbl_rel->{bound_name}}}) {
                            if ($item_med->{dbt_schema_key} eq $table_name) {
                                $col_total++;
                            }
                        }
                    }
                }
                
                for (my $i = 0; $i < @view_fields_mediator; $i++) {
                    $col_total++;
                }
                
                for (my $i = 0; $i < $col_total; $i++) {
                    my $temp_line = $line;
                    
                    $temp_line =~ s/__field_blank__/$new_line/;
                    $template_content .= $temp_line;
                }
                
            } elsif ($line =~ /__task_update__/) {
                my $pkey_get_data = "$primary_key=\$tld_" . $primary_key . "_";
                my $update_get_data = "task=" . $test_mode . $task_update;
                my $update_post_data = $test_mode . $task_update;
                my $get_data = "$pkey_get_data&$update_get_data";
                
                if ($this->{arg}->{dbi_multi_row_opt} == 2 || 
                    $this->{arg}->{dbi_multi_row_opt} == 3) { ### multi row update operations
                    $line =~ s/__task_update__/$update_post_data/g;
                    $template_content .= $line;
                    
                } else {
                    $line =~ s/__task_update__/$get_data/g;
                    $template_content .= $line;                
                }
                
            } elsif ($line =~ /__task_delete__/) {
                my $pkey_get_data = "$primary_key=\$tld_" . $primary_key . "_";
                my $delete_get_data = "task=" . $test_mode . $task_delete;
                my $delete_post_data = $test_mode . $task_delete;
                my $get_data = "$pkey_get_data&$delete_get_data";
                
                if ($this->{arg}->{dbi_multi_row_opt} == 2 || 
                    $this->{arg}->{dbi_multi_row_opt} == 3) { ### multi row update operations
                    $line =~ s/__task_delete__/$delete_post_data/g;
                    $template_content .= $line;
                    
                } else {
                    $line =~ s/__task_delete__/$get_data/g;
                    $template_content .= $line;                
                }
                
            } elsif ($line =~ /__task_insert__/) {
                my $get_data = "task=" . $test_mode . $task_insert;
                
                $line =~ s/__task_insert__/$get_data/g;
                $template_content .= $line;
                
            } elsif ($line =~ /__task_remove__/) {
                my $pkey_get_data = "$pk_med_table=\$tld_" . $pk_med_table . "_";
                my $remove_get_data = "task=" . $test_mode . $task_remove;
                my $get_data = "$pkey_get_data&$remove_get_data";
                
                $line =~ s/__task_remove__/$get_data/g;
                $template_content .= $line;
                
            } elsif ($line =~ /__comp_remove__/) { 
                my $comp_remove = $test_mode . $task_remove;
                
                $line =~ s/__comp_remove__/$comp_remove/g;
                $template_content .= $line;
                
            } elsif ($line =~ /__remove_key_field__/) {
                $line =~ s/__remove_key_field__/$pk_med_table/g;
                
                if ($line =~ /__inl_name__/) {
                    my $inl_name = "inl_" . $table_name;
                    $line =~ s/__inl_name__/$inl_name/g;
                }
                
                if ($line =~ /__dbisn_name__/) {
                    my $dbisn_name = "dbisn_" . $table_name;
                    $line =~ s/__dbisn_name__/$dbisn_name/g;
                }
                
                $template_content .= $line;                
            
            } elsif ($line =~ /__task_add__/) {
                my $get_data = "task=" . $test_mode . $task_add;
                
                $line =~ s/__task_add__/$get_data/g;
                $template_content .= $line;
                
            } elsif ($line =~ /__inl_name__/) {
                my $inl_name = "inl_" . $table_name;
                
                $line =~ s/__inl_name__/$inl_name/g;
                
                $template_content .= $line; 
                
            } elsif ($line =~ /__lsn_name__/) {
                my $lsn_name = "lsn_" . $table_name;
                
                $line =~ s/__lsn_name__/$lsn_name/g;
                
                $template_content .= $line;
                
            } elsif ($line =~ /__filter_part_start__/) {
                $filter_part_start = 1;
                
            }  elsif ($line =~ /__filter_part_end__/) {
                $filter_part_start = 0;
                
                if (defined($key_field_list)) {
                    my @str_part = split(/__part_spliter__/, $filter_part_str);
                    my @kf = split(/ /, $key_field_list);
                    
                    $template_content .= $str_part[0];
                    
                    foreach my $field (@kf) { 
                        my $caption = $field;
                           $caption =~ s/_/ /g;
                           $caption =~ s/(\w+)/\u\L$1/g;
                           
                        my $str_temp = $str_part[1];
                           $str_temp =~ s/__filter_field_caption__/$caption/;
                           $str_temp =~ s/__filter_field_name__/$field/g;
                           
                        $template_content .= $str_temp;
                    }
                    
                    $template_content .= $str_part[2];
                }                
                
            } else {
                if ($filter_part_start) {
                    $filter_part_str .= $line;
                    
                } else {
                    $template_content .= $line;
                }
            }
        }
        
        close(MYFILE);
        
        if ($this->{arg}->{test_mode}) {
            $template_filename =~ s/^template_/template_test_/;
        }        
        
        my $file_name = $this->save_Template_File_Option($template_content, $template_filename);
        
        $this->{arg}->{"tmplt_name_list"} = $file_name;
        
        return $file_name;
    }
}

sub generate_DBI_IU_Form {
    my $this = shift @_;
    
    my $opr_type = shift @_;
    my $template_file = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    
    my $mtp = $this->{arg}->{map_table_parent};
    
    my $primary_key = $this->{primary_key};
    my @view_fields = @{$this->{view_fields}};
    
    my $code_tmplt_filename = undef;
    
    if ($opr_type eq "insert") {
        if ($this->{arg}->{dbi_multi_row_opt} == 1 || $this->{arg}->{dbi_multi_row_opt} == 3) {
            if ($this->{arg}->{dbi_handling_opt} == 2) {
                $code_tmplt_filename = "template_webman_db_item_insert_multirows_type2.html";
                
            } elsif ($this->{arg}->{dbi_handling_opt} == 4) {
                $code_tmplt_filename = "template_webman_db_item_insert_multirows_type2_classic.html";
            }

        } else {
            if ($this->{arg}->{dbi_handling_opt} == 2) {
                $code_tmplt_filename = "template_webman_db_item_insert.html";
                
            } elsif ($this->{arg}->{dbi_handling_opt} == 4) {
                $code_tmplt_filename = "template_webman_db_item_insert_classic.html";
            }
        }

    } elsif ($opr_type eq "update") {
        if ($this->{arg}->{dbi_multi_row_opt} == 2 || $this->{arg}->{dbi_multi_row_opt} == 3) {
            $code_tmplt_filename = "template_webman_db_item_update_multirows_type2.html";

        } else {
            if ($this->{arg}->{dbi_handling_opt} == 2) {
                $code_tmplt_filename = "template_webman_db_item_update.html";
                
            } elsif ($this->{arg}->{dbi_handling_opt} == 5 || $this->{arg}->{dbi_handling_opt} == 8) {
                $code_tmplt_filename = "template_webman_db_item_update_classic.html";
            }
        }
    }
    
    ###########################################################################
    
    if (open(MYFILE, "./rsc/code_template/$code_tmplt_filename")) {
        my $table_name_struct = $this->get_Table_Name_Struct;
        
        my $template_content = undef;
        my $template_filename .= $table_name_struct . "_$opr_type.html";
        
        my $task_fwd = $table_name_struct . "_$opr_type";
        
        if ($opr_type eq "insert" && defined($this->{arg}->{mod_name_insert})) {
            $template_filename = $this->{arg}->{mod_name_insert};
            $task_fwd = $this->{arg}->{mod_name_insert};
        }
        
        if ($opr_type eq "update" && defined($this->{arg}->{mod_name_update})) {
            $template_filename = $this->{arg}->{mod_name_update};
            $task_fwd = $this->{arg}->{mod_name_update};
        }
        
        ### in case of $task_fwd and template_filename is taken from 
        ### $this->{arg}->{mod_name_???}
        $template_filename =~ s/\.pm$/\.html/;
        $task_fwd =~ s/\.pm$//;
        
        ### in case of $task_fwd and $template_filename is not taken from 
        ### $this->{arg}->{mod_name_???}
        $template_filename = $this->refine_Part_Name($template_filename);
        $task_fwd = $this->refine_Part_Name($task_fwd);
                
        #######################################################################
        
        my @file_content = <MYFILE>;
        
        my $start_caption = 0;
        my $start_field = 0;
        my $str_caption = undef;
        my $str_field = undef;
        
        my $start_caption_field = 0;
        my $str_caption_field = undef;
        
        my $str_complete = undef;
        
        foreach my $line (@file_content) {
            if (!$start_caption && !$start_field && !$start_caption_field) {
                if ($line =~ /__parent_item_key_info__/) {
                    my $parent_table = $mtp->{$this->{arg}->{table_name}};
                    
                    if ($parent_table ne "") {
                        my %map_table_UK = $this->get_Map_Table_UK;
                        
                        if ($map_table_UK{$parent_table} ne "") {
                            my $cgi_pattern_name = "\$cgi_" . $map_table_UK{$parent_table} . "_";
                            
                            $line = "<b>$cgi_pattern_name</b> \n&gt; \n";
                            
                        } else {
                            $line = "<b>???</b> \n&gt; \n";
                        }
                        
                    } else {
                        $line = undef;
                    }
                }
                
                if ($line =~ /__task_fwd__/) {
                    $line =~ s/__task_fwd__/$task_fwd/;
                }
                
                if ($line =~ /__irn_cgi_var_name__/) {
                    my $irn_cgi_var_name = "irn_$table_name";
                    
                    $line =~ s/__irn_cgi_var_name__/$irn_cgi_var_name/g;
                }
                
                if ($line =~ /__text2db_link__/) {
                    my $task = $table_name_struct . "_text2db_" . $opr_type;
                    
                    if (defined($this->{arg}->{"mod_name_" . $opr_type . "_txt"})) {
                        $task = $this->{arg}->{"mod_name_" . $opr_type . "_txt"};
                        $task =~ s/\.pm$//;
                    }
                
                    my $txt2bd_link  = "<!-- start_cgihtml_ //-->\n";
                       $txt2bd_link .= "<a href=\"index.cgi?link_id=\$cgi_link_id_&task=$task\">Upload Text File</a>\n";
                       $txt2bd_link .= "<!-- end_cgihtml_ //-->\n";
                    
                    if ($this->{arg}->{dbi_txt2db_opt} && 
                        $this->{arg}->{dbi_handling_opt} != 5 && 
                        $this->{arg}->{dbi_handling_opt} != 6) {
                        $line =~ s/__text2db_link__/$txt2bd_link/;
                        
                    } else {
                        $line =~ s/__text2db_link__//;
                    }
                }
                
                ### single row captions template
                if ($line =~ /__colspan__/) {
                    my $colspan = @view_fields + 1;
                    
                    $line =~ s/__colspan__/$colspan/;
                }
                
                if ($line =~ /__start_caption__/ ||
                    $line =~ /__start_field__/ || 
                    $line =~ /__start_caption_field__/) {
                    ### do nothing
                } else {
                    $template_content .= $line;
                }
            }
            
            ### single row captions template ##################################
            if ($line =~ /__start_caption__/) {
                $line = "";
                $start_caption = 1;
                
            } elsif ($line =~ /__end_caption__/) {                                                
                $start_caption = 0;
                $str_complete = $str_caption;
            }
            
            if ($start_caption) {
                $str_caption .= $line;
            }
            
            if ($line =~ /__start_field__/) {
                $line = "";
                $start_field = 1;
                
            } elsif ($line =~ /__end_field__/) {                                                
                $start_field = 0;
                $str_complete = $str_field;
            }
            
            if ($start_field) {
                $str_field .= $line;
            }            
            
            ### repeated row captions template ###############################
            
            if ($line =~ /__start_caption_field__/) {
                $line = "";
                $start_caption_field = 1;
                
            } elsif ($line =~ /__end_caption_field__/) {
                if ($opr_type eq "insert" && ($this->{arg}->{dbi_multi_row_opt} == 1 || $this->{arg}->{dbi_multi_row_opt} == 3)) {
                    $template_content .= "\n  <tr><td align=\"center\" colspan=\"2\"><b>Item No. \$row_num_</b></td></tr>\n\n";
                }
                
                if ($opr_type eq "update" && ($this->{arg}->{dbi_multi_row_opt} == 2 || $this->{arg}->{dbi_multi_row_opt} == 3)) {
                    $template_content .= "\n  <tr><td align=\"center\" colspan=\"2\"><b>Item No. \$row_num_</b></td></tr>\n\n";
                }                
                                
                $start_caption_field = 0;
                $str_complete = $str_caption_field;
            }
            
            if ($start_caption_field) {
                $str_caption_field .= $line;
            }
            
            ###################################################################
            
            ### $str_complete content can be $str_caption,  
            ### $str_field, or $str_caption_field
            if (defined($str_complete)) {
                foreach my $item (@view_fields) {
                    if (!$this->{field_name_exclude}->{$item->{field_name}}) {
                        my $str_temp = $str_complete;

                        my $caption = $item->{field_name};
                           $caption =~ s/_/ /g;
                           $caption =~ s/(\w+)/\u\L$1/g;

                        my $field_name  = "\$db_" . $item->{field_name};
                        my $field_value = "\$db_" . $item->{field_name} . "_";

                        if ($opr_type eq "insert" && ($this->{arg}->{dbi_multi_row_opt} == 1 || $this->{arg}->{dbi_multi_row_opt} == 3)) {
                            $field_name  .= "_\$row_idx";
                            $field_value .= "\$row_idx_";
                        }

                        if ($opr_type eq "update" && ($this->{arg}->{dbi_multi_row_opt} == 2 || $this->{arg}->{dbi_multi_row_opt} == 3)) {
                            $field_name  .= "_\$row_idx";
                            $field_value .= "\$row_idx_";
                        }                    

                        my $field_error = "";

                        if ($item->{key} eq "PRI" || $item->{key} eq "UNI" || !$item->{can_null}) { 
                            if ($opr_type eq "insert" && ($this->{arg}->{dbi_multi_row_opt} == 1 || $this->{arg}->{dbi_multi_row_opt} == 3)) {
                                $field_error = "<font color=\"#FF0000\">\$fe_" . $item->{field_name} . "_\$row_idx_</font>";

                            } elsif ($opr_type eq "update" && ($this->{arg}->{dbi_multi_row_opt} == 2 || $this->{arg}->{dbi_multi_row_opt} == 3)) {
                                $field_error = "<font color=\"#FF0000\">\$fe_" . $item->{field_name} . "_\$row_idx_</font>";

                            } else {
                                $field_error = "<font color=\"#FF0000\">\$fe_" . $item->{field_name} . "_</font>";
                            }
                        }
                        
                        ### ife stand for input_form_element
                        my $ife = undef;
                        
                        my $parent_table = $mtp->{$this->{arg}->{table_name}};
                        my %map_UK_table = $this->get_Map_UK_Table;

                        if ($parent_table ne "" && $parent_table eq $map_UK_table{$item->{field_name}}) {
                            ### the field is a single key field value from the parent table
                            $field_value = "\$cgi_" . $item->{field_name} . "_";
                            
                            $ife = "__field_value__ <input name=\"__field_name__\" type=\"hidden\" id=\"__field_name__\" value=\"__field_value__\">";
                            $ife =~ s/__field_name__/$field_name/g;
                            $ife =~ s/__field_value__/$field_value/g;
                            
                            $ife = "<!-- start_cgihtml_ //-->$ife<!-- end_cgihtml_ //-->";

                            $str_temp =~ s/__field_caption__/$caption/;
                            $str_temp =~ s/__input_form_element__/$ife/;
                            $str_temp =~ s/__field_error__//;
                            
                        } else {
                            $ife = "<input name=\"__field_name__\" type=\"text\" id=\"__field_name__\" value=\"__field_value__\" __field_size__>";

                            if ($item->{field_type} eq "text") { 
                                $ife = "<textarea name=\"__field_name__\" id=\"__field_name__\" cols=\"50\">__field_value__</textarea>";

                            } elsif ($item->{field_type} eq "varchar") {
                                if ($item->{field_length} > 100) {
                                    $ife = "<textarea name=\"__field_name__\" id=\"__field_name__\" cols=\"50\">__field_value__</textarea>";

                                } else {
                                    my $field_size = $item->{field_length};

                                    if ($field_size > 50) {
                                        $field_size = 50
                                    }

                                    $field_size = "size=\"$field_size\"";

                                    $ife =~ s/__field_size__/$field_size/;
                                }

                            } else {
                                my $field_size = $item->{field_length};

                                $field_size = "size=\"$field_size\"";

                                $ife =~ s/__field_size__/$field_size/;
                            }

                            $ife =~ s/__field_name__/$field_name/g;
                            $ife =~ s/__field_value__/$field_value/;

                            $str_temp =~ s/__field_caption__/$caption/;
                            $str_temp =~ s/__input_form_element__/$ife/;
                            $str_temp =~ s/__field_error__/$field_error/;
                        }

                        $template_content .= "$str_temp\n";
                    }
                }
                
                $str_complete = undef;
            }
            
        }
        
        close(MYFILE);
        
        if ($this->{arg}->{test_mode}) {
            $template_filename =~ s/^template_/template_test_/;
        }        
        
        my $file_name = $this->save_Template_File_Option($template_content, $template_filename);
        
        $this->{arg}->{"tmplt_name_" . $opr_type} = $file_name;  
    }
}

sub generate_DBI_IUD_Confirm { 
    my $this = shift @_;
    
    my $opr_type = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    
    my $mtp = $this->{arg}->{map_table_parent};
    
    my $primary_key = $this->{primary_key};
    my @view_fields = @{$this->{view_fields}};
    
    my $code_tmplt_filename = undef;
    
    if ($opr_type eq "insert") {
        if ($this->{arg}->{dbi_multi_row_opt} == 1 || $this->{arg}->{dbi_multi_row_opt} == 3) {
            if ($this->{arg}->{dbi_handling_opt} == 2) {
                $code_tmplt_filename = "template_webman_db_item_insert_multirows_type2_confirm.html";
            
            } elsif ($this->{arg}->{dbi_handling_opt} == 4) {
                $code_tmplt_filename = "template_webman_db_item_insert_multirows_type2_confirm_classic.html";
            }
            
        } else {
            if ($this->{arg}->{dbi_handling_opt} == 2) {
                $code_tmplt_filename = "template_webman_db_item_insert_confirm.html";
            
            } elsif ($this->{arg}->{dbi_handling_opt} == 4) {
                $code_tmplt_filename = "template_webman_db_item_insert_confirm_classic.html";
            }
        }
        
    } elsif ($opr_type eq "update") {
        if ($this->{arg}->{dbi_multi_row_opt} == 2 || $this->{arg}->{dbi_multi_row_opt} == 3) {
            $code_tmplt_filename = "template_webman_db_item_update_multirows_type2_confirm.html";
            
        } else {
            if ($this->{arg}->{dbi_handling_opt} == 2) {
                $code_tmplt_filename = "template_webman_db_item_update_confirm.html";
                
            } elsif ($this->{arg}->{dbi_handling_opt} == 5 || $this->{arg}->{dbi_handling_opt} == 8) {
                $code_tmplt_filename = "template_webman_db_item_update_confirm_classic.html";
            }
        }
        
    } elsif ($opr_type eq "delete") {
        if ($this->{arg}->{dbi_multi_row_opt} == 2 || $this->{arg}->{dbi_multi_row_opt} == 3) {
            $code_tmplt_filename = "template_webman_db_item_delete_multirows_type2.html";
            
        } else {
            if ($this->{arg}->{dbi_handling_opt} == 2) {
                $code_tmplt_filename = "template_webman_db_item_delete.html";
                
            } elsif ($this->{arg}->{dbi_handling_opt} == 6 || $this->{arg}->{dbi_handling_opt} == 8) {
                $code_tmplt_filename = "template_webman_db_item_delete_classic.html";
            }
        }
    }   
    
    ###########################################################################
    
    if (open(MYFILE, "./rsc/code_template/$code_tmplt_filename")) {
        my $table_name_struct = $this->get_Table_Name_Struct;
        
        my $template_content = undef;
        my $template_filename .= $table_name_struct . "_$opr_type";
        
        my $task_fwd = $table_name_struct . "_$opr_type";
            
        if (defined($this->{arg}->{mod_name_delete})) {
            $template_filename = $this->{arg}->{mod_name_delete};
            $task_fwd = $this->{arg}->{mod_name_delete};
        }


        if ($opr_type eq "insert" && defined($this->{arg}->{mod_name_insert})) {
            $template_filename = $this->{arg}->{mod_name_insert};
            $task_fwd = $this->{arg}->{mod_name_insert};
        }

        if ($opr_type eq "update" && defined($this->{arg}->{mod_name_update})) {
            $template_filename = $this->{arg}->{mod_name_update};
            $task_fwd = $this->{arg}->{mod_name_update};
        }
        
        ### in case of $task_fwd and template_filename is taken from 
        ### $this->{arg}->{mod_name_???}
        $template_filename =~ s/\.pm$//;
        $task_fwd =~ s/\.pm$//;
        
        ### in case of $task_fwd and $template_filename is not taken from 
        ### $this->{arg}->{mod_name_???}
        $template_filename = $this->refine_Part_Name($template_filename);
        $task_fwd = $this->refine_Part_Name($task_fwd);
        
        if ($opr_type eq "delete") { 
            $template_filename .= ".html";
        } else {
            $template_filename .= "_confirm.html";
        }        
        
        #######################################################################        
        
        my @file_content = <MYFILE>;
        
        my $start_caption = 0;
        my $start_field = 0;
        my $str_caption = undef;
        my $str_field = undef;
        
        my $start_caption_field = 0;
        my $str_caption_field = undef;
        
        my $str_complete = undef;
        
        foreach my $line (@file_content) {
            if (!$start_caption && !$start_field && !$start_caption_field) {                
                if ($line =~ /__parent_item_key_info__/) {
                    my $parent_table = $mtp->{$this->{arg}->{table_name}};
                    
                    if ($parent_table ne "") {
                        my %map_table_UK = $this->get_Map_Table_UK;
                        
                        if ($map_table_UK{$parent_table} ne "") {
                            my $cgi_pattern_name = "\$cgi_" . $map_table_UK{$parent_table} . "_";
                            
                            $line = "<b>$cgi_pattern_name</b> \n&gt; \n";
                            
                        } else {
                            $line = "<b>???</b> \n&gt; \n";
                        }
                        
                    } else {
                        $line = undef;
                    }
                }                
                
                if ($line =~ /__task_fwd__/) {                               
                    $line =~ s/__task_fwd__/$task_fwd/;
                }

                if ($line =~ /__text2db_link__/) {
                    my $task = $table_name_struct . "_text2db_delete";

                    if (defined($this->{arg}->{"mod_name_delete_txt"})) {
                        $task = $this->{arg}->{"mod_name_delete_txt"};
                        $task =~ s/\.pm$//;
                    }                

                    my $txt2bd_link  = "<!-- start_cgihtml_ //-->\n";
                       $txt2bd_link .= "<a href=\"index.cgi?link_id=\$cgi_link_id_&task=$task\">Upload Text File</a>\n";
                       $txt2bd_link .= "<!-- end_cgihtml_ //-->\n";

                    if ($opr_type eq "delete" && 
                        $this->{arg}->{dbi_txt2db_opt} && 
                        $this->{arg}->{dbi_handling_opt} == 2) {
                        $line =~ s/__text2db_link__/$txt2bd_link/;

                    } else {
                        $line =~ s/__text2db_link__//;
                    }
                }
                
                ### single row captions template
                if ($line =~ /__colspan__/) {
                    my $colspan = @view_fields + 1;
                    
                    $line =~ s/__colspan__/$colspan/;
                }
                
                if ($line =~ /__start_caption__/ ||
                    $line =~ /__start_field__/ || 
                    $line =~ /__start_caption_field__/) {
                    ### do nothing
                } else {
                    $template_content .= $line;
                }                
            }
            
            ### single row captions template ##################################
            
            if ($line =~ /__start_caption__/) {
                $line = "";
                $start_caption = 1;
                
            } elsif ($line =~ /__end_caption__/) {                                                
                $start_caption = 0;
                $str_complete = $str_caption;
            }
            
            if ($start_caption) {
                $str_caption .= $line;
            }
            
            if ($line =~ /__start_field__/) {
                $line = "";
                $start_field = 1;
                
            } elsif ($line =~ /__end_field__/) {                                                
                $start_field = 0;
                $str_complete = $str_field;
            }
            
            if ($start_field) {
                $str_field .= $line;
            }            
            
            ### repeated row captions template ###############################
            
            if ($line =~ /__start_caption_field__/) {
                $line = "";
                $start_caption_field = 1;
                
            } elsif ($line =~ /__end_caption_field__/) {
            
                if ($opr_type eq "insert" && ($this->{arg}->{dbi_multi_row_opt} == 1 || $this->{arg}->{dbi_multi_row_opt} == 3)) {
                    $template_content .= "\n  <tr><td align=\"center\" colspan=\"2\"><b>Item No. \$row_num_</b></td></tr>\n\n";
                }
                
                if (($opr_type eq "update" || $opr_type eq "delete") && 
                    ($this->{arg}->{dbi_multi_row_opt} == 2 || $this->{arg}->{dbi_multi_row_opt} == 3)) {
                    $template_content .= "\n  <tr><td align=\"center\" colspan=\"2\"><b>Item No. \$row_num_</b></td></tr>\n\n";
                }               
                                
                $start_caption_field = 0;
                $str_complete = $str_caption_field;
            }
            
            if ($start_caption_field) {
                $str_caption_field .= $line;
            }
            
            ###################################################################
            
            ### $str_complete content can be $str_caption,  
            ### $str_field, or $str_caption_field
            
            if (defined($str_complete)) {
                foreach my $item (@view_fields) {
                    if (!$this->{field_name_exclude}->{$item->{field_name}}) {
                        my $str_temp = $str_complete;

                        my $caption = $item->{field_name};
                           $caption =~ s/_/ /g;
                           $caption =~ s/(\w+)/\u\L$1/g;

                        my $field_value = "\$db_" . $item->{field_name} . "_";

                        if ($opr_type eq "insert" && ($this->{arg}->{dbi_multi_row_opt} == 1 || $this->{arg}->{dbi_multi_row_opt} == 3)) {
                            $field_value .= "\$row_idx_";
                        }

                        if (($opr_type eq "update" || $opr_type eq "delete") && 
                            ($this->{arg}->{dbi_multi_row_opt} == 2 || $this->{arg}->{dbi_multi_row_opt} == 3)) {
                            $field_value .= "\$row_idx_";
                        }                    

                        $str_temp =~ s/__field_caption__/$caption/;
                        $str_temp =~ s/__field_value__/$field_value/;

                        $template_content .= "$str_temp\n";
                    }
                }
                
                $str_complete = undef;
            }
        }
        
        close(MYFILE);
        
        if ($this->{arg}->{test_mode}) {
            $template_filename =~ s/^template_/template_test_/;
        }        
        
        my $file_name = $this->save_Template_File_Option($template_content, $template_filename);
    
        $this->{arg}->{"tmplt_name_" . $opr_type . "_confirm"} = $file_name;    
    }
}

sub generate_DBI_IUD_Txt2DB {
    my $this = shift @_;
    
    my $opr_type = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    
    my $mtp = $this->{arg}->{map_table_parent};
    
    my $primary_key = $this->{primary_key};
    my @view_fields = @{$this->{view_fields}};
    
    my $table_name_struct = $this->get_Table_Name_Struct;
    
    my $code_tmplt_filename = undef;
    
    my %operation_title = ("insert" => "Insert via Text File", 
                           "update" => "Update via Text File", 
                           "delete" => "Delete via Text File");
                           
    
    
    ### define the previous task info to bring forward ########################
    
    my $task_fwd = $table_name_struct . "_$opr_type";

    if ($opr_type eq "insert" && defined($this->{arg}->{mod_name_insert})) {
        $task_fwd = $this->{arg}->{mod_name_insert};

    } elsif ($opr_type eq "update" && defined($this->{arg}->{mod_name_update})) {
        $task_fwd = $this->{arg}->{mod_name_update};

    } elsif ($opr_type eq "delete" && defined($this->{arg}->{mod_name_delete})) {
        $task_fwd = $this->{arg}->{mod_name_delete};
    }

    ### in case of $task_fwd is taken from $this->{arg}->{mod_name_???}
    $task_fwd =~ s/\.pm$//;
                           
    
    ### generate file upload form #############################################
    
    $code_tmplt_filename = "template_webman_text2db_map.html";
    
    if ($this->{arg}->{dbi_handling_opt} != 2) {
        $code_tmplt_filename = "template_webman_text2db_map_classic.html";
    }    
    
    if (open(MYFILE, "./rsc/code_template/$code_tmplt_filename")) {
        my $template_content = undef;
        my $template_filename .= $table_name_struct . "_text2db_" . $opr_type . ".html";
        
        if (defined($this->{arg}->{"mod_name_" . $opr_type . "_txt"})) {
            $template_filename = $this->{arg}->{"mod_name_" . $opr_type . "_txt"};
            $template_filename =~ s/\.pm$/\.html/;
        }        
        
        my @file_content = <MYFILE>;
        
        foreach my $line (@file_content) {
            if ($line =~ /__parent_item_key_info__/) {                
                my $parent_table = $mtp->{$this->{arg}->{table_name}};

                if ($parent_table ne "") {
                    my %map_table_UK = $this->get_Map_Table_UK;

                    if ($map_table_UK{$parent_table} ne "") {
                        my $cgi_pattern_name = "\$cgi_" . $map_table_UK{$parent_table} . "_";

                        $line = "<b>$cgi_pattern_name</b> \n&gt; \n";

                    } else {
                        $line = "<b>???</b> \n&gt; \n";
                    }

                } else {
                    $line = undef;
                }                
            }
                
            if ($line =~ /__task_fwd__/) {
                $line =~ s/__task_fwd__/$task_fwd/;
            }
            
            if ($line =~ /__operation_title__/) {
                $line =~ s/__operation_title__/$operation_title{$opr_type}/;
            }
            
            $template_content .= $line;
        }
        
        close(MYFILE);
        
        if ($this->{arg}->{test_mode}) {
            $template_filename =~ s/^template_/template_test_/;
        }        
        
        my $file_name = $this->save_Template_File_Option($template_content, $template_filename);
    
        $this->{arg}->{"tmplt_name_" . $opr_type . "_txt"} = $file_name;        
    }
    
    
    ### generate confirmation form ############################################
    
    $code_tmplt_filename = "template_webman_text2db_map_confirm.html";
    
    if ($this->{arg}->{dbi_handling_opt} != 2) {
        $code_tmplt_filename = "template_webman_text2db_map_confirm_classic.html";
    }    
    
    if (open(MYFILE, "./rsc/code_template/$code_tmplt_filename")) {
        my $template_content = undef;
        my $template_filename .= $table_name_struct . "_text2db_" . $opr_type . "_confirm.html";
        
        if (defined($this->{arg}->{"mod_name_" . $opr_type . "_txt"})) {
            $template_filename = $this->{arg}->{"mod_name_" . $opr_type . "_txt"};
            $template_filename =~ s/\.pm$/_confirm\.html/;
        }        
        
        my @file_content = <MYFILE>;
        
        foreach my $line (@file_content) {
            if ($line =~ /__parent_item_key_info__/) {                
                my $parent_table = $mtp->{$this->{arg}->{table_name}};

                if ($parent_table ne "") {
                    my %map_table_UK = $this->get_Map_Table_UK;

                    if ($map_table_UK{$parent_table} ne "") {
                        my $cgi_pattern_name = "\$cgi_" . $map_table_UK{$parent_table} . "_";

                        $line = "<b>$cgi_pattern_name</b> \n&gt; \n";

                    } else {
                        $line = "<b>???</b> \n&gt; \n";
                    }

                } else {
                    $line = undef;
                }                
            }
                
            if ($line =~ /__task_fwd__/) {
                $line =~ s/__task_fwd__/$task_fwd/;
            }
            
            if ($line =~ /__operation_title__/) {
                $line =~ s/__operation_title__/$operation_title{$opr_type}/;
            }
            
            $template_content .= $line;
        }
        
        close(MYFILE);
        
        if ($this->{arg}->{test_mode}) {
            $template_filename =~ s/^template_/template_test_/;
        }        
        
        my $file_name = $this->save_Template_File_Option($template_content, $template_filename);
    
        $this->{arg}->{"tmplt_name_" . $opr_type . "_txt_confirm"} = $file_name;        
    }    
}

sub generate_DBI_Add_Form {
    my $this = shift @_;
    
    my $key_field_list = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    my $dbt_med_schema_act = $this->{dbt_med_schema_act};
    
    my $mtp = $this->{arg}->{map_table_parent};
    
    my $primary_key = $this->{primary_key};
    my @view_fields = @{$this->{view_fields}};
    my @view_fields_mediator = ();
    
    if (open(MYFILE, "./rsc/code_template/template_webman_db_item_list_dynamic_AFL_Selection.html")) {
        my $table_name_struct = $this->get_Table_Name_Struct;
        
        my $template_content = undef;
        my $template_filename .= $table_name_struct . "_add.html";
        
        if (defined($this->{arg}->{mod_name_add})) {
            $template_filename = $this->{arg}->{mod_name_add};
            $template_filename =~ s/\.pm$/\.html/;
        }        
        
        my $current_table = $this->{arg}->{table_info};
        
        my $id_item_parent = undef;
        my $id_item_added = undef;
        my $table_name_current = $current_table->{name};
        my $table_name_parent = $current_table->{parent};
        
        ### $table_name_mediator might be equal to undef if $table_name is 
        ### linked to parent table via sub type table that act as a mediator        
        my $table_name_mediator = $current_table->{via_mediator};
        
        #$this->{wmct}->debug(__FILE__, __LINE__, "generate_DBI_Add_Form : \$table_name_mediator = $table_name_mediator\n");
        
        if ($table_name_mediator eq "") {
            ### try to check if tables are interconnected via acting mediator table
            foreach my $tbl_rel (@{$dbt_schema->{$table_name_parent}}) {
                if ($dbt_med_schema_act->{$tbl_rel->{bound_name}} ne "") {
                    foreach my $item_med (@{$dbt_med_schema_act->{$tbl_rel->{bound_name}}}) {
                        if ($item_med->{bound_name} eq $table_name_current) {
                            $table_name_mediator = $tbl_rel->{bound_name};
                        }
                    }
                }
            }
        }        
        
        foreach my $item (@{$dbt_schema->{$table_name_parent}}) {
            if ($item->{bound_name} eq $table_name_mediator) {
                $id_item_parent = $item->{bound_key};
            }
        }
        
        foreach my $item (@{$dbt_schema->{$table_name_current}}) {
            if ($item->{bound_name} eq $table_name_mediator) {
                $id_item_added = $item->{bound_key};
            }
        }        
        
        #print "\$id_item_parent = $id_item_parent\n";
        #print "\$id_item_added = $id_item_added\n";
        #my $stuck = <STDIN>;
        
        #######################################################################
        
        my $filter_part_start = 0;
        my $filter_part_str = undef;

        my @file_content = <MYFILE>;
        
        foreach my $line (@file_content) {
            if ($line =~ /__parent_item_key_info__/) {
                my $temp_line = $line;
                my $parent_table = $mtp->{$this->{arg}->{table_name}};
                
                if ($parent_table ne "") {
                    my %map_table_UK = $this->get_Map_Table_UK;
                    
                    #print "\%map_table_UK:\n";
                    #foreach my $key (keys(%map_table_UK)) {
                    #    print "$key -> $map_table_UK{$key}\n";
                    #}
                    
                    #my $stuck = <STDIN>;

                    if ($map_table_UK{$parent_table} ne "") {
                        my $cgi_pattern_name = "\$cgi_" . $map_table_UK{$parent_table} . "_";
                        
                        $temp_line =~ s/__parent_item_key_info__/$cgi_pattern_name/;
                        $template_content .= $temp_line; 
                        
                    } else {
                            $template_content .= "<b>???</b>";
                    }
                }
                
            } elsif ($line =~ /__list_title__/) {
                my $temp_line = $line;
                
                my $list_title = $this->{arg}->{table_name};
                   $list_title =~ s/^[a-z]+_//;
                   $list_title =~ s/_/ /;
                   $list_title =~ s/(\w+)/\u\L$1/g;              
                
                $temp_line =~ s/__list_title__/$list_title/;
                $template_content .= $temp_line;
                
            } elsif ($line =~ /__menu_item__/) {
                my $num = 0;
                
                foreach my $item (@view_fields) {
                    if (!$this->{field_name_exclude}->{$item->{field_name}}) {
                        my $temp_line = $line;
                        my $new_line = "<th>menu_item" . $num. "_</th>";

                        $temp_line =~ s/__menu_item__/$new_line/;
                        $template_content .= $temp_line;

                        $num++;
                    }
                }
                
                ### put other fields from mediator table
                if ($table_name_mediator ne "") {
                    $this->{dbu}->set_Table($table_name_mediator);
                    my @ahr = $this->{dbu}->get_Table_Structure;

                    foreach my $item (@ahr) {
                        if (!($item->{field_name} =~ /^id_/)) {
                            my $temp_line = $line;
                            
                            my $field_title = $item->{field_name};
                               $field_title =~ s/_/ /;
                               $field_title =~ s/(\w+)/\u\L$1/g;
                               
                            my $new_line = "<th>$field_title</th>";

                            $temp_line =~ s/__menu_item__/$new_line/;
                            $template_content .= $temp_line;
                            
                            push(@view_fields_mediator, $item->{field_name});
                        }     
                    }
                }
                
                #print "\$dbt_schema = $dbt_schema\n";
                
                if ($dbt_schema ne "") {
                    foreach my $tbl_rel (@{$dbt_schema->{$table_name}}) {
                        if ($tbl_rel->{generate_code}) {
                            my $bnd_tbl_name = $tbl_rel->{bound_name};
                               $bnd_tbl_name =~ s/^$app_name//;
                               $bnd_tbl_name =~ s/^_//;
                               $bnd_tbl_name =~ s/_/ /;

                            my $caption = $bnd_tbl_name;
                               $caption =~ s/(\w+)/\u\L$1/g;

                            my $temp_line = $line;
                            my $new_line = "<th>$caption</th>";

                            $temp_line =~ s/__menu_item__/$new_line/;
                            $template_content .= $temp_line;
                        }
                    }                    
                } 
                
            } elsif ($line =~ /__field_name__/) {
                foreach my $item (@view_fields) {
                    if (!$this->{field_name_exclude}->{$item->{field_name}}) {
                        my $temp_line = $line;
                        my $new_line = "<td>\$tld_" . $item->{field_name} . "_</td>";

                        $temp_line =~ s/__field_name__/$new_line/;
                        $template_content .= $temp_line;
                    }
                    
                    ### next is to add lines for extra fields as popup info. 
                    ### element if it's set by developers 
                }
                
                ### get other fields from mediator table
                if (@view_fields_mediator) {
                    foreach my $field (@view_fields_mediator) {
                        my $temp_line = $line;
                        my $new_line = "<td><input type=\"text\" name=\"" . $field . "_\$tld_idx_\" size=\"10\"></td>";
                        
                        $temp_line =~ s/__field_name__/$new_line/;
                        $template_content .= $temp_line;
                    }
                }                
                
                if ($dbt_schema ne "") {
                    foreach my $tbl_rel (@{$dbt_schema->{$table_name}}) {
                        if ($tbl_rel->{generate_code}) {                            
                            if ($tbl_rel->{bound_type} ne "mediator") {
                                my $bnd_tbl_name = $tbl_rel->{bound_name};
                                my $bnd_key = $tbl_rel->{bound_key};

                                my $task_name = $bnd_tbl_name . "_list";
                                   $task_name =~ s/^$app_name//;
                                   $task_name = $table_name_struct . $task_name;

                                my $link_get_data = "link_id=__link_id_" . $bnd_tbl_name . "__&$bnd_key=\$tld_$bnd_key" . "_";

                                my $temp_line = $line;
                                my $new_line = "<td><a href=\"index.cgi?$link_get_data\">\$tld_" . $bnd_tbl_name . "_</a></td>";

                                $temp_line =~ s/__field_name__/$new_line/;
                                $template_content .= $temp_line;
                                
                            } else { ### trace other sub tables connected via current mediator table
                                foreach my $item_med (@{$dbt_med_schema->{$tbl_rel->{bound_name}}}) {
                                    if ($item_med->{generate_code}) {
                                        my $bnd_tbl_name = $item_med->{bound_name};
                                        my $bnd_key = $tbl_rel->{bound_key};

                                        my $task_name = $bnd_tbl_name . "_list";
                                           $task_name =~ s/^$app_name//;
                                           $task_name = $table_name_struct . $task_name;

                                        my $link_get_data = "link_id=__link_id_" . $bnd_tbl_name . "__&$bnd_key=\$tld_$bnd_key" . "_";

                                        my $temp_line = $line;
                                        my $new_line = "<td><a href=\"index.cgi?$link_get_data\">\$tld_" . $bnd_tbl_name . "_</a></td>";

                                        $temp_line =~ s/__field_name__/$new_line/;
                                        $template_content .= $temp_line;                                        
                                    }
                                }
                            
                            }
                        }
                    }                    
                }                
                
            } elsif ($line =~ /__id_item_added__/) {
                $line =~ s/__id_item_added__/$id_item_added/g;
                
                if ($line =~ /__inl_name__/) {
                    my $inl_name = "inl_" . $table_name . "_AFLS";
                    $line =~ s/__inl_name__/$inl_name/g;
                }
                
                if ($line =~ /__dbisn_name__/) {
                    my $dbisn_name = "dbisn_" . $table_name . "_AFLS";
                    $line =~ s/__dbisn_name__/$dbisn_name/g;
                }              
                
                $template_content .= $line;
                
            } elsif ($line =~ /__field_blank__/) {
                my $new_line = "<td>...</td>";
                
                my $col_total = 0;
                
                foreach my $item (@view_fields) {
                    if (!$this->{field_name_exclude}->{$item->{field_name}}) {
                        $col_total++;
                    }
                }
                
                foreach my $tbl_rel (@{$dbt_schema->{$table_name}}) {
                    if ($tbl_rel->{generate_code}) {
                        $col_total++;
                    }
                }
                
                for (my $i = 0; $i < @view_fields_mediator; $i++) {
                    $col_total++;
                }                
                
                for (my $i = 0; $i < $col_total; $i++) {
                    my $temp_line = $line;
                    
                    $temp_line =~ s/__field_blank__/$new_line/;
                    $template_content .= $temp_line;
                }                
                
            } elsif ($line =~ /__inl_name__/) {
                my $inl_name = "inl_" . $table_name . "_AFLS";
                
                $line =~ s/__inl_name__/$inl_name/g;
                $template_content .= $line;
                
            } elsif ($line =~ /__lsn_name__/) {
                my $lsn_name = "lsn_" . $table_name . "_AFLS";
                
                $line =~ s/__lsn_name__/$lsn_name/g;
                $template_content .= $line;
                
            } elsif ($line =~ /__filter_part_start__/) {
                $filter_part_start = 1;
                
            }  elsif ($line =~ /__filter_part_end__/) {
                $filter_part_start = 0;
                
                if (defined($key_field_list)) {
                    my @str_part = split(/__part_spliter__/, $filter_part_str);
                    my @kf = split(/ /, $key_field_list);
                    
                    $template_content .= $str_part[0];
                    
                    foreach my $field (@kf) { 
                        my $caption = $field;
                           $caption =~ s/_/ /g;
                           $caption =~ s/(\w+)/\u\L$1/g;
                           
                        my $str_temp = $str_part[1];
                           $str_temp =~ s/__filter_field_caption__/$caption/;
                           $str_temp =~ s/__filter_field_name__/$field/g;
                           
                        $template_content .= $str_temp;
                    }
                    
                    $template_content .= $str_part[2];
                }
                
            } else {
                if ($filter_part_start) {
                    $filter_part_str .= $line;
                    
                } else {
                    $template_content .= $line;
                }
            }
        }
        
        close(MYFILE);
        
        if ($this->{arg}->{test_mode}) {
            $template_filename =~ s/^template_/template_test_/;
        }        
        
        $this->save_Template_File_Option($template_content, $template_filename);
        
    
    }
}

sub set_Excluded_Fields {
    my $this = shift @_;
    
    my $codegen_input = $this->{arg}->{codegen_input};
    my $codegen_input_rec = $this->{arg}->{codegen_input_rec};    
    
    my %field_name_exclude = ();
    my @view_fields_exclude = ();
    
    my @view_fields = @{$this->{view_fields}};
    
    my $num = 1;
    foreach my $item (@view_fields) {
        print "$num. $item->{field_name}\n";
        $num++;
    }
    
    print "\n";
    print "Enter field numbers (separated by space): ";
    
    my $field_num_exclude = undef;
    
    if ($codegen_input->[0]->{current_idx} > 0) {
        print $codegen_input->[$codegen_input->[0]->{current_idx}] . "\n";

        $field_num_exclude = $codegen_input->[$codegen_input->[0]->{current_idx}];
        $codegen_input->[0]->{current_idx}++;
        
    } else {
        $field_num_exclude = <STDIN>;
        $field_num_exclude =~ s/\n//;
        $field_num_exclude =~ s/\r//;
    }
       
    push(@{$codegen_input_rec}, $choice);
       
    my @field_numbers = split(/ /, $field_num_exclude);
    
    foreach my $num (@field_numbers) {
        my $field_name = $view_fields[$num - 1]->{field_name};
        
        if (!($field_name =~ /^id_/)) { ### not a primary keys or foreign keys
            
            print "Exlude field $num : $field_name\n";
            
            $field_name_exclude{$field_name} = 1;
            push(@view_fields_exclude, $view_fields[$num - 1]);
        }
    }
    
    $this->{field_name_exclude} = \%field_name_exclude;
    $this->{view_fields_exclude} = \@view_fields_exclude;
}

sub get_Table_Name_Struct {
    my $this = shift @_;
    
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
        
    my $mtp = $this->{arg}->{map_table_parent};

    my $table_name_struct = $table_name;
    my $table_parent_trace = $mtp->{$table_name};

    while ($table_parent_trace ne "") {
        $table_name_struct = $table_parent_trace . "_" . $table_name_struct;
        $table_parent_trace = $mtp->{$table_parent_trace};
    }

    my $str_sub = "_" . $app_name . "_";

    $table_name_struct =~ s/$str_sub/_/g;
    
    my @part_name = split(/_/, $table_name_struct);
    
    my $part_prev = undef;
    my $table_name_struct_ret = undef;
    
    foreach my $part (@part_name) {
        if ($part ne $part_prev) {
            $table_name_struct_ret .= $part . "_";
        }
        
        $part_prev = $part;
    }
    
    $table_name_struct_ret =~ s/_$//;
    
    return $table_name_struct_ret;
}

sub get_List_Title {
    my $this = shift @_;
    
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};    
    
    my $mtp = $this->{arg}->{map_table_parent};
    
    my $list_title = undef;

    my $table_trace = $table_name;
    my $parent_table = $mtp->{$table_name};

    while ($parent_table ne "") { ### mtp stand for map_table_parent
        my $caption = $table_trace;

        $caption =~ s/^$app_name//;
        $caption =~ s/^_//;
        $caption =~ s/_/ /;
        $caption =~ s/(\w+)/\u\L$1/g;

        $list_title = $caption . " &gt; " . $list_title;

        $table_trace = $parent_table;
        $parent_table = $mtp->{$parent_table};
    }

    $list_title .= "List";
    
}

sub save_Template_File_Option {
    my $this = shift @_;
    
    my $file_content = shift @_;
    my $file_name = shift @_;
    
    my $path_file_name = $this->{app_path_template} . $file_name;
    
    my $write_file = 1;
    my $decide = 0;
    
    my $file_name_new = undef;
    
    if (-e $path_file_name && !$this->{arg}->{overwrite_all_template}) {
        $decide = 1;
    }
    
    print "\n\n";
    print "### Generate template file.\n\n";
    
    while ($decide) {
        print "The file name '$path_file_name' is already exist!!!\n";
        
        my $choice = undef;
        
        while ($choice ne "y" && $choice ne "n" && $choice ne "a") {
            print "Overwrite the existing file? [y/n/a]: ";
        
            $choice = <STDIN>;
            $choice =~ s/\n//;
            $choice =~ s/\r//;
        }
        
        if ($choice eq "y" || $choice eq "a") {
            $write_file = 1;
            $decide = 0;
            
            if ($choice eq "a") {
                $this->{arg}->{overwrite_all_template} = 1;
            }
            
        } elsif ($choice eq "n") {
            
            print "New file name or just press enter to skip: "; 
            
            $file_name_new = <STDIN>;
            
            $file_name_new =~ s/\n//;
            $file_name_new =~ s/\r//;
            
            print "\n";
            
            if ($file_name_new ne "") {
                $path_file_name = $this->{app_path_template} . $file_name_new;
                
                if (-e $path_file_name) {
                    $write_file = 0;
                    $decide = 1;
                    
                } else {
                    $write_file = 1;
                    $decide = 0;
                }
                
            } else {
                $write_file = 0;
                $decide = 0; 
            }
        }
    }    
    
    if ($write_file) {
        #print "File Content:\n$file_content";
        print "Save template file > $path_file_name\n\n";   

        if (open(MYFILE, ">$path_file_name")) {
            print MYFILE ($file_content);
            close(MYFILE);
        }
        
        ### Also write the original backup into apps' codegen_ori directory. 
        ### Useful later for analysis of code reuse contributed by automatic 
        ### code generator. 
        my $path_file_name_ori = $this->{wmct}->{dir_local} . "/app_rsc/" . $this->{app_name} . "/codegen_ori/";
        
        if (defined($file_name_new)) {
           $path_file_name_ori .= "$file_name_new";
           
        } else {
            $path_file_name_ori .= "$file_name";
        }
        
        if (open(MYFILE, ">$path_file_name_ori")) {
            print MYFILE ($file_content);
            close(MYFILE);        
        }
        
    } else {
        print "No template file has been saved.\n\n";
    }
    
    if ($file_name_new ne "") {
        return $file_name_new;
        
    } else {
        return $file_name;
    }    
}

### used to avoid name parts recur. 
sub refine_Part_Name {
    my $this = shift @_;
    
    my $part_name = shift @_;
    
    my %dict = ();
    my @parts = split(/_/, $part_name);
    
    $part_name = "";
    
    foreach my $part (@parts) {
        if (!$dict{$part}) {
            $dict{$part} = 1;
            
            $part_name .= $part . "_";   
        }
    }
    
    $part_name =~ s/_$//;
    
    return $part_name;
}

sub get_Map_Table_UK {
    my $this = shift @_;
    
    ### map linked (parent) tables and their UKs 
    my %map_table_UK = (); 

    if (defined($this->{arg}->{foreign_unique_keys})) {
        my $fu_keys = $this->{arg}->{foreign_unique_keys};

        foreach my $item (@{$fu_keys}) {
            ### get and map FKs that not PKs (mostly are should be UKs)
            if ($item->{field_type} ne "PRI") {
                $map_table_UK{$item->{table_name}} = $item->{field_name};
            }
        }   
    }
    
    return  %map_table_UK;
}

sub get_Map_UK_Table {
    my $this = shift @_;
    
    ### map FKs that are UKs from linked (parent) table 
    my %map_UK_table = ();

    if (defined($this->{arg}->{foreign_unique_keys})) {
        my $fu_keys = $this->{arg}->{foreign_unique_keys};

        foreach my $item (@{$fu_keys}) {
            ### get and map FKs that not PKs (mostly are should be UKs)
            if ($item->{field_type} ne "PRI") {
                $map_UK_table{$item->{field_name}} = $item->{table_name};
            }
        }
    }
    
    return %map_UK_table;
}


1;