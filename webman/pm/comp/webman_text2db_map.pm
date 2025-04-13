package webman_text2db_map;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use Text_DB_Map;

sub new {
    my $class = shift;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    $this->{template_default_confirm} = undef;
    
    $this->{task} = undef;
    
    $this->{spliter_col} = undef;
    $this->{spliter_row} = undef;
    
    $this->{table_name} = undef;
    
    ### fields order/sequence separated by single spaces
    $this->{field_list} = undef;

    ### key field used to check item existence/duplication    
    $this->{key_field_name} = undef;
    
    ### added key-field dynamically via CGI parameter value    
    $this->{key_field_name_dynamic} = undef;
    
    ### 01/01/2014
    ### to accept blank field it must be 
    ### first converted
    $this->{blank_field_conversion} = undef;     
    
    ### 21/12/2013
    ### Special CGI parameter to mark the row to be skipped 
    ### from being included in the database operations. 
    $this->{rowskip_cgi_var} = undef;
    
    ### 28/05/2014
    $this->{db_item_auth_mode} = undef;    
    
    $this->{sql_debug} = undef;
    
    $this->{submit_button_name} = undef;
    $this->{proceed_on_submit} = undef;
    $this->{confirm_on_submit} = undef;
    $this->{cancel_on_submit} = undef;
    
    $this->{link_path_level_start} = undef; ### 13/03/2013
    $this->{link_path_level_deep} = undef; ### 13/03/2013
    $this->{link_path_separator_tag} = undef; ### 13/03/2013
    $this->{link_path_unselected_color} = undef; ### 13/03/2013
    $this->{link_path_additional_get_data} = undef; ### 13/03/2013   
    
    ### it's possible database table has one of its field named
    ### as "num" and will conflict with $tld_num_ pattern used by 
    ### Table_List_Data instance to display the item number
    $this->{row_num_text_pattern};
    
    $this->{last_phase_cgi_data_reset} = undef;
    
    bless $this, $class;
    
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

sub set_Template_Default {
    my $this = shift @_;
    
    my $template_file = shift @_;
    
    $this->{template_default} = $template_file;
}

sub set_Template_Default_Confirm {
    my $this = shift @_;
    
    $this->{template_default_confirm} = shift @_;
}

sub set_Task {
    my $this = shift @_;
    
    $this->{task} = shift @_;
}

sub set_Spliter_Column {
    my $this = shift @_;
    
    $this->{spliter_col} = shift @_;
}

sub set_Spliter_Row {
    my $this = shift @_;
    
    $this->{spliter_row} = shift @_;
}

sub set_Spliter_Row {
    my $this = shift @_;
    
    $this->{spliter_row} = shift @_;
}

sub set_Table_Name {
    my $this = shift @_;
    
    $this->{table_name} = shift @_;
}

sub set_Field_List {
    my $this = shift @_;
    
    $this->{field_list} = shift @_;
}

sub set_Key_Field_Name {
    my $this = shift @_;
    
    $this->{key_field_name} = shift @_;
}

sub set_Key_Field_Name_Dynamic {
    my $this = shift @_;
    
    $this->{key_field_name_dynamic} = shift @_;
}

### 01/01/2014
sub set_Blank_Field_Conversion {
    my $this = shift @_;
    
    $this->{blank_field_conversion} = shift @_;
}

sub set_SQL_Debug{
    my $this = shift @_;
    
    $this->{sql_debug} = shift @_;
}

sub set_Submit_Button_Name {
    my $this = shift @_;
    
    $this->{submit_button_name} = shift @_;
}

sub set_Proceed_On_Submit {
    my $this = shift @_;
    
    $this->{proceed_on_submit} = shift @_;
}

sub set_Confirm_On_Submit {
    my $this = shift @_;
    
    $this->{confirm_on_submit} = shift @_;
}

sub set_Cancel_On_Submit {
    my $this = shift @_;
    
    $this->{cancel_on_submit} = shift @_;
}

sub get_SQL {
    my $this = shift @_;
        
    return $this->{sql};
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    $this->SUPER::run_Task();
    
    my $return_status = 0;
    
    ###########################################################################
    
    if ($this->{key_field_name_dynamic} ne "") {
        my $cgi_HTML = new CGI_HTML_Map;

        $cgi_HTML->set_CGI($cgi);
        $cgi_HTML->set_HTML_Code($this->{key_field_name_dynamic});

        ### $esc_mode can be 0 or 1
        $cgi_HTML->set_Escape_HTML_Tag($esc_mode);

        $this->{key_field_name_dynamic_result} = $cgi_HTML->get_HTML_Code;        
    }
    
    ### 21/12/2013
    if ($this->{rowskip_cgi_var} eq "") { $this->{rowskip_cgi_var} = "_row_skip_"; }
    
    ### 28/05/2014
    if ($this->{db_item_auth_mode} eq "") { $this->{db_item_auth_mode} = 1; }    
    
    ###########################################################################
    
    #$cgi->add_Debug_Text("\$this->{field_list} = $this->{field_list}", __FILE__, __LINE__, "TRACING");
    
    if ($cgi->param("\$this->{field_list}") ne "") {
        $this->{field_list} = $cgi->param_Shift("\$this->{field_list}");
    }
    
    #$cgi->add_Debug_Text("\$this->{field_list} = $this->{field_list}", __FILE__, __LINE__, "TRACING");
    
    my @field_list = split(/ /, $this->{field_list});
    
    my @kfns = ();
    my @kfn_all = ();
    my $kf_str_struct = undef;
    
    if ($this->{key_field_name} ne "") {
        ### refine $this->{key_field_name}
        while ($this->{key_field_name} =~ /  /) {
            $this->{key_field_name} =~ s/  / /;
        }
        
        $this->{key_field_name} =~ s/^ //;
        $this->{key_field_name} =~ s/ $//;
        
        ### construct key field name array
        @kfns = split(/ /, $this->{key_field_name});
        
        foreach my $key_field_name (@kfns) {
            ### developer can/might mix key fields as:
            ### field_1 field_2&field_3 ... field_n"
            my @kfns_mix = split(/&/, $key_field_name);
            
            foreach my $kfn (@kfns_mix) {
                if (!grep(/^$kfn$/, @field_list)) {
                    ### key field name is set but not exist in field list
                    push(@field_list, $kfn);

                    if (!defined($this->{task})) { 
                        $this->{task} = "insert";
                    }            

                } else { 
                    if (!defined($this->{task})) {
                        if (@field_list == 1) {
                            $this->{task} = "delete";
                        } else {
                            $this->{task} = "update";
                        }
                    }
                }
                
                push(@kfn_all, $kfn);
            }
            
            ### construct key fields string structure
            if (@kfns_mix > 1) {
                $kf_str_struct .= "(";

                foreach my $kfn (@kfns_mix) {
                    $kf_str_struct .= "$kfn and ";
                }

                $kf_str_struct =~ s/ and $//;
                $kf_str_struct .= ") or ";

            } else {
                $kf_str_struct .= "$key_field_name or ";
            }            
        }
    }
    
    $this->{field_list_array_ref} = \@field_list;
    $this->{key_field_name_array_ref} = \@kfn_all;
    
    $kf_str_struct =~ s/ or $//;
    
    $this->{kf_str_struct} = $kf_str_struct;
        
    #$cgi->add_Debug_Text("\$kf_str_struct --- $kf_str_struct", __FILE__, __LINE__, "TRACING");    
    
    ###########################################################################
    
    if ($this->{submit_button_name} eq undef) { $this->{submit_button_name} = "button_submit"; }
    if ($this->{proceed_on_submit} eq undef) { $this->{proceed_on_submit} = "Upload"; }
    if ($this->{confirm_on_submit} eq undef) { $this->{confirm_on_submit} = "Confirm"; }
    if ($this->{cancel_on_submit} eq undef) { $this->{cancel_on_submit} = "Cancel"; }
    
    ###########################################################################
    
    if ($this->check_Button_On_Submit("proceed_")) {
        if ($this->{template_default_confirm} ne "") { ### need confirmation page
            $this->process_Text_Content;
            
        } else { ### doesn't need confirmation page
            $this->process_Text_Content;
            $return_status = $this->applied_Text_Content;
        }
    }
    
    ### process_Text_Content has been called at "proceed_"
    if ($this->check_Button_On_Submit("confirm_")) {
        $return_status = $this->applied_Text_Content;
    }
    
    if ($this->init_Phase) {
        ### useful in the situation where this module is called via:
        ### item list -> item update -> text2db update option
        $this->init_Phase_CGI_Data_Cache_Remove;
    }
    
    if ($this->last_Phase) { ### a normal last phase ### 17/01/2011
        $this->last_Phase_CGI_Data_Reset;
        
        ### in case new columns was added into 
        ### TLD for database operation
        $cgi->param_Shift("\$this->{field_list}");
    }    
    
    return $return_status;
}

sub process_Content {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    
    #$cgi->add_Debug_Text("\!\$this->field_Entry_Error = " . !$this->field_Entry_Error, __FILE__, __LINE__);
    
    if ($this->check_Button_On_Submit("proceed_") && 
        $this->{template_default_confirm} ne "") {
        
        $this->{template_default} = $this->{template_default_confirm};
    }
    
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
    my $te_type_name = $te->get_Name;
    
    if ($te_type_name eq "link_path") {
        my $wmlpg = new webman_link_path_generator;
        
        $wmlpg->set_Template_Default("template_link_path.html");
        $wmlpg->set_Carried_GET_Data("session_id");
        $wmlpg->set_Additional_GET_Data($this->{link_path_additional_get_data}); ### 01/01/2009
        $wmlpg->set_Level_Start($this->{link_path_level_start});
        
        if ($this->{link_path_level_deep} < 1) { ### 14/12/2010
            $this->{link_path_level_deep} = $this->get_My_Link_Level;
        }
        
        $wmlpg->set_Level_Deep($this->{link_path_level_deep});
        
        if ($this->{link_path_separator_tag} ne "") { ### 14/12/2010
            $wmlpg->set_Separator_Tag($this->{link_path_separator_tag});
        }
        
        if ($this->{link_path_unselected_color} ne "") { ### 14/12/2010
            $wmlpg->set_Non_Selected_Link_Color($this->{link_path_unselected_color});
        }
        
        $wmlpg->set_CGI($cgi);
        $wmlpg->set_DBI_Conn($db_conn);
        
        $wmlpg->set_Link_Path($this->get_Link_Path); ### 04/02/2009
        
        $wmlpg->set_Current_Dynamic_Content_Name($te_type_name); ### 26/05/2011
        $wmlpg->set_Module_DB_Param; ### 26/05/2011        
        
        $wmlpg->run_Task;
        $wmlpg->process_Content;
        
        $te_content = $wmlpg->get_Content;
    }
    
    if ($te_type_name eq "form_hidden_field") {
        my $hpd = $this->generate_Hidden_POST_Data("session_id link_id");

        $te_content = $hpd;
    }
    
    if ($te_type_name eq "txt2db_format") {
        my @field_array = @{$this->{field_list_array_ref}};
        my $col_split = $this->{spliter_col};
        my $row_split = $this->{spliter_row};
        
        if (!defined($row_split) || $row_split eq "\n") {
            $row_split = "\\n";
        }
        
        if (!defined($col_split)) {
            $col_split = "\\t";
            
        } elsif ($col_split eq "\t") {
            $col_split = "\\t";
        }
        
        $te_content  = "<pre>\n";
        
        for (my $i = 0; $i < 2; $i++) {
            for (my $j = 0; $j < @field_array; $j++) {
                if ($j == (@field_array - 1)) {
                    $te_content .= $field_array[$j] . "[$i]$row_split\n";
                    
                } else {
                    $te_content .= $field_array[$j] . "[$i] $col_split ";
                }
            }
        }
        
        for (my $j = 0; $j < @field_array; $j++) {
            for (my $l = 0; $l < length($field_array[$j]); $l++) {
                $te_content .= ".";
            }
            
            $te_content .= "...";
            
            if ($j == (@field_array - 1)) {
                $te_content .= "$row_split\n";

            } else {
                $te_content .= " $col_split ";
            }            
        }
        
        for (my $j = 0; $j < @field_array; $j++) {
            if ($j == (@field_array - 1)) {
                $te_content .= $field_array[$j] . "[<i>n</i>]$row_split\n";

            } else {
                $te_content .= $field_array[$j] . "[<i>n</i>] $col_split ";
            }
        }        
        
        $te_content .= "</pre>\n";
    }
    
    if ($te_type_name eq "txt2db_item") {
        if (defined($this->{tld})) {
            $te_content = $this->{tld}->get_Table_List;
        }
    }    
    
    $this->add_Content($te_content);
}

sub process_LIST { ### TE_TYPE_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_name = $te->get_Name;
    
    #$te_content = ...;
    #$te->set_Content($te_content);
    
    #$this->SUPER::process_LIST($te);
    
    if ($te_type_name eq "txt2db_item") {
        if (defined($this->{tld})) {
            #$te_content = $this->{tld}->get_Table_List;
            
            my $tldhtml = new TLD_HTML_Map;
            
            if ($this->{row_num_text_pattern} ne "") {
                $tldhtml->set_Row_Num_Text_Pattern($this->{row_num_text_pattern});
            }

            $tldhtml->set_Table_List_Data($this->{tld});
            $tldhtml->set_HTML_Code($te_content);

            #$cgi->add_Debug_Text("\$this->{db_items_num_begin} = $this->{db_items_num_begin}", __FILE__, __LINE__);


            #$tldhtml->set_Start_Counter($this->{db_items_num_begin});

            $te_content = $tldhtml->get_HTML_Code;            
        }    
    }
    
    #if ($this->get_Error eq "") {
    #   $this->add_Content($te_content);
        
    #} else {
    #   $this->add_Content($this->get_Error);
    #}
    
    $this->add_Content($te_content);
}

sub process_Text_Content {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    
    my @file_name = $cgi->upl_File_Name;
    my @file_content = $cgi->upl_File_Content;
    
    if (@file_name > 0) {
        #$cgi->add_Debug_Text("<pre>$file_content[0]</pre>", __FILE__, __LINE__);
        
        my $txt2db = new Text_DB_Map;
        
        $txt2db->set_Text_File_Content($file_content[0]);        
        
        $txt2db->set_Spliter_Column($this->{spliter_col});
        $txt2db->set_Spliter_Row($this->{spliter_row});
        
        ### 01/01/2014
        if (defined($this->{blank_field_conversion})) {
            $txt2db->set_Blank_Field_Conversion($this->{blank_field_conversion});
        }        

        $txt2db->set_Conn($db_conn);
        $txt2db->set_Table_Name($this->{table_name});
        
        my @field_list = @{$this->{field_list_array_ref}};
        
        $txt2db->set_Field_List(\@field_list);
        
        $this->{tld} = $txt2db->generate_TLD($cgi);
        
        $this->{tld} = $this->customize_TLD_DB_Operation;
        
        my $tld = $this->{tld};
        
        if (defined($tld)) {
            my $row_num = $tld->get_Row_Num;
            my $col_num = $tld->get_Column_Num;
            
            ### generate HTML_DB_Map format CGI variables
            for (my $i = 0; $i < $row_num; $i++) {
                for (my $j = 0; $j < $col_num; $j++) {
                    my $col_name = $tld->get_Column_Name($j);
                    my $col_val = $tld->get_Data($i, $col_name);

                    $cgi->push_Param("\$db_" . $col_name . "_$i", $col_val);
                }
                
                ### 21/12/2013
                $cgi->push_Param($this->{rowskip_cgi_var} . $i, "0");
                
                if ($tld->get_Data($i, "_skip_")) {
                    $cgi->push_Param($this->{rowskip_cgi_var} . $i, "1");
                }
                
                #$cgi->add_Debug_Text("skip = " . $tld->get_Data($i, "_skip_"), __FILE__, __LINE__);
            }
            
            ### detect new added columns by $this->customize_TLD_DB_Operation
            my $field_list_added = undef;
            
            for (my $j = 0; $j < $col_num; $j++) {
                my $col_name = $tld->get_Column_Name($j);
                
                if (!grep(/^$col_name$/, @field_list) && $col_name ne "_skip_") {
                    $field_list_added .= " $col_name";
                }
            }
            
            if (defined($field_list_added)) {
                my $field_list_new = $this->{field_list} . $field_list_added;
                
                $field_list_new =~ s/  / /g;
                
                $cgi->push_Param("\$this->{field_list}", $field_list_new);
            }
            
            #$cgi->add_Debug_Text("\$field_list_added = $field_list_added", __FILE__, __LINE__, "TRACING"); 
        }
    }
    
    if (!$this->init_Phase & !$this->last_Phase) {
        $this->check_Pre_Operation_Status;
        $this->{tld} = $this->customize_TLD_View;
    }
}

sub customize_TLD_DB_Operation {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    return $this->{tld};
}

sub check_Pre_Operation_Status {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $tld = $this->{tld};
    
    my @kfn_all = @{$this->{key_field_name_array_ref}};
    
    if (defined($tld)) {
        ### start customize tld
        
        $tld->add_Column("_row_status_");
        
        for (my $i = 0; $i < $tld->get_Row_Num; $i++) { 
            #my $tld_data = $tld->get_Data($i, "col_name_");
            
            $tld->set_Data($i, "_row_status_", "Ok");
            
            my $kf_str = $this->{kf_str_struct};
            
            for (my $j = 0; $j < $tld->get_Column_Num; $j++) {
                my $column_name = $tld->get_Column_Name($j);
                
                if (grep(/^$column_name$/, @kfn_all)) {

                    my $kf_value = $tld->get_Data($i, $column_name);

                    ### reformat it following SQL standard input
                    $kf_value =~ s/'/\\'/g;    
                    
                    $kf_str =~ s/$column_name/$column_name='$kf_value'/;
                }
            }
            
            #$cgi->add_Debug_Text($kf_str, __FILE__, __LINE__);
            
            if (defined($this->{key_field_name_dynamic_result})) {
                $kf_str .= " and $this->{key_field_name_dynamic_result}";
            }
            
            #$cgi->add_Debug_Text($kf_str, __FILE__, __LINE__);
            
            if ($this->{key_field_name} ne "") {
                $dbu->set_Table($this->{table_name});
                $dbu->set_Keys_Str($kf_str);
                
                if ($this->{task} eq "insert") {
                    if ($dbu->find_Item) {
                        $tld->set_Data($i, "_row_status_", "Duplicate Entry");
                    }

                } else { ### update or delete
                    if (!$dbu->find_Item) {
                        $tld->set_Data($i, "_row_status_", "Not Exist");
                    }
                }
                
                $dbu->set_Keys_Str(undef);
                
                #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
                #$cgi->add_Debug_Text($kf_str, __FILE__, __LINE__, "TRACING");
            }
        }
        
        $this->{tld} = $tld;
    }    
}

sub customize_TLD_View {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    return $this->{tld};
}

sub applied_Text_Content {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;    
    
    my $status = 1;
    
    my $htmldb = new HTML_DB_Map;

    $htmldb->set_CGI($cgi);
    $htmldb->set_DBI_Conn($db_conn);
    $htmldb->set_Table($this->{table_name});
    
    ### 28/05/2014
    ### Just for the purpose of to record the '$login_name' if special fields 
    ### 'wmf_created' and 'wmf_modified' are exist in the current operated table. 
    if ($this->{db_item_auth_mode}) {
        my $db_item_auth_table_name = "webman_" . $cgi->param("app_name") . "_db_item_auth";
        $htmldb->set_DB_Item_Auth_Info($login_name, \@groups, $db_item_auth_table_name);
    }    
    
    my @cgi_var_list = $cgi->var_Name;
    
    my @field_list = @{$this->{field_list_array_ref}};
    my @kfn_all = @{$this->{key_field_name_array_ref}};
    
    my $idx = 0;
    my $first_field_cgi_var = "\\\$db_" . $field_list[0] . "_$idx";    
    
    #$cgi->add_Debug_Text("\$this->{task} = $this->{task}", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$first_field_cgi_var = " . $first_field_cgi_var, __FILE__, __LINE__);
    #$cgi->add_Debug_Text("grep = " . grep(/^$first_field_cgi_var$/, @cgi_var_list), __FILE__, __LINE__);
    
    while (grep(/^$first_field_cgi_var$/, @cgi_var_list)) {
        #$cgi->add_Debug_Text("\$first_field_cgi_var = $first_field_cgi_var", __FILE__, __LINE__, "TRACING");
        
        if (!$cgi->param($this->{rowskip_cgi_var} . $idx)) {
        
            foreach my $field (@field_list) {
                my $dbf_cgi_var_name = "\$db_" . $field;
                my $dbf_cgi_var_name_idx = $dbf_cgi_var_name . "_$idx";

                $cgi->push_Param($dbf_cgi_var_name, $cgi->param($dbf_cgi_var_name_idx));

                #$cgi->add_Debug_Text("\$dbf_cgi_var_name = $dbf_cgi_var_name", __FILE__, __LINE__, "TRACING");
            }

            my $kf_str = $this->{kf_str_struct};

            #$cgi->add_Debug_Text($kf_str, __FILE__, __LINE__, "DATABASE");

            foreach my $key_field_name (@kfn_all) {
                #$cgi->add_Debug_Text($key_field_name, __FILE__, __LINE__);

                my $kf_value = $cgi->param("\$db_" . $key_field_name);

                ### reformat it following SQL standard input
                $kf_value =~ s/'/\\'/g;  
                $kf_value =~ s/\%/\\\%/g;

                $kf_str =~ s/$key_field_name/$key_field_name='$kf_value'/;
            }

            #$cgi->add_Debug_Text($kf_str, __FILE__, __LINE__);

            if (defined($this->{key_field_name_dynamic_result})) {
                $kf_str .= " and $this->{key_field_name_dynamic_result}";
            }

            #$cgi->add_Debug_Text($kf_str, __FILE__, __LINE__);

            if ($this->{task} eq "insert") {
                my $duplicate = 0;

                if ($this->{key_field_name} ne "") { 
                    $dbu->set_Table($this->{table_name});
                    $dbu->set_Keys_Str($kf_str);

                    $duplicate = $dbu->find_Item(undef, undef);

                    $dbu->set_Keys_Str(undef);
                }

                if (!$duplicate) {
                    $htmldb->insert_Table;

                } else {
                    $cgi->add_Debug_Text("Duplicate field(s) entry: $kf_str", __FILE__, __LINE__, "DATABASE");
                }

                $this->{sql} .= $htmldb->get_SQL .";";

                if ($this->{sql_debug}) {
                    $cgi->add_Debug_Text($htmldb->get_SQL, __FILE__, __LINE__, "DATABASE");
                }

            } elsif ($this->{task} eq "update") {
                #$cgi->add_Debug_Text($kf_str, __FILE__, __LINE__, "DATABASE");
                $htmldb->set_Update_Keys_Str($kf_str);
                $htmldb->update_Table;

                $this->{sql} .= $htmldb->get_SQL .";";

                if ($this->{sql_debug}) {
                    $cgi->add_Debug_Text($htmldb->get_SQL, __FILE__, __LINE__, "DATABASE");
                }            

            } elsif ($this->{task} eq "delete") {
                #$cgi->add_Debug_Text("Try to delete via text file input", __FILE__, __LINE__, "TRACING");

                $dbu->set_Table($this->{table_name});
                $dbu->set_Keys_Str($kf_str);
                $dbu->delete_Item;
                $dbu->set_Keys_Str(undef);

                $this->{sql} .= $dbu->get_SQL .";";

                if ($this->{sql_debug}) {
                    $cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
                }            
            }

            #$cgi->add_Debug_Text($htmldb->get_SQL, __FILE__, __LINE__, "DATABASE");
            #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");

            if ($htmldb->get_DB_Error_Message ne "") {
                $cgi->add_Debug_Text($htmldb->get_DB_Error_Message, __FILE__, __LINE__, "DATABASE");
                $status = 0;

            } else {
                #$cgi->add_Debug_Text($htmldb->get_SQL, __FILE__, __LINE__, "DATABASE");
            }
        }
        
        $idx++;
        
        $first_field_cgi_var = "\\\$db_" . $field_list[0] . "_$idx";
    }
    
    return $status;
}

sub check_Button_On_Submit { ### 08/12/2010
    my $this = shift @_;
    
    my $submit_option = shift @_;
    
    ### 03/03/2011
    ### besides inside $this->run_Task function, also need to put all values 
    ### checking below so $this->init_Phase and $this->confirm_Phase can be 
    ### used/called before $this->run_Task
    if ($this->{submit_button_name} eq undef) { $this->{submit_button_name} = "button_submit"; }
    if ($this->{proceed_on_submit} eq undef) { $this->{proceed_on_submit} = "Upload"; }
    if ($this->{confirm_on_submit} eq undef) { $this->{confirm_on_submit} = "Confirm"; }
    if ($this->{cancel_on_submit} eq undef) { $this->{cancel_on_submit} = "Cancel"; }    
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $submit_current = $cgi->param($this->{submit_button_name});
    
    if ($submit_option eq "proceed_" &&
        $submit_current eq $this->{proceed_on_submit}) { 
        return 1;
    }
    
    if ($submit_option eq "confirm_" &&
        $submit_current eq $this->{confirm_on_submit}) { 
        return 1;
    }
    
    if ($submit_option eq "cancel_" &&
        $submit_current eq $this->{cancel_on_submit}) { 
        return 1;
    }     
    
    return 0;
}

sub init_Phase {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    
    if (!$this->check_Button_On_Submit("proceed_") &&
        !$this->check_Button_On_Submit("confirm_") &&
        !$this->check_Button_On_Submit("cancel_")) {
        return 1;
    }
    
    return 0;
}

sub init_Phase_CGI_Data_Cache_Remove {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    
    my @CGI_var_name = $cgi->var_Name;
    
    foreach my $var_name (@CGI_var_name) {
        if ($var_name =~ /^\$db_/) {
            $this->{init_phase_cgi_data_remove} .= "$var_name ";
        }
    }
    
    #$cgi->add_Debug_Text($this->{init_phase_cgi_data_remove}, __FILE__, __LINE__, "TRACING");
    
    $this->remove_DB_Cache_CGI_Var($this->{init_phase_cgi_data_remove});    
}

sub last_Phase {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;  
    
    if ($this->check_Button_On_Submit("cancel_")) {
        $this->{last_phase} = 1;
        
        return $this->{last_phase};
    }
    
    my $total_status = 0;
    
    if ($this->{template_default_confirm} eq "") {
        $this->{last_phase} = $this->check_Button_On_Submit("proceed_");
        
    } else {
        $this->{last_phase} = $this->check_Button_On_Submit("confirm_");
    }
    
    #$cgi->add_Debug_Text("\$this->{last_phase} = $this->{last_phase}", __FILE__, __LINE__);    
    
    return $this->{last_phase};
}

sub last_Phase_CGI_Data_Reset {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    ### try to auto set all possible data related CG database cache variables
    
    if ($this->{last_phase_cgi_data_reset} eq "") { 
        $this->{last_phase_cgi_data_reset} = "task $this->{submit_button_name} ";
        
    } elsif (!($this->{last_phase_cgi_data_reset} =~ / $/)) {
        $this->{last_phase_cgi_data_reset} .= " ";
    }
    
    $dbu->set_Table($this->{table_name});
    
    my @ahr = $dbu->get_Table_Structure;
    my $pkf = $ahr[0]->{field_name};
    
    my @CGI_var_name = $cgi->var_Name;
    
    foreach my $var_name (@CGI_var_name) {
        if ($var_name =~ /^\$db_/) {
            $this->{last_phase_cgi_data_reset} .= "$var_name ";
        }
        
        ### also try to remove any possible current table pk field
        ### that passed as a CGI variable for example when this module
        ### was intergrate with multi row database operations modules
        ### for update/delete
        if ($var_name =~ /^$pkf/) {
            $this->{last_phase_cgi_data_reset} .= "$var_name ";
        }
        
        ### 21/12/2013
        ### Remove the special CGI parameter 
        if ($var_name =~ /^$this->{rowskip_cgi_var}/) {
            $this->{last_phase_cgi_data_reset} .= "$var_name ";
        }         
    }    
    
    #$cgi->add_Debug_Text("\$this->{last_phase_cgi_data_reset} = $this->{last_phase_cgi_data_reset}", __FILE__, __LINE__);        
    
    ###########################################################################
    
    $this->set_CGI_Data_Reset($this->{last_phase_cgi_data_reset});
    #$this->reset_CGI_Data;
}

1;