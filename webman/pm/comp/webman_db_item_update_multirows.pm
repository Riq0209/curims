package webman_db_item_update_multirows;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    $this->{template_default_confirm} = undef;

    $this->{table_name} = undef;
    $this->{update_keys_str} = undef;
    $this->{db_item_auth_mode} = undef; ### 11/02/2011
    $this->{sql_view} = undef;
    $this->{sql_debug} = undef;
    
    $this->{check_on_cgi_data} = undef;
    $this->{check_on_fields_duplication} = undef;
    $this->{check_on_fields_existence} = undef; ### 11/10/2011
    $this->{limit_on_fields} = undef;
    $this->{esc_datahtml_tag} = undef; ### 09/02/2011
    
    $this->{map_blank_fields_error_msg} = undef; ### 24/12/2010
    $this->{map_duplicate_fields_error_msg} = undef; ### 24/12/2010    
    
    $this->{submit_button_name} = undef; ### 13/01/2007
    $this->{proceed_on_submit} = undef;
    $this->{confirm_on_submit} = undef; ### 18/12/2008
    $this->{cancel_on_submit} = undef;
    
    $this->{link_path_level_start} = undef; ### 06/02/2008
    $this->{link_path_level_deep} = undef; ### 14/12/2010
    $this->{link_path_separator_tag} = undef; ### 14/12/2010
    $this->{link_path_unselected_color} = undef; ### 14/12/2010
    $this->{link_path_additional_get_data} = undef; ### 01/01/2009
    
    $this->{exclude_db_cache_cgi_var} = undef; ### 18/12/2009
    $this->{remove_db_cache_cgi_var} = undef; ### 05/01/2009
    
    $this->{last_phase_cgi_data_reset} = undef; ### 14/04/2008
    $this->{last_phase_url_redirect} = undef; ### 21/03/2012
    
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
    
    $this->{template_default} = shift @_;
}

sub set_Template_Default_Confirm {
    my $this = shift @_;
    
    $this->{template_default_confirm} = shift @_;
}

sub set_DBI_App_Conn {
    my $this = shift @_;
    
    $this->{dbi_app_conn} = shift @_;
}

sub set_Table_Name {
    my $this = shift @_;
    
    $this->{table_name} = shift @_;
}

sub set_Update_Keys_Str {
    my $this = shift @_;
    
    $this->{update_keys_str} = shift @_;
}

sub set_SQL_View {
    my $this = shift @_;
    
    $this->{sql_view} = shift @_;
}

sub set_SQL_Debug {
    my $this = shift @_;
    
    $this->{sql_debug} = shift @_;
}

sub set_Proceed_On_Submit {
    my $this = shift @_;
    
    $this->{proceed_on_submit} = shift @_;
}

sub set_Cancel_On_Submit {
    my $this = shift @_;
    
    $this->{cancel_on_submit} = shift @_;
}

sub set_Check_On_CGI_Data {
    my $this = shift @_;
    
    $this->{check_on_cgi_data} = shift @_;
}

sub set_Check_On_Fields_Duplication {
    my $this = shift @_;
    
    $this->{check_on_fields_duplication} = shift @_;
}

sub set_Check_On_Fields_Existence { ### 10/10/2011
    my $this = shift @_;
    
    $this->{check_on_fields_existence} = shift @_;
}

sub set_Limit_On_Fields {
    my $this = shift @_;
    
    $this->{limit_on_fields} = shift @_;
}

sub set_Link_Path_Level_Start {
    my $this = shift @_;
    
    $this->{link_path_level_start} = undef;
}

sub set_Link_Path_Level_Deep {
    my $this = shift @_;
    
    $this->{link_path_level_deep} = undef;
}

sub set_Link_Path_Separator_Tag {
    my $this = shift @_;
    
    $this->{link_path_separator_tag} = undef;
}


sub set_Link_Path_Unselected_Color {
    my $this = shift @_;

    $this->{link_path_unselected_color} = undef;
}

sub set_Link_Path_Additional_Get_Data { ### 11/02/2006
    my $this = shift @_;
    
    $this->{link_path_additional_get_data} = shift @_;
}

sub set_Submit_Button_Name { ### 13/01/2007
    my $this = shift @_;
    
    $this->{submit_button_name} = shift @_; 
}

sub set_Last_Phase_CGI_Data_Reset { ### 14/04/2008
    my $this = shift @_;
    
    $this->{last_phase_cgi_data_reset} = shift @_;
}

sub set_Last_Phase_URL_Redirect { ### 21/03/2012
    my $this = shift @_;
    
    $this->{last_phase_url_redirect} = shift @_;
}

