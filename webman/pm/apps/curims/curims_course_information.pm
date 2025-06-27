package curims_course_information;

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

    # Get the course ID and task from the URL and push them to the template for routing
    my $id_course = $cgi->param("id_course_62base");
    my $task = $cgi->param("task");
    $cgi->push_Param("id_course_62base", $id_course);
    $cgi->push_Param("current_task", $task);
    
    ### DB item list with multi row operations  
    ### support need this to behave correctly 
    #if (!$cgi->param_Exist("task")) {
    #    $cgi->push_Param("task", "");
    #}
        my $course_id = $cgi->param("id_course_62base");

    # Lookup curriculum_name and intake_session and push combined label to CGI
    if ($course_id) {
        $dbu->set_Table("curims_course");
        my $course_name   = $dbu->get_Item("course_name",   "id_course_62base", $course_id);
        my $course_code    = $dbu->get_Item("course_code",    "id_course_62base", $course_id);

        my $label = "$course_code - $course_name";

        # Set into CGI so that $cgi_cgi_curriculum_name_ works in template
        $cgi->push_Param("course_name_link", $label);
    }

    if (!$cgi->param_Exist("task")) {
        $cgi->push_Param("task", "");
    }
    
    $this->SUPER::run_Task();
}


sub customize_SQL { ### TE_TYPE_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;    
    my $te = shift @_; 

    my $cgi = $this->get_CGI;

    # The base SQL is defined here because the template element does not provide one.
    # This query fetches course details for the main list view.
    my $sql = q{
        SELECT
            c.course_code,
            c.course_name,
            c.credit_hour,
            c.prerequisite_code,
            cc.id_currcourse_62base,
            cc.status,
            (SELECT COUNT(*) FROM curims_elective WHERE id_currcourse_62base = cc.id_currcourse_62base) AS curims_course
        FROM
            curims_course c
        LEFT JOIN
            curims_currcourse cc ON c.id_course_62base = cc.id_course_62base
    };

    # Filter the main list by the course ID from the URL
    my $id_course_62base = $cgi->param('id_course_62base');
    # If no ID, return a query that yields no results to avoid errors.
    return "SELECT * FROM curims_course WHERE 1=0" if !$id_course_62base;

    # Apply the filter using the course ID, ensuring the column is not ambiguous.
    my $sql_filter = "c.id_course_62base = " . $this->get_DB_Conn->quote($id_course_62base);

    # Append the WHERE clause to the SQL query.
    $sql .= " WHERE $sql_filter";

    # Add a default ORDER BY clause for consistent results.
    $sql .= " ORDER BY c.course_code";

    return $sql;
}


# sub customize_TLD {
#     my $this = shift @_;
    
#     my $tld = shift @_;
    
#     $tld->add_Column("row_class");
#     $tld->add_Column("course_code");
#     $tld->add_Column("course_name");
#     $tld->add_Column("credit_hour");
#     $tld->add_Column("prerequisite_code");
#     $tld->add_Column("id_currcourse_62base");
#     $tld->add_Column("status");
#     $tld->add_Column("curims_course");
    

#     my $row_class = "row_odd";
    
#     for (my $i = 0; $i < $tld->get_Row_Num; $i++) { 
#         $tld->set_Data($i, "row_class", "$row_class");
        
#         if ($row_class eq "row_odd") {
#             $row_class = "row_even";
#         } else {
#             $row_class = "row_odd";
#         }        
#     }
    
