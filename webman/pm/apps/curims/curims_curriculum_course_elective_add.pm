package curims_curriculum_course_elective_add;

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
        $cgi->push_Param("task", "curims_curriculum_course_elective_list");        
        $cgi->redirect_Page("index.cgi?$get_data");
        
    } elsif ($submission_type eq "add_selected" && grep(/^id_course_62base_/, @cgi_var_list)) {  
        my $id_item_parent = $cgi->param("id_currcourse_62base");
        
        $cgi->push_Param("\$db_id_currcourse_62base", $id_item_parent);

        my $id_curriculum_value = $cgi->param("id_curriculum_62base");
        $cgi->push_Param("\$db_id_curriculum_62base", $id_curriculum_value);
        
        my $htmldb = new HTML_DB_Map;

        $htmldb->set_CGI($cgi);
        $htmldb->set_DBI_Conn($db_conn);
        
        ### it's the mediator table
        $htmldb->set_Table("curims_elective");        

        foreach my $var (@cgi_var_list) {                
            if ($var =~ /^id_course_62base_/) {
                my $id_item_added = $cgi->param_Shift($var);
                
                $cgi->push_Param("\$db_id_course_62base", $id_item_added);

                ### get the current number of selected item to be added
                my $num = $var;
                   $num =~ s/^id_course_62base_//;

                ### below is the example to add other none PK & FK of the mediator tables
                #my $other_mediator_field = $cgi->param_Shift("other_mediator_field_" . $num);
                #$cgi->push_Param("\$db_other_mediator_field", $other_mediator_field);
                
                my $year_taken = $cgi->param_Shift("year_taken_" . $num);
                $cgi->push_Param("\$db_year_taken", $year_taken);                

                my $semester_taken = $cgi->param_Shift("semester_taken_" . $num);
                $cgi->push_Param("\$db_semester_taken", $semester_taken);                

                my $semester_no = $cgi->param_Shift("semester_no_" . $num);
                $cgi->push_Param("\$db_semester_no", $semester_no);                

                my $status = $cgi->param_Shift("status_" . $num);
                $cgi->push_Param("\$db_status", $status);                

                
                $htmldb->insert_Table;
                
                if ($htmldb->get_DB_Error_Message ne "") {
                    $cgi->add_Debug_Text($htmldb->get_DB_Error_Message, __FILE__, __LINE__, "DATABASE");
                    $cgi->add_Debug_Text($htmldb->get_SQL, __FILE__, __LINE__, "DATABASE");
                }
                
                ### Shift all CGI variables that represent current mediator 
                ### table fields from DB cache or they will be forwarded to
                ### the next same operation on other mediator table.
                $cgi->param_Shift("\$db_id_course_62base");
                $cgi->param_Shift("\$db_year_taken");
                $cgi->param_Shift("\$db_semester_taken");
                $cgi->param_Shift("\$db_semester_no");
                $cgi->param_Shift("\$db_status");
            }                
        }
        
        ### enable the next 2 code lines to 
        ### directly going back to the parent list
        #$cgi->push_Param("task", undef);
        #$cgi->redirect_Page("index.cgi?$get_data");
    }    
    
    ###########################################################################
    # 🟢 Get curriculum ID from query param
    my $curriculum_id = $cgi->param("id_curriculum_62base");

    # Lookup curriculum_name and intake_session and push combined label to CGI
    if ($curriculum_id) {
        $dbu->set_Table("curims_curriculum");
        my $curriculum_name   = $dbu->get_Item("curriculum_name",   "id_curriculum_62base", $curriculum_id);
        my $intake_session    = $dbu->get_Item("intake_session",    "id_curriculum_62base", $curriculum_id);

        my $label = "$curriculum_name - $intake_session";

        # Set into CGI so that $cgi_cgi_curriculum_name_ works in template
        $cgi->push_Param("curriculum_name_elective_page", $label);
    }

    my $id_curriculum_62base = $cgi->param('id_curriculum_62base');
    my $total_items = 0;

    if ($id_curriculum_62base) {
        # Count courses available to be added (i.e., not already in this curriculum)
        my $sql = "SELECT COUNT(*) FROM curims_course 
                   WHERE id_course_62base NOT IN 
                       (SELECT id_course_62base FROM curims_currcourse 
                        WHERE id_curriculum_62base = ?)";
        my $sth = $db_conn->prepare($sql);
        $sth->execute($id_curriculum_62base);
        ($total_items) = $sth->fetchrow_array();
        $sth->finish();
    }

    $this->set_DB_Items_View_Num($total_items || 0);

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
        
        #my $id_item_parent = $cgi->param("id_curriculum_62base");
        
        #my $component = new webman_db_item_view;

        #$component->set_CGI($cgi);
        #$component->set_DBI_Conn($db_conn);

        #$component->set_Template_Default("template_???.html");

        #$component->set_SQL_Debug(1); ### 0 or 1 and default is 0

        #$component->set_SQL("select * from __parent_table_name__ where id_curriculum_62base='$id_item_parent'");

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

    my $id_curriculum_62base = $cgi->param('id_curriculum_62base');
    
    if ($id_curriculum_62base) {
        # Filter out courses that are already in the curriculum
        my $sql_filter = "id_course_62base NOT IN (SELECT id_course_62base FROM curims_currcourse WHERE id_curriculum_62base = '$id_curriculum_62base')";
        
        my @sql_part = split(/ order by /i, $sql);
        
        my $base_query = $sql_part[0];
        my $order_by_clause = $sql_part[1] ? "ORDER BY " . $sql_part[1] : "";

        if ($base_query =~ / where /i) {
            $sql = "$base_query AND ($sql_filter) $order_by_clause";
        } else {
            $sql = "$base_query WHERE $sql_filter $order_by_clause";
        }
    }
    
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