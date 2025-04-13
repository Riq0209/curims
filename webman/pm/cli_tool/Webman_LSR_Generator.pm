package Webman_LSR_Generator;

use Cwd;

sub new {
    my $class = shift @_;
    
    my $init_ref = shift @_;
    my $dbu = shift @_;
    my $arg = shift @_;
    my $field_name_exclude = shift @_;
    
    my $this = {};
    
    $this->{wmct} = $init_ref->{wmct};
    $this->{app_name} = $init_ref->{app_name};
    $this->{table_name} = $init_ref->{table_name};
    
    ### dbts stand for database table structure (array ref. of hash ref.)
    $this->{dbts} = $init_ref->{dbts}; 
    
    $this->{dbt_schema} = $init_ref->{dbt_schema};
    $this->{dbt_med_schema} = $init_ref->{dbt_med_schema};
    $this->{dbt_med_schema_act} = $init_ref->{dbt_med_schema_act};
    
    $this->{dbu} = $dbu;
    $this->{arg} = $arg;
    
    $this->{field_name_exclude} = $field_name_exclude;
    
    $this->{app_path} = $this->{wmct}->{"dir_web_cgi"} . "/$this->{app_name}/";
    
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
    
    my $primary_key = undef;
    my $primary_key_extra = undef;
    my $unique_key = undef;
    my @view_fields = ();
    
    print "\n### Process DBTS for table $this->{table_name} to generate LSR\n\n";
    
    foreach my $item (@{$dbts}) {
        print "$item->{field_name} - $item->{field_type} - $item->{field_length} - $item->{can_null} - $item->{key} - $item->{default_value} - $item->{is_auto_increment}\n";
        
        if ($item->{key} eq "PRI") {
            if ($primary_key eq "") {
                $primary_key = $item->{field_name};
                
            } else {
                $primary_key_extra .= "$item->{field_name} ";
            }
        }
        
        if ($item->{key} eq "UNI") {
            $unique_key .= "$item->{field_name} ";
        }
        
        if ($item->{field_name} =~ /^id_/) {
        
        } else {
            push(@view_fields, $item);
        }
    }
    
    $primary_key_extra =~ s/ $//;
    
    $this->{primary_key} = $primary_key;
    $this->{primary_key_extra} = $primary_key_extra;
    $this->{unique_key} = $unique_key;
    $this->{view_fields} = \@view_fields;
    
    $this->{parent_table} = $this->{arg}->{map_table_parent}->{$this->{table_name}};
    $this->{parent_link_id} = $this->{arg}->{map_table_link_id}->{$this->{parent_table}};    
}

sub choose_Link_ID {
    my $this = shift @_;
    
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    
    my $dbu = $this->{dbu};
    
    my $valid = 0;
    my $link_id = undef;
    
    my $codegen_input = $this->{arg}->{codegen_input};
    my $codegen_input_rec = $this->{arg}->{codegen_input_rec};
    
    while (!$valid) {
        $valid = 1;
        
        print "\n\n";
        print "Link ID for code deployment (-1 to skip): ";
        
        if ($codegen_input->[0]->{current_idx} > 0) {
            print $codegen_input->[$codegen_input->[0]->{current_idx}] . "\n";

            $link_id = $codegen_input->[$codegen_input->[0]->{current_idx}];
            $codegen_input->[0]->{current_idx}++;   
            
        } else {
            $link_id = <STDIN>;
            $link_id =~ s/\n//;
            $link_id =~ s/\r//;
        }
        
        if ($link_id == -1) {
            push(@{$codegen_input_rec}, "### Link ID for code deployment (-1 to skip):");
            push(@{$codegen_input_rec}, $link_id);
            return 0;
            
        } else {
            push(@{$codegen_input_rec}, "### Link ID for code deployment (-1 to skip):");
            push(@{$codegen_input_rec}, $link_id);
        }

        $dbu->set_Table("webman_" . $this->{app_name} . "_link_structure");

        if (!$dbu->find_Item("link_id", $link_id)) {
            print "Can't proceed since the link_id '$link_id' is not exist!!!\n";
            $valid = 0;
            #exit 1;
        }

        $dbu->set_Table("webman_" . $this->{app_name} . "_link_reference");

        if ($dbu->find_Item("link_id", $link_id)) {

            if ($dbu->find_Item("link_id dynamic_content_name ref_type ref_name", "$link_id content_main DYNAMIC_MODULE webman_component_selector")) {
                print "\n";
                print "Warning!!! link_id '$link_id' already has a reference to 'webman_component_selector' module!!!\n";
                print "\n";
                
                my $proceed = 0;
                
                if ($codegen_input->[0]->{current_idx} > 0) {
                    print "Proceed? [y/n]: ";
                    print $codegen_input->[$codegen_input->[0]->{current_idx}] . "\n";

                    $proceed = $codegen_input->[$codegen_input->[0]->{current_idx}];
                    $codegen_input->[0]->{current_idx}++;
                }

                while ($proceed ne "y" && $proceed ne "n") {
                    print "Proceed? [y/n]: ";
                    
                    $proceed = <STDIN>;
                    $proceed =~ s/\n//;
                    $proceed =~ s/\n//;
                }
                
                push(@{$codegen_input_rec}, "### Warning!!! link_id '$link_id' already has a reference to 'webman_component_selector' module!!!");
                push(@{$codegen_input_rec}, "### Proceed? [y/n]:");
                push(@{$codegen_input_rec}, $proceed);

                if ($proceed eq "y") {
                    $valid = 2;
                    
                } else {
                    $valid = 0;
                }
                
            } else {
                print "\n";
                print "Warning!!! link_id '$link_id' already has a reference that not refer to 'webman_component_selector' module!!!\n";
                print "\n";
                
                my $proceed = 0;
                
                ### text based input
                if ($codegen_input->[0]->{current_idx} > 0) {
                    print "Proceed? [y/n]: ";
                    print $codegen_input->[$codegen_input->[0]->{current_idx}] . "\n";

                    $proceed = $codegen_input->[$codegen_input->[0]->{current_idx}];
                    $codegen_input->[0]->{current_idx}++;
                }

                while ($proceed ne "y" && $proceed ne "n") {
                    print "Proceed? [y/n]: ";
                    
                    $proceed = <STDIN>;
                    $proceed =~ s/\n//;
                    $proceed =~ s/\n//;
                }
                
                push(@{$codegen_input_rec}, "### Warning!!! link_id '$link_id' already has a reference that not refer to 'webman_component_selector' module!!!");
                push(@{$codegen_input_rec}, "### Proceed? [y/n]:");
                push(@{$codegen_input_rec}, $proceed);

                if ($proceed eq "y") {
                    $valid = 1;
                    
                } else {
                    $valid = 0;
                }
            }
        }
    }
    
    my $link_ref_id = undef;
    
    $dbu->set_Table("webman_" . $this->{app_name} . "_link_reference");
    
    if ($valid == 1) {
        $link_ref_id = $dbu->get_Unique_Random_Num("link_ref_id", "10000", "19999");
        
    } elsif ($valid == 2) {
        if ($dbu->count_Item("link_id ref_name", "$link_id webman_component_selector") > 1) {
            my @ahr = $dbu->get_Items("link_ref_id dynamic_content_name", "link_id ref_name", "$link_id webman_component_selector");
            
            print "\n";
            print "The link_id '$link_id' has more than 1 references to 'webman_component_selector' module!!!\n\n";
            
            my %map_refid_dcname = ();
            
            print "Ref. ID -> Dynamic Content Name\n";
            foreach my $item (@ahr) {
                print "$item->{link_ref_id} ->  $item->{dynamic_content_name}\n";
                
                $map_refid_dcname{$item->{link_ref_id}} = $item->{dynamic_content_name};
            }
            
            print "\n";
            
            ### text based input
            if ($codegen_input->[0]->{current_idx} > 0) {
                print "Ref. ID to be used: ";
                print $codegen_input->[$codegen_input->[0]->{current_idx}] . "\n";

                $link_ref_id = $codegen_input->[$codegen_input->[0]->{current_idx}];
                $codegen_input->[0]->{current_idx}++;
            }            
            
            while ($map_refid_dcname{$link_ref_id} eq "") {
                print "Ref. ID to be used: ";
                
                $link_ref_id = <STDIN>;
                $link_ref_id =~ s/\n//;
                $link_ref_id =~ s/\r//;
            }
            
            push(@{$codegen_input_rec}, "### The link_id '$link_id' has more than 1 references to 'webman_component_selector' module!!!");
            push(@{$codegen_input_rec}, "### Ref. ID to be used:");
            push(@{$codegen_input_rec}, $link_ref_id);
            
            
        } else {
            $link_ref_id = $dbu->get_Item("link_ref_id", "link_id ref_name", "$link_id webman_component_selector");
        }
    }
    
    $this->{link_id} = $link_id;
    $this->{link_ref_id} = $link_ref_id;
    
    $this->{arg}->{map_table_link_id}->{$this->{table_name}} = $link_id;
    
    return 1;
}

