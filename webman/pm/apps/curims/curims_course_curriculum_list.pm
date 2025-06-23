package curims_course_curriculum_list;

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
    
    ### DB item list with multi row operations  
    ### support need this to behave correctly 
    #if (!$cgi->param_Exist("task")) {
    #    $cgi->push_Param("task", "");
    #}
    # ✅ Set curriculum_name for template rendering
    my $curriculum_id = $cgi->param("id_curriculum_62base");
    my $curriculum_name = $dbu->get_Item("curriculum_name", "id_curriculum_62base", $curriculum_id);
    $cgi->param("cgi_curriculum_name", $curriculum_name);

    
    $this->SUPER::run_Task();
}

sub customize_SQL {
    my $this = shift @_;
    my $te = shift @_; # Template Engine

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn; # For quoting

    # Fetch CGI parameters
    my $id_course_62base = $cgi->param('id_course_62base');
    my $order_curims_curriculum = $cgi->param('order_curims_curriculum');

    # --- Parameter Validation and Defaulting ---
    unless (defined $id_course_62base && $id_course_62base ne '') {
        $cgi->add_Debug_Text("CRITICAL: 'id_course_62base' CGI parameter is missing or empty.", __FILE__, __LINE__, "SQL_PARAM_ERROR");
        return "SELECT 'Error: id_course_62base is missing' AS error_message;";
    }

    my $order_by_column = "curriculum_code"; # Default order column (must exist in t_view)
                                          # Aliases from subquery can also be used here if filter is applied.
    if (defined $order_curims_curriculum && $order_curims_curriculum ne '') {
        # Basic validation for ORDER BY column. 
        # Allow simple column names (from t_view or aliases like source_table) or t_view.column_name format.
        if ($order_curims_curriculum =~ /^(?:t_view\.)?[a-zA-Z0-9_]+$/ ||
            $order_curims_curriculum =~ /^(med_id_curriculum_62base|med_id_course_62base|source_table)$/) {
            $order_by_column = $order_curims_curriculum;
        } else {
            $cgi->add_Debug_Text("Warning: Invalid or potentially unsafe 'order_curims_curriculum' CGI parameter ('$order_curims_curriculum'). Using default.", __FILE__, __LINE__, "SQL_PARAM_WARN");
        }
    }
    
    my $quoted_id_course_62base = $db_conn->quote($id_course_62base);

    # --- Define the common columns to select from t_med (curims_currcourse/curims_elective) ---
    my $t_med_common_columns_select_list = 
        "t_med.id_curriculum_62base AS med_id_curriculum_62base, " .
        "t_med.id_course_62base AS med_id_course_62base";

    # SQL Part 1: curims_currcourse
    my $sql_part1 = 
        "(SELECT t_view.*, " .
        "$t_med_common_columns_select_list, " .
        "'currcourse' AS source_table " .
        "FROM curims_curriculum t_view, curims_currcourse t_med " .
        "WHERE t_med.id_course_62base = $quoted_id_course_62base " .
        "AND t_med.id_curriculum_62base = t_view.id_curriculum_62base)";

    # SQL Part 2: curims_elective
    my $sql_part2 = 
        "(SELECT t_view.*, " .
        "$t_med_common_columns_select_list, " .
        "'elective' AS source_table " .
        "FROM curims_curriculum t_view, curims_elective t_med " .
        "WHERE t_med.id_course_62base = $quoted_id_course_62base " .
        "AND t_med.id_curriculum_62base = t_view.id_curriculum_62base)";

    # Base UNIONed query
    my $unioned_sql_no_order = "$sql_part1\nUNION ALL\n$sql_part2";
    my $final_sql = "";

    # Handling filter_course_code:
    my $filter_course_code_val = $cgi->param("filter_course_code");
    # if (defined $filter_course_code_val && $filter_course_code_val ne '' && $filter_course_code_val ne '%') {
    #     my $quoted_filter_val = $db_conn->quote($filter_course_code_val);
        
    #     $final_sql = "SELECT * FROM (\n" .
    #                  "$unioned_sql_no_order\n" .
    #                  ") AS combined_results " .
    #                  "WHERE combined_results.course_code LIKE $quoted_filter_val " .
    #                  "ORDER BY $order_by_column";
            
    # } else {
    #     $final_sql = "$unioned_sql_no_order\nORDER BY $order_by_column";
    # }

    $final_sql = "$unioned_sql_no_order\nORDER BY $order_by_column";

    #$cgi->add_Debug_Text("Constructed SQL: $final_sql", __FILE__, __LINE__, "DATABASE_CUSTOMIZED_SQL");
    return $final_sql;
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
        
    }
    
    return $tld;
}

1;