#     return $tld;
# }

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
    $tld->add_Column("curims_assesment");
    $tld->add_Column("curims_clo");
    $tld->add_Column("curims_curriculum");
    $tld->add_Column("curims_topic");
    
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
        
        $dbu->set_Table("curims_assesment");
        my $count_item = $dbu->count_Item("id_course_62base", $tld->get_Data($i, "id_course_62base"));
        $tld->set_Data($i, "curims_assesment", $count_item);

        $dbu->set_Table("curims_clo");
        my $count_item = $dbu->count_Item("id_course_62base", $tld->get_Data($i, "id_course_62base"));
        $tld->set_Data($i, "curims_clo", $count_item);

        $dbu->set_Table("curims_elective");
        my $count_item = $dbu->count_Item("id_course_62base", $tld->get_Data($i, "id_course_62base"));
       #$cgi->add_Debug_Text($dbu->get_SQL(), __FILE__, __LINE__, "DATABASE");

       if ($count_item == 0) {
        $dbu->set_Table("curims_currcourse");
        my $count_for_curriculum = $dbu->count_Item("id_course_62base", $tld->get_Data($i, "id_course_62base"));
        if ($count_for_curriculum != 0)  {
          $tld->set_Data($i, "curims_curriculum", $count_for_curriculum);  
        } else {
          $dbu->set_Table("curims_elective");
          $count_for_curriculum = $dbu->count_Item("id_course_62base", $tld->get_Data($i, "id_course_62base")); 
          if ($count_for_curriculum != 0) {
            $tld->set_Data($i, "curims_curriculum", $count_for_curriculum); 
          }
        }
       } else {
        $tld->set_Data($i, "curims_curriculum", $count_item);
       }

        $dbu->set_Table("curims_topic");
        my $count_item = $dbu->count_Item("id_course_62base", $tld->get_Data($i, "id_course_62base"));
        $tld->set_Data($i, "curims_topic", $count_item);

    }
    
    return $tld;
}

