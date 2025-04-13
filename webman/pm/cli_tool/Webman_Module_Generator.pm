package Webman_Module_Generator;

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
    
    $this->{app_path_module} = $this->{wmct}->{dir_base} . "/webman/pm/apps/" . $this->{app_name} . "/";
    
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

sub generate_DBI_Search {
    my $this = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    
    my $mtp = $this->{arg}->{map_table_parent};
    
    my $code_template_file = "webman_db_item_search.pm";
    
    if ($this->{arg}->{dbi_handling_opt} == 5 || $this->{arg}->{dbi_handling_opt} == 6) {
        $code_template_file = "webman_db_item_search_found_redirect.pm";
    }
    
    if (open(MYFILE, "./rsc/code_template/$code_template_file")) {
        my $table_name_struct = $this->get_Table_Name_Struct;
        
        my $module_content = undef;
        my $module_filename = $table_name_struct;
        
        if (defined($this->{arg}->{key_field_search})) {
            my $kfs = $this->{arg}->{key_field_search};
            
            $kfs =~ s/_//g;
            $kfs =~ s/ /_/g;
               
            $module_filename .= "_" . $kfs . "_search.pm";
            
        } else {
            $module_filename .= "_search.pm";
        }
      
        $module_filename = $this->refine_Module_File_Name($module_filename);
        
        if ($this->{arg}->{test_mode}) {
            $module_filename = "test_" . $module_filename;
        }        

        my @file_content = <MYFILE>;
        
        foreach my $line (@file_content) {
            if ($line =~ /__component_name__/) {
                my $comp_name = $module_filename;
                   $comp_name =~ s/\.pm$//;
                   
                $line =~ s/__component_name__/$comp_name/;
            }
            
            $module_content .= $line;
        }
        
        close(MYFILE);        
        
        my $file_name = $this->save_Module_File_Option($module_content, $module_filename);
        
        $this->{arg}->{mod_name_search} = $file_name;
    }
}

