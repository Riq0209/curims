package curims_curriculum_details_list;

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
    
    
    $this->SUPER::run_Task();
}

sub customize_SQL {
    my $this = shift @_;
    my $te = shift @_;

    my $sql = q{
        SELECT
    cu.id_curriculum_62base,
    cu.curriculum_code,
    cu.curriculum_name,
    cu.intake_session,
    cu.intake_semester,
    cu.intake_year,

    c.course_code,
    c.course_name,
    cc.year_taken,
    cc.semester_taken,

    p.plo_code,
    p.plo_description

FROM curims_curriculum cu
LEFT JOIN curims_currcourse cc ON cu.id_curriculum_62base = cc.id_curriculum_62base
LEFT JOIN curims_course c ON cc.id_course_62base = c.id_course_62base
LEFT JOIN curims_currplo cp ON cu.id_curriculum_62base = cp.id_curriculum_62base
LEFT JOIN curims_plo p ON cp.id_plo_62base = p.id_plo_62base
ORDER BY cu.id_curriculum_62base, cc.created_date, cp.created_date;
    };

    $this->{sql} = $sql;
    return $sql;
}





sub customize_TLD {
    my $this = shift @_;
    my $tld = shift @_;

    my $cgi = $this->get_CGI;

    my $html = '';
    my $prev_id = '';
    my $course_rows = '';
    my $plo_rows = '';
    my %seen_courses = ();
    my %seen_plos = ();
    my $row_num = 1;
    my $course_num = 1;
    my $plo_num = 1;

    for (my $i = 0; $i < $tld->get_Row_Num; $i++) {
        my $curriculum_id = $tld->get_Data($i, "id_curriculum_62base");

        if ($curriculum_id ne $prev_id) {
            # Finalize previous curriculum block
            if ($course_rows ne '' || $plo_rows ne '') {
                $html .= "<h4>Courses</h4>
                          <table border='1' style='margin-bottom:10px'>
                          <tr><th>No.</th><th>Course Code</th><th>Course Name</th><th>Year</th><th>Semester</th></tr>
                          $course_rows
                          </table>";

                $html .= "<h4>PLOs</h4>
                          <table border='1' style='margin-bottom:20px'>
                          <tr><th>No.</th><th>PLO Code</th><th>PLO Description</th></tr>
                          $plo_rows
                          </table>";

                $course_rows = '';
                $plo_rows = '';
                $course_num = 1;
                $plo_num = 1;
                %seen_courses = ();
                %seen_plos = ();
            }

            # Curriculum Header
            $html .= "<h3>Curriculum Info</h3>
                      <table border='1' style='margin-bottom:10px'>
                      <tr><th>Curriculum Code</th><th>Name</th><th>Session</th><th>Year</th><th>Semester</th></tr>
                      <tr>
                        <td>" . $tld->get_Data($i, "curriculum_code") . "</td>
                        <td>" . $tld->get_Data($i, "curriculum_name") . "</td>
                        <td>" . $tld->get_Data($i, "intake_session") . "</td>
                        <td>" . $tld->get_Data($i, "intake_year") . "</td>
                        <td>" . $tld->get_Data($i, "intake_semester") . "</td>
                      </tr>
                      </table>";

            $prev_id = $curriculum_id;
        }

        # --- Add course if unique ---
        my $ccode = $tld->get_Data($i, "course_code") || '';
        my $cname = $tld->get_Data($i, "course_name") || '';
        my $cyear = $tld->get_Data($i, "year_taken") || '';
        my $csem  = $tld->get_Data($i, "semester_taken") || '';

        my $course_key = "$ccode|$cname|$cyear|$csem";
        if ($ccode ne '' && !$seen_courses{$course_key}) {
            $course_rows .= "<tr>
                              <td>$course_num.</td>
                              <td><b>$ccode</b></td>
                              <td>$cname</td>
                              <td>$cyear</td>
                              <td>$csem</td>
                            </tr>";
            $seen_courses{$course_key} = 1;
            $course_num++;
        }

        # --- Add PLO if unique ---
        my $pcode = $tld->get_Data($i, "plo_code") || '';
        my $pdesc = $tld->get_Data($i, "plo_description") || '';

        my $plo_key = "$pcode|$pdesc";
        if ($pcode ne '' && !$seen_plos{$plo_key}) {
            $plo_rows .= "<tr>
                            <td>$plo_num.</td>
                            <td><b>$pcode</b></td>
                            <td>$pdesc</td>
                          </tr>";
            $seen_plos{$plo_key} = 1;
            $plo_num++;
        }
    }

    # Final block at the end of loop
    if ($course_rows ne '' || $plo_rows ne '') {
        $html .= "<h4>Courses</h4>
                  <table border='1'>
                  <tr><th>No.</th><th>Course Code</th><th>Course Name</th><th>Year</th><th>Semester</th></tr>
                  $course_rows
                  </table>";

        $html .= "<h4>PLOs</h4>
                  <table border='1'>
                  <tr><th>No.</th><th>PLO Code</th><th>PLO Description</th></tr>
                  $plo_rows
                  </table>";
    }

    # Output
  $this->add_Content($html);
    return $tld;
}


1;