sub add_Link_Reference {
    my $this = shift @_;
       
    my $dynamic_content_name = shift @_; ### dynamic_content_name => content_main
    my $ref_name = shift @_; ### ref_name => $this->{table_name} . "_list"

    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)    
    
    my $dbu = $this->{dbu};
    
    my $link_id = $this->{link_id};
    my $link_ref_id = $this->{link_ref_id};
    
    $dbu->set_Table("webman_" . $this->{app_name} . "_link_reference");
    
    ### the $link_ref_id might be from the existing one
    if (!$dbu->find_Item("link_ref_id", "$link_ref_id")) {
    
        print "Use new link ref. ID = $link_ref_id\n";

        ### construct $dbu string key and value for link_reference table ##########
        my $str_key = undef;
        my $str_val = undef;

        ### lrf stand for link_reference_field ###
        my %lrf = (link_ref_id => $link_ref_id, link_id => $link_id, dynamic_content_num => -2, 
                   dynamic_content_name => $dynamic_content_name, ref_type => DYNAMIC_MODULE, ref_name => $ref_name, 
                   blob_id => -1);

        foreach my $key (keys(%lrf)) {
            $str_key .= "$key ";

            my $val = $lrf{$key};
               $val =~ s/ /\\\\ /g;

            $str_val .= "$val ";
        }

        $str_key =~ s/ $//;
        $str_val =~ s/ $//;

        #print "\$str_key = -$str_key-\n";
        #print "\$str_val = -$str_val-\n";

        $dbu->set_Table("webman_" . $this->{app_name} . "_link_reference");
        $dbu->insert_Row($str_key, $str_val);

        #print "SQL = " . $dbu->get_SQL . "\n";
        
    } else {
        #print "Use existing link ref. ID = $link_ref_id\n";
    }
    
    #my $stuck = <STDIN>;
}

