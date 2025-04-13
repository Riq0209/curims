package __component_name__;

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
    
    __push_param_parent_UK_start__
    $dbu->set_Table("__parent_table__");
    my $__parent_UK__ = $dbu->get_Item("__parent_UK__", "__parent_PK__", $cgi->param("__parent_PK__"));
    $cgi->push_Param("__parent_UK__", "$__parent_UK__");
    __push_param_parent_UK_end__
    
    ###########################################################################
    
    ### the line below also remove "submission_type" from CGI var. list
    my $submission_type = $cgi->param_Shift("submission_type");
    
    my $get_data = $cgi->generate_GET_Data("link_id");
    my @cgi_var_list = $cgi->var_Name;
    
    if ($submission_type eq "parent_list") {
        $cgi->push_Param("task", __task_parent_list__);        
        $cgi->redirect_Page("index.cgi?$get_data");
        
    } elsif ($submission_type eq "add_selected" && grep(/^__id_item_added___/, @cgi_var_list)) {  
        my $id_item_parent = $cgi->param("__id_item_parent__");
        
        $cgi->push_Param("\$db___id_item_parent__", $id_item_parent);
        
        my $htmldb = new HTML_DB_Map;

        $htmldb->set_CGI($cgi);
        $htmldb->set_DBI_Conn($db_conn);
        
        ### it's the mediator table
        $htmldb->set_Table("__mediator_table_name__");        

        foreach my $var (@cgi_var_list) {                
            if ($var =~ /^__id_item_added___/) {
                my $id_item_added = $cgi->param_Shift($var);
                
                $cgi->push_Param("\$db___id_item_added__", $id_item_added);

                ### get the current number of selected item to be added
                my $num = $var;
                   $num =~ s/^__id_item_added___//;

                ### below is the example to add other none PK & FK of the mediator tables
                #my $other_mediator_field = $cgi->param_Shift("other_mediator_field_" . $num);
                #$cgi->push_Param("\$db_other_mediator_field", $other_mediator_field);
                
                __add_mediator_field_start__
                my $__mediator_field__ = $cgi->param_Shift("__mediator_field___" . $num);
                $cgi->push_Param("\$db___mediator_field__", $__mediator_field__);                
                __add_mediator_field_end__
                
                $htmldb->insert_Table;
                
                if ($htmldb->get_DB_Error_Message ne "") {
                    $cgi->add_Debug_Text($htmldb->get_DB_Error_Message, __FILE__, __LINE__, "DATABASE");
                    $cgi->add_Debug_Text($htmldb->get_SQL, __FILE__, __LINE__, "DATABASE");
                }
                
                ### Shift all CGI variables that represent current mediator 
                ### table fields from DB cache or they will be forwarded to
                ### the next same operation on other mediator table.
                __shift_mediator_field_start__
                $cgi->param_Shift("\$db___mediator_field__");
                __shift_mediator_field_end__
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
    
        ### Basic code structure to display parent item detail information 
        ### where the current sub list is associated with.
        
        #my $id_item_parent = $cgi->param("__id_item_parent__");
        
        #my $component = new webman_db_item_view;

        #$component->set_CGI($cgi);
        #$component->set_DBI_Conn($db_conn);

        #$component->set_Template_Default("template_???.html");

        #$component->set_SQL_Debug(1); ### 0 or 1 and default is 0

        #$component->set_SQL("select * from __parent_table_name__ where __id_item_parent__='$id_item_parent'");

        #if ($component->authenticate($login_name, \@groups, "webman_". $cgi->param("app_name") . "_comp_auth")) {
        #    $component->run_Task;
        #    $component->process_Content;
        #    $component->end_Task;
        #}
        
        #my $content = $component->get_Content;
        
        #$this->add_Content($content);
        
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
    __filter_part_start__
    my $sql_filter = undef;
    __part_spliter__
    
    if (!$cgi->param_Exist("filter___filter_field_name___afls") || $cgi->param("filter___filter_field_name___afls") eq "") {
        $cgi->push_Param("filter___filter_field_name___afls", "\%");
    }
    my $filter___filter_field_name___afls = $cgi->param("filter___filter_field_name___afls");
    $sql_filter .= "__filter_field_name__ like '$filter___filter_field_name___afls' and ";
    __part_spliter__
    
    $sql_filter =~ s/ and $//;
    
    my @sql_part = split(/ order by /, $sql);
    
    #$cgi->add_Debug_Text($sql, __FILE__, __LINE__, "DATABASE");
    
    if ($sql_part[0] =~ / where /) {
        $sql = "$sql_part[0] and $sql_filter order by $sql_part[1]";
        
    } else {
        $sql = "$sql_part[0] where $sql_filter order by $sql_part[1]";
    }
    
    #$cgi->add_Debug_Text($sql, __FILE__, __LINE__, "DATABASE");
    __filter_part_end__
    
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
    __tld_add_column__
    
    ### HTML CSS class
    my $row_class = "row_odd";
    
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