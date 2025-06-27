package curims_course_topic_schedule_link;

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
    
    ### DB item dynamic list with multi row insert/update/delete  
    ### operations support need this to behave correctly 

        my $course_id = $cgi->param("id_course_62base");

    # Lookup curriculum_name and intake_session and push combined label to CGI
    if ($course_id) {
        $dbu->set_Table("curims_course");
        my $course_name   = $dbu->get_Item("course_name",   "id_course_62base", $course_id);
        my $course_code    = $dbu->get_Item("course_code",    "id_course_62base", $course_id);

        my $label = "$course_code - $course_name";

        # Set into CGI so that $cgi_cgi_curriculum_name_ works in template
        $cgi->push_Param("course_topic", $label);
    }

    # Fetch Total Topic for the current session
    my $total_topic_count = 0;
    if ($db_conn) {
        my $sql_total_topic = "SELECT COUNT(*) FROM curims_topic"; # Count all curricula
        my $sth_total_topic = $db_conn->prepare($sql_total_topic);
        if ($sth_total_topic) {
            eval {
                $sth_total_topic->execute(); 
                ($total_topic_count) = $sth_total_topic->fetchrow_array();
                $sth_total_topic->finish();
            };
            if ($@) {
                $cgi->add_Debug_Text("DBI error fetching total topic count: $@", __FILE__, __LINE__, "ERROR");
            }
        } else {
            $cgi->add_Debug_Text("DBI prepare error for total topic count: " . ($db_conn->errstr || 'Unknown error'), __FILE__, __LINE__, "ERROR");
        }
    }
    $cgi->push_Param("total_topic", $total_topic_count || 0);

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

    ### fetch total topic count after insertion
    my $total_items = "Select count(*) from curims_topic";
    my $sth_topic = $db_conn->prepare($total_items);
    $sth_topic->execute();
    my ($total_topic) = $sth_topic->fetchrow_array();
    $this->set_DB_Items_View_Num($total_topic);
    
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
    $tld->add_Column("curims_schedule");
    
    my $row_class = "row_odd"; ### HTML CSS class
    
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
        
        $dbu->set_Table("curims_schedule");
        my $count_item = $dbu->count_Item("id_topic_62base", $tld->get_Data($i, "id_topic_62base"));
        $tld->set_Data($i, "curims_schedule", $count_item);

    }
    
    return $tld;
}

1;