sub generate_DBI_List_Dynamic {
    my $this = shift @_;
    
    my $link_sub_tables = shift @_;
    my $key_field_list = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    my $dbt_med_schema = $this->{dbt_med_schema};
    my $dbt_med_schema_act = $this->{dbt_med_schema_act};
    
    my $mtp = $this->{arg}->{map_table_parent};
    
    my $code_template_file = "webman_db_item_list_dynamic.pm";
    
    if ($this->{arg}->{dbi_handling_opt} == 2) {
        if ($this->{arg}->{dbi_multi_row_opt} == 2 || $this->{arg}->{dbi_multi_row_opt} == 3) {
            $code_template_file = "webman_db_item_list_dynamic_IUD_MR.pm";
        }
    }
    
    if (open(MYFILE, "./rsc/code_template/$code_template_file")) {
        my $table_name_struct = $this->get_Table_Name_Struct;
        
        my $module_content = undef;
        my $module_filename = undef;
                
        if (!defined($link_sub_tables)) {
            $module_filename = $table_name_struct . "_list.pm";
            
        } else {
            $module_filename = $table_name_struct . $link_sub_tables . "_link.pm";
        }
        
        $module_filename = $this->refine_Module_File_Name($module_filename);
        
        if ($this->{arg}->{test_mode}) {
            $module_filename = "test_" . $module_filename;
        }
        
        my $push_param_parent_UK_start = 0;
        my $push_param_parent_UK_str = undef;
        
        my $filter_part_start = 0;
        my $filter_part_str = undef;
        
        my $fu_keys = undef;
        my %map_table_PK = ();
        my %map_table_UK = ();
        
        if (defined($this->{arg}->{foreign_unique_keys})) {
            $fu_keys = $this->{arg}->{foreign_unique_keys};

            ### get and map FKs that are PKs or UKs
            foreach my $item (@{$fu_keys}) {
                if ($item->{field_type} eq "PRI") {
                    $map_table_PK{$item->{table_name}} = $item->{field_name};
                    
                } else {
                    $map_table_UK{$item->{table_name}} = $item->{field_name};
                }
            }        
        }        
        
        my @file_content = <MYFILE>;
        
        foreach my $line (@file_content) {
            if ($line =~ /__component_name__/) {
                my $comp_name = $module_filename;
                   $comp_name =~ s/\.pm$//;
                
                $line =~ s/__component_name__/$comp_name/;
            }
            
            if ($line =~ /__push_param_parent_UK_start__/) {
                $line = undef;
                $push_param_parent_UK_start = 1;
                
            } elsif ($line =~ /__push_param_parent_UK_end__/) {
                $line = undef;
                $push_param_parent_UK_start = 0;
                
                my $parent_table = $mtp->{$table_name};
                
                if (defined($fu_keys) && defined($parent_table)) {
                    my $parent_PK = $map_table_PK{$parent_table};
                    my $parent_UK = $map_table_UK{$parent_table};
                    
                    if (defined($parent_PK) && defined($parent_UK)) {
                        my $temp_str = $push_param_parent_UK_str;
                           $temp_str =~ s/__parent_table__/$parent_table/g;
                           $temp_str =~ s/__parent_PK__/$parent_PK/g;
                           $temp_str =~ s/__parent_UK__/$parent_UK/g;

                       $module_content .= "$temp_str\n";                    
                    }
                }
            }
            
            if ($line =~ /__tld_add_column__/) {
                #print "\$dbt_schema = $dbt_schema\n";
                
                if ($dbt_schema eq "") {
                    $line =~ s/__tld_add_column__//;
                    
                } else {
                    my $line_temp = "";
                    
                    foreach my $tbl_rel (@{$dbt_schema->{$table_name}}) {
                        if ($tbl_rel->{generate_code}) {
                            if ($tbl_rel->{bound_type} ne "mediator") {
                                my $table_name = $tbl_rel->{bound_name};                        
                                my $str_code = "\$tld->add_Column(\"" . $table_name ."\");";

                                $line_temp .= $line;
                                $line_temp =~ s/__tld_add_column__/$str_code/;

                                #print "> $item->{bound_type}-$item->{bound_name}\n";
                                
                            } else { ### trace other sub tables connected via current mediator table
                                foreach my $item_med (@{$dbt_med_schema->{$tbl_rel->{bound_name}}}) {
                                    if ($item_med->{generate_code}) {
                                        my $table_name = $item_med->{bound_name};                        
                                        my $str_code = "\$tld->add_Column(\"" . $table_name ."\");";

                                        $line_temp .= $line;
                                        $line_temp =~ s/__tld_add_column__/$str_code/;                                    
                                    }
                                }
                            }
                        }
                        
                        ### check acting mediator schema
                        if ($dbt_med_schema_act->{$tbl_rel->{bound_name}} ne "") {
                            foreach my $item_med (@{$dbt_med_schema_act->{$tbl_rel->{bound_name}}}) {
                                if ($item_med->{dbt_schema_key} eq $table_name) {
                                    my $table_name = $item_med->{bound_name};                        
                                    my $str_code = "\$tld->add_Column(\"" . $table_name ."\");";

                                    $line_temp .= $line;
                                    $line_temp =~ s/__tld_add_column__/$str_code/; 
                                }
                            }
                        }                        
                    }
                    
                    $line = $line_temp;
                }
            }
            
            if ($line =~ /__count_related_entity_item__/) {
                if ($dbt_schema eq "") {
                    $line =~ s/__count_related_entity_item__//;
                    
                } else {
                    my $line_temp = "";                    
                    
                    foreach my $tbl_rel (@{$dbt_schema->{$table_name}}) {
                        if ($tbl_rel->{generate_code}) {
                            if ($tbl_rel->{bound_type} ne "mediator") {
                                my $table_name = $tbl_rel->{bound_name};
                                my $relation_key = $tbl_rel->{bound_key};

                                my @str_code = ();

                                push(@str_code, "\$dbu->set_Table(\"$table_name\");");
                                push(@str_code, "my \$count_item = \$dbu->count_Item(\"$relation_key\", \$tld->get_Data(\$i, \"$relation_key\"));");
                                push(@str_code, "\$tld->set_Data(\$i, \"$table_name\", \$count_item);\n");

                                foreach my $str (@str_code) {
                                    $line_temp .= $line;
                                    $line_temp =~ s/__count_related_entity_item__/$str/;
                                }
                                
                            } else { ### trace other sub tables connected via current mediator table
                                foreach my $item_med (@{$dbt_med_schema->{$tbl_rel->{bound_name}}}) {
                                    if ($item_med->{generate_code}) {
                                        my $table_name = $tbl_rel->{bound_name};
                                        my $relation_key = $tbl_rel->{bound_key};

                                        my @str_code = ();

                                        push(@str_code, "\$dbu->set_Table(\"$table_name\");");
                                        push(@str_code, "my \$count_item = \$dbu->count_Item(\"$relation_key\", \$tld->get_Data(\$i, \"$relation_key\"));");
                                        push(@str_code, "\$tld->set_Data(\$i, \"$item_med->{bound_name}\", \$count_item);\n"); ### the only difference is here

                                        foreach my $str (@str_code) {
                                            $line_temp .= $line;
                                            $line_temp =~ s/__count_related_entity_item__/$str/;
                                        }
                                    }
                                }
                            }                            
                        }
                        
                        ### check acting mediator schema                        
                        #$this->{wmct}->debug(__FILE__, __LINE__, "\$dbt_med_schema_act->{$tbl_rel->{bound_name}} = $dbt_med_schema_act->{$tbl_rel->{bound_name}}\n");
                        
                        if ($dbt_med_schema_act->{$tbl_rel->{bound_name}} ne "") {
                            foreach my $item_med (@{$dbt_med_schema_act->{$tbl_rel->{bound_name}}}) {
                                if ($item_med->{dbt_schema_key} eq $table_name) {
                                    my $table_name = $tbl_rel->{bound_name};
                                    my $relation_key = $tbl_rel->{bound_key};

                                    my @str_code = ();

                                    push(@str_code, "\$dbu->set_Table(\"$table_name\");");
                                    push(@str_code, "my \$count_item = \$dbu->count_Item(\"$relation_key\", \$tld->get_Data(\$i, \"$relation_key\"));");
                                    push(@str_code, "\$tld->set_Data(\$i, \"$item_med->{bound_name}\", \$count_item);\n"); ### the only difference is here

                                    foreach my $str (@str_code) {
                                        $line_temp .= $line;
                                        $line_temp =~ s/__count_related_entity_item__/$str/;
                                    }
                                }
                            }
                        }                        
                    }
                    
                    $line = $line_temp;
                }
            }
            
            if ($line =~ /__filter_part_start__/) {
                $line = undef;
                $filter_part_start = 1;
                
            }  elsif ($line =~ /__filter_part_end__/) {
                $line = undef;
                $filter_part_start = 0;
                
                if (defined($key_field_list)) {
                    my @str_part = split(/__part_spliter__/, $filter_part_str);
                    my @kf = split(/ /, $key_field_list);
                    
                    $module_content .= $str_part[0];
                    
                    foreach my $field (@kf) {                            
                        my $str_temp = $str_part[1];
                           $str_temp =~ s/__filter_field_name__/$field/g;
                           
                        $module_content .= $str_temp;
                    }
                    
                    $module_content .= $str_part[2];
                }
            }
            
            if (defined($line)) {
                if ($push_param_parent_UK_start) {
                    $push_param_parent_UK_str .= $line;
                    
                } elsif ($filter_part_start) {
                    $filter_part_str .= $line;

                } else {
                    $module_content .= $line;
                }
            }            
        }
        
        close(MYFILE);
        
        my $file_name = $this->save_Module_File_Option($module_content, $module_filename);
        
        $this->{arg}->{mod_name_list} = $file_name;
    }    
}