sub set_Field_Error { ### 24/12/2010
    my $this = shift @_;
    
    my $field_name = shift @_;
    my $field_error = shift @_;
    
    if ($this->{fe_hash} eq undef) { 
        $this->{fe_hash} = {};
    }
    
    $this->{fe_hash}->{"\$fe_" . $field_name} .= $field_error;
    
    my $cgi = $this->get_CGI;
    
    #$cgi->add_Debug_Text("\$this->{fe_hash}->{$field_name} = " . $this->{fe_hash}->{$field_name}, __FILE__, __LINE__, "TRACING");
}

sub get_SQL_View {
    my $this = shift @_;
        
    return $this->{sql_view};
}

sub get_SQL {
    my $this = shift @_;
        
    return $this->{sql};
}

sub get_Error_Message {
    my $this = shift @_;
    
    return $this->{db_item_access_error_message};
}

sub get_Last_Phase_CGI_Data_Reset { ### 14/04/2008
    my $this = shift @_;
    
    return $this->{last_phase_cgi_data_reset};
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    $this->SUPER::run_Task();
    
    #$cgi->add_Debug_Text("run_Task: ". $this->get_Component_Name_Full, __FILE__, __LINE__);
    
    my $return_status = 0;
    
    my @CGI_var_list = $cgi->var_Name;
    
    ###########################################################################
    
    ### 25/12/2010
    
    if ($this->{limit_on_fields} ne "") {
        $this->{limit_on_fields_dict} = {};
        
        my @spliter = split(/ /, $this->{limit_on_fields});
        
        foreach my $item (@spliter) {
            $this->{limit_on_fields_dict}->{$item} = 1;
        }
        
        my %cgi_var_val = $cgi->get_Param_Val_Hash;
        
        $this->{exceptional_db_fields} = "";
        
        foreach my $var (keys(%cgi_var_val)) {
            if ($var =~ /^\$db_/) {
                $var =~ s/^\$db_//;
                
                if (!$this->{limit_on_fields_dict}->{$var}) {
                    $this->{exceptional_db_fields} .= "\$db_" . $var . " ";
                }
            }
        }
        
        $this->{exceptional_db_fields} =~ s/ $//;
    }    
    
    ###########################################################################
    
    ### 24/12/2010
    
    if ($this->{map_blank_fields_error_msg} ne "") { ### developers want to customize blank fields error message
        $this->{map_bfe_msg} = {};     
        
        my @field_error = split(/,/, $this->{map_blank_fields_error_msg});

        foreach my $item (@field_error) {
            my @spliter = split(/=>/, $item);

            my $field = $this->refine_Caption_Field_Text($spliter[0]);
            my $error = $this->refine_Caption_Field_Text($spliter[1]);

            #$cgi->add_Debug_Text("field : error = $field : $error", __FILE__, __LINE__);

            $this->{map_bfe_msg}->{"\$fe_" . $field} = $error;
        }
    }    
    
    if ($this->{map_duplicate_fields_error_msg} ne "") { ### developers want to want to customize duplicate fields error message
        $this->{map_dfe_msg} = {};     
        
        my @field_error = split(/,/, $this->{map_duplicate_fields_error_msg});

        foreach my $item (@field_error) {
            my @spliter = split(/=>/, $item);

            my $field = $this->refine_Caption_Field_Text($spliter[0]);
            my $error = $this->refine_Caption_Field_Text($spliter[1]);

            #$cgi->add_Debug_Text("field : error = $field : $error", __FILE__, __LINE__);

            $this->{map_dfe_msg}->{"\$fe_" . $field} = $error;
        }
    }    
    
    ############################################################################
    
    ### set default value if undef
    if ($this->{db_item_auth_mode} eq "") { $this->{db_item_auth_mode} = 1; }
    if ($this->{submit_button_name} eq undef) { $this->{submit_button_name} = "button_submit"; } 
    if ($this->{proceed_on_submit} eq undef) { $this->{proceed_on_submit} = "Proceed"; }
    if ($this->{confirm_on_submit} eq undef) { $this->{confirm_on_submit} = "Confirm"; }
    if ($this->{edit_on_submit} eq undef) { $this->{edit_on_submit} = "Edit"; }
    if ($this->{cancel_on_submit} eq undef) { $this->{cancel_on_submit} = "Cancel"; }    
    
    ### 09/12/2010
    $this->{last_phase} = 0;
    
    ###########################################################################
    ### 05/07/2011
    ### current table's primary key used for update operation
    my $update_key_field = $this->{update_keys_str}; 
    
    $update_key_field =~ s/=.+$//;
    
    while ($update_key_field =~ / /) {
        $update_key_field =~ s/ //;
    }
    
    $this->{update_key_field} = $update_key_field;
    
    my @update_key_field_list = ();
    
    foreach my $var_name (@CGI_var_list) {
        if ($var_name =~ /^$update_key_field/ && $cgi->param($update_key_field) eq "") {
            $cgi->push_Param($update_key_field, $cgi->param($var_name));
        }
        
        if ($var_name =~ /^$update_key_field/ && $var_name =~ /_\d+$/) {
            push (@update_key_field_list, $var_name);
        }
        
        #$cgi->add_Debug_Text($var_name, __FILE__, __LINE__);
    }
    
    ### 27/02/2014
    ### Always sort @update_key_field_list numerically to make sure it 
    ### correctly ordered by its original number.
    my %num2ukfl = ();
    foreach my $item (@update_key_field_list) {
        my $num = $item;
        $num =~ s/$update_key_field//;
        $num =~ s/_//;
        
        $num2ukfl{$num} = $item;
        
        #$cgi->add_Debug_Text($num, __FILE__, __LINE__);
    }
    
    my $idx = 0;
    my @nums = sort { $a <=> $b } keys(%num2ukfl);
    
    foreach my $num (@nums) {
         $update_key_field_list[$idx] = $num2ukfl{$num};
         $idx++;
         #$cgi->add_Debug_Text($num, __FILE__, __LINE__);
    }
    ### 27/02/2014    
    
    $this->{update_key_field_list} = \@update_key_field_list;
    
    if ($cgi->param($update_key_field) eq "") {
        $this->{last_phase} = 1;
    }
    
    ###########################################################################

    if ($this->check_Button_On_Submit("cancel_")) {
        $this->{last_phase} = 1;
    }

    my $total_status = 0;

    if ($this->{template_default_confirm} eq "") {
        $total_status = $this->check_Button_On_Submit("proceed_");

    } else {
        $total_status = $this->check_Button_On_Submit("confirm_");
    }

    $this->{field_error_status} = $this->check_On_CGI_Data + 
                                  $this->check_On_Fields_Duplication +
                                  $this->check_On_Fields_Existence;
                                  
    #$cgi->add_Debug_Text("\$this->{field_error_status} = $this->{field_error_status}", __FILE__, __LINE__);

    $total_status += $this->{field_error_status};

    if ($total_status == 4) {
        $this->{last_phase} = 1;
    }

    #$cgi->add_Debug_Text("\$this->{field_error_status} = $this->{field_error_status}", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$total_status = $total_status", __FILE__, __LINE__);

    $this->generate_Field_Error_Variables_Info; ### can only be called after check_On_CGI_Data 
                                                ### and check_On_Fields_Duplication methods invoked
                                                    
    ############################################################################ 
    
    #print "\$this->{table_name} = " . $this->{table_name} . "<br>";
    
    if ($this->last_Phase && !$this->check_Button_On_Submit("cancel_")) {
        
        my $htmldb = new HTML_DB_Map;

        $htmldb->set_CGI($cgi);
        $htmldb->set_DBI_Conn($db_conn);
        $htmldb->set_Table($this->{table_name});

        if ($this->{exceptional_db_fields} ne "") { ### 25/12/2010
                                                    ### $this->{exceptional_db_fields} is automatically generated
                                                    ### if $this->{limit_on_fields} is set by developers
            $htmldb->set_Exceptional_Fields($this->{exceptional_db_fields});
        }
        
        my $row_idx = 0;

        LOOP_UPDATE: foreach my $update_key_field (@{$this->{update_key_field_list}}) {
            $cgi->push_Param($this->{update_key_field}, $cgi->param($update_key_field));

            $htmldb->set_Update_Keys_Str($this->construct_Update_Key_Str);

            foreach my $var (@CGI_var_list) {
                if ($var =~ /^\$db_.+_$row_idx/) {
                    #$cgi->add_Debug_Text("\$var = $var", __FILE__, __LINE__, "TRACING");

                    my $var_db_fmt = $var;
                       $var_db_fmt =~ s/_$row_idx$//;

                    $cgi->push_Param($var_db_fmt, $cgi->param($var));
                }
            }
            
            $row_idx++;

            if ($this->{db_item_auth_mode}) {
                my $caller_get_data = $cgi->generate_GET_Data("link_id session_id") . "&$this->{submit_button_name}=$this->{cancel_on_submit}";
                my $db_item_auth_table_name = "webman_" . $cgi->param("app_name") . "_db_item_auth";

                $htmldb->set_DB_Item_Auth_Info($login_name, \@groups, $db_item_auth_table_name);
                $htmldb->set_Error_Back_Link("<a href=\"index.cgi?$caller_get_data&task=\">Back to previous possible working page.</a>");

                $htmldb->update_Table(undef, undef, 0); ### not execute only prepare the sql statement

                if ($htmldb->{db_item_access_error_message} ne "") {
                    $this->{last_phase} = 0;
                    $this->{error} = $htmldb->{db_item_access_error_message};

                    $cgi->add_Debug_Text("Catch at first level DBI Access Control", __FILE__, __LINE__, "TRACING");
                    
                    last LOOP_UPDATE;
                }        
            }    

            if ($this->{last_phase} && $this->{table_name} ne "" && $cgi->param($update_key_field) ne "") {        
                $this->customize_CGI_Data;
                $htmldb->update_Table;
                $return_status = 1;

                if ($htmldb->get_DB_Error_Message ne "") {
                    $return_status = 0;
                    $cgi->add_Debug_Text("Database Error: " . $htmldb->get_DB_Error_Message, __FILE__, __LINE__, "DATABASE");
                }        

                $this->{sql} .= $htmldb->get_SQL ."; ";                
            }
        }
        
        if ($this->{sql_debug}) {
            $cgi->add_Debug_Text("SQL = " . $this->{sql}, __FILE__, __LINE__, "DATABASE");
        }        
    }
    
    ###########################################################################
    
    ### try to auto set all possible data related CG database cache variables    
    
    if ($this->last_Phase && $this->{last_phase_cgi_data_reset} eq "") { 
        $this->{last_phase_cgi_data_reset} = "task $this->{submit_button_name} ";
        
    } elsif (!($this->{last_phase_cgi_data_reset} =~ / $/)) {
        $this->{last_phase_cgi_data_reset} .= " ";
    }
    
    
    @CGI_var_list = $cgi->var_Name; ### make sure @CGI_var_list is the latest one
    
    foreach my $var_name (@CGI_var_list) {
        if ($var_name =~ /^\$db_/) {
            $this->{last_phase_cgi_data_reset} .= "$var_name ";
        }
        
        if ($var_name =~ /^$update_key_field/) {
            $this->{last_phase_cgi_data_reset} .= "$var_name ";
        }
    }    
    
    #$cgi->add_Debug_Text("\$this->{last_phase_cgi_data_reset} = $this->{last_phase_cgi_data_reset}", __FILE__, __LINE__);
    
    if ($this->{last_phase}) { ### a normal last phase ### 17/01/2011
        $this->last_Phase_CGI_Data_Reset;
        
        if ($this->{last_phase_url_redirect} ne "") {
            #$cgi->add_Debug_Text("Ready to redirect to $this->{last_phase_url_redirect}", __FILE__, __LINE__);

            my $cgi_HTML = new CGI_HTML_Map; ### 10/02/2013

            $cgi_HTML->set_CGI($cgi);
            $cgi_HTML->set_HTML_Code($this->{last_phase_url_redirect});
      
            $cgi->redirect_Page($cgi_HTML->get_HTML_Code);
        }        
    }
    
    return $return_status;
}

