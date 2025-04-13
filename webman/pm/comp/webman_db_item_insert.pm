package webman_db_item_insert;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
    
    my $this = $class->SUPER::new();  
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    $this->{template_default_confirm} = undef;
        
    $this->{table_name} = undef;
    $this->{exceptional_db_fields} = undef; ### 12/04/2008
    $this->{db_item_auth_mode} = undef; ### 11/02/2011
    $this->{sql_debug} = shift @_;
    
    $this->{submit_button_name} = undef; ### 13/01/2007
    $this->{proceed_on_submit} = undef;
    $this->{confirm_on_submit} = undef; ### 18/12/2008
    $this->{edit_on_submit} = undef; ### 08/12/2010
    $this->{cancel_on_submit} = undef;
    
    $this->{check_on_cgi_data} = undef;
    $this->{check_on_fields_duplication} = undef;
    $this->{check_on_fields_existence} = undef; ### 10/10/2011
    $this->{esc_datahtml_tag} = undef; ### 09/02/2011
    
    $this->{map_blank_fields_error_msg} = undef; ### 24/12/2010
    $this->{map_duplicate_fields_error_msg} = undef; ### 24/12/2010
    $this->{map_existence_fields_error_msg} = undef; ### 10/10/2011

    $this->{link_path_level_start} = undef; ### 06/02/2008
    $this->{link_path_level_deep} = undef; ### 14/12/2010
    $this->{link_path_separator_tag} = undef; ### 14/12/2010
    $this->{link_path_unselected_color} = undef; ### 14/12/2010
    $this->{link_path_additional_get_data} = undef; ### 01/01/2009
    
    $this->{exclude_db_cache_cgi_var} = undef; ### 17/12/2008
    $this->{remove_db_cache_cgi_var} = undef; ### 02/01/2009
    
    $this->{last_phase_cgi_data_reset} = undef; ### 14/04/2008
    $this->{last_phase_only_if_submit_is} = undef; ### 15/12/2010    
    
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

sub set_DBI_App_Conn {
    my $this = shift @_;
    
    $this->{dbi_app_conn} = shift @_;
}

sub set_Template_Default {
    my $this = shift @_;
    
    $this->{template_default} = shift @_;
}

sub set_Template_Default_Confirm {
    my $this = shift @_;
    
    $this->{template_default_confirm} = shift @_;
}

sub set_Table_Name {
    my $this = shift @_;
    
    $this->{table_name} = shift @_;
}

sub set_Exceptional_DB_Fields { ### 12/04/2008
    my $this = shift @_;
    
    $this->{exceptional_db_fields} = shift @_;
}

sub set_SQL_Debug {
    my $this = shift @_;
    
    $this->{sql_debug} = shift @_;
}