sub add_Dyna_Mod_Selector {
    my $this = shift @_;
       
    my $dbi_handling_opt = shift @_;
    my $dbi_txt2db_opt = shift @_;
    
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbu = $this->{dbu};
    
    my $link_id = $this->{link_id};
    my $link_ref_id = $this->{link_ref_id};
    
    my $table_name_struct = $this->get_Table_Name_Struct;
    
    if ($this->{arg}->{test_mode}) {
        $table_name_struct = "test_" . $table_name_struct;
    }
    
    ###########################################################################
    
    my $mod_name_list = $table_name_struct . "_list";
    
    if (defined($this->{arg}->{mod_name_list})) { 
        $mod_name_list = $this->{arg}->{mod_name_list};
        $mod_name_list =~ s/\.pm$//;
    }    
    
    my $mod_name_search = $table_name_struct . "_search";
    
    if (defined($this->{arg}->{mod_name_search})) { 
        $mod_name_search = $this->{arg}->{mod_name_search};
        $mod_name_search =~ s/\.pm$//;
    }
    
    my $mod_name_insert = $table_name_struct . "_insert";
    
    if (defined($this->{arg}->{mod_name_insert})) { 
        $mod_name_insert = $this->{arg}->{mod_name_insert};
        $mod_name_insert =~ s/\.pm$//;
    }
    
    my $mod_name_insert_txt = $table_name_struct . "text2db_insert";
    
    if (defined($this->{arg}->{mod_name_insert_txt})) { 
        $mod_name_insert_txt = $this->{arg}->{mod_name_insert_txt};
        $mod_name_insert_txt =~ s/\.pm$//;
    }    
    
    my $mod_name_update = $table_name_struct . "_update";
    
    if (defined($this->{arg}->{mod_name_update})) { 
        $mod_name_update = $this->{arg}->{mod_name_update};
        $mod_name_update =~ s/\.pm$//;
    }
    
    my $mod_name_update_txt = $table_name_struct . "text2db_update";
    
    if (defined($this->{arg}->{mod_name_update_txt})) { 
        $mod_name_update_txt = $this->{arg}->{mod_name_update_txt};
        $mod_name_update_txt =~ s/\.pm$//;
    }    
    
    my $mod_name_delete = $table_name_struct . "_delete";
    
    if (defined($this->{arg}->{mod_name_delete})) { 
        $mod_name_delete = $this->{arg}->{mod_name_delete};
        $mod_name_delete =~ s/\.pm$//;
    }
    
    my $mod_name_delete_txt = $table_name_struct . "text2db_delete";
    
    if (defined($this->{arg}->{mod_name_delete_txt})) { 
        $mod_name_delete_txt = $this->{arg}->{mod_name_delete_txt};
        $mod_name_delete_txt =~ s/\.pm$//;
    }
    
    my $mod_name_add = $table_name_struct . "_add";
    
    if (defined($this->{arg}->{mod_name_add})) { 
        $mod_name_add = $this->{arg}->{mod_name_add};
        $mod_name_add =~ s/\.pm$//;
    }
    
    my $mod_name_remove = $table_name_struct . "_remove";
    
    if (defined($this->{arg}->{mod_name_remove})) { 
        $mod_name_remove = $this->{arg}->{mod_name_remove};
        $mod_name_remove =~ s/\.pm$//;
    }    
    
    ### dmsr stand for dynamic_module_selector_row ###
    my @dmsr = ({cgi_value => undef, dyna_mod_name => $mod_name_list}, 
                {cgi_value => $mod_name_insert, dyna_mod_name => $mod_name_insert}, 
                {cgi_value => $mod_name_update, dyna_mod_name => $mod_name_update}, 
                {cgi_value => $mod_name_delete, dyna_mod_name => $mod_name_delete},
                {cgi_value => $mod_name_add, dyna_mod_name => $mod_name_add},
                {cgi_value => $mod_name_remove, dyna_mod_name => $mod_name_remove},
                {cgi_value => undef, dyna_mod_name => $mod_name_search},
                {cgi_value => $mod_name_update, dyna_mod_name => $mod_name_update},
                {cgi_value => $mod_name_delete, dyna_mod_name => $mod_name_delete},
                {cgi_value => undef, dyna_mod_name => $mod_name_insert},
                {cgi_value => $mod_name_insert_txt, dyna_mod_name => $mod_name_insert_txt}, 
                {cgi_value => $mod_name_update_txt, dyna_mod_name => $mod_name_update_txt},
                {cgi_value => $mod_name_delete_txt, dyna_mod_name => $mod_name_delete_txt},
                {cgi_value => $table_name_struct . "_text2db_updatedelete", dyna_mod_name => $mod_name_update_txt},
                {cgi_value => $table_name_struct . "_text2db_updatedelete", dyna_mod_name => $mod_name_delete_txt});
                
    my %active_idx = (0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0, 9 => 0, 
                      10 => 0, 11 => 0, 12 => 0, 13 => 0, 14 => 0);
    
    if ($dbi_handling_opt < 4) {
        $active_idx{0} = 1;
        
        #print "\$this->{parent_table} = $this->{parent_table}\n";
        #print "\$this->{parent_link_id} = $this->{parent_link_id}\n";
        #print "\$this->{link_id} = $this->{link_id}\n";
        #my $stuck = <STDIN>;
        
        ### need to set the value of 'task' CGI variable if current list 
        ### component has a parent list component and both are deployed on 
        ### the same link        
        if ($this->{link_id} == $this->{parent_link_id}) {
            $dmsr[0]->{cgi_value} = $mod_name_list;
            
            if (!defined($this->{arg}->{mod_name_list})) {
                $this->{arg}->{mod_name_list} = $mod_name_list;
            }
        }
    }
    
    if ($dbi_handling_opt == 2) {
        $active_idx{1} = 1;
        $active_idx{2} = 1;
        $active_idx{3} = 1;
        
        if ($dbi_txt2db_opt) {
            $active_idx{10} = 1;
            $active_idx{11} = 1;
            $active_idx{12} = 1;
        }        
        
    } elsif ($dbi_handling_opt == 3) {
        $active_idx{4} = 1;
        $active_idx{5} = 1;
        
    } elsif ($dbi_handling_opt == 4) {
        $active_idx{9} = 1;
        
        if ($dbi_txt2db_opt) {
            $active_idx{10} = 1;
        }
        
    } elsif ($dbi_handling_opt == 5) {
        $active_idx{6} = 1;
        $active_idx{7} = 1;
        
        if ($dbi_txt2db_opt) {
            $active_idx{13} = 1;
        }        
        
    } elsif ($dbi_handling_opt == 6) {
        $active_idx{6} = 1;
        $active_idx{8} = 1;
        
        if ($dbi_txt2db_opt) {
            $active_idx{14} = 1;
        }        
        
    } elsif ($dbi_handling_opt == 7) {
        $active_idx{6} = 1;
        
    } elsif ($dbi_handling_opt == 8) {
        $active_idx{6} = 1;
        $active_idx{7} = 1;
        $active_idx{8} = 1;
    }
    
    my $index = 0;
    
    foreach my $item (@dmsr) {
        if ($active_idx{$index}) {
            my $keys   = "link_ref_id cgi_param cgi_value dyna_mod_name";
            my $values = "$this->{link_ref_id} task $item->{cgi_value} $item->{dyna_mod_name}";
            $dbu->set_Table("webman_" . $this->{app_name} . "_dyna_mod_selector");
            
            if (!$dbu->find_Item($keys, $values)) {
                $dbu->insert_Row($keys, $values);
                print "SQL = " . $dbu->get_SQL . "\n";
                
            } else {
                print "Duplicate entry of task & dynamic module selection logic: ";
                print "$this->{link_ref_id} - task - $item->{cgi_value} - $item->{dyna_mod_name}\n";
            }
        }
        
        $index++;
    }
}

