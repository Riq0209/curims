package curims_curriculum_course_list;

use webman_db_item_view_dynamic;

@ISA=("webman_db_item_view_dynamic");

sub new {
    my $class = shift;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    my $num = 100;
    # Set default number of items per page to 100
    $this->set_DB_Items_View_Num($num);
    
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

    # my $id_curriculum_62base = $cgi->param('id_curriculum_62base');
    my $total_items = 0;


        # Count from curims_currcourse
        my $sql_currcourse = "SELECT COUNT(*) FROM curims_currcourse";
        my $sth_currcourse = $db_conn->prepare($sql_currcourse);
        $sth_currcourse->execute();
        my ($total_currcourse) = $sth_currcourse->fetchrow_array();
        $total_items += $total_currcourse if $total_currcourse;

        # # Count from curims_elective
        # my $sql_elective = "SELECT COUNT(*) FROM curims_elective WHERE id_curriculum_62base = ?";
        # my $sth_elective = $db_conn->prepare($sql_elective);
        # $sth_elective->execute($id_curriculum_62base);
        # my ($total_elective) = $sth_elective->fetchrow_array();
        # $total_items += $total_elective if $total_elective;


        $this->set_DB_Items_View_Num($total_items);
    # $cgi->push_Param("total_items_course", $total_items);
    
    ### DB item list with multi row operations  
    ### support need this to behave correctly 
    #if (!$cgi->param_Exist("task")) {
    #    $cgi->push_Param("task", "");
    #}
        my $curriculum_id = $cgi->param("id_curriculum_62base");

    # Lookup curriculum_name and intake_session and push combined label to CGI
    if ($curriculum_id) {
        $dbu->set_Table("curims_curriculum");
        my $curriculum_name   = $dbu->get_Item("curriculum_name",   "id_curriculum_62base", $curriculum_id);
        my $intake_session    = $dbu->get_Item("intake_session",    "id_curriculum_62base", $curriculum_id);

        my $label = "$curriculum_name - $intake_session";

        # Set into CGI so that $cgi_cgi_curriculum_name_ works in template
        $cgi->push_Param("cgi_curriculum_name", $label);
    }

    if (!$cgi->param_Exist("task")) {
        $cgi->push_Param("task", "");
    }
    
    $this->SUPER::run_Task();
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
    if (!$cgi->param_Exist("filter_course_code") || $cgi->param("filter_course_code") eq "") {
        $cgi->push_Param("filter_course_code", "\%");
    }
    my $filter_course_code = $cgi->param("filter_course_code");
    $sql_filter .= "course_code like '$filter_course_code' and ";
    
    
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
    $tld->add_Column("curims_course");
    
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
        $dbu->set_Table("curims_elective");
        my $count_item = $dbu->count_Item("id_currcourse_62base", $tld->get_Data($i, "id_currcourse_62base"));

        if ($count_item != 0) {
            $tld->set_Data($i, "curims_course", $count_item." (Elective) ");
        } else {
            $tld->set_Data($i, "curims_course", $count_item);
        }
        
        # $dbu->set_Table("curims_elective");
        # my $count_item = $dbu->count_Item("id_currcourse_62base", $tld->get_Data($i, "id_currcourse_62base"));

        # if ($count_item != 0) {
        #     $tld->set_Data($i, "curims_course", $count_item." (Elective) ");
        # } else {
        #     $tld->set_Data($i, "curims_course", "");
        # }
    }
    
    return $tld;
}

1;