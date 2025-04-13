package webman_db_item_search;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use webman_db_item_view;
use webman_db_item_view_dynamic;

sub new {
    my $class = shift;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    $this->{template_default_found} = undef;
    $this->{template_default_found_list} = undef;
    
    ### 25/03/2016
    $this->{always_display_as_list} = undef;
    
    $this->{table_name} = undef;
    
    ### Human friendly key name for search 
    ### operation such as nric, matric no., etc.
    $this->{key_field_search} = undef;
    
    ### Mainly used as a key to integrate search  
    ### with update/delete operations. Might be 
    ### the same with key_field_search or other 
    ### auto generate random key to avoid users 
    ### easily guess the key value and increase 
    ### the possibilities of sql data tampering 
    ### attack.
    $this->{key_field_primary} = undef;
    
    ### message when item is not found
    $this->{not_found_message} = undef; 
    
    ### Automatically generated based on table_name
    ### and key_field member variables. It can also
    ### be set manually for more complex search 
    ### operation. CGI variables are passed to this
    ### sql member variable by using the pattern 
    ### $cgi_field_name_
    $this->{sql} = undef;
    
    ### Options [0|1] to debug the sql statement used
    ### for search operation as a CGI debug text
    $this->{sql_debug} = undef;
    
    $this->{item_found_url_redirect} = undef; ### 13/08/2011
    
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

sub set_Template_Default_Found {
    my $this = shift @_;
    
    $this->{template_default_found} = shift @_;
}

sub set_Template_Default_Found_List {
    my $this = shift @_;
    
    $this->{template_default_found_List} = shift @_;
}

sub set_Table_Name {
    my $this = shift @_;
    
    $this->{table_name} = shift @_;
}

sub set_Key_Field_Search {
    my $this = shift @_;
    
    $this->{key_field_search} = shift @_;
}

sub set_Key_Field_Primary {
    my $this = shift @_;
    
    $this->{key_field_primary} = shift @_;
}

sub set_SQL {
    my $this = shift @_;
    
    $this->{sql} = shift @_;
}

sub set_SQL_Debug {
    my $this = shift @_;
    
    $this->{sql_debug} = shift @_;
}

sub set_Not_Found_Message {
    my $this = shift @_;
    
    $this->{not_found_message} = shift @_;
}

sub set_Item_Found_URL_Redirect {
    my $this = shift @_;
    
    $this->{item_found_url_redirect} = shift @_;
}

sub get_SQL {
    my $this = shift @_;
        
    return $this->{sql};
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
    
    $this->{found} = 0;
    
    ###########################################################################
    
    my @kfs_list = split(/ /, $this->{key_field_search});
    my @kfs_available = ();
    
    foreach my $kfs (@kfs_list) {
        if (!$cgi->param_Exist($kfs)) {
            $cgi->push_Param($kfs, "");
            
        } elsif ($cgi->param($kfs) ne "") {
            push(@kfs_available, $kfs);
        }
    }
    
    if (@kfs_available > 0) {
        $dbu->set_Table($this->{table_name});
        
        if (!defined($this->{sql})) {
            my $keys_str = undef;
            
            foreach my $kfs (@kfs_available) {
                $keys_str .= "$kfs='" . $cgi->param($kfs) . "' and ";
            }
            
            $keys_str =~ s/and $//;
            
            $this->{keys_str} = $keys_str;
            
            $dbu->set_Keys_Str($this->{keys_str});
            
            #$cgi->add_Debug_Text("\$keys_str = $keys_str", __FILE__, __LINE__, "TRACING");
            
            $this->{total_item_found} = $dbu->count_Item;
            
            #$cgi->add_Debug_Text("\$this->{total_item_found} = $this->{total_item_found}", __FILE__, __LINE__, "TRACING");
            
            if ($this->{total_item_found} > 0) {
                $this->{found} = 1;
            }
            
            $this->{sql} = "select * from $this->{table_name} where $keys_str";
            
            my $sql = $this->customize_SQL;
            
            if ($this->{sql} ne $sql) {
                $this->{sql} = $sql;
                
                my @sql_part = split(/where/, $this->{sql});
                
                $this->{keys_str} = $sql_part[1];
                
                $dbu->set_Keys_Str($this->{keys_str});
                $this->{total_item_found} = $dbu->count_Item;
                
                if ($this->{total_item_found} > 0) {
                    $this->{found} = 1;
                }                
            }
            
            if ($this->{sql_debug}) {
                $cgi->add_Debug_Text("Query Find: " . $dbu->get_SQL, __FILE__, __LINE__);
            }
            
            $dbu->set_Keys_Str(undef);
        
        } else {
            my $cgi_HTML = new CGI_HTML_Map;

            $cgi_HTML->set_CGI($cgi);
            
            #$cgi->add_Debug_Text("$this->{sql}", __FILE__, __LINE__, "TRACING");

            $cgi_HTML->set_HTML_Code($this->{sql});
            $cgi_HTML->set_Escape_HTML_Tag(0); ### can be 0 or 1

            $this->{sql} = $cgi_HTML->get_HTML_Code;
            $this->{sql} = $this->customize_SQL;
            
            #$cgi->add_Debug_Text("$this->{sql}", __FILE__, __LINE__, "TRACING");
            
            my @sql_part = split(/ where /i, $this->{sql});
            
            $dbu->set_Keys_Str($sql_part[1]);
            
            $this->{total_item_found} = $dbu->count_Item;
            
            if ($this->{total_item_found} > 0) {
                $this->{found} = 1;
            }
            
            if ($this->{sql_debug}) {
                $cgi->add_Debug_Text("Query Find: " . $dbu->get_SQL, __FILE__, __LINE__);
            }            
            
            $dbu->set_Keys_Str(undef);
        }
    }   
    
    if ($this->{sql_debug}) {
        $cgi->add_Debug_Text("Query List: " . $this->{sql}, __FILE__, __LINE__, "DATABASE");
    }    
    
    if ($this->{found}) {    
        ### Add table's primary key in CGI variable list as a
        ### key for integration with update/delete operations.
        ### If the primary key is the same with the search key
        ### it should be already available inside CGI var. cache
        if ($this->{key_field_primary} ne $this->{key_field_search}) {
            $dbu->set_Keys_Str($this->{keys_str});
            my $pk_val = $dbu->get_Item($this->{key_field_primary});
            $dbu->set_Keys_Str(undef);

            $cgi->push_Param($this->{key_field_primary}, $pk_val);
        }
        
        $this->redirect_Page;     
        
    } else {
        if (defined($this->{keys_str}) ne "" && !defined($this->{not_found_message})) {
            $this->{not_found_message} = "<font color=\"#FF0000\">No item found for current search entry.</font>";
        }
    }    
    
    return $this->{found};
}

sub process_Content {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    #$cgi->add_Debug_Text("\!\$this->field_Entry_Error = " . !$this->field_Entry_Error, __FILE__, __LINE__);
    
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
    
    if ($te_type_name eq "search_result") {
        if ($this->{found}) {
            my $component = undef;
            
            if ($this->{total_item_found} > 1 || $this->{always_display_as_list}) {
                $component = new webman_db_item_view_dynamic;
                
                $component->set_DB_Items_Set_Num_Var("dbisn_found"); 
                $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_found");
                
            } else {
                $component = new webman_db_item_view;
            }

            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn);
            
            if ($this->{total_item_found} > 1 || $this->{always_display_as_list}) {
                $component->set_Template_Default($this->{template_default_found_list});
                
            } else {
                $component->set_Template_Default($this->{template_default_found});
            }

            $component->set_SQL_Debug($num); ### 0 or 1 and default is 0
            
            $component->set_SQL($this->{sql});

            #if ($component->authenticate($login_name, \@groups, "webman_". $cgi->param("app_name") . "_comp_auth")) {
                $component->run_Task;
                $component->process_Content;
                $component->end_Task;
            #}

            $te_content = $component->get_Content;
            
        } else {
            $te_content = $this->{not_found_message};
        }
    }
    
    $this->add_Content($te_content);
}

### 19/03/2012
### Still not found the strength reasons to override this function.
#sub process_CGIHTML { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
#    my $this = shift @_;
#    my $te = shift @_;

#    my $cgi = $this->get_CGI;
#    my $db_conn = $this->get_DB_Conn;
#    my $db_interface = $this->get_DB_Interface;    
    
#    my $te_content = $te->get_Content;
#    my $te_type_num = $te->get_Type_Num;
#    my $te_type_name = $te->get_Name;
    
#    if ($te_type_name eq "link_update_delete") {
#        if ($this->{found}) {
#            $this->SUPER::process_CGIHTML($te);
#        }
        
#    } else {
#        $this->SUPER::process_CGIHTML($te);
#    }
#}

sub redirect_Page {
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    if ($this->{item_found_url_redirect} ne "") {
        my $new_url = $this->translate_CGI_HTML_Map_Key_Str($this->{item_found_url_redirect});
        #$cgi->add_Debug_Text("\$new_url = $new_url", __FILE__, __LINE__, "TRACING");
        $cgi->redirect_Page($new_url);
    }    
}

sub customize_SQL { 
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $sql = $this->{sql};
    
    ### Next to customize the $sql string
    ### ???
    
    return $sql;
}

1;