sub set_Submit_Button_Name { ### 13/01/2007
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

sub set_Edit_On_Submit {
    my $this = shift @_;
    
    $this->{edit_on_submit} = shift @_;
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

sub set_Last_Phase_CGI_Data_Reset { ### 14/04/2008
    my $this = shift @_;
    
    $this->{last_phase_cgi_data_reset} = shift @_;
}

sub set_Last_Phase_Only_If_Submit_Is { ### 15/04/2008
    my $this = shift @_;
    
    $this->{last_phase_only_if_submit_is} = shift @_;
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
    
    if ($this->{map_existence_fields_error_msg} ne "") { ### developers want to want to customize existence fields error message
        $this->{map_efe_msg} = {};     
        
        my @field_error = split(/,/, $this->{map_existence_fields_error_msg});

        foreach my $item (@field_error) {
            my @spliter = split(/=>/, $item);

            my $field = $this->refine_Caption_Field_Text($spliter[0]);
            my $error = $this->refine_Caption_Field_Text($spliter[1]);

            #$cgi->add_Debug_Text("field : error = $field : $error", __FILE__, __LINE__);

            $this->{map_efe_msg}->{"\$fe_" . $field} = $error;
        }
    }    
    
    ###########################################################################
    
    ### 15/12/2010
    ### set default value if undef
    if ($this->{db_item_auth_mode} eq "") { $this->{db_item_auth_mode} = 1; }
    if ($this->{submit_button_name} eq undef) { $this->{submit_button_name} = "button_submit"; }
    if ($this->{proceed_on_submit} eq undef) { $this->{proceed_on_submit} = "Proceed"; }
    if ($this->{confirm_on_submit} eq undef) { $this->{confirm_on_submit} = "Confirm"; }
    if ($this->{edit_on_submit} eq undef) { $this->{edit_on_submit} = "Edit"; }
    if ($this->{cancel_on_submit} eq undef) { $this->{cancel_on_submit} = "Cancel"; }
    
    ### 09/12/2010
    $this->{last_phase} = 0;
    
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
    
    $total_status += $this->{field_error_status};
    
    if ($total_status == 4) {
        $this->{last_phase} = 1;
    }
    
    #$cgi->add_Debug_Text("\$this->{field_error_status} = $this->{field_error_status}", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$total_status = $total_status", __FILE__, __LINE__, "TRACING");
    
    $this->generate_Field_Error_Variables_Info; ### can only be called after check_On_CGI_Data 
                                                ### and check_On_Fields_Duplication methods invoked
    
    ############################################################################
    
    #print "\$this->{table_name} = " . $this->{table_name} . "<br>";

    my $htmldb = new HTML_DB_Map;

    $htmldb->set_CGI($cgi);
    $htmldb->set_DBI_Conn($db_conn);
    $htmldb->set_Table($this->{table_name});

    if ($this->{exceptional_db_fields} ne "") { ### 12/04/2008
        $htmldb->set_Exceptional_Fields($this->{exceptional_db_fields});
    }    
    
    if ($this->{db_item_auth_mode}) {
        my $caller_get_data = $cgi->generate_GET_Data("link_id session_id") . "&$this->{submit_button_name}=$this->{cancel_on_submit}";
        my $db_item_auth_table_name = "webman_" . $cgi->param("app_name") . "_db_item_auth";

        $htmldb->set_DB_Item_Auth_Info($login_name, \@groups, $db_item_auth_table_name);
        $htmldb->set_Error_Back_Link("<a href=\"index.cgi?$caller_get_data&task=\">Back to previous possible working page.</a>");
        
        $htmldb->insert_Table(0); ### not execute only prepare the sql statement
        
        if ($htmldb->{db_item_access_error_message} ne "") {
            $this->{last_phase} = 0;
            $this->{error} = $htmldb->{db_item_access_error_message};
            
            $cgi->add_Debug_Text("Catch at first level DBI Access Control", __FILE__, __LINE__, "TRACING");
        }
    }    
    
    if ($this->{table_name} ne "" && $this->{last_phase} && !$this->check_Button_On_Submit("cancel_")) {
        $this->customize_CGI_Data;
        $htmldb->insert_Table;
        $return_status = 1;
        
        if ($htmldb->get_DB_Error_Message ne "") {
            $return_status = 0;
            $cgi->add_Debug_Text("Database Error: " . $htmldb->get_DB_Error_Message, __FILE__, __LINE__, "DATABASE");
        }        
        
        $this->{sql} =  $htmldb->get_SQL;
        
        if ($this->{sql_debug}) {
            $cgi->add_Debug_Text("SQL = " . $this->{sql}, __FILE__, __LINE__, "DATABASE");
        }        
    }
    
    ###########################################################################
    
    my $current_submit = $cgi->param($this->{submit_button_name});
    
    #$cgi->add_Debug_Text("$current_submit : $this->{last_phase_only_if_submit_is}", __FILE__, __LINE__);
    
    if ($this->{last_phase_only_if_submit_is} ne "") { 
        if ($current_submit ne $this->{last_phase_only_if_submit_is}) {
            if ($this->{last_phase}) {
                $this->{last_phase_cgi_data_reset} = "$this->{submit_button_name} "; ### special 'task' CGI variable name
                                                                                     ### is not included so it can keep 
                                                                                     ### displaying the insert form
                                                                                     
                $this->last_Phase_CGI_Data_Reset; ### need this since it will not be called after
                                                  ### $this->{last_phase} is set back to '0'
                                                  
                $this->{last_phase} = 0;
            }
            
        } else { ### without this it's only working if $this->{last_phase_only_if_submit_is}
                 ### is equal with $this->{cancel_on_submit} or $this->{confirm_on_submit}
                 
            $this->{last_phase} = 1;
        }
        
    }
    
    if ($this->{last_phase}) { ### a normal last phase ### 17/01/2011
        $this->last_Phase_CGI_Data_Reset;
    }
    
    ###########################################################################
    
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
    
    if ($this->{esc_datahtml_tag} eq "") { $this->{esc_datahtml_tag} = 1; }
    
    my $content = undef;
    
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
        my $post_data = undef;

        my $data_HTML = new Data_HTML_Map;

        $data_HTML->set_CGI($cgi);
        $data_HTML->set_Special_Tag_View($this->{esc_datahtml_tag}); ### can be 0 or 1
        
        my $content_temp = $te_content;
            
        $data_HTML->set_HTML_Code($content_temp);
        
        my $content_temp = $data_HTML->get_HTML_Code;
        
        ### next is to help clear the default value even cgi database field data sill not exist
        
        ### for input type text
        $content_temp =~ s/value *= *"\$db_.+_"/value=""/g;

        ### for text area
        $content_temp =~ s/> *\$db_.+_ *</></g;

            
        $content .= $content_temp;
    }
    
    $this->add_Content($content);
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    $this->add_Content($te_content);
}

sub get_DB_Conn_App {
    my $this = shift @_;
    
    if ($this->{dbi_app_conn} ne "") {
        
        my @spliters = split(/ /, $this->{dbi_app_conn});
        
        my $db_conn = DBI->connect("DBI:$spliters[0]:dbname=$spliters[1]", "$spliters[2]", "$spliters[3]");
        
        return $db_conn;
    }
    
    return undef;
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
    
    my $submit_current = $cgi->param($this->{submit_button_name});
    
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
    
        my @check_on_cgi_data = split(/ /, $this->{check_on_cgi_data});
    
        for ($i = 0; $i < @check_on_cgi_data; $i++) {
            my $fe_name = $check_on_cgi_data[$i];
               $fe_name =~ s/^\$db_/\$fe_/;
               
            if ($this->{fe_hash}->{$fe_name} ne "") {
                $status = 0;
                
            } else {
                $this->{fe_hash}->{$fe_name} = ""; ### just make the hash exist if it's not
                
                if ($cgi->param($check_on_cgi_data[$i]) eq "") {
                    $status = 0;
                    
                    if ($this->{map_bfe_msg}->{$fe_name} ne "") {
                        $this->{fe_hash}->{$fe_name} = $this->{map_bfe_msg}->{$fe_name};
                        
                    } else {
                        $this->{fe_hash}->{$fe_name} .= "Error: Blank Field";
                    }                    
                }                
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
        
        my @check_on_fields_duplication = split(/ /, $this->{check_on_fields_duplication});
    
        for (my $i = 0; $i < @check_on_fields_duplication; $i++) {
            my $keystr = undef;
            my @combined_fields = ();
            
            if ($check_on_fields_duplication[$i] =~ /&/) {
                my @key_list = split(/&/, $check_on_fields_duplication[$i]);
                $key_first = $key_list[0];
                
                foreach my $key (@key_list) {
                    $cgi_var = "\$db_" . $key;
                    $value = $cgi->param($cgi_var);
                    
                    $keystr .= "$key='$value' and ";
                    
                    push(@combined_fields, $key);
                    
                    #$cgi->add_Debug_Text("\$cgi_var = $cgi_var" . $fe_name, __FILE__, __LINE__, "TRACING");
                }
                
                $keystr =~ s/ and $//;
                #$cgi->add_Debug_Text("\$keystr = $keystr : " . $fe_name, __FILE__, __LINE__, "TRACING");
                
            } else {
                $key_first = $check_on_fields_duplication[$i];
                
                $cgi_var = "\$db_" . $key_first;
                $value = $cgi->param($cgi_var);

                $keystr .= "$key_first='$value'";
                #$cgi->add_Debug_Text("\$keystr = $keystr : " . $fe_name, __FILE__, __LINE__, "TRACING");
            }
            
            my $fe_name = "\$fe_" . $key_first;
            #$cgi->add_Debug_Text("\$fe_name = " . $fe_name, __FILE__, __LINE__, "TRACING");

            if ($this->{fe_hash}->{$fe_name} ne "") { ### other error might has been detected 
                                                      ### previously
                $status = 0;
                
            } else {
                $this->{fe_hash}->{$fe_name} = ""; ### just make the hash exist if it's not
                
                $dbu->set_Keys_Str($keystr);

                if ($dbu->find_Item($key_first, undef)) {
                    $status = 0;
                    
                    if ($this->{map_dfe_msg}->{$fe_name} ne "") {
                        $this->{fe_hash}->{$fe_name} = $this->{map_dfe_msg}->{$fe_name};
                        
                    } else {
                        $this->{fe_hash}->{$fe_name} .= "Error: Duplicate Entry";
                    }
                    
                    #$cgi->add_Debug_Text("\$this->{fe_hash}->{$fe_name} = $this->{fe_hash}->{$fe_name}", __FILE__, __LINE__, "TRACING");
                    
                    ### if duplicate entry detected as a combination of fields
                    for (my $j = 1; $j < @combined_fields; $j++) {
                        $fe_name = "\$fe_" . $combined_fields[$j];
                        
                        if ($this->{map_dfe_msg}->{$fe_name} ne "") {
                            $this->{fe_hash}->{$fe_name} = $this->{map_dfe_msg}->{$fe_name};

                        } else {
                            $this->{fe_hash}->{$fe_name} .= "Error: Duplicate Entry";
                        }                    
                    }
                }

                $dbu->set_Keys_Str(undef);

                #$cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__, "DATABASE");                
            }
            
            #$cgi->add_Debug_Text("\$keystr = $keystr : " . $fe_name, __FILE__, __LINE__, "TRACING");
        }
    }
    
    return $status;
}

sub check_On_Fields_Existence { ### 10/10/2010
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
        
        foreach my $item (@fields_tables) {
            my @data = split(/=>/, $item);
            
            my $field = $data[0];
            my $table = $data[1];
            
            #$cgi->add_Debug_Text("$field => $table", __FILE__, __LINE__);
            
            my $fe_name = "\$fe_" . $field;
            
            if ($this->{fe_hash}->{$fe_name} ne "") { ### other error might has been detected 
                                                      ### previously
                $status = 0;
                
            } else {
                $this->{fe_hash}->{$fe_name} = ""; ### just make the hash exist if it's not            
            
                $dbu->set_Table($table);

                if (!$dbu->find_Item("$field", $cgi->param("\$db_" . $field))) {
                    $status = 0;
                    
                    if ($this->{map_efe_msg}->{$fe_name} ne "") {
                        $this->{fe_hash}->{$fe_name} = $this->{map_efe_msg}->{$fe_name};
                        
                    } else {
                        $this->{fe_hash}->{$fe_name} .= "Error: Field's value not exist in '$table' table";
                    }                    
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
    
    my $cgi = $this->get_CGI;
    
    #$cgi->add_Debug_Text("fields existence = " . $this->check_On_Fields_Existence, __FILE__, __LINE__, "TRACING");

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
    
    ### 03/03/2011
    ### besides inside $this->run_Task function, also need to put all last 
    ### phase mechanism checking below so $this->last_Phase can be used/called
    ### before calling $this->run_Task    
    
    if ($this->check_Button_On_Submit("cancel_")) {
        $this->{last_phase} = 1;
        
        return $this->{last_phase};
    }
    
    my $total_status = 0;
    
    if ($this->{template_default_confirm} eq "") {
        $total_status = $this->check_Button_On_Submit("proceed_");
        
    } else {
        $total_status = $this->check_Button_On_Submit("confirm_");
    }
    
    $this->{field_error_status} = $this->check_On_CGI_Data + 
                                  $this->check_On_Fields_Existence + 
                                  $this->check_On_Fields_Duplication;
    
    $total_status += $this->{field_error_status};
    
    if ($total_status == 4) {
        $this->{last_phase} = 1;
    }
    
    #$cgi->add_Debug_Text("\$this->{field_error_status} = $this->{field_error_status}", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$total_status = $total_status", __FILE__, __LINE__);    
    
    return $this->{last_phase};
}

sub last_Phase_CGI_Data_Reset {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $db_conn_app = $this->get_DB_Conn_App;
    
    ### try to auto set all possible data related CG database cache variables
    
    if ($this->{last_phase_cgi_data_reset} eq "") { 
        $this->{last_phase_cgi_data_reset} = "task $this->{submit_button_name} ";
        
    } elsif (!($this->{last_phase_cgi_data_reset} =~ / $/)) {
        $this->{last_phase_cgi_data_reset} .= " ";
    }
    
    my @CGI_var_name = $cgi->var_Name;
    
    foreach my $var_name (@CGI_var_name) {
        if ($var_name =~ /^\$db_/) {
            $this->{last_phase_cgi_data_reset} .= "$var_name ";
        }
    }
    
    #$cgi->add_Debug_Text("\$this->{last_phase_cgi_data_reset} = $this->{last_phase_cgi_data_reset}", __FILE__, __LINE__);        
    
    ###########################################################################
    
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