sub customize_CGI_Data { ### 11/10/2011
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
}

sub process_Content {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    #$cgi->add_Debug_Text("\!\$this->field_Entry_Error = " . !$this->field_Entry_Error, __FILE__, __LINE__);
    
    if (!$this->field_Entry_Error && 
        $this->check_Button_On_Submit("proceed_") && 
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
        
        if ($this->{link_path_level_deep} < 0) { ### 14/12/2010
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
    
    $this->add_Content($te_content);
}

sub process_DATAHTML { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    my $content = undef;
    
    if ($this->{esc_datahtml_tag} eq "") { $this->{esc_datahtml_tag} = 1; }
    
    ### 15/01/2012
    ### This function might be no more required since we already have 
    ### "form_hidden_field" template element name inside process_DYNAMIC    
    if ($te_type_name eq "cgi_data_map") {
        my $data_HTML = new Data_HTML_Map;
        
        $data_HTML->set_CGI($cgi);
        $data_HTML->set_HTML_Code($te_content);
        $data_HTML->set_Special_Tag_View(1); ### can be 0 or 1
        
        $content = $data_HTML->get_HTML_Code;
    }
    
    if ($te_type_name eq "form_db_field") {
        if (!$this->check_Button_On_Submit("proceed_") &&
            !$this->check_Button_On_Submit("edit_") &&
            !$this->check_Button_On_Submit("cancel_") &&
            !$this->{last_phase}) { ### first time call so need to inject DB fields into CGI data
            
            $this->inject_DBF_To_CGI;
        }        
        
        my $data_HTML = new Data_HTML_Map;

        for (my $row_idx = 0;  $row_idx < @{$this->{update_key_field_list}}; $row_idx++) {
            my $row_num = $row_idx + 1;
            my $content_temp = $te_content;

            $content_temp =~ s/\$row_num_/$row_num/g;
            $content_temp =~ s/\$row_idx/$row_idx/g;

            $data_HTML->set_CGI($cgi);
            $data_HTML->set_HTML_Code($content_temp);
            $data_HTML->set_Special_Tag_View($this->{esc_datahtml_tag}); ### can be 0 or 1

            ### 17/12/2013
            $content_temp = $data_HTML->get_HTML_Code;
            
            ### Next is to help clear the default value even cgi database 
            ### field data sill not exist.
                
            ### for input type text
            $content_temp =~ s/value *= *"\$db_.+_$row_idx."/value=""/g;

            ### for text area
            $content_temp =~ s/> *\$db_.+_$row_idx. *</></g;            
            
            $content .= $content_temp;
        }
    }
    
    $this->add_Content($this->refine_Form_DB_Field_Row_Str($content));
}

### 21/01/2013
### Provide more flexibility inside the child module so developers can 
### further refine the final constructed form-field-row string using Perl's  
### regular expression and string substitutions.
sub refine_Form_DB_Field_Row_Str {
    my $this = shift @_;
    my $str = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    return $str;
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    $this->add_Content($te_content);
}

sub get_DB_Conn_App {
    my $this = shift @_;
    
    #print "\$this->{dbi_app_conn} = " . $this->{dbi_app_conn} . "<br>";
    
    if ($this->{dbi_app_conn} ne "") {
        
        my @spliters = split(/ /, $this->{dbi_app_conn});
        
        my $db_conn = DBI->connect("DBI:$spliters[0]:dbname=$spliters[1]", "$spliters[2]", "$spliters[3]");
        
        return $db_conn;
    }
    
    return undef;
}

sub construct_Update_Key_Str { ### 09/12/2010
    my $this = shift @_;

    my $cgi = $this->get_CGI;

    my $key_str = $this->{update_keys_str};
    
    my $cgi_HTML = new CGI_HTML_Map;
        
    $cgi_HTML->set_CGI($cgi);
    
    $cgi_HTML->set_HTML_Code($key_str);
    #$cgi_HTML->set_Escape_HTML_Tag(???); ### can be 0 or 1
    
    $key_str = $cgi_HTML->get_HTML_Code;    
        
    #$cgi->add_Debug_Text("construct_Update_Key_Str : $key_str", __FILE__, __LINE__, "TRACING");
    
    return $key_str;
}

sub contra_Update_Key_Str { ### 09/12/2010
    my $this = shift @_;
    
    my $contra_key_str = $this->construct_Update_Key_Str;
    
    $contra_key_str =~ s/=/\!=/g;
    
    return $contra_key_str;
}

sub inject_DBF_To_CGI { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;  
    
    my $row_idx = 0;
    my @CGI_var_list = $cgi->var_Name;
    
    foreach my $var_name (@{$this->{update_key_field_list}}) {    
        $cgi->push_Param($this->{update_key_field}, $cgi->param($var_name));

        #$cgi->add_Debug_Text($this->{update_key_field} . "=" . $cgi->param("$this->{update_key_field}"), __FILE__, __LINE__, "TRACING");

        my $sql = undef;

        if ($this->{sql_view} ne "") {

            $sql = $this->{sql_view};

            my $cgi_HTML = new CGI_HTML_Map;

            $cgi_HTML->set_CGI($cgi);

            $cgi_HTML->set_HTML_Code($sql);
            #$cgi_HTML->set_Escape_HTML_Tag(???); ### can be 0 or 1

            $sql = $cgi_HTML->get_HTML_Code;

        } else {
            $sql = "select * from " . $this->{table_name};

            if ($this->{update_keys_str} ne "") { ### 23/12/2010
                $sql .= " where " . $this->construct_Update_Key_Str;
            }
        }

        #$cgi->add_Debug_Text("\$sql = $sql", __FILE__, __LINE__, "TRACING");

        my $db_conn_app = $this->get_DB_Conn_App;

        my $dbihtml = new DBI_HTML_Map;

        if ($db_conn_app ne undef) {
            $dbihtml->set_DBI_Conn($db_conn_app);

        } else {
            $dbihtml->set_DBI_Conn($db_conn);
        }

        $dbihtml->set_SQL($sql);
        $dbihtml->set_HTML_Code($te_content);
        $dbihtml->set_Special_Tag_View(0);

        my $tld = $dbihtml->get_Table_List_Data;

        $this->{sql_view_result} .= $dbihtml->get_SQL . "; ";

        if ($tld) {
            my $col_num = $tld->get_Column_Num;

            for (my $i = 0; $i < $col_num; $i++) {
                my $col_name = $tld->get_Column_Name($i);
                my $col_data = $tld->get_Data(0, $tld->get_Column_Name($i));

                #$cgi->add_Debug_Text($col_name . "=" . $col_data, __FILE__, __LINE__);

                if ($cgi->param("\$db_" . $col_name) eq "") { ### allow developer to overwrite instead of 
                                                              ### default value from db
                    if ($this->{limit_on_fields_dict} ne "") {
                        if ($this->{limit_on_fields_dict}->{$col_name}) {
                            $cgi->push_Param("\$db_" . $col_name . "_$row_idx", $col_data);
                        }

                    } else {
                        $cgi->push_Param("\$db_" . $col_name . "_$row_idx", $col_data);         
                    }
                }
            }
        }
        
        $row_idx++;
    }
    
    if ($this->{sql_debug}) {
        $cgi->add_Debug_Text("SQL View = " . $this->{sql_view_result}, __FILE__, __LINE__, "DATABASE");    
    }    
}

sub check_Button_On_Submit { ### 08/12/2010
    my $this = shift @_;
    
    my $submit_option = shift @_;
    
    ### 03/03/2011
    ### besides inside $this->run_Task function, also need to put all values 
    ### checking below so $this->init_Phase and $this->confirm_Phase can be 
    ### used/called before $this->run_Task
    if ($this->{submit_button_name} eq undef) { $this->{submit_button_name} = "button_submit"; }
    if ($this->{proceed_on_submit} eq undef) { $this->{proceed_on_submit} = "Proceed"; }
    if ($this->{confirm_on_submit} eq undef) { $this->{confirm_on_submit} = "Confirm"; }
    if ($this->{edit_on_submit} eq undef) { $this->{edit_on_submit} = "Edit"; }
    if ($this->{cancel_on_submit} eq undef) { $this->{cancel_on_submit} = "Cancel"; }     
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $submit_current = $cgi->param("$this->{submit_button_name}");
    
    if ($submit_option eq "proceed_" &&
        $submit_current eq $this->{proceed_on_submit}) { 
        return 1;
    }
    
    if ($submit_option eq "confirm_" &&
        $submit_current eq $this->{confirm_on_submit}) { 
        return 1;
    }
    
    if ($submit_option eq "edit_" &&
        $submit_current eq $this->{edit_on_submit}) { 
        return 1;
    }
    
    if ($submit_option eq "cancel_" &&
        $submit_current eq $this->{cancel_on_submit}) { 
        return 1;
    }     
    
    return 0;
}

sub check_On_CGI_Data {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $status = 1;
    
    if ($this->{fe_hash} eq undef) { 
        $this->{fe_hash} = {};
    } else {
        #$cgi->add_Debug_Text("Ok not create another fe_hash inside check_On_CGI_Data", __FILE__, __LINE__, "TRACING");
    }
    
    #$cgi->add_Debug_Text("\$this->{fe_hash}->{shortname} = " . $this->{fe_hash}->{shortname}, __FILE__, __LINE__, "TRACING");
    
    if ($this->{check_on_cgi_data} ne "") {
        my @CGI_var_list = $cgi->var_Name;
        my @check_on_cgi_data = split (/ /, $this->{check_on_cgi_data});
    
        for ($i = 0; $i < @check_on_cgi_data; $i++) {
            my $fe_name = $check_on_cgi_data[$i];
               $fe_name =~ s/^\$db_/\$fe_/;
               
            my $row_idx = 0;
                
            foreach my $var_name (@{$this->{update_key_field_list}}) {
                my $fe_name_mr = $fe_name . "_$row_idx";

                if ($this->{fe_hash}->{$fe_name_mr} ne "") {
                    $status = 0;

                } else {
                    $this->{fe_hash}->{$fe_name_mr} = ""; ### just make the hash exist if it's not

                    if ($cgi->param($check_on_cgi_data[$i] . "_$row_idx") eq "") {
                        $status = 0;

                        if ($this->{map_bfe_msg}->{$fe_name_mr} ne "") {
                            $this->{fe_hash}->{$fe_name_mr} = $this->{map_bfe_msg}->{$fe_name_mr};

                        } else {
                            $this->{fe_hash}->{$fe_name_mr} .= "Error: Blank Field ";
                        }                    
                    }                
                }

                $row_idx++;
            }
        }
        
    }
    
    #foreach my $key (keys(%{$this->{fe_hash}})) {
        #$cgi->add_Debug_Text("\$this->{fe_hash}->{$key} = " . $this->{fe_hash}->{$key}, __FILE__, __LINE__, "TRACING");
    #}    
    
    return $status;
}

sub check_On_Fields_Duplication {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $db_conn_app = $this->get_DB_Conn_App;

    if ($db_conn_app ne undef) {
        $db_conn = $db_conn_app;
    }
    
    #my $dbu = new DB_Utilities;
    
    #$dbu->set_DBI_Conn($db_conn);
    
    $dbu->set_Table($this->{table_name});
    
    my $status = 1;
    
    if ($this->{fe_hash} eq undef) { 
        $this->{fe_hash} = {};
        
    } else {
        #$cgi->add_Debug_Text("Ok not create another fe_hash inside check_On_Fields_Duplication", __FILE__, __LINE__, "TRACING");
    }
    
    if ($this->{check_on_fields_duplication} ne "") {
        my $cgi_var = undef;
        my $key_first = undef;
        my $value = undef;
        
        my @CGI_var_list = $cgi->var_Name;
        
        my $row_idx = 0;
        
        ### dictionary to detect field duplication at CGI data level
        my %dict_keystr = ();
        
        my @check_on_fields_duplication = split (/ /, $this->{check_on_fields_duplication});        
                
        foreach my $var_name (@{$this->{update_key_field_list}}) {
            my $row_idx_str = "_$row_idx";

            my $update_key_field_value = $cgi->param($var_name);

            for ($i = 0; $i < @check_on_fields_duplication; $i++) {
                my $keystr = undef;
                my @combined_fields = ();
                
                if ($check_on_fields_duplication[$i] =~ /&/) {
                    my @keys = split(/&/, $check_on_fields_duplication[$i]);
                    $key_first = $keys[0];

                    foreach my $key (@keys) {
                        $cgi_var = "\$db_" . $key;
                        $value = $cgi->param($cgi_var . $row_idx_str);

                        $keystr .= "$key='$value' and ";
                        
                        push(@combined_fields, $key);
                        
                        #$cgi->add_Debug_Text("\$cgi_var = $cgi_var" . $fe_name, __FILE__, __LINE__, "TRACING");
                    }

                    $keystr .= "$this->{update_key_field} != '$update_key_field_value'";

                } else {
                    $key_first = $check_on_fields_duplication[$i];

                    $cgi_var = "\$db_" . $key_first;
                    $value = $cgi->param($cgi_var . $row_idx_str);

                    $keystr .= "$key_first='$value' and $this->{update_key_field} != '$update_key_field_value'";
                }
                
                #$cgi->add_Debug_Text("\$keystr = $keystr : " . $fe_name, __FILE__, __LINE__, "TRACING");

                my $fe_name = "\$fe_" . $key_first . $row_idx_str;
                #$cgi->add_Debug_Text("\$fe_name = " . $fe_name, __FILE__, __LINE__, "TRACING");

                if ($this->{fe_hash}->{$fe_name} ne "") { ### error might has been detected 
                                                          ### and customized by developers
                    $status = 0;

                } else {
                    $this->{fe_hash}->{$fe_name} = ""; ### just make the hash exist if it's not
                    
                    my $found_duplicate = 0;
                    
                    my $keystr_dict_fmt = $keystr;
                       $keystr_dict_fmt =~ s/ and id_.+$//;
                       
                    #$cgi->add_Debug_Text("\$keystr_dict_fmt = $keystr_dict_fmt - $dict_keystr{$keystr_dict_fmt}", __FILE__, __LINE__, "TRACING");                       
                       
                    if ($dict_keystr{$keystr_dict_fmt}) {
                        #detect field duplication at CGI data level
                        $found_duplicate = 1;
                        
                    } else {
                        $dict_keystr{$keystr_dict_fmt} = 1;

                        $dbu->set_Keys_Str($keystr);

                        if ($dbu->find_Item($key_first, undef)) {
                            $found_duplicate = 1;
                        }
                        
                        $dbu->set_Keys_Str(undef);
                        #$cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__, "DATABASE");                        
                    }
                    
                    if ($found_duplicate) {
                        $status = 0;

                        if ($this->{map_dfe_msg}->{$fe_name} ne "") {
                            $this->{fe_hash}->{$fe_name} = $this->{map_dfe_msg}->{$fe_name};

                        } else {
                            $this->{fe_hash}->{$fe_name} .= "Error: Duplicate Entry ";
                        }

                        ### if duplicate entry detected as a combination of fields
                        for (my $j = 1; $j < @combined_fields; $j++) {
                            $fe_name = "\$fe_" . $combined_fields[$j] . $row_idx_str;

                            if ($this->{map_dfe_msg}->{$fe_name} ne "") {
                                $this->{fe_hash}->{$fe_name} = $this->{map_dfe_msg}->{$fe_name};

                            } else {
                                $this->{fe_hash}->{$fe_name} .= "Error: Duplicate Entry";
                            }                    
                        }                        
                    }
                }

                #$cgi->add_Debug_Text("\$keystr = $keystr : " . $fe_name, __FILE__, __LINE__, "TRACING");
            }

            $row_idx++;
        }
    }
    
    return $status;
}

sub check_On_Fields_Existence { ### 11/10/2010
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $status = 1;
    
    if ($this->{fe_hash} eq undef) { 
        $this->{fe_hash} = {};
        
    } else {
        #$cgi->add_Debug_Text("Ok not create another fe_hash inside check_On_Fields_Existence", __FILE__, __LINE__, "TRACING");
    }
    
    if ($this->{check_on_fields_existence} ne "") {
        $this->{check_on_fields_existence} =~ s/ //g;
        
        my @fields_tables = split(/\,/, $this->{check_on_fields_existence});
        
        for (my $row_idx = 0; $row_idx < @{$this->{update_key_field_list}}; $row_idx++) {
            my $row_idx_str = "_$row_idx";
            
            foreach my $item (@fields_tables) {
                my @data = split(/=>/, $item);

                my $field = $data[0];
                my $table = $data[1];

                my $fe_name = "\$fe_" . $field . $row_idx_str;
                
                #$cgi->add_Debug_Text("$field => $table", __FILE__, __LINE__, "TRACING");

                if ($this->{fe_hash}->{$fe_name} ne "") { ### other error might has been detected 
                                                          ### previously
                    $status = 0;

                } else {
                    $this->{fe_hash}->{$fe_name} = ""; ### just make the hash exist if it's not            

                    $dbu->set_Table($table);

                    if (!$dbu->find_Item("$field", $cgi->param("\$db_" . $field . "_$row_idx"))) {
                        $status = 0;

                        if ($this->{map_efe_msg}->{$fe_name} ne "") {
                            $this->{fe_hash}->{$fe_name} = $this->{map_efe_msg}->{$fe_name};

                        } else {
                            $this->{fe_hash}->{$fe_name} .= "Error: Field's value not exist in '$table' table ";
                        }                    
                    }
                    
                    #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
                    #$cgi->add_Debug_Text("\$this->{fe_hash}->{$fe_name} = $this->{fe_hash}->{$fe_name}", __FILE__, __LINE__, "TRACING");
                }
            }
        }
    }
    
    return $status;
}

sub generate_Field_Error_Variables_Info {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    
        
    my %fe_hash = %{$this->{fe_hash}};

    my @hash_keys = keys(%fe_hash);

    foreach $hash_key (keys(%fe_hash)) {
    
        ### If $fe_hash{$hash_key} has no value it will not included as
        ### DB cached CGI variables. This help to clear DB cache from 
        ### field error CGI variables if there is no single error for
        ### for field entry (the really last phase of module process).
            
        if ($this->check_Button_On_Submit("proceed_") || $this->check_Button_On_Submit("confirm_")) {
            if (!$cgi->set_Param_Val($hash_key, $fe_hash{$hash_key})) {
                $cgi->add_Param($hash_key, $fe_hash{$hash_key});
            }
        
        } else { ### this will cover for no submit button entry and 
                 ### $this->check_Button_On_Submit("cancel_")
            if (!$cgi->set_Param_Val($hash_key, "")) {
                $cgi->add_Param($hash_key, "");
            }
        }
        
        #$cgi->add_Debug_Text("\$hash_key = " . $hash_key . " = " . $fe_hash{$hash_key}, __FILE__, __LINE__);
    }   
}

sub field_Entry_Error {
    my $this = shift @_;
    
    if ($this->{field_error_status} == 3) {
        return 0;
    }
    
    return 1;
}

sub init_Phase { ### 24/02/2011
    my $this = shift @_;
    
    if (!$this->check_Button_On_Submit("proceed_") && !$this->check_Button_On_Submit("edit_") &&
        !$this->check_Button_On_Submit("cancel_") && !$this->check_Button_On_Submit("confirm_")) {
        
        return 1;
    }
    
    return 0;
}

sub confirm_Phase { ### 15/02/2011
    my $this = shift @_;
    
    if ($this->check_On_CGI_Data && 
        $this->check_On_Fields_Duplication && 
        $this->check_On_Fields_Existence &&
        $this->check_Button_On_Submit("proceed_") && 
        $this->{template_default_confirm} ne "") {
        
        return 1;
    }    
    
    return 0;
}

sub edit_Phase {
    my $this = shift @_;
    
    return $this->check_Button_On_Submit("edit_");
}

sub last_Phase {
    my $this = shift @_;
    
    return $this->{last_phase};
}

sub last_Phase_CGI_Data_Reset {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $db_conn_app = $this->get_DB_Conn_App;
    
    $this->set_CGI_Data_Reset($this->{last_phase_cgi_data_reset});
    #$this->reset_CGI_Data;
}

sub refine_Caption_Field_Text {
    my $this = shift @_;
    
    my $text = shift @_;
    
    $text =~ s/^ //;
    $text =~ s/ $//;
    
    while ($text =~ /  /) { $text =~ s/  / /g; }
    
    return $text;
}

1;
