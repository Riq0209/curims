package curims_clo_plo_add;

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
        $cgi->push_Param("task", "curims_clo_plo_list");        
        $cgi->redirect_Page("index.cgi?$get_data");
        
    } elsif ($submission_type eq "add_selected" && grep(/^id_plo_62base_/, @cgi_var_list)) {  
        my $id_item_parent = $cgi->param("id_clo_62base");
        
        $cgi->push_Param("\$db_id_clo_62base", $id_item_parent);
        
        my $htmldb = new HTML_DB_Map;

        $htmldb->set_CGI($cgi);
        $htmldb->set_DBI_Conn($db_conn);
        
        ### it's the mediator table
        $htmldb->set_Table("curims_cloplo");        

        foreach my $var (@cgi_var_list) {                
            if ($var =~ /^id_plo_62base_/) {
                my $id_item_added = $cgi->param_Shift($var);
                
                $cgi->push_Param("\$db_id_plo_62base", $id_item_added);

                ### get the current number of selected item to be added
                my $num = $var;
                   $num =~ s/^id_plo_62base_//;

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
                $cgi->param_Shift("\$db_id_plo_62base");
            }                
        }
        
        ### enable the next 2 code lines to 
        ### directly going back to the parent list
        #$cgi->push_Param("task", undef);
        #$cgi->redirect_Page("index.cgi?$get_data");
    }    
    
    ###########################################################################
    my $id_clo_62base = $cgi->param('id_clo_62base');
    my $id_course_62base = $cgi->param('id_course_62base');
    my $total_items = 0;
        

                    my $sql_plo = "SELECT COUNT(*) FROM curims_plo";
                    my $sth_plo = $db_conn->prepare($sql_plo);
                    $sth_plo->execute();
                    ($total_items) = $sth_plo->fetchrow_array();
                    $sth_plo->finish();

        
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
        
        #my $id_item_parent = $cgi->param("id_clo_62base");
        
        #my $component = new webman_db_item_view;

        #$component->set_CGI($cgi);
        #$component->set_DBI_Conn($db_conn);

        #$component->set_Template_Default("template_???.html");

        #$component->set_SQL_Debug(1); ### 0 or 1 and default is 0

        #$component->set_SQL("select * from __parent_table_name__ where id_clo_62base='$id_item_parent'");

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
    my $id_clo_62base = $cgi->param('id_clo_62base');
    my $id_course_62base = $cgi->param('id_course_62base');
    
    if ($id_clo_62base && $id_course_62base) {
        # First, get the curriculum ID based on the course prefix
        my $sql_course = "SELECT UPPER(SUBSTRING(TRIM(LEADING FROM course_code), 1, 4)) as course_prefix 
                         FROM curims_course 
                         WHERE id_course_62base = ?";
        my $sth_course = $db_conn->prepare($sql_course);
        $sth_course->execute($id_course_62base);
        my $course_data = $sth_course->fetchrow_hashref();
        $sth_course->finish();
        
        if ($course_data && $course_data->{course_prefix}) {
            # Get curriculum ID using the course prefix
            my $sql_curriculum = "SELECT id_curriculum_62base 
                                FROM curims_curriculum 
                                WHERE UPPER(SUBSTRING(TRIM(curriculum_code), 1, 4)) = ?";
            my $sth_curriculum = $db_conn->prepare($sql_curriculum);
            $sth_curriculum->execute($course_data->{course_prefix});
            my $curriculum_data = $sth_curriculum->fetchrow_hashref();
            $sth_curriculum->finish();
            my $sql_filter;
            my @sql_part = split(/ order by /i, $sql);
            my $base_query = $sql_part[0];
            my $order_by_clause = $sql_part[1] ? "ORDER BY " . $sql_part[1] : "";

            if ($curriculum_data && $curriculum_data->{id_curriculum_62base}) {
                
                # Filter PLOs by curriculum
                $sql_filter = "id_plo_62base IN (
                    SELECT id_plo_62base FROM curims_plo 
                    WHERE id_curriculum_62base = '$curriculum_data->{id_curriculum_62base}'
                    )";
                
                if ($base_query =~ / where /i) {
                    $sql = "$base_query AND ($sql_filter) $order_by_clause";
                } else {
                    $sql = "$base_query WHERE $sql_filter $order_by_clause";
                }
            } else {
                # No curriculum filter - show all PLOs
                $sql = "select * from curims_plo";
            }
            
            # Prepare and execute the statement
            my $sth = $db_conn->prepare($sql) or die "Cannot prepare: " . $db_conn->errstr();
            $sth->execute() or die "Cannot execute: " . $sth->errstr();
            $sql = $sth->{Statement};
            $sth->finish();
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