package wmcudas_apps_user_add;

use webman_db_item_view_dynamic;

@ISA=("webman_db_item_view_dynamic");

sub new {
    my $class = shift;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
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

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    ###########################################################################
    
    
    ###########################################################################
    
    ### the line below also remove "submission_type" from CGI var. list
    my $submission_type = $cgi->param_Shift("submission_type");
    
    my $get_data = $cgi->generate_GET_Data("link_id");
    my @cgi_var_list = $cgi->var_Name;
    
    if ($submission_type eq "parent_list") {
        $cgi->push_Param("task", "wmcudas_apps_user_list");        
        $cgi->redirect_Page("index.cgi?$get_data");
        
    } elsif ($submission_type eq "add_selected" && grep(/^id_user_36base_/, @cgi_var_list)) {  
        my $id_item_parent = $cgi->param("id_apps_36base");
        
        $cgi->push_Param("\$db_id_apps_36base", $id_item_parent);
        
        my $htmldb = new HTML_DB_Map;

        $htmldb->set_CGI($cgi);
        $htmldb->set_DBI_Conn($db_conn);
        
        ### it's the mediator table
        $htmldb->set_Table("wmcudas_userapps");        

        foreach my $var (@cgi_var_list) {                
            if ($var =~ /^id_user_36base_/) {
                my $id_item_added = $cgi->param_Shift($var);
                
                $cgi->push_Param("\$db_id_user_36base", $id_item_added);

                ### get the current number of selected item to be added
                my $num = $var;
                   $num =~ s/^id_user_36base_//;

                ### below is the example to add other none PK & FK of the mediator tables
                #my $other_mediator_field = $cgi->param_Shift("other_mediator_field_" . $num);
                #$cgi->push_Param("\$db_other_mediator_field", $other_mediator_field);
                
                
                $htmldb->insert_Table;
                
                if ($htmldb->get_DB_Error_Message ne "") {
                    $cgi->add_Debug_Text($htmldb->get_DB_Error_Message, __FILE__, __LINE__, "DATABASE");
                    $cgi->add_Debug_Text($htmldb->get_SQL, __FILE__, __LINE__, "DATABASE");
                }
                
                ### Shift all CGI variables that represent current mediator 
                ### table fields from DB cache or they will be forwarded to
                ### the next same operation on other mediator table.
                $cgi->param_Shift("\$db_id_user_36base");
            }                
        }
        
        ### enable the next 2 code lines to 
        ### directly going back to the parent list
        #$cgi->push_Param("task", undef);
        #$cgi->redirect_Page("index.cgi?$get_data");
    }    
    
    ###########################################################################
    
    $this->SUPER::run_Task();
}

sub process_DYNAMIC { ### TE_TYPE_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
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
    
    if ($te_type_name eq "parent_item_info") {
        my $id_item_parent = $cgi->param("id_apps_36base");
        
        my $component = new webman_db_item_view;

        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn);

        #$component->set_Template_Default("template_???.html");

        $component->set_SQL_Debug(1); ### 0 or 1 and default is 0

        $component->set_SQL("select * from __parent_table_name__ where id_apps_36base='$id_item_parent'");

        if ($component->authenticate($login_name, \@groups, "webman_". $cgi->param("app_name") . "_comp_auth")) {
            $component->run_Task;
            $component->process_Content;
            $component->end_Task;
        }
        
        my $content = $component->get_Content;
        
        $this->add_Content($content);
        
    } else {
        $this->SUPER::process_DYNAMIC($te);
    }
}

sub customize_SQL {
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $sql = $this->{sql};
    
    ### Next to customize the $sql string
    ### ???
    my $sql_filter = undef;
    
    
    if (!$cgi->param_Exist("filter_login_name_afls") || $cgi->param("filter_login_name_afls") eq "") {
        $cgi->push_Param("filter_login_name_afls", "\%");
    }
    my $filter_login_name_afls = $cgi->param("filter_login_name_afls");
    $sql_filter .= "login_name like '$filter_login_name_afls' and ";
    
    
    if (!$cgi->param_Exist("filter_full_name_afls") || $cgi->param("filter_full_name_afls") eq "") {
        $cgi->push_Param("filter_full_name_afls", "\%");
    }
    my $filter_full_name_afls = $cgi->param("filter_full_name_afls");
    $sql_filter .= "full_name like '$filter_full_name_afls' and ";
    
    
    if (!$cgi->param_Exist("filter_description_afls") || $cgi->param("filter_description_afls") eq "") {
        $cgi->push_Param("filter_description_afls", "\%");
    }
    my $filter_description_afls = $cgi->param("filter_description_afls");
    $sql_filter .= "description like '$filter_description_afls' and ";
    
    
    $sql_filter =~ s/ and $//;
    
    my @sql_part = split(/ order by /, $sql);
    
    #$cgi->add_Debug_Text($sql, __FILE__, __LINE__, "DATABASE");
    
    if ($sql_part[0] =~ / where /) {
        $sql = "$sql_part[0] and $sql_filter order by $sql_part[1]";
        
    } else {
        $sql = "$sql_part[0] where $sql_filter order by $sql_part[1]";
    }
    
    #$cgi->add_Debug_Text($sql, __FILE__, __LINE__, "DATABASE");
    
    return $sql;
}

sub customize_TLD {
    my $this = shift @_;
    
    my $tld = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $i = 0;
    my $tld_data = undef;
    
    my $caller_get_data = $cgi->generate_GET_Data("link_name link_id dmisn app_name");
    my $get_data = undef;
    
    $tld->add_Column("row_class");
    #__tld_add_column__    
    my $row_class = "row_even";
    
    for ($i = 0; $i < $tld->get_Row_Num; $i++) { 
        #$tld_data = $tld->get_Data($i, "col_name_");
        
        #$tld_data = "<font color=\"#0099FF\">$tld_data</font>";
            
        #$tld->set_Data($i, "col_name_", $tld_data);
        #$tld->set_Data_Get_Link($i, "col_name_", "index.cgi?$get_data", "link_properties_");
        
        $tld->set_Data($i, "row_class", "$row_class");
        
        if ($row_class eq "row_odd") {
            $row_class = "row_even";
            
        } else {
            $row_class = "row_odd";
        }        
        
        __count_related_entity_item__        
    }
    
    return $tld;
}

1;