sub set_Key_Ref_ID {
    my $this = shift @_;
    
    $this->{set_link_ref_id} = shift @_;
    $this->{set_scdmr_id} = shift @_;
    $this->{set_dyna_mod_selector_id} = shift @_;
    
    my $dbu = $this->{dbu};
    
    my $table_name_struct = $this->get_Table_Name_Struct;
    
    if ($this->{arg}->{test_mode}) {
        $table_name_struct = "test_" . $table_name_struct;
    }    
    
    if ($this->{set_link_ref_id} eq "") {
        $this->{set_link_ref_id} = $this->{link_ref_id};
        
    } elsif ($this->{set_scdmr_id} eq "") {
        ### not implemented yet
        
    } elsif ($this->{set_dyna_mod_selector_id} eq "") {        
        $dbu->set_Table("webman_" . $this->{app_name} . "_dyna_mod_selector");
        
        my $mod_name_search = $table_name_struct . "_search";
        
        if (defined($this->{arg}->{mod_name_search})) { 
            $mod_name_search = $this->{arg}->{mod_name_search};
            $mod_name_search =~ s/\.pm$//;
        }        
        
        $this->{dms_id_search} = $dbu->get_Item("dyna_mod_selector_id", 
                                                "link_ref_id dyna_mod_name", 
                                                "$this->{link_ref_id} " . $mod_name_search);
                                                
        #print "sub set_Key_Ref_ID: SQL = " . $dbu->get_SQL . "\n\n";
        
        
        my $mod_name_list = $table_name_struct . "_list";
        
        if (defined($this->{arg}->{mod_name_list})) { 
            $mod_name_list = $this->{arg}->{mod_name_list};
            $mod_name_list =~ s/\.pm$//;
        }        
        
        $this->{dms_id_list} = $dbu->get_Item("dyna_mod_selector_id", 
                                              "link_ref_id dyna_mod_name", 
                                              "$this->{link_ref_id} " . $mod_name_list);
                                               
        #print "sub set_Key_Ref_ID: SQL = " . $dbu->get_SQL . "\n\n";
        
        
        my $mod_name_insert = $table_name_struct . "_insert";
        
        if (defined($this->{arg}->{mod_name_insert})) { 
            $mod_name_insert = $this->{arg}->{mod_name_insert};
            $mod_name_insert =~ s/\.pm$//;
        }        
        
        $this->{dms_id_insert} = $dbu->get_Item("dyna_mod_selector_id", 
                                                "link_ref_id dyna_mod_name", 
                                                "$this->{link_ref_id} " . $mod_name_insert);
                                                
        #print "sub set_Key_Ref_ID: SQL = " . $dbu->get_SQL . "\n\n";                                                
                                                
        my $mod_name_insert_txt = $table_name_struct . "_insert_txt";
        
        if (defined($this->{arg}->{mod_name_insert_txt})) { 
            $mod_name_insert_txt = $this->{arg}->{mod_name_insert_txt};
            $mod_name_insert_txt =~ s/\.pm$//;
        }
        
        $this->{dms_id_insert_txt} = $dbu->get_Item("dyna_mod_selector_id", 
                                                    "link_ref_id dyna_mod_name", 
                                                    "$this->{link_ref_id} " . $mod_name_insert_txt);        
                                                                  
        #print "sub set_Key_Ref_ID: SQL = " . $dbu->get_SQL . "\n\n";
        
        
        my $mod_name_update = $table_name_struct . "_update";
        
        if (defined($this->{arg}->{mod_name_update})) { 
            $mod_name_update = $this->{arg}->{mod_name_update};
            $mod_name_update =~ s/\.pm$//;
        }        
        
        $this->{dms_id_update} = $dbu->get_Item("dyna_mod_selector_id", 
                                                "link_ref_id dyna_mod_name", 
                                                "$this->{link_ref_id} " . $mod_name_update);
                                                
        #print "sub set_Key_Ref_ID: SQL = " . $dbu->get_SQL . "\n\n";     
        
                                                
        my $mod_name_update_txt = $table_name_struct . "_update_txt";
        
        if (defined($this->{arg}->{mod_name_update_txt})) { 
            $mod_name_update_txt = $this->{arg}->{mod_name_update_txt};
            $mod_name_update_txt =~ s/\.pm$//;
        }
        
        $this->{dms_id_update_txt} = $dbu->get_Item("dyna_mod_selector_id", 
                                                    "link_ref_id dyna_mod_name", 
                                                    "$this->{link_ref_id} " . $mod_name_update_txt);                                                        
                                                
        #print "sub set_Key_Ref_ID: SQL = " . $dbu->get_SQL . "\n\n";
        
        
        my $mod_name_delete = $table_name_struct . "_delete";
        
        if (defined($this->{arg}->{mod_name_delete})) { 
            $mod_name_delete = $this->{arg}->{mod_name_delete};
            $mod_name_delete =~ s/\.pm$//;
        }
        
        $this->{dms_id_delete} = $dbu->get_Item("dyna_mod_selector_id", 
                                                "link_ref_id dyna_mod_name", 
                                                "$this->{link_ref_id} " . $mod_name_delete);
                                                
        #print "sub set_Key_Ref_ID: SQL = " . $dbu->get_SQL . "\n\n";     
        
                                                
        my $mod_name_delete_txt = $table_name_struct . "_delete_txt";
        
        if (defined($this->{arg}->{mod_name_delete_txt})) { 
            $mod_name_delete_txt = $this->{arg}->{mod_name_delete_txt};
            $mod_name_delete_txt =~ s/\.pm$//;
        }
        
        $this->{dms_id_delete_txt} = $dbu->get_Item("dyna_mod_selector_id", 
                                                    "link_ref_id dyna_mod_name", 
                                                    "$this->{link_ref_id} " . $mod_name_delete_txt);                                                
                                                
        #print "sub set_Key_Ref_ID: SQL = " . $dbu->get_SQL . "\n\n"; 
        
        
        my $mod_name_add = $table_name_struct . "_add";
        
        if (defined($this->{arg}->{mod_name_add})) { 
            $mod_name_add = $this->{arg}->{mod_name_add};
            $mod_name_add =~ s/\.pm$//;
        }
        
        $this->{dms_id_add} = $dbu->get_Item("dyna_mod_selector_id", 
                                             "link_ref_id dyna_mod_name", 
                                             "$this->{link_ref_id} " . $mod_name_add);
        
        #print "sub set_Key_Ref_ID: SQL = " . $dbu->get_SQL . "\n\n"; 
        
        
        my $mod_name_remove = $table_name_struct . "_remove";
        
        if (defined($this->{arg}->{mod_name_remove})) { 
            $mod_name_remove = $this->{arg}->{mod_name_remove};
            $mod_name_remove =~ s/\.pm$//;
        }
        
        $this->{dms_id_remove} = $dbu->get_Item("dyna_mod_selector_id", 
                                                "link_ref_id dyna_mod_name", 
                                                "$this->{link_ref_id} " . $mod_name_remove);
                                                
        #print "sub set_Key_Ref_ID: SQL = " . $dbu->get_SQL . "\n\n";        
    }
}

sub regenerate_Parent_DBIVD_Template {
    my $this = shift @_;
    my $map_table_list_template = shift @_;
    
    #$this->{wmct}->debug(__FILE__, __LINE__, 
    #                     "\$this->{arg}->{table_name} = $this->{arg}->{table_name}\n" .
    #                     "\$this->{parent_table} = $this->{parent_table}\n");
    
    if ($this->{parent_table} ne "") {
        my $parent_dbivd_tmplt = $map_table_list_template->{$this->{parent_table}};
        
        if ($this->{arg}->{test_mode}) {
            $parent_dbivd_tmplt =~ s/^template_/template_test_/;
        }        
        
        my $ptrn_rplc = "__link_id_" . $this->{table_name} . "__";
        my $text_rplc = $this->{link_id};
        
        if ($this->{link_id} == $this->{parent_link_id}) {
            my $task = $this->{arg}->{mod_name_list};
               $task =~ s/\.pm$//;
               
            $text_rplc .= "&task=$task";
            
        } else {
            $text_rplc .= "&task=";        
        }
        
        print "\n";
        print "Regenerate Parent Template: $parent_dbivd_tmplt \n";- 
        print "Replace the tag $ptrn_rplc -> $text_rplc\n";
    
        print "Press enter to continue... ";
        my $stuck = <STDIN>;
        
        if (open(MYFILE, $this->{app_path} . $parent_dbivd_tmplt)) {
            my $template_content = undef;
            
            my @file_content = <MYFILE>;
                
            foreach my $line (@file_content) {
                $line =~ s/$ptrn_rplc/$text_rplc/;
                $template_content .= $line;
            }
            
            close(MYFILE);
            
            $this->save_Template_File_Option($template_content, $this->{app_path} . $parent_dbivd_tmplt);
        }
         
    }
}