sub generate_DBI_IUD {
    my $this = shift @_;

    my $opr_type = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    
    my $mtp = $this->{arg}->{map_table_parent};
    
    my $code_tmplt_filename = undef;
    
    if ($opr_type eq "insert") {
        if ($this->{arg}->{dbi_multi_row_opt} == 1 || $this->{arg}->{dbi_multi_row_opt} == 3) {
            $code_tmplt_filename = "webman_db_item_insert_multirows.pm";
            
        } else {
            $code_tmplt_filename = "webman_db_item_insert.pm";
        }
        
    } elsif ($opr_type eq "update") {
        if ($this->{arg}->{dbi_multi_row_opt} == 2 || $this->{arg}->{dbi_multi_row_opt} == 3) {
            $code_tmplt_filename = "webman_db_item_update_multirows.pm";
            
        } else {
            $code_tmplt_filename = "webman_db_item_update.pm";
        }
        
    } elsif ($opr_type eq "delete") {
        if ($this->{arg}->{dbi_multi_row_opt} == 2 || $this->{arg}->{dbi_multi_row_opt} == 3) {
            $code_tmplt_filename = "webman_db_item_delete_multirows.pm";
            
        } else {
            $code_tmplt_filename = "webman_db_item_delete.pm";
        }
    }    
    
    if (open(MYFILE, "./rsc/code_template/$code_tmplt_filename")) {
        my $table_name_struct = $this->get_Table_Name_Struct;
        
        my $module_content = undef;
        my $module_filename = $table_name_struct;
        
        if (defined($this->{arg}->{key_field_search})) {
            my $kfs = $this->{arg}->{key_field_search};
            
            $kfs =~ s/_//g;
            $kfs =~ s/ /_/g;
            
            $module_filename .= "_" . $kfs . "_$opr_type.pm";
            
        } else {
            if ($code_tmplt_filename =~ /_multirows\.pm$/) {
                $module_filename .= "_multirows_$opr_type.pm";
            } else {
                $module_filename .= "_std_$opr_type.pm";
            }
        }
        
        $module_filename = $this->refine_Module_File_Name($module_filename);
        
        if ($this->{arg}->{test_mode}) {
            $module_filename = "test_" . $module_filename;
        }        
        
        #######################################################################
        
        my $push_param_parent_FK_start = 0;
        my $push_param_parent_FK_str = undef;
        
        my $push_param_FK_start = 0;
        my $push_param_FK_str = undef;
        
        my $fu_keys = undef;
        my %map_table_PK = ();
        my %map_table_UK = ();
        
        if (defined($this->{arg}->{foreign_unique_keys})) {
            $fu_keys = $this->{arg}->{foreign_unique_keys};

            ### get and map FKs that not PKs (mostly are should be UKs)
            foreach my $item (@{$fu_keys}) {
                if ($item->{field_type} eq "PRI") {
                    $map_table_PK{$item->{table_name}} = $item->{field_name};
                    
                } else {
                    $map_table_UK{$item->{table_name}} = $item->{field_name};
                }
            }        
        }
        
        my @file_content = <MYFILE>;
        
        foreach my $line (@file_content) {
            if ($line =~ /__component_name__/) {
                my $comp_name = $module_filename;
                   $comp_name =~ s/\.pm$//;
                   
                $line =~ s/__component_name__/$comp_name/;
            }
            
            if ($line =~ /__cgi_push_param__/) {
                my $parent_table = $mtp->{$table_name};
                
                if ($parent_table eq "") {
                    $line = "";
                    
                } else {
                    my $bound_key = undef;
                    
                    foreach my $tbl_rel (@{$dbt_schema->{$parent_table}}) {
                        if ($tbl_rel->{bound_name} eq $table_name) {
                            $bound_key = $tbl_rel->{bound_key};
                        }
                        
                        #$this->{wmct}->debug(__FILE__, __LINE__, "$parent_table > $tbl_rel->{bound_key} >  $tbl_rel->{bound_name}\n");
                    }

                    my @str_code = ("if (\$cgi->param(\"\\\$db_$bound_key\") ne \$cgi->param(\"$bound_key\")) {",
                                    "    \$cgi->push_Param(\"\\\$db_$bound_key\", \$cgi->param(\"$bound_key\"));",
                                    "}");
                    
                    my $line_temp = undef;
                    
                    foreach my $item (@str_code) {
                        $line_temp .= $line;
                        $line_temp =~ s/__cgi_push_param__/$item/;
                    }
                                   
                    $line = $line_temp;
                }
            }
            
            if ($line =~ /__irn_cgi_var_name__/) {
                my $irn_cgi_var_name = "irn_$table_name";

                $line =~ s/__irn_cgi_var_name__/$irn_cgi_var_name/g;
            }
            
            if ($line =~ /__push_param_parent_FK_start__/) {
                $push_param_parent_FK_start = 1;
                
            } elsif($line =~ /__push_param_parent_FK_end__/) {
                $push_param_parent_FK_start = 0;
                
                my $parent_table = $mtp->{$table_name};
                
                if (defined($fu_keys) && defined($parent_table)) {
                    ### start process the real FKs that are
                    ### mostly UKs in the parent table
                    foreach my $item (@{$fu_keys}) {
                        if ($item->{field_type} ne "PRI" && $item->{table_name} eq $parent_table) {
                            my $linked_table_FK = $item->{field_name};
                            my $linked_table_name= $parent_table;
                            my $linked_table_PK = $map_table_PK{$parent_table};
                            
                            my $temp_str = $push_param_parent_FK_str;
                               $temp_str =~ s/__linked_table_PK__/$linked_table_PK/g;
                               $temp_str =~ s/__linked_table_name__/$linked_table_name/g;
                               $temp_str =~ s/__linked_table_FK__/$linked_table_FK/g;
                               
                           $module_content .= "$temp_str\n";
                        }
                    }
                }
                
            } elsif ($line =~ /__push_param_FK_start__/) {
                $push_param_FK_start = 1;
                
            } elsif ($line =~ /__push_param_FK_end__/) {
                $push_param_FK_start = 0;
                
                if (defined($fu_keys)) {                    
                    ### start process the real FKs that are PKs
                    foreach my $item (@{$fu_keys}) {
                        if ($item->{field_type} eq "PRI") {
                            my $linked_table_PK = $item->{field_name};
                            my $linked_table_name= $item->{table_name};
                            my $linked_table_UK = $map_table_UK{$linked_table_name};
                            
                            if ($linked_table_UK ne "") {
                                my $temp_str = $push_param_FK_str;
                                   $temp_str =~ s/__linked_table_PK__/$linked_table_PK/g;
                                   $temp_str =~ s/__linked_table_name__/$linked_table_name/g;
                                   $temp_str =~ s/__linked_table_UK__/$linked_table_UK/g;
                                   
                                $module_content .= "$temp_str\n";
                            }
                        }
                    }
                }
                
            } else {
                if ($push_param_parent_FK_start) {
                    $push_param_parent_FK_str .= $line;
                    
                } elsif ($push_param_FK_start) {
                    $push_param_FK_str .= $line;
                    
                } else {
                    $module_content .= $line;
                }
            }
        }
        
        close(MYFILE);        
        
        my $file_name = $this->save_Module_File_Option($module_content, $module_filename);
        
        $this->{arg}->{"mod_name_" . $opr_type} = $file_name;
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
    
    my $code_tmplt_filename = "webman_text2db_map.pm";
    
    if ($opr_type eq "insert") {
    
    } elsif ($opr_type eq "update") {
        
    } elsif ($opr_type eq "delete") {
    
    }
    
    if (open(MYFILE, "./rsc/code_template/$code_tmplt_filename")) {
        my $table_name_struct = $this->get_Table_Name_Struct;
        
        my $module_content = undef;
        my $module_filename = $table_name_struct;
        
        $module_filename .= "_text2db_" .$opr_type . ".pm";
        
        $module_filename = $this->refine_Module_File_Name($module_filename);
        
        if ($this->{arg}->{test_mode}) {
            $module_filename = "test_" . $module_filename;
        }
        
        my $add_FK_start = 0;
        my $add_FK_str = undef;
        my $fu_keys = undef;
        my %map_table_UK = ();
        
        if (defined($this->{arg}->{foreign_unique_keys})) {
            $fu_keys = $this->{arg}->{foreign_unique_keys};

            ### get and map FKs that not PKs (mostly are should be UKs)
            foreach my $item (@{$fu_keys}) {
                if ($item->{field_type} ne "PRI") {
                    $map_table_UK{$item->{table_name}} = $item->{field_name};
                }
            }
        }

        my @file_content = <MYFILE>;
        
        foreach my $line (@file_content) {
            if ($line =~ /__component_name__/) {
                my $comp_name = $module_filename;
                   $comp_name =~ s/\.pm$//;
                   
                $line =~ s/__component_name__/$comp_name/;
            }
            
            if ($line =~ /__add_col_linked_table_PK__/ || $line =~ /__add_FK_start__/) {
                if ($line =~ /__add_col_linked_table_PK__/) {
                    foreach my $item (@{$fu_keys}) {
                        if ($item->{field_type} eq "PRI") {
                            my $temp_str = $line;
                            my $linked_table_PK = $item->{field_name};
                            my $rplc_str = "\$tld->add_Column(\"$linked_table_PK\");";
                            
                            $temp_str =~ s/__add_col_linked_table_PK__/$rplc_str/;
                            $module_content .= $temp_str;
                        }
                    }
                
                } else { ### __add_FK_start__
                    $add_FK_start = 1;
                }
                
            } elsif($line =~ /__add_FK_end__/) {
                $add_FK_start = 0;
                
                ### start process the real FKs that are PKs
                foreach my $item (@{$fu_keys}) {
                    if ($item->{field_type} eq "PRI") {
                        my $linked_table_PK = $item->{field_name};
                        my $linked_table_name= $item->{table_name};
                        my $linked_table_UK = $map_table_UK{$linked_table_name};

                        if ($linked_table_UK ne "") {
                            my $temp_str = $add_FK_str;
                               $temp_str =~ s/__linked_table_PK__/$linked_table_PK/g;
                               $temp_str =~ s/__linked_table_name__/$linked_table_name/g;
                               $temp_str =~ s/__linked_table_UK__/$linked_table_UK/g;

                            $module_content .= "$temp_str\n";
                        }
                    }
                }                
                
            } else {
                if ($add_FK_start) {
                    $add_FK_str .= $line;
                    
                } else {
                    $module_content .= $line;
                }
            }
        }
        
        my $file_name = $this->save_Module_File_Option($module_content, $module_filename);
        
        $this->{arg}->{"mod_name_" . $opr_type . "_txt"} = $file_name;        
    }
    
}

sub generate_DBI_Add {
    my $this = shift @_;
    
    my $key_field_list = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    my $dbt_med_schema_act = $this->{dbt_med_schema_act};
    
    my $mtp = $this->{arg}->{map_table_parent};
    
    #print "\$key_field_list = $key_field_list\n";
    
    if (open(MYFILE, "./rsc/code_template/db_item_add.pm")) {
        my $table_name_struct = $this->get_Table_Name_Struct;
        
        my $module_content = undef;
        my $module_filename = $table_name_struct . "_add.pm";
        
        $module_filename = $this->refine_Module_File_Name($module_filename);
        
        if ($this->{arg}->{test_mode}) {
            $module_filename = "test_" . $module_filename;
        }        

        
        my $current_table = $this->{arg}->{table_info};
        
        my $id_item_parent = undef;
        my $id_item_added = undef;
        my $table_name_current = $current_table->{name};
        my $table_name_parent = $current_table->{parent};
        my $table_name_mediator = $current_table->{via_mediator};
        
        if ($table_name_mediator eq "") {
            print "Try to check if tables are interconnected via acting mediator table\n";
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
        
        #print "\$current_table->{name} = $current_table->{name}\n";
        #print "\$current_table->{parent} = $current_table->{parent}\n";
        #print "\$current_table->{via_mediator} = $current_table->{via_mediator}\n";        
        
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
        
        my $push_param_parent_UK_start = 0;
        my $push_param_parent_UK_str = undef;        
        
        my $filter_part_start = 0;
        my $filter_part_str = undef;
        
        my $add_mediator_field_start = 0;
        my $add_mediator_field_str = undef;
        
        my $shift_mediator_field_start = 0;
        my $shift_mediator_field_str = undef;        
        
        my $fu_keys = undef;
        my %map_table_PK = ();
        my %map_table_UK = ();
        
        if (defined($this->{arg}->{foreign_unique_keys})) {
            $fu_keys = $this->{arg}->{foreign_unique_keys};

            ### get and map FKs that are PKs or UKs
            foreach my $item (@{$fu_keys}) {
                if ($item->{field_type} eq "PRI") {
                    $map_table_PK{$item->{table_name}} = $item->{field_name};
                    
                } else {
                    $map_table_UK{$item->{table_name}} = $item->{field_name};
                }
            }        
        }        
        
        my @file_content = <MYFILE>;
        
        foreach my $line (@file_content) {
            if ($line =~ /__component_name__/) {
                my $comp_name = $module_filename;
                   $comp_name =~ s/\.pm$//;
                   
                $line =~ s/__component_name__/$comp_name/;
            }
            
            if ($line =~ /__push_param_parent_UK_start__/) {
                $line = undef;
                $push_param_parent_UK_start = 1;
                
            } elsif ($line =~ /__push_param_parent_UK_end__/) {
                $line = undef;
                $push_param_parent_UK_start = 0;
                
                my $parent_table = $mtp->{$table_name};
                
                if (defined($fu_keys) && defined($parent_table)) {
                    my $parent_PK = $map_table_PK{$parent_table};
                    my $parent_UK = $map_table_UK{$parent_table};
                    
                    if (defined($parent_PK) && defined($parent_UK)) {
                        my $temp_str = $push_param_parent_UK_str;
                           $temp_str =~ s/__parent_table__/$parent_table/g;
                           $temp_str =~ s/__parent_PK__/$parent_PK/g;
                           $temp_str =~ s/__parent_UK__/$parent_UK/g;

                       $module_content .= "$temp_str\n";                    
                    }
                }
            }
            
            if ($line =~ /__task_parent_list__/) {
                my $task = $module_filename;
                   $task =~ s/_add\.pm$/_list/;
                   
                $line =~ s/__task_parent_list__/\"$task\"/;
            }
            
            if ($line =~ /__tld_add_column__/) {
                $line = "    #__tld_add_column__"; ### still not found cases to enable this part
            }
            
            #__id_item_parent__
            
            if ($line =~ /__id_item_parent__/) {
                $line =~ s/__id_item_parent__/$id_item_parent/;
            }
            
            #__id_item_added__
            if ($line =~ /__id_item_added__/) {
                $line =~ s/__id_item_added__/$id_item_added/;
            }
            
            #__mediator_table_name__
            if ($line =~ /__mediator_table_name__/) {
                $line =~ s/__mediator_table_name__/$table_name_mediator/;
            }
            
            ### add none PK & FK of other PK mediator table fields
            if ($line =~ /__add_mediator_field_start__/) {
                $line = undef;
                $add_mediator_field_start = 1;
                
            }  elsif ($line =~ /__add_mediator_field_end__/) {
                $line = undef;
                $add_mediator_field_start = 0;
                
                $this->{dbu}->set_Table($table_name_mediator);
                my @ahr = $this->{dbu}->get_Table_Structure;
                
                foreach my $item (@ahr) {
                    if (!($item->{field_name} =~ /^id_/)) {
                        my $str_temp = $add_mediator_field_str;
                           $str_temp =~ s/__mediator_field__/$item->{field_name}/g;

                        $module_content .= "$str_temp\n";
                    }
                }
            }
            
            ### shift all CGI variables that represent mediator table fields
            if ($line =~ /__shift_mediator_field_start__/) {
                $line = undef;
                $shift_mediator_field_start = 1;
                
            }  elsif ($line =~ /__shift_mediator_field_end__/) {
                $line = undef;
                $shift_mediator_field_start = 0;
                
                my $str_temp = $shift_mediator_field_str;
                   $str_temp =~ s/__mediator_field__/$id_item_added/;
                   
                $module_content .= "$str_temp";
                
                $this->{dbu}->set_Table($table_name_mediator);
                my @ahr = $this->{dbu}->get_Table_Structure;
                
                foreach my $item (@ahr) {
                    if (!($item->{field_name} =~ /^id_/)) {
                        $str_temp = $shift_mediator_field_str;
                        $str_temp =~ s/__mediator_field__/$item->{field_name}/;

                        $module_content .= "$str_temp";
                    }
                }
            }            
            
            ### add filter fields
            if ($line =~ /__filter_part_start__/) {
                $line = undef;
                $filter_part_start = 1;
                
            }  elsif ($line =~ /__filter_part_end__/) {
                $line = undef;
                $filter_part_start = 0;
                
                if (defined($key_field_list)) {
                    my @str_part = split(/__part_spliter__/, $filter_part_str);
                    my @kf = split(/ /, $key_field_list);
                    
                    $module_content .= $str_part[0];
                    
                    foreach my $field (@kf) {                            
                        my $str_temp = $str_part[1];
                           $str_temp =~ s/__filter_field_name__/$field/g;
                           
                        $module_content .= $str_temp;
                    }
                    
                    $module_content .= $str_part[2];
                }
            }
            
            
            if (defined($line)) {
                if ($push_param_parent_UK_start) {
                    $push_param_parent_UK_str .= $line;
                                
                } elsif ($filter_part_start) {
                    $filter_part_str .= $line;

                } elsif ($add_mediator_field_start) {
                    $add_mediator_field_str .= $line;
                    
                } elsif ($shift_mediator_field_start) {
                    $shift_mediator_field_str .= $line;
                    
                } else {
                    $module_content .= $line;
                }
            }
        }
        
        close(MYFILE);        
        
        my $file_name = $this->save_Module_File_Option($module_content, $module_filename);
        
        $this->{arg}->{mod_name_add} = $file_name;
    }
}

sub generate_DBI_Remove {
    my $this = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    my $table_name = $this->{table_name};
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    my $dbt_med_schema = $this->{dbt_med_schema};
    my $dbt_med_schema_act = $this->{dbt_med_schema_act};    
    
    my $mtp = $this->{arg}->{map_table_parent};
    
    my $mtp = $this->{arg}->{map_table_parent};
    
    my $table_info = $this->{arg}->{table_info};
    
    my $table_name_parent = $table_info->{parent};
    
    ### $table_name_mediator might be equal to undef if $table_name is 
    ### linked to parent table via sub type table that act as a mediator
    my $table_name_mediator = $table_info->{via_mediator};
    
    my $pk_med_table = $dbt_med_schema->{$table_name_mediator}->[0]->{pk};
    
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
    
    #print "\$table_name = $table_name\n";
    #print "\$$table_name_mediator = $table_name_mediator\n";
    #print "\$pk_med_table = $pk_med_table\n";
    
    #my $stuck = <STDIN>;
    
    if (open(MYFILE, "./rsc/code_template/db_item_remove.pm")) {
        my $table_name_struct = $this->get_Table_Name_Struct;
        
        my $module_content = undef;
        my $module_filename = $table_name_struct . "_remove.pm";
        
        $module_filename = $this->refine_Module_File_Name($module_filename);
        
        if ($this->{arg}->{test_mode}) {
            $module_filename = "test_" . $module_filename;
        }        

        my @file_content = <MYFILE>;
        
        foreach my $line (@file_content) {
            if ($line =~ /__component_name__/) {
                my $comp_name = $module_filename;
                   $comp_name =~ s/\.pm$//;
                   
                $line =~ s/__component_name__/$comp_name/;
            }
            
            if ($line =~ /__delete_key_field__/) {
                $line =~ s/__delete_key_field__/$pk_med_table/g;
            }
            
            $module_content .= $line;
        }
        
        close(MYFILE);        
        
        my $file_name = $this->save_Module_File_Option($module_content, $module_filename);
        
        $this->{arg}->{mod_name_remove} = $file_name;
    }    
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

sub save_Module_File_Option {
    my $this = shift @_;
    
    my $file_content = shift @_;
    my $file_name = shift @_;

    my $path_file_name = $this->{app_path_module} . $file_name;
    
    my $write_file = 1;
    my $decide = 0;
    
    my $file_name_new = undef;
    
    if (-e $path_file_name && !$this->{arg}->{overwrite_all_module}) {
        $decide = 1;
    }
    
    print "\n\n";
    print "### Generate module file.\n\n";
    
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
                $this->{arg}->{overwrite_all_module} = 1;
            }
            
        } elsif ($choice eq "n") {
            
            print "New file name or just press enter to skip: "; 
            
            $file_name_new = <STDIN>;
            
            $file_name_new =~ s/\n//;
            $file_name_new =~ s/\r//;
            
            print "\n";
            
            if ($file_name_new ne "") {
                $path_file_name = $this->{app_path_module} . $file_name_new;
                
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
    
    print "\n";
    
    if ($write_file) {
        #print "File Content:\n$file_content";
        print "Save module file > $path_file_name\n\n"; 
        
        if ($file_name_new ne "") {
            my $pkg_def_old ="package $file_name";
            my $pkg_def_new = "package $file_name_new";
            
            $pkg_def_old =~ s/\.pm$//;
            $pkg_def_new =~ s/\.pm$//;

            $file_content =~ s/^$pkg_def_old/$pkg_def_new/;
        }
        
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
        print "No module file has been saved.\n\n";
    }
    
    if ($file_name_new ne "") {
        return $file_name_new;

    } else {
        return $file_name;
    }    
}

### used to avoid name parts recur. 
sub refine_Module_File_Name {
    my $this = shift @_;
    
    my $file_name = shift @_;
    
    my %dict_parts = ();
    my @name_parts = split(/_/, $file_name);
    
    $file_name = "";
    
    foreach my $part (@name_parts) {
        if (!$dict_parts{$part}) {
            $dict_parts{$part} = 1;
            
            $file_name .= $part . "_";   
        }
    }
    
    $file_name =~ s/_$//;
    
    return $file_name;
}

1;