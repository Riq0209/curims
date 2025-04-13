package webman_db_item_delete_multirows;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
        
    $this->{table_name} = undef;
    $this->{delete_keys_str} = undef;
    $this->{sql_view} = undef;
    
    $this->{db_item_auth_mode} = undef; ### 11/02/2011
    $this->{sql_debug} = undef;
    
    $this->{submit_button_name} = undef; ### 13/01/2007
    $this->{proceed_on_submit} = undef;
    $this->{cancel_on_submit} = undef;
    
    $this->{esc_datahtml_tag} = undef; ### 09/02/2011

    $this->{link_path_level_start} = undef; ### 06/02/2008
    $this->{link_path_level_deep} = undef; ### 14/12/2010
    $this->{link_path_separator_tag} = undef; ### 14/12/2010
    $this->{link_path_unselected_color} = undef; ### 14/12/2010    
    $this->{link_path_additional_get_data} = undef; ### 01/01/2009
    
    $this->{exclude_db_cache_cgi_var} = undef; ### 17/12/2008
    $this->{remove_db_cache_cgi_var} = undef; ### 05/01/2009
    
    $this->{last_phase_cgi_data_reset} = undef; ### 14/04/2008
    $this->{last_phase_url_redirect} = undef; ### 13/03/2011
    
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

sub set_Table_Name {
    my $this = shift @_;
    
    $this->{table_name} = shift @_;
}

sub set_Delete_Keys_Str {
    my $this = shift @_;
    
    $this->{delete_keys_str} = shift @_;
}

sub set_SQL_View {
    my $this = shift @_;
    
    $this->{sql_view} = shift @_;
}

sub set_SQL_Debug {
    my $this = shift @_;
    
    $this->{sql_debug} = shift @_;
}

sub get_SQL {
    my $this = shift @_;
        
    return $this->{sql};
}

sub set_Submit_Button_Name { ### 13/01/2007
    my $this = shift @_;
    
    $this->{submit_button_name} = shift @_; 
}

sub set_Proceed_On_Submit {
    my $this = shift @_;
    
    $this->{proceed_on_submit} = shift @_;
}