sub process_LIST { ### TE_TYPE_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;    
    my $te = shift @_; 

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;

    # Fetch the course ID from the URL parameters
    my $id_course_62base = $cgi->param('id_course_62base');
    if (!$id_course_62base) {
        $this->add_Content("<div class='w3-panel w3-red'><p>Error: Course ID is missing.</p></div>");
        return;
    }

    # Fetch header information in steps for robustness
    my $header_data;
    eval {
        # Step 1: Get base course info and extract first 4 characters of course code
        my $sql_course = "SELECT course_code, 
                                 UPPER(SUBSTRING(TRIM(LEADING FROM course_code), 1, 4)) as course_prefix,
                                 course_name, 
                                 credit_hour, 
                                 prerequisite_code 
                          FROM curims_course 
                          WHERE id_course_62base = ?";
        
        my $sth_course = $db_conn->prepare($sql_course);
        $sth_course->execute($id_course_62base);
        $header_data = $sth_course->fetchrow_hashref();
        $sth_course->finish();
        
     # Get the first 4 characters of the course code
     my $course_prefix = uc(substr($header_data->{course_code}, 0, 4));
     
     # Debug: Show what we're searching for
     warn "DEBUG - Looking up curriculum with prefix: '$course_prefix' from course code: $header_data->{course_code}";
     
     # Find curriculum where first 4 characters of code match the course prefix
     my $sql_curriculum = "SELECT curriculum_name, curriculum_code 
                           FROM curims_curriculum 
                           WHERE UPPER(SUBSTRING(TRIM(curriculum_code), 1, 4)) = ?";
     
     warn "DEBUG - Executing query: $sql_curriculum with param: $course_prefix";
     
     my $sth_curriculum = $db_conn->prepare($sql_curriculum);
     $sth_curriculum->execute($course_prefix);
     my $curriculum_data = $sth_curriculum->fetchrow_hashref();
     $sth_curriculum->finish();
     
     if ($curriculum_data) {
         $header_data->{curriculum_name} = $curriculum_data->{curriculum_name};
         $header_data->{curriculum_code} = $curriculum_data->{curriculum_code};
         warn "DEBUG - Found curriculum: $curriculum_data->{curriculum_name} (Code: $curriculum_data->{curriculum_code})";
     } else {
         warn "DEBUG - No curriculum found for prefix: $course_prefix";
         $header_data->{curriculum_name} = 'N/A';
     }


        if ($header_data) {
            # Step 2: Get curriculum link info
            my $sql_currcourse = "SELECT id_curriculum_62base, semester_no FROM curims_currcourse WHERE id_course_62base = ?";
            my $sth_currcourse = $db_conn->prepare($sql_currcourse);
            $sth_currcourse->execute($id_course_62base);
            my $currcourse_data = $sth_currcourse->fetchrow_hashref();
            $sth_currcourse->finish();

            if ($currcourse_data) {
    $header_data->{semester_no} = $currcourse_data->{semester_no};

    # Step 3: Get curriculum name by matching first 4 characters of course code with curriculum code
    my $id_curriculum_62base = $currcourse_data->{id_curriculum_62base};
    
}

        }
    };
    if ($@) {
        $this->add_Content("<div class='w3-panel w3-red'><p>Error fetching course data: $@</p></div>");
        return;
    }

    # Dynamically generate the header table HTML
    if ($header_data) {
        # Use the curriculum_name we already fetched from the database
        my $program_name = $header_data->{curriculum_name} || 'N/A';
        my $course_code = $header_data->{course_code} || 'N/A';
        my $course_name = $header_data->{course_name} || 'N/A';
        my $credit_hours = $header_data->{credit_hour} || 'N/A';
        my $prerequisite_code = $header_data->{prerequisite_code} || 'N/A';
        my $academic_session_semester = ($header_data->{academic_session} && $header_data->{semester_no})
                                      ? $header_data->{academic_session} . '/' . $header_data->{semester_no}
                                      : 'N/A';

        my $header_html = qq{
<div class="w3-container">
 <table class="w3-table w3-bordered" id="no-rounded-table" style="width:100%">
    <tr>
      <td class="w3-container w3-border" style="width:20%; font-weight:bold;">School/Faculty:</td>
      <td class="w3-container w3-border" style="width:20%;">Computing/Engineering</td>
      <td class="w3-container w3-border" style="width:15%; font-weight:bold;">Page:</td>
      <td class="w3-container w3-border" style="width:15%;">1 of 1</td>
    </tr>
    <tr>
      <td class="w3-container w3-border" style="font-weight:bold;">Program name:</td>
      <td class="w3-container w3-border" colspan="3">$program_name</td>
    </tr>
    <tr>
      <td class="w3-container w3-border" style="font-weight:bold;">Course code:</td>
      <td id="course-code-val" class="w3-container w3-border">$course_code</td>
      <td class="w3-container w3-border" style="font-weight:bold;">Academic Session/Semester:</td>
      <td class="w3-container w3-border">$academic_session_semester</td>
    </tr>
    <tr>
      <td class="w3-container w3-border" style="font-weight:bold;">Course name:</td>
      <td id="course-name-val" class="w3-container w3-border" colspan="3">$course_name</td>
    </tr>
    <tr>
      <td class="w3-container w3-border" style="font-weight:bold;">Credit hours:</td>
      <td class="w3-container w3-border" colspan="1">$credit_hours</td>
      <td class="w3-container w3-border" style="font-weight:bold;">Prerequisite code:</td>
      <td class="w3-container w3-border">$prerequisite_code</td>
    </tr>
 </table>
</div>
<br>
        };
        my $print_container = qq{
<div id="printable-content">
        };
        # $this->add_Content($print_container);
        $this->add_Content($header_html);
        # $cgi->add_Debug_Text($header_html, __FILE__, __LINE__, "DATABASE");
    }
    # Fetch course synopsis
    my $course_synopsis = '';
    eval {
        my $sql_synopsis = "SELECT course_synopsis FROM curims_course WHERE id_course_62base = ?";
        my $sth_synopsis = $db_conn->prepare($sql_synopsis);
        $sth_synopsis->execute($id_course_62base);
        my $row = $sth_synopsis->fetchrow_hashref;
        $course_synopsis = $row->{course_synopsis} || '-';
        $sth_synopsis->finish();
    };
    if ($@) {
        $course_synopsis = '<span style="color:red">Error fetching course synopsis</span>';
    }

# Fetch lecturer information
    my $lecturers;
    eval {
        my $sql_lecturer = "SELECT l.name, l.office, l.contact, l.email FROM curims_lecturer l JOIN curims_course_lecturer cl ON l.id_lecturer_62base = cl.id_lecturer_62base WHERE cl.id_course_62base = ?";
        my $sth_lecturer = $db_conn->prepare($sql_lecturer);
        $sth_lecturer->execute($id_course_62base);
        $lecturers = $sth_lecturer->fetchall_arrayref({}); # Fetch all as array of hashrefs
        $sth_lecturer->finish();
    };
    if ($@) {
        $this->add_Content("<div class='w3-panel w3-red'><p>Error fetching lecturer data: $@</p></div>");
    }

    if ($lecturers && @$lecturers) {
        my $rowspan = @$lecturers + 1;
        my $lecturer_html = qq{
<div class="w3-container">
<table class="w3-table w3-bordered w3-centered" id="no-rounded-table" style="width:100%">
    <tbody>
        <tr>
            <td class=" w3-container w3-border" style="font-weight:bold;">Course Synopsis</td>
            <td class=" w3-container w3-border" style="text-align: left;" colspan="4">$course_synopsis</td>
        </tr>
        <tr>
            <td class=" w3-container w3-border" style="font-weight:bold;">Course Coordinator</td>
            <td class=" w3-container w3-border"style="text-align: left;" colspan="4">N/A</td>
        </tr>
        <tr>
            <td rowspan="$rowspan" class="w3-border w3-container w3-center" style="font-weight:bold;">Course lecturer(s)</td>
            <td class=" w3-container w3-border" style="font-weight:bold;">Name</td>
            <td class=" w3-container w3-border" style="font-weight:bold;">Office</td>
            <td class=" w3-container w3-border" style="font-weight:bold;">Contact</td>
            <td class=" w3-container w3-border" style="font-weight:bold;">Email</td>
        </tr>
};
        foreach my $lecturer (@$lecturers) {
            my $name    = $lecturer->{name} || '-';
            my $office  = $lecturer->{office} || '-';
            my $contact = $lecturer->{contact} || '-';
            my $email   = $lecturer->{email} || '-';
            
            $lecturer_html .= qq{
        <tr>
            <td class=" w3-container w3-border">$name</td>
            <td class=" w3-container w3-border">$office</td>
            <td class=" w3-container w3-border">$contact</td>
            <td class=" w3-container w3-border">$email</td>
        </tr>
};
        }

        $lecturer_html .= qq{
    </tbody>
</table>
</div>
<br>
};
        $this->add_Content($lecturer_html);
    } else {
        # If no lecturers are found, display a message.
        my $no_lecturer_html = qq{
<div class="w3-container">
<p>No lecturer information found for this course.</p>
</div>
};
        $this->add_Content($no_lecturer_html);
    }

    # --- PLO Mapping Table ---
    my $plo_title = qq{
<div class="w3-container" style="width:100%">
<b>Mapping of the Course Learning Outcomes (CLO) to the Programme Learning Outcomes (PLO), Teaching &
Learning (T&L) methods and Assessment methods:</b>
</div>
};
    $this->add_Content($plo_title);

    # --- CLO Table ---
    my $clo_title = qq{
<div class="w3-container" style="width:100%">
<b>Course Learning Outcomes (CLO)</b>
</div>
};
    $this->add_Content($clo_title);

    my $clos;
    eval {
        my $sql_clo = q{
            SELECT clo.id_clo_62base, clo.clo_code, clo.clo_description, clo.clo_tl_methods
            FROM curims_clo clo
            WHERE clo.id_course_62base = ?
            ORDER BY clo.clo_code
        };
        my $sth_clo = $db_conn->prepare($sql_clo);
        $sth_clo->execute($id_course_62base);
        $clos = $sth_clo->fetchall_arrayref({});
        $sth_clo->finish();

        # For each CLO, fetch linked PLO codes and tags
        foreach my $clo (@$clos) {
            my $id_clo_62base = $clo->{id_clo_62base};
            my $sql_plo = q{
                SELECT p.plo_code, p.plo_tag
                FROM curims_cloplo cp
                JOIN curims_plo p ON cp.id_plo_62base = p.id_plo_62base
                WHERE cp.id_clo_62base = ?
                ORDER BY p.plo_code
            };
            my $sth_plo = $db_conn->prepare($sql_plo);
            $sth_plo->execute($id_clo_62base);
            my @plos;
            while (my $row = $sth_plo->fetchrow_hashref) {
                push @plos, $row;
            }
            $sth_plo->finish();
            $clo->{plo_list} = \@plos;
            $clo->{plo_code_list} = join(", ", map { $_->{plo_code} } @plos);
            $clo->{plo_tag_list} = join(", ", map { $_->{plo_tag} } @plos);
        }
    };

    if ($@) {
        $this->add_Content("<div class='w3-panel w3-red'><p>Error fetching CLO data: $@</p></div>");
    }

    if ($clos && @$clos) {
        my $clo_html = qq{
<div class="w3-container">
<table class="w3-table w3-bordered" id="no-rounded-table" style="width:100%">
  <thead>
    <tr>
      <th style="width:20%;" class="w3-container w3-border">No.</th>
      <th class="w3-container w3-border">CLO</th>
      <th class="w3-container w3-border">PLO (Code)</th>
      <th class="w3-container w3-border">T&L Methods</th>
    </tr>
  </thead>
  <tbody>
};
        foreach my $clo (@$clos) {
            my $clo_code = $clo->{clo_code} || 'N/A';
            my $clo_desc = $clo->{clo_description} || 'N/A';
            my $plo_code_list = $clo->{plo_code_list} || 'N/A';
            my $plo_tag_list = $clo->{plo_tag_list} || 'N/A';
            my $clo_tl_methods = $clo->{clo_tl_methods} || 'N/A';
            $clo_html .= qq{
    <tr>
      <td class="w3-container w3-border">$clo_code</td>
      <td class="w3-container w3-border">$clo_desc</td>
      <td class="w3-container w3-border">$plo_code_list ($plo_tag_list)</td>
      <td class="w3-container w3-border">$clo_tl_methods</td>
    </tr>
};
        }
        $clo_html .= qq{
  </tbody>
</table>
</div>
<br>
};
        $this->add_Content($clo_html);
    } else {
        my $no_clo_html = qq{
<div class="w3-container">
<p>No CLOs found for this course.</p>
</div>
};
        $this->add_Content($no_clo_html);
    }

    # --- Weekly Schedule Table ---
    my $schedule_title = qq{
<div class="w3-container" style="width:100%; text-align:left">
<b>Weekly Schedule</b>
</div>
};
    $this->add_Content($schedule_title);

    my $schedule_data;
    eval {
        my $sql_schedule = q{
            SELECT 
                s.week, 
                DATE_FORMAT(s.date_start, '%e/%c') AS date_start_f, 
                DATE_FORMAT(s.date_end, '%e/%c') AS date_end_f, 
                s.info,
                t.title, 
                t.subtopic
            FROM curims_schedule s
            JOIN curims_topic t ON s.id_topic_62base = t.id_topic_62base
            WHERE t.id_course_62base = ?
            ORDER BY s.week
        };
        my $sth_schedule = $db_conn->prepare($sql_schedule);
        $sth_schedule->execute($id_course_62base);
        $schedule_data = $sth_schedule->fetchall_arrayref({});
        $sth_schedule->finish();
    };

    if ($@) {
        $this->add_Content("<div class='w3-panel w3-red'><p>Error fetching schedule data: $@</p></div>");
    }

    if ($schedule_data && @$schedule_data) {
        my $schedule_html = qq{
<div class="w3-container">
<table class="w3-table w3-bordered" id="no-rounded-table" style="width:100%">
  <tbody>
};
        foreach my $item (@$schedule_data) {
            my $week = $item->{week} || '';
            my $date_start = $item->{date_start_f} || '';
            my $date_end = $item->{date_end_f} || '';
            my $title = $item->{title} || '';
            my $subtopic = $item->{subtopic} || '';
            my $info = $item->{info} || '';
            $subtopic =~ s/\n/<br>/g; # Replace newlines with <br> for HTML display

            $schedule_html .= qq{
    <tr>
      <td style="width:20%;" class="w3-container w3-border">Week $week<br>$date_start-$date_end<br>$info</td>
      <td class="w3-container w3-border"><b>$title</b><br>$subtopic</td>
    </tr>
};
        }
        $schedule_html .= qq{
  </tbody>
</table>
</div>
<br>
};
        $this->add_Content($schedule_html);
    } else {
        my $no_schedule_html = qq{
<div class="w3-container">
<p>No weekly schedule found for this course.</p>
</div>
};
        $this->add_Content($no_schedule_html);
    }

    # --- Assessment Table Generation (New Format) ---
    my $assessment_section_title_html = qq{
<div class="w3-container" style="width:100%">
<b>Assessment Methods and Mapping to PLOs</b>
</div>
<br>
};
    $this->add_Content($assessment_section_title_html);

    my @assessment_data_raw;
    eval {
        my $sql_assessment = q{
            SELECT
                a.id_assesment_62base, a.name, a.type, a.sequence,
                p.plo_tag, 
                ap.percentage
            FROM
                curims_assesment a
            LEFT JOIN
                curims_assesplo ap ON a.id_assesment_62base = ap.id_assesment_62base
            LEFT JOIN
                curims_plo p ON ap.id_plo_62base = p.id_plo_62base
            WHERE
                a.id_course_62base = ?
            ORDER BY
                a.type, a.sequence, p.plo_tag
        };
        my $sth_assessment = $db_conn->prepare($sql_assessment);
        $sth_assessment->execute($id_course_62base);
        @assessment_data_raw = @{$sth_assessment->fetchall_arrayref({}) || []};
        $sth_assessment->finish();
    };

    if ($@) {
        $this->add_Content(qq{<div class="w3-panel w3-red w3-padding"><p>Error fetching assessment data: $@</p></div>});
    } elsif (@assessment_data_raw) {
        my %assessments_processed;
        my $grand_total_percentage = 0;

        for my $row (@assessment_data_raw) {
            my $ass_id = $row->{id_assesment_62base};
            unless (exists $assessments_processed{$ass_id}) {
                $assessments_processed{$ass_id} = {
                    id       => $ass_id,
                    name     => $row->{name} || 'N/A',
                    type     => $row->{type} || 'Uncategorized',
                    sequence => $row->{sequence},
                    plo_info => {}, # Hash to store plo_tag => percentage
                };
            }
            if (defined $row->{plo_tag} && $row->{plo_tag} ne '') {
                $assessments_processed{$ass_id}{plo_info}{$row->{plo_tag}} = $row->{percentage};
            }
            $grand_total_percentage += ($row->{percentage} || 0) if defined $row->{percentage};
        }

        my %data_by_type;
        my @sorted_assessment_ids = sort {
            ($assessments_processed{$a}{type} cmp $assessments_processed{$b}{type}) ||
            ($assessments_processed{$a}{sequence} <=> $assessments_processed{$b}{sequence})
        } keys %assessments_processed;

        for my $ass_id (@sorted_assessment_ids) {
            my $ass_info = $assessments_processed{$ass_id};
            my $type = $ass_info->{type};
            push @{$data_by_type{$type}}, $ass_info;
        }

        my $assessment_table_html = qq{<div class="w3-container">
<table class="w3-table w3-bordered" id="no-rounded-table" style="width:100%">
  <tbody>
};
        my $has_content = 0;

        for my $type (sort keys %data_by_type) {
            my $assessments_in_type = $data_by_type{$type};
            if ($assessments_in_type && @$assessments_in_type) {
                $has_content = 1;
                $assessment_table_html .= qq{
    <tr>
      <th class="w3-container w3-border" style="width:5%;">No.</th>
      <th class="w3-container w3-border" style="width:45%;">$type</th>
      <th class="w3-container w3-border w3-center" style="width:25%;">PLO</th>
      <th class="w3-container w3-border w3-center" style="width:25%;">Percentage</th>
    </tr>
};
                my $item_number = 1;
                foreach my $ass_info (@$assessments_in_type) {
                    my @plo_tags = sort keys %{$ass_info->{plo_info}};
                    my $plo_tags_str;
                    my $percentages_str;

                    if (@plo_tags) {
                        my @percentages;
                        for my $tag (@plo_tags) {
                            my $perc = defined $ass_info->{plo_info}{$tag} ? $ass_info->{plo_info}{$tag} : '-';
                            push @percentages, $perc . '%';
                        }
                        $plo_tags_str = join("<br>", @plo_tags);
                        $percentages_str = join("<br>", @percentages);
                    } else {
                        $plo_tags_str = '-';
                        $percentages_str = '-';
                    }

                    $assessment_table_html .= qq{
    <tr>
      <td class="w3-center w3-border w3-container">$item_number</td>
      <td class="w3-border w3-container">} . ($ass_info->{name} || 'N/A') . qq{</td>
      <td class="w3-center w3-border w3-container">$plo_tags_str</td>
      <td class="w3-center w3-border w3-container">$percentages_str</td>
    </tr>
};
                    $item_number++;
                }
            }
        }

        if ($has_content) {
            $assessment_table_html .= qq{
    <tr>
      <td colspan="3" class="w3-right-align w3-padding w3-container w3-border"><b>Grand Total</b></td>
      <td class="w3-center w3-padding w3-container w3-border"><b>$grand_total_percentage%</b></td>
    </tr>
  </tbody>
</table>
</div>
<br>
};
            my $print_container_end = qq{
</div>
};
            $this->add_Content($assessment_table_html);
            # $this->add_Content($print_container_end);
        } else {
             $this->add_Content(qq{<div class="w3-container"><p>No assessment data found for this course.</p></div><br>});
        }
    } else {
        $this->add_Content(qq{<div class="w3-container"><p>No assessment data found for this course.</p></div><br>});
    }



}

1;