sub generate_DB_Item_Search {
    my $this = shift @_;
    my $key_field = shift @_;
    
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    
    my $table_name_struct = $this->get_Table_Name_Struct;
  
    ### For search item the code generator will by default generate two types
    ### of view template which are single row result template & multi row 
    ### result template. Since the multi row result template is the second one
    ### generated so $this->{arg}->{tmplt_name_view} will have this  multi row 
    ### result template as its last value assignment.
    my $template_default_found_list = $this->{arg}->{tmplt_name_view};
    
    my $template_default_found = $template_default_found_list;
    
    ### there are 3 possible sub types of multi 
    ### row result (list, LFU, LFD, and LFUD)
    $template_default_found =~ s/_list\.html$/\.html/;
    $template_default_found =~ s/_LFU\.html$/\.html/;
    $template_default_found =~ s/_LFD\.html$/\.html/;
    $template_default_found =~ s/_LFUD\.html$/\.html/;
    
    ###########################################################################
    
    if ($this->{arg}->{test_mode}) {
        $template_default_found =~ s/^template_/template_test_/;
    }    
    
    ### dmpr stand for dynamic_module_paramater_row ###
    my @dmpr = ({table_name => $this->{table_name}},
                {template_default_found => $template_default_found},
                {template_default_found_list => $template_default_found_list},
                {key_field_search => $key_field},
                {key_field_primary => $this->{primary_key}});
                
    if ($this->{arg}->{dbi_handling_opt} == 5) {
        my $task = $this->{arg}->{"mod_name_update"};
           $task =~ s/\.pm$//;
           
        push(@dmpr, {item_found_url_redirect => "./index.cgi?link_id=\$cgi_link_id_&task=$task"});
        
    } elsif ($this->{arg}->{dbi_handling_opt} == 6) {
        my $task = $this->{arg}->{"mod_name_delete"};
           $task =~ s/\.pm$//;
           
        push(@dmpr, {item_found_url_redirect => "./index.cgi?link_id=\$cgi_link_id_&task=$task"});
    }
    
    print "\n### Set up DB_Item_Search key-value pairs:\n";
    
    $this->add_Dyna_Mod_Param(\@dmpr, $this->{dms_id_search});
}

sub generate_DB_Item_List_Dynamic {
    my $this = shift @_;
    
    my $link_ref_id = $this->{set_link_ref_id};
    my $scdmr_id = $this->{set_scdmr_id};
    my $dyna_mod_selector_id = $this->{set_dyna_mod_selector_id};
    
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    my $dbt_med_schema = $this->{dbt_med_schema};
    my $dbt_med_schema_act = $this->{dbt_med_schema_act};
    
    my $dbu = $this->{dbu};
    
    my $table_info = $this->{arg}->{table_info};
    
    ### construct $dbu string key and value for dyna_mod_param table ##########
    $str_key = "";
    $str_val = "";
    
    my $order_field_caption = undef;
    my $order_field_name = undef;
    my $map_caption_field = undef;
    
    foreach my $item (@{$dbts}) {
        if (!($item->{field_name} =~ /^id_/) && !$this->{field_name_exclude}->{$item->{field_name}}) { 
            my $caption = $item->{field_name};
               $caption =~ s/_/ /g;
               $caption =~ s/(\w+)/\u\L$1/g;
               
            $order_field_caption .= "$caption:";
            $order_field_name .= "$item->{field_name}:";
            
            $map_caption_field .= "$caption => $item->{field_name}, ";
        }
    }
    
    $order_field_caption =~ s/:$//;
    $order_field_name =~ s/:$//;
    $map_caption_field =~ s/, $//;
    
    ### dmpr stand for dynamic_module_paramater_row ###
    my @dmpr = ({order_field_cgi_var => "order_" . $this->{table_name}}, 
                {order_field_caption => $order_field_caption}, {order_field_name => $order_field_name},
                {map_caption_field => $map_caption_field}, 
                {db_items_set_number_var => "dbisn_" . $this->{table_name}}, 
                {dynamic_menu_items_set_number_var => "dmisn_" . $this->{table_name}}, 
                {inl_var_name => "inl_" . $this->{table_name}}, 
                {lsn_var_name => "lsn_" . $this->{table_name}});
                
    my $mtp = $this->{arg}->{map_table_parent};
    
    my $parent_table = $mtp->{$this->{table_name}};
    
    #$this->{wmct}->debug(__FILE__, __LINE__, "\$parent_table = $parent_table  \$this->{table_name} = $this->{table_name}\n");  
    
    if ($parent_table eq "") {
        push(@dmpr, {table_name => $this->{table_name}});
        
    } else {
        ### can be direct bound key from parent to viewed table
        ### or bound key from mediator table to viewed table 
        my $bound_key = undef; 
        
        ### bound key from parent table to mediator table
        my $bound_key_p2mediator = undef; 
        
        my $table_name_mediator = undef;
        
        foreach my $tbl_rel (@{$dbt_schema->{$parent_table}}) {
            #$this->{wmct}->debug(__FILE__, __LINE__, "\$tbl_rel->{bound_name} = $tbl_rel->{bound_name}\n");
            
            if ($tbl_rel->{bound_name} eq $this->{table_name}) {
                $bound_key = $tbl_rel->{bound_key};
            }
            
            #print "Compare: $tbl_rel->{bound_name} | $table_info->{via_mediator}\n";
            #my $stuck = <STDIN>;
            
            ### check if tables are interconnected via mediator table
            if ($tbl_rel->{bound_name} eq $table_info->{via_mediator}) {                
                $bound_key_p2mediator = $tbl_rel->{bound_key};
                $table_name_mediator = $table_info->{via_mediator};               
                
                ### trace the bound key between mediator and the current viewed table name 
                foreach my $item_med (@{$dbt_med_schema->{$table_name_mediator}}) {
                
                    #print "\$item_med->{bound_name} = $item_med->{bound_name} | $this->{table_name} [" . __FILE__ . " : " . __LINE__ . "]\n";
                    #my $stuck = <STDIN>;
                        
                    if ($item_med->{bound_name} eq $this->{table_name}) {
                        $bound_key = $item_med->{bound_key};                        
                    }
                }
            }

            #print "$parent_table > $tbl_rel->{bound_key} >  $tbl_rel->{bound_name} |  $this->{table_name}: [" . __FILE__ . " : " . __LINE__ . "]\n";
            #print "via_mediator = " . $table_info->{via_mediator} . "\n";
            #my $stuck = <STDIN>;
            
            ### check if tables are interconnected via acting mediator table
            if ($dbt_med_schema_act->{$tbl_rel->{bound_name}} ne "") {
                foreach my $item_med (@{$dbt_med_schema_act->{$tbl_rel->{bound_name}}}) {
                    if ($item_med->{bound_name} eq $this->{table_name}) {
                        #$this->{wmct}->debug(__FILE__, __LINE__, 
                        #                     "\$dbt_med_schema_act->{$tbl_rel->{bound_name}} = $dbt_med_schema_act->{$tbl_rel->{bound_name}}\n");
                        
                        $bound_key_p2mediator = $tbl_rel->{bound_key};
                        $table_name_mediator = $tbl_rel->{bound_name};                         
                        $bound_key = $item_med->{bound_key};
                    
                    }
                }
            }
        } 
        
        my $sql = undef;
        
        if (!defined($bound_key_p2mediator)) {
            $sql = "select * from $this->{table_name} where $bound_key='\$cgi_" . $bound_key . "_' order by \$cgi_order_" . $this->{table_name} . "_";
        
        } else {
            ### t_med.* below is useful for Add From List (AFL) related 
            ### operation (remove is made and refer to mediator table and 
            ### its primary key)
            $sql = "select t_view.*, t_med.* from $this->{table_name} t_view, $table_name_mediator t_med where t_med.$bound_key_p2mediator ='\$cgi_" . $bound_key_p2mediator . "_' and t_med.$bound_key = t_view.$bound_key order by \$cgi_order_" . $this->{table_name} . "_";
        }
        
        #print "SQL = $sql [" . __FILE__ . " : " . __LINE__ . "]\n";
        #my $stuck = <STDIN>;
        
        push(@dmpr, {sql => $sql});
    }
    
    if ($this->{link_id} == $this->{parent_link_id}) {
        push(@dmpr, {link_path_additional_get_data => "task=&button_submit="});
    }     
    
    print "\n### Set up DB_Item_List_Dynamic key-value pairs:\n";  
    
    $this->add_Dyna_Mod_Param(\@dmpr, $this->{dms_id_list});
    
}