sub set_Cancel_On_Submit {
    my $this = shift @_;
    
    $this->{cancel_on_submit} = shift @_;
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

sub set_Last_Phase_URL_Redirect { ### 13/03/2011
    my $this = shift @_;
    
    $this->{last_phase_url_redirect} = shift @_;
}

sub get_SQL_View {
    my $this = shift @_;
    
    return $this->{sql_view};
}

sub get_SQL {
    my $this = shift @_;
        
    return $this->{sql};
}

sub get_Last_Phase_CGI_Data_Reset { ### 14/04/2008
    my $this = shift @_;
    
    return $this->{last_phase_cgi_data_reset};
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;    
    
    $this->SUPER::run_Task();
    
    my $return_status = 0;
    
    my @CGI_var_list = $cgi->var_Name;
    
    ###########################################################################
    
    ### set default value if undef
    if ($this->{db_item_auth_mode} eq "") { $this->{db_item_auth_mode} = 1; }; ### 12/02/2011
    if ($this->{submit_button_name} eq undef) { $this->{submit_button_name} = "button_submit"; }
    if ($this->{proceed_on_submit} eq undef) { $this->{proceed_on_submit} = "Proceed"; }
    if ($this->{cancel_on_submit} eq undef) { $this->{cancel_on_submit} = "Cancel"; }    
    
    ###########################################################################
    
    ### 09/12/2010
    $this->{last_phase} = 0;
    
    ###########################################################################
    ### 07/07/2011
    ### current table's primary key used for delete operation
    my $delete_key_field = $this->{delete_keys_str}; 
    
    $delete_key_field =~ s/=.+$//;
    
    while ($delete_key_field =~ / /) {
        $delete_key_field =~ s/ //;
    }
    
    $this->{delete_key_field} = $delete_key_field;
    
    my @delete_key_field_list = ();
    
    foreach my $var_name (@CGI_var_list) {
        if ($var_name =~ /^$delete_key_field/ && $cgi->param($delete_key_field) eq "") {
            $cgi->push_Param($delete_key_field, $cgi->param($var_name));
        }
        
        if ($var_name =~ /^$delete_key_field/ && $var_name =~ /_\d+$/) {
            push (@delete_key_field_list, $var_name);
        }
    }
    
    $this->{delete_key_field_list} = \@delete_key_field_list;
    
    if ($cgi->param($delete_key_field) eq "") {
        $this->{last_phase} = 1;
    }
    
    #$cgi->add_Debug_Text("\$this->{last_phase} = $this->{last_phase}", __FILE__, __LINE__);
    
    ###########################################################################
    
    if ($this->{template_default} eq "") {
        $this->{last_phase} = 1;
        
    } elsif ($this->check_Button_On_Submit("proceed_") || $this->check_Button_On_Submit("cancel_")) {
        $this->{last_phase} = 1;
    }
    
    ###########################################################################
    
    #my $dbu = new DB_Utilities;

    #my $db_conn_app = $this->get_DB_Conn_App;

    #if ($db_conn_app ne undef) {
    #    $dbu->set_DBI_Conn($db_conn_app);

    #} else {
    #    $dbu->set_DBI_Conn($db_conn);
    #}

    $dbu->set_CGI($cgi);
    
    if ($this->{last_phase} && !$this->check_Button_On_Submit("cancel_") && $this->{delete_key_field_list} ne "") {
        LOOP_DELETE: foreach my $var_name (@{$this->{delete_key_field_list}}) {    
            $cgi->push_Param($this->{delete_key_field}, $cgi->param($var_name));

            if ($this->{db_item_auth_mode}) {
                my @tables = split (/ /, $this->{table_name});

                $dbu->set_Table($tables[0]);
                $dbu->set_Keys_Str($this->construct_Delete_Key_Str);

                my $caller_get_data = $cgi->generate_GET_Data("link_id session_id") . "&$this->{submit_button_name}=$this->{cancel_on_submit}";

                $dbu->set_DB_Item_Auth_Info($login_name);
                $dbu->set_Error_Back_Link("<a href=\"index.cgi?$caller_get_data&task=\">Back to previous possible working page.</a>");

                $dbu->delete_Item(undef, undef, 0); ### not execute only prepare the sql statement

                if (!$dbu->authenticate_DB_Item_Access("DELETE")) {
                    $this->{last_phase} = 0;
                    $this->{error} = $dbu->{db_item_access_error_message};

                    $cgi->add_Debug_Text("Catch at first level DBI Access Control", __FILE__, __LINE__, "TRACING");

                    last LOOP_DELETE;
                }

                $dbu->set_Keys_Str(undef);
            }

            if ($this->{table_name} ne "" && $this->{last_phase} &&
                $this->construct_Delete_Key_Str ne "" && !$this->check_Button_On_Submit("cancel_")) {

                my @tables = split (/ /, $this->{table_name});

                foreach my $table (@tables) {
                    $dbu->set_Table($table);
                    $dbu->set_Keys_Str($this->construct_Delete_Key_Str);

                    if ($this->{db_item_auth_mode}) {
                        my $caller_get_data = $cgi->generate_GET_Data("link_id session_id") . "&$this->{submit_button_name}=$this->{cancel_on_submit}";
                        $dbu->set_DB_Item_Auth_Info($login_name);
                        $dbu->set_Error_Back_Link("<a href=\"index.cgi?$caller_get_data\">Back to previous possible working page.</a>");
                    }

                    $dbu->delete_Item;
                    #$cgi->add_Debug_Text("key str = " . $this->construct_Delete_Key_Str, __FILE__, __LINE__, "DATABASE");
                    #$cgi->add_Debug_Text("\$dbu->get_SQL = " . $dbu->get_SQL, __FILE__, __LINE__, "DATABASE");

                    if ($dbu->{db_item_access_error_message} ne "") {
                        $this->{last_phase} = 0;
                        $this->{error} = $dbu->{db_item_access_error_message};
                        $return_status = 0;

                    } else {
                        $return_status = 1;
                    }

                    $this->{sql} .= $dbu->get_SQL . "; ";

                    $dbu->set_Keys_Str(undef);
                }        
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
    
    my @CGI_var_name = $cgi->var_Name;
    
    foreach my $var_name (@CGI_var_name) {
        if ($var_name =~ /^\$db_/) {
            $this->{last_phase_cgi_data_reset} .= "$var_name ";
        }
        
        if ($var_name =~ /^$delete_key_field/) {
            $this->{last_phase_cgi_data_reset} .= "$var_name ";
        }        
    }
    
    #$cgi->add_Debug_Text("\$this->{last_phase_cgi_data_reset} = $this->{last_phase_cgi_data_reset}", __FILE__, __LINE__);
    
    if ($this->{last_phase}) { ### a normal last phase ### 17/01/2011
        $this->last_Phase_CGI_Data_Reset;
        
        if ($this->{last_phase_url_redirect} ne "") { ### 13/03/2012
            #$cgi->add_Debug_Text("Ready to redirect to $this->{last_phase_url_redirect}", __FILE__, __LINE__);

            my $cgi_HTML = new CGI_HTML_Map; ### 10/02/2013

            $cgi_HTML->set_CGI($cgi);
            $cgi_HTML->set_HTML_Code($this->{last_phase_url_redirect});
      
            $cgi->redirect_Page($cgi_HTML->get_HTML_Code);
        }        
    }
    
    return $return_status;
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
            !$this->check_Button_On_Submit("cancel_") &&
            !$this->{last_phase}) { ### first time call so need to inject DB fields into CGI data
            
            if ($this->{template_default} ne "") { ### and only if confirmation is applied
                $this->inject_DBF_To_CGI;
            }
        }        
        
        my $data_HTML = new Data_HTML_Map;
        
        for (my $row_idx = 0;  $row_idx < @{$this->{delete_key_field_list}}; $row_idx++) {
            my $row_num = $row_idx + 1;
            my $content_temp = $te_content;

            $content_temp =~ s/\$row_num_/$row_num/g;
            $content_temp =~ s/\$row_idx/$row_idx/g;
            
            $data_HTML->set_CGI($cgi);
            $data_HTML->set_HTML_Code($content_temp);
            $data_HTML->set_Special_Tag_View($this->{esc_datahtml_tag}); ### can be 0 or 1

            $content .= $data_HTML->get_HTML_Code;
        }
    }
    
    $this->add_Content($this->refine_Confirm_DB_Field_Row_Str($content));
}

### Provide more flexibility inside the child module so developers can 
### further refine the final constructed confirm-field-row string using 
### Perl's regular expression and string substitutions.
sub refine_Confirm_DB_Field_Row_Str {
    my $this = shift @_;
    my $str = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    #for (my $row_idx = 0;  $row_idx < @{$this->{delete_key_field_list}}; $row_idx++) {
        #$str =~ ....;
    #}
    
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
    
    if ($this->{dbi_app_conn} ne "") {
        
        my @spliters = split(/ /, $this->{dbi_app_conn});
        
        my $db_conn = DBI->connect("DBI:$spliters[0]:dbname=$spliters[1]", "$spliters[2]", "$spliters[3]");
        
        return $db_conn;
    }
    
    return undef;
}

sub construct_Delete_Key_Str { ### 09/12/2010
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    
    my $key_str = $this->{delete_keys_str};

    my $cgi_HTML = new CGI_HTML_Map;
        
    $cgi_HTML->set_CGI($cgi);
    
    $cgi_HTML->set_HTML_Code($key_str);
    #$cgi_HTML->set_Escape_HTML_Tag(???); ### can be 0 or 1
    
    $key_str = $cgi_HTML->get_HTML_Code;
    
    return $key_str;
}

sub inject_DBF_To_CGI { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;  

    my $row_idx = 0;
    
    foreach my $var_name (@{$this->{delete_key_field_list}}) {    
        $cgi->push_Param($this->{delete_key_field}, $cgi->param($var_name));
        
        my $sql = undef;

        if ($this->{sql_view} ne "") {

            $sql = $this->{sql_view};

            my $cgi_HTML = new CGI_HTML_Map;

            $cgi_HTML->set_CGI($cgi);

            $cgi_HTML->set_HTML_Code($sql);
            $cgi_HTML->set_Escape_HTML_Tag(0); ### can be 0 or 1

            $sql = $cgi_HTML->get_HTML_Code;

        } else {
            $sql = "select * from " . $this->{table_name};

            if ($this->{delete_keys_str} ne "") { ### 23/12/2010
                $sql .= " where " . $this->construct_Delete_Key_Str;
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
        $dbihtml->set_Special_Tag_View(0);

        my $tld = $dbihtml->get_Table_List_Data;

        $this->{sql_view_result} .= $dbihtml->get_SQL . "; ";    

        if ($tld) {
            my $col_num = $tld->get_Column_Num;

            for (my $i = 0; $i < $col_num; $i++) {
                my $col_name = $tld->get_Column_Name($i);
                my $col_data = $tld->get_Data(0, $tld->get_Column_Name($i));

                #$cgi->add_Debug_Text($col_name . "=" . $col_data, __FILE__, __LINE__);

                $cgi->push_Param("\$db_" . $col_name . "_$row_idx", $col_data);      
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
    if ($this->{cancel_on_submit} eq undef) { $this->{cancel_on_submit} = "Cancel"; }     
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $submit_current = $cgi->param($this->{submit_button_name});
    
    if ($submit_option eq "proceed_" &&
        $submit_current eq $this->{proceed_on_submit}) { 
        return 1;
    }
        
    if ($submit_option eq "cancel_" &&
        $submit_current eq $this->{cancel_on_submit}) { 
        return 1;
    }     
    
    return 0;
}

sub confirm_Phase { ### 12/03/2011
    my $this = shift @_;
    
    if (!$this->check_Button_On_Submit("proceed_") &&
        !$this->check_Button_On_Submit("cancel_") && 
        $this->{template_default} ne "") {
        
        return 1;
    }
    
    return 0;
}

sub last_Phase { ### 12/03/2011
    my $this = shift @_;
    
    if ($this->{template_default} eq "") {
        return 1;
    }
    
    if ($this->check_Button_On_Submit("proceed_") || 
        $this->check_Button_On_Submit("cancel_")) {
        
        return 1;
    }
    
    return 0;
}

sub check_Proceed_On_Submit {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $submit_button_name = undef;
    
    if ($this->{submit_button_name} eq undef) { ### 13/01/2007
        $submit_button_name = "submit";
        
    } else {
        $submit_button_name = $this->{submit_button_name};
    }
    
    my $submit = $cgi->param("$submit_button_name");
    
    #print "\$submit_button_name = $submit_button_name <br>";
    #print "\$submit = $submit <br>";
    
    if ($this->{proceed_on_submit} eq "") {
        return 1;
        
    } else {
        if ($this->{proceed_on_submit} eq $submit) { 
            return 1;
            
        } else {
            return 0;
        }
    }
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

1;
