package curims_dashboard;

use webman_db_item_view_dynamic;

@ISA=("webman_db_item_view_dynamic");

sub new {
    
    my $class = shift;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);

    my $total_items = "Select count(*) from curims_curriculum";
    my $sth_curriculum = $db_conn->prepare($total_items);
    $sth_curriculum->execute();
    my ($total_curriculum) = $sth_curriculum->fetchrow_array();
    $this->set_DB_Items_View_Num($total_curriculum);
    
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
    

    # Define current academic session (this could also come from a config file or DB)
    my ($sec,$min,$hour,$mday,$mon,$year) = localtime();
    my $month = $mon + 1;
    my $current_year = 1900 + $year;

    my ($academic_year_start, $academic_year_end, $semester);

    if ($month >= 9) {
        # Sept–Dec → Semester 1 of new academic year
        $academic_year_start = $current_year;
        $academic_year_end = $current_year + 1;
        $semester = 1;
    } elsif ($month >= 3) {
        # Mar–Aug → Semester 2 of previous academic year
        $academic_year_start = $current_year - 1;
        $academic_year_end = $current_year;
        $semester = 2;
    } else {
        # Jan–Feb → Still Semester 1 of previous academic year
        $academic_year_start = $current_year - 1;
        $academic_year_end = $current_year;
        $semester = 1;
    }

    my $academic_session = "$academic_year_start/$academic_year_end-$semester";
    $cgi->push_Param("current_academic_session", $academic_session);



    # Fetch Total Curriculum for the current session
    my $total_curriculum_count = 0;
    if ($db_conn) {
        my $sql_total_curr = "SELECT COUNT(*) FROM curims_curriculum"; # Count all curricula
        my $sth_total_curr = $db_conn->prepare($sql_total_curr);
        if ($sth_total_curr) {
            eval {
                $sth_total_curr->execute(); 
                ($total_curriculum_count) = $sth_total_curr->fetchrow_array();
                $sth_total_curr->finish();
            };
            if ($@) {
                $cgi->add_Debug_Text("DBI error fetching total curriculum count: $@", __FILE__, __LINE__, "ERROR");
            }
        } else {
            $cgi->add_Debug_Text("DBI prepare error for total curriculum count: " . ($db_conn->errstr || 'Unknown error'), __FILE__, __LINE__, "ERROR");
        }
    }
    $cgi->push_Param("total_curriculum", $total_curriculum_count || 0);


    # Fetch Total Courses
    my $total_course_count = 0;
    if ($db_conn) {
        my $sql_total_course = "SELECT COUNT(*) FROM curims_course";
        my $sth_total_course = $db_conn->prepare($sql_total_course);
        if ($sth_total_course) {
            eval {
                $sth_total_course->execute();
                ($total_course_count) = $sth_total_course->fetchrow_array();
                $sth_total_course->finish();
            };
            if ($@) {
                $cgi->add_Debug_Text("DBI error fetching total course count: $@", __FILE__, __LINE__, "ERROR");
            }
        } else {
            $cgi->add_Debug_Text("DBI prepare error for total course count: " . ($db_conn->errstr || 'Unknown error'), __FILE__, __LINE__, "ERROR");
        }
    }
    $cgi->push_Param("total_course", $total_course_count || 0); 

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
        if (!$cgi->param_Exist("filter_curriculum_code") || $cgi->param("filter_curriculum_code") eq "") {
        $cgi->push_Param("filter_curriculum_code", "\%");
    }
    my $filter_curriculum_code = $cgi->param("filter_curriculum_code");
    $sql_filter .= "curriculum_code like '$filter_curriculum_code' and ";
    
    
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
    $tld->add_Column("curims_core");
    $tld->add_Column("curims_elective");
    $tld->add_Column("curims_general");
    $tld->add_Column("curims_total");
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
        
        my $id_curr = $tld->get_Data($i, "id_curriculum_62base");
        my $curriculum_name_string = $tld->get_Data($i, "curriculum_name"); # Get original curriculum name

        # Calculate total number of courses for this curriculum
        $dbu->set_Table("curims_currcourse"); # Ensure table is set for count_Item
        my $course_count = $dbu->count_Item("id_curriculum_62base", $id_curr);
        $tld->set_Data($i, "curims_course", $course_count || 0);

        # Count number of 'Core' courses for this curriculum using direct DBI
        my $core_count = 0;
        if ($db_conn) { # $db_conn should be available from the parent class
            my $sql_core = "SELECT COUNT(*) FROM curims_currcourse WHERE id_curriculum_62base = ? AND status = ?";
            my $sth_core = $db_conn->prepare($sql_core);
            if ($sth_core) {
                eval {
                    $sth_core->execute($id_curr, 'Core');
                    ($core_count) = $sth_core->fetchrow_array();
                    $sth_core->finish();
                };
                if ($@) {
                    $cgi->add_Debug_Text("DBI execute/fetch error for core count: $@", __FILE__, __LINE__, "ERROR");
                    $core_count = 0; # Default to 0 on error
                }
            } else {
                $cgi->add_Debug_Text("DBI prepare error for core count: " . ($db_conn->errstr || 'Unknown error'), __FILE__, __LINE__, "ERROR");
            }
        } else {
            $cgi->add_Debug_Text("DB_Conn not available for core count calculation.", __FILE__, __LINE__, "ERROR");
        }
        $tld->set_Data($i, "curims_core", $core_count || 0);

        # Count number of 'Elective' courses for this curriculum, handling 'Choose X' format
        my $elective_count = 0;
        if ($db_conn) { # $db_conn should be available from the parent class
            my $sql_elective = "SELECT c.course_name 
                              FROM curims_course c
                              JOIN curims_currcourse cc ON c.id_course_62base = cc.id_course_62base
                              WHERE cc.id_curriculum_62base = ? AND cc.status = 'Elective'";
            my $sth_elective = $db_conn->prepare($sql_elective);
            if ($sth_elective) {
                eval {
                    $sth_elective->execute($id_curr);
                    while (my $row = $sth_elective->fetchrow_hashref()) {
                        my $course_name = $row->{course_name} || '';
                        
                        # Check if this is an elective course with "Choose X" format (with or without credits)
                        if ($course_name =~ /^Elective Courses - Choose (\d+)(?:\s*\([^)]+\))?/) {
                            $elective_count += $1;  # Add the number after "Choose"
                        } else {
                            $elective_count++;  # Regular elective course, count as 1
                        }
                    }
                    $sth_elective->finish();
                };
                if ($@) {
                    $cgi->add_Debug_Text("DBI execute/fetch error for elective count: $@", __FILE__, __LINE__, "ERROR");
                    $elective_count = 0; # Default to 0 on error
                }
            } else {
                $cgi->add_Debug_Text("DBI prepare error for elective count: " . ($db_conn->errstr || 'Unknown error'), __FILE__, __LINE__, "ERROR");
            }
        } else {
            $cgi->add_Debug_Text("DB_Conn not available for elective count calculation.", __FILE__, __LINE__, "ERROR");
        }
        $tld->set_Data($i, "curims_elective", $elective_count || 0);
        # Count number of 'General' courses for this curriculum using direct DBI
        my $general_count = 0;
        if ($db_conn) { # $db_conn should be available from the parent class
            my $sql_general = "SELECT COUNT(*) FROM curims_currcourse WHERE id_curriculum_62base = ? AND status = ?";
            my $sth_general = $db_conn->prepare($sql_general);
            if ($sth_general) {
                eval {
                    $sth_general->execute($id_curr, 'General');
                    ($general_count) = $sth_general->fetchrow_array();
                    $sth_general->finish();
                };
                if ($@) {
                    $cgi->add_Debug_Text("DBI execute/fetch error for general count: $@", __FILE__, __LINE__, "ERROR");
                    $general_count = 0; # Default to 0 on error
                }
            } else {
                $cgi->add_Debug_Text("DBI prepare error for general count: " . ($db_conn->errstr || 'Unknown error'), __FILE__, __LINE__, "ERROR");
            }
        } else {
            $cgi->add_Debug_Text("DB_Conn not available for general count calculation.", __FILE__, __LINE__, "ERROR");
        }
        $tld->set_Data($i, "curims_general", $general_count || 0);

        # Calculate total number of courses for this curriculum
        my $total_count = 0;
        $total_count = $core_count + $elective_count + $general_count;
        $tld->set_Data($i, "curims_total", $total_count || 0);

        # Conditionally create link for curriculum name (uses total $course_count)
        my $curriculum_name_display;
        if (defined($course_count) && $course_count > 0) {
            $curriculum_name_display = qq{<a href="index.cgi?link_id=6&task=curims_curriculum_course_list_bysem&id_curriculum_62base=$id_curr">$curriculum_name_string</a>};
        } else {
            $curriculum_name_display = $curriculum_name_string; # Plain text if no courses
        }
        $tld->set_Data($i, "curriculum_name", $curriculum_name_display); # Update 'curriculum_name' field with HTML or plain text
    }
    
    return $tld;
}

1;