sub generate_DB_Item_Insert {
    my $this = shift @_;
    my $key_field = shift @_;

    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $mtt = $this->{arg}->{map_table_type};
    
    my $table_name_struct = $this->get_Table_Name_Struct;
    
    my $check_on_cgi_data = undef;
    my $check_on_fields_duplication = $this->{primary_key_extra} . $this->{unique_key};
    my $template_default_confirm = "template_" . $table_name_struct . "_insert_confirm.html";
    
    if (defined($this->{arg}->{tmplt_name_insert_confirm})) { 
        $template_default_confirm = $this->{arg}->{tmplt_name_insert_confirm};
    }    
    
    if ($this->{arg}->{test_mode}) {
        $template_default_confirm =~ s/^template_/template_test_/;
    }
    
    foreach my $item (@{$this->{view_fields}}) {
        if (!$item->{can_null}) {
            $check_on_cgi_data .= "\$db_" . $item->{field_name} . " ";
        }
    }
    
    ### dmpr stand for dynamic_module_paramater_row ###
    my @dmpr = ({table_name => $this->{table_name}}, 
                {check_on_cgi_data => $check_on_cgi_data}, 
                {check_on_fields_duplication => $check_on_fields_duplication}, 
                {template_default_confirm => $template_default_confirm});
                
    if (defined($this->{arg}->{foreign_unique_keys}) && $mtt->{$this->{table_name}} eq "sub") {
        my $fu_keys = $this->{arg}->{foreign_unique_keys};
        
        my $check_on_fields_existence = undef;
        
        foreach my $item (@{$fu_keys}) {
            #print "$item->{field_name} - $item->{field_type} - $item->{table_name}\n";
            
            if ($item->{field_type} ne "PRI") {
                $check_on_fields_existence .= "$item->{field_name} => $item->{table_name}, "
            }
        }
        
        $check_on_fields_existence =~ s/\, $//;
        
        push(@dmpr, {check_on_fields_existence => $check_on_fields_existence});
    }
                
    if (defined($key_field)) {
        $key_field =~ s/ /&/g;
        push(@dmpr, {check_on_fields_duplication => $key_field});
    }                
                
    if (defined($this->{arg}->{mod_name_list}) && 
        $this->{link_id} == $this->{parent_link_id}) {
        
        my $task = $this->{arg}->{mod_name_list};
           $task =~ s/\.pm$//;
           
        push(@dmpr, {last_phase_cgi_data_reset => "task='$task' button_submit"});
        push(@dmpr, {link_path_additional_get_data => "task=&button_submit="});
    }                
    
    print "\n### Set up DB_Item_Insert key-value pairs:\n";
    
    $this->add_Dyna_Mod_Param(\@dmpr, $this->{dms_id_insert});
}

sub generate_DB_Item_Insert_Text2DB {
    my $this = shift @_;
    my $key_field = shift @_;

    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    
    my $field_list = undef;
    my $table_name_struct = $this->get_Table_Name_Struct;
    my $template_default_confirm = "template_" . $table_name_struct . "_insert_txt_confirm.html";
    
    if (defined($this->{arg}->{tmplt_name_insert_txt_confirm})) { 
        $template_default_confirm = $this->{arg}->{tmplt_name_insert_txt_confirm};
    }    
    
    if ($this->{arg}->{test_mode}) {
        $template_default_confirm =~ s/^template_/template_test_/;
    }
    
    foreach my $item (@{$this->{view_fields}}) {
        if (!$this->{field_name_exclude}->{$item->{field_name}}) {
            $field_list .= $item->{field_name} . " ";
        }
    }    
    
    ### dmpr stand for dynamic_module_paramater_row ###
    my @dmpr = ({table_name => $this->{table_name}}, 
                {task => "insert"}, 
                {field_list => $field_list}, 
                {template_default_confirm => $template_default_confirm});
                
    if (defined($key_field)) {
        $key_field =~ s/ /&/g;
        push(@dmpr, {key_field_name => $key_field});
    }
                
    if (defined($this->{arg}->{mod_name_list}) && 
        $this->{link_id} == $this->{parent_link_id}) {
        
        my $task = $this->{arg}->{mod_name_list};
           $task =~ s/\.pm$//;
           
        push(@dmpr, {last_phase_cgi_data_reset => "task='$task' button_submit"});
        push(@dmpr, {link_path_additional_get_data => "task=&button_submit="});
    }                
    
    print "\n### Set up DB_Item_Insert_Text2DB key-value pairs:\n";
        
    $this->add_Dyna_Mod_Param(\@dmpr, $this->{dms_id_insert_txt});
}

sub generate_DB_Item_Update {
    my $this = shift @_;
    my $key_field = shift @_;

    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $mtt = $this->{arg}->{map_table_type};
    
    my $table_name_struct = $this->get_Table_Name_Struct;
    
    my $check_on_cgi_data = undef;
    my $check_on_fields_duplication = $this->{primary_key_extra} . $this->{unique_key};
    my $template_default_confirm = "template_" . $table_name_struct . "_update_confirm.html";    
    
    if (defined($this->{arg}->{tmplt_name_update_confirm})) { 
        $template_default_confirm = $this->{arg}->{tmplt_name_update_confirm};
    }    
    
    if ($this->{arg}->{test_mode}) {
        $template_default_confirm =~ s/^template_/template_test_/;
    }    
    
    foreach my $item (@{$this->{view_fields}}) {
        if (!$item->{can_null}) {
            $check_on_cgi_data .= "\$db_" . $item->{field_name} . " ";
        }
    }
    
    ### dmpr stand for dynamic_module_paramater_row ###
    my @dmpr = ({table_name => $this->{table_name}}, 
                {check_on_cgi_data => $check_on_cgi_data}, 
                {check_on_fields_duplication => $check_on_fields_duplication}, 
                {template_default_confirm => $template_default_confirm}, 
                {update_keys_str => "$this->{primary_key}='\$cgi_" . $this->{primary_key} . "_'"});                
    
    #if ($this->{arg}->{dbi_handling_opt} == 5) {
    #    push(@dmpr, {last_phase_cgi_data_reset => "task $key_field"});
    #}
    
    if (defined($this->{arg}->{foreign_unique_keys}) && $mtt->{$this->{table_name}} eq "sub") {
        my $fu_keys = $this->{arg}->{foreign_unique_keys};
        
        my $check_on_fields_existence = undef;
        
        foreach my $item (@{$fu_keys}) {
            #print "$item->{field_name} - $item->{field_type} - $item->{table_name}\n";
            
            if ($item->{field_type} ne "PRI") {
                $check_on_fields_existence .= "$item->{field_name} => $item->{table_name}, "
            }
        }
        
        $check_on_fields_existence =~ s/\, $//;
        
        push(@dmpr, {check_on_fields_existence => $check_on_fields_existence});
    }    
    
    if (defined($key_field)) {
        $key_field =~ s/ /&/g;
        push(@dmpr, {check_on_fields_duplication => $key_field});
    }    
    
    if (defined($this->{arg}->{mod_name_list}) && 
        $this->{link_id} == $this->{parent_link_id}) {
        
        my $task = $this->{arg}->{mod_name_list};
           $task =~ s/\.pm$//;
           
        push(@dmpr, {last_phase_cgi_data_reset => "task='$task' button_submit"});
        push(@dmpr, {link_path_additional_get_data => "task=&button_submit="});
    }     
    
    print "\n### Set up DB_Item_Update key-value pairs:\n";
    
    $this->add_Dyna_Mod_Param(\@dmpr, $this->{dms_id_update});
}

sub generate_DB_Item_Update_Text2DB {
    my $this = shift @_;
    my $key_field = shift @_;

    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    
    my $table_name_struct = $this->get_Table_Name_Struct;
    
    my $field_list = undef;
    my $table_name_struct = $this->get_Table_Name_Struct;
    my $template_default_confirm = "template_" . $table_name_struct . "_update_txt_confirm.html";
    
    if (defined($this->{arg}->{tmplt_name_update_txt_confirm})) { 
        $template_default_confirm = $this->{arg}->{tmplt_name_update_txt_confirm};
    }    
    
    if ($this->{arg}->{test_mode}) {
        $template_default_confirm =~ s/^template_/template_test_/;
    }    
    
    foreach my $item (@{$this->{view_fields}}) {
        if (!$this->{field_name_exclude}->{$item->{field_name}}) {
            $field_list .= $item->{field_name} . " ";
        }
    }
    
    ### dmpr stand for dynamic_module_paramater_row ###
    my @dmpr = ({table_name => $this->{table_name}}, 
                {task => "update"}, 
                {field_list => $field_list},
                {template_default_confirm => $template_default_confirm});
                
    if (defined($key_field)) {
        $key_field =~ s/ /&/g;
        push(@dmpr, {key_field_name => $key_field});
    }
                
    if (defined($this->{arg}->{mod_name_list}) && 
        $this->{link_id} == $this->{parent_link_id}) {
        
        my $task = $this->{arg}->{mod_name_list};
           $task =~ s/\.pm$//;
           
        push(@dmpr, {last_phase_cgi_data_reset => "task='$task' button_submit"});
        push(@dmpr, {link_path_additional_get_data => "task=&button_submit="});
    }                
    
    print "\n### Set up DB_Item_Update_Text2DB key-value pairs:\n";
    
    $this->add_Dyna_Mod_Param(\@dmpr, $this->{dms_id_update_txt});
}

sub generate_DB_Item_Delete {
    my $this = shift @_;
    my $key_field = shift @_;

    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    
    my $table_name_struct = $this->get_Table_Name_Struct;

    my $template_default = "template_" . $table_name_struct . "_delete.html";
    
    if (defined($this->{arg}->{tmplt_name_delete_confirm})) { 
        $template_default = $this->{arg}->{tmplt_name_delete_confirm};
    }    
    
    if ($this->{arg}->{test_mode}) {
        $template_default =~ s/^template_/template_test_/;
    }    
    
    ### dmpr stand for dynamic_module_paramater_row ###
    my @dmpr = ({table_name => $this->{table_name}},
                {template_default => $template_default}, 
                {delete_keys_str => "$this->{primary_key}='\$cgi_" . $this->{primary_key} . "_'"});
    
    #if ($this->{arg}->{dbi_handling_opt} == 6) {
    #    push(@dmpr, {last_phase_cgi_data_reset => "task $key_field"});
    #}
    
    if (defined($this->{arg}->{mod_name_list}) && 
        $this->{link_id} == $this->{parent_link_id}) {
        
        my $task = $this->{arg}->{mod_name_list};
           $task =~ s/\.pm$//;
           
        push(@dmpr, {last_phase_cgi_data_reset => "task='$task' button_submit"});
        push(@dmpr, {link_path_additional_get_data => "task=&button_submit="});
    }    
    
    print "\n### Set up DB_Item_Delete key-value pairs:\n";
    
    $this->add_Dyna_Mod_Param(\@dmpr, $this->{dms_id_delete});
}

sub generate_DB_Item_Delete_Text2DB {
    my $this = shift @_;
    my $key_field = shift @_;

    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    
    my $table_name_struct = $this->get_Table_Name_Struct;
    
    my $table_name_struct = $this->get_Table_Name_Struct;
    my $template_default_confirm = "template_" . $table_name_struct . "_delete_txt_confirm.html";
    
    if (defined($this->{arg}->{tmplt_name_delete_txt_confirm})) { 
        $template_default_confirm = $this->{arg}->{tmplt_name_delete_txt_confirm};
    }    
    
    if ($this->{arg}->{test_mode}) {
        $template_default_confirm =~ s/^template_/template_test_/;
    }    
    
    ### dmpr stand for dynamic_module_paramater_row ###
    my @dmpr = ({table_name => $this->{table_name}},
                {task => "delete"},
                {field_list => $key_field},
                {template_default_confirm => $template_default_confirm});
                
    if (defined($key_field)) {
        $key_field =~ s/ /&/g;
        push(@dmpr, {key_field_name => $key_field});
    }                
                
    if (defined($this->{arg}->{mod_name_list}) && 
        $this->{link_id} == $this->{parent_link_id}) {
        
        my $task = $this->{arg}->{mod_name_list};
           $task =~ s/\.pm$//;
           
        push(@dmpr, {last_phase_cgi_data_reset => "task='$task' button_submit"});
        push(@dmpr, {link_path_additional_get_data => "task=&button_submit="});
    }                
    
    print "\n### Set up DB_Item_Delete_Text2DB key-value pairs:\n";
    
    $this->add_Dyna_Mod_Param(\@dmpr, $this->{dms_id_delete_txt});
}

sub generate_DB_Item_Add {
    my $this = shift @_;

    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    
    my $table_name_struct = $this->get_Table_Name_Struct;

    my $template_default = "template_" . $table_name_struct . "_add.html";
    
    my $link_ref_id = $this->{set_link_ref_id};
    my $scdmr_id = $this->{set_scdmr_id};
    my $dyna_mod_selector_id = $this->{set_dyna_mod_selector_id};
    
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    my $dbt_med_schema = $this->{dbt_med_schema};
    my $dbt_med_schema_act = $this->{dbt_med_schema_act};
    
    my $dbu = $this->{dbu};
    
    ### construct $dbu string key and value for dyna_mod_param table ##########
    $str_key = "";
    $str_val = "";
    
    my $order_field_caption = undef;
    my $order_field_name = undef;
    my $map_caption_field = undef;
    
    foreach my $item (@{$dbts}) {
        if (!($item->{field_name} =~ /^id_/) && !$this->{field_name_exclude}->{$item->{field_name}}) { 
            my $caption = $item->{field_name};
               $caption =~ s/_/ /g;
               $caption =~ s/(\w+)/\u\L$1/g;
               
            $order_field_caption .= "$caption:";
            $order_field_name .= "$item->{field_name}:";
            
            $map_caption_field .= "$caption => $item->{field_name}, ";
        }
    }
    
    $order_field_caption =~ s/:$//;
    $order_field_name =~ s/:$//;
    $map_caption_field =~ s/, $//;    
    
    ### dmpr stand for dynamic_module_paramater_row ###
    my @dmpr = ({order_field_cgi_var => "order_" . $this->{table_name} . "_AFLS"}, 
                {order_field_caption => $order_field_caption}, {order_field_name => $order_field_name},
                {map_caption_field => $map_caption_field}, 
                {db_items_set_number_var => "dbisn_" . $this->{table_name} . "_AFLS"}, 
                {dynamic_menu_items_set_number_var => "dmisn_" . $this->{table_name} . "_AFLS"}, 
                {inl_var_name => "inl_" . $this->{table_name} . "_AFLS"}, 
                {lsn_var_name => "lsn_" . $this->{table_name} . "_AFLS"}, 
                {link_path_additional_get_data => "task=&button_submit="});
    
    my $current_table = $this->{arg}->{table_info};

    my $id_item_parent = undef;
    my $id_item_added = undef;
    my $table_name_current = $current_table->{name};
    my $table_name_parent = $current_table->{parent};
    my $table_name_mediator = $current_table->{via_mediator};
    
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
                
    my $sql = "select * from $table_name_current where $id_item_added not in (select $id_item_added from $table_name_mediator where $id_item_parent='\$cgi_" . $id_item_parent . "_') order by \$cgi_order_" . $this->{table_name} ."_AFLS_";
    
    push(@dmpr, {sql => $sql});

    print "\n### Set up DB_Item_Add key-value pairs:\n";
    
    $this->add_Dyna_Mod_Param(\@dmpr, $this->{dms_id_add});    
}

sub generate_DB_Item_Remove {
    my $this = shift @_;

    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    my $dbt_schema = $this->{dbt_schema};
    my $dbt_med_schema = $this->{dbt_med_schema};
    my $dbt_med_schema_act = $this->{dbt_med_schema_act};
    
    my $table_name_struct = $this->get_Table_Name_Struct;

    my $template_default = "template_" . $table_name_struct . "_remove.html";
    
    my $current_table = $this->{arg}->{table_info};
    
    my $table_name_current = $current_table->{name};
    my $table_name_parent = $current_table->{parent};
    
    my $table_name_mediator = $current_table->{via_mediator};
    my $pk_med_table = $dbt_med_schema->{$table_name_mediator}->[0]->{pk};
    
    if ($table_name_mediator eq "") {
        ### try to check if tables are interconnected via acting mediator table
        foreach my $tbl_rel (@{$dbt_schema->{$table_name_parent}}) {
            if ($dbt_med_schema_act->{$tbl_rel->{bound_name}} ne "") {
                foreach my $item_med (@{$dbt_med_schema_act->{$tbl_rel->{bound_name}}}) {
                    if ($item_med->{bound_name} eq $table_name_current) {
                        $table_name_mediator = $tbl_rel->{bound_name};
                        $pk_med_table = $item_med->{pk};
                    }
                }
            }
        }
    }    
    
    my $task_last_phase = $this->{arg}->{mod_name_remove};
       $task_last_phase =~ s/_remove\.pm$/_list/;
    
    ### dmpr stand for dynamic_module_paramater_row ###
    my @dmpr = ({table_name => $table_name_mediator},
                {delete_keys_str => "$pk_med_table='\$cgi_" . $pk_med_table . "_'"}, 
                {last_phase_cgi_data_reset => "task='$task_last_phase' button_submit"});
    
    print "\n### Set up DB_Item_Remove key-value pairs:\n";
    
    $this->add_Dyna_Mod_Param(\@dmpr, $this->{dms_id_remove});    
}

sub add_Dyna_Mod_Param {
    my $this = shift @_;
       
    my $ahr = shift @_; ### array ref. of hash ref. of key-value pairs
    my $current_dms_id = shift @_;
    
    my $link_ref_id = $this->{set_link_ref_id};
    my $scdmr_id = $this->{set_scdmr_id};
    my $dyna_mod_selector_id = $current_dms_id;
    
    my $dbts = $this->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)    
    
    my $dbu = $this->{dbu};
    
    $dbu->set_Table("webman_" . $this->{app_name} . "_dyna_mod_param");
    
    foreach my $item (@{$ahr}) {        
        my ($key, $val) = each(%{$item});
    
        $val =~ s/ /\\ /g;
        
        if ($val ne "") {
            if (!$dbu->find_Item("link_ref_id scdmr_id dyna_mod_selector_id param_name", "$link_ref_id $scdmr_id $dyna_mod_selector_id $key")) {
                $dbu->insert_Row("link_ref_id scdmr_id dyna_mod_selector_id param_name param_value", 
                                 "$link_ref_id $scdmr_id $dyna_mod_selector_id $key $val");
                                
                print "Insert dynamic module param.: $link_ref_id $scdmr_id $dyna_mod_selector_id $key = $val\n";
                
            } else {
                print "Duplicate entry of dynamic module param.: $link_ref_id $scdmr_id $dyna_mod_selector_id $key = $val\n";
            }
            
        }
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

sub save_Template_File_Option {
    my $this = shift @_;
    
    my $file_content = shift @_;
    my $file_name = shift @_;
    
    #print "File Content:\n$file_content";
    print "\n\n";
    print "File Name > $file_name\n\n";
    print "Save above template file [y/n]: ";

    #my $choice = <STDIN>;
    #   $choice =~ s/\n//;
    #   $choice =~ s/\r//;

    #if ($choice eq "y") {
        if (open(MYFILE, ">$file_name")) {
            print MYFILE ($file_content);
            close(MYFILE);
        }
    #}
}

1;