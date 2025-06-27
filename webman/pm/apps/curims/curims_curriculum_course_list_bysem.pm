package curims_curriculum_course_list_bysem;

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
    

    my $id_curriculum_62base = $cgi->param('id_curriculum_62base');
    my $total_items = 0;

    if ($id_curriculum_62base) {
        # Count from curims_currcourse
        my $sql_currcourse = "SELECT COUNT(*) FROM curims_currcourse WHERE id_curriculum_62base = ?";
        my $sth_currcourse = $db_conn->prepare($sql_currcourse);
        $sth_currcourse->execute($id_curriculum_62base);    
        my ($total_currcourse) = $sth_currcourse->fetchrow_array();
        $total_items += $total_currcourse if $total_currcourse;

        # Count from curims_elective
        my $sql_elective = "SELECT COUNT(*) FROM curims_elective WHERE id_curriculum_62base = ?";
        my $sth_elective = $db_conn->prepare($sql_elective);
        $sth_elective->execute($id_curriculum_62base);
        my ($total_elective) = $sth_elective->fetchrow_array();
        $total_items += $total_elective if $total_elective;
    }

    $this->set_DB_Items_View_Num($total_items);
        
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
            $tld->set_Data($i, "curims_course", $count_item);
        } else {
            $tld->set_Data($i, "curims_course", "");
        }

        # my $id_currcourse = $tld->get_Data($i, "id_currcourse_62base");
        # my $elective;
        
        # if ($count_item != 0) {
        #     $elective = qq{<a href="index.cgi?link_id=7&task=curims_curriculum_course_elective_list_view&id_curriculum_62base=$id_currcourse">$count_item</a>};
        # } else {
        #     $elective = "";
        # }
        # $tld->set_Data($i, "curims_course", $elective);
    }
    
    return $tld;
}
sub process_LIST { ### TE_TYPE_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $dbu = $this->get_DBU;

    my $tld = $this->{tld};
    my $num_col = $tld->get_Column_Num;
    my $num_row = $tld->get_Row_Num;

    # Get the curriculum ID
    my $curriculum_id = $cgi->param('id_curriculum_62base');
    
    # --- 0. Fetch and Display PLOs ---
    if ($curriculum_id) {
        my $plo_query = qq{
            SELECT plo_code, plo_tag, plo_description,
                   CAST(SUBSTRING(plo_code, 4) AS UNSIGNED) as plo_number
            FROM curims_plo 
            WHERE id_curriculum_62base = ?
            ORDER BY plo_number ASC
        };
        
        my $sth = $db_conn->prepare($plo_query);
        $sth->execute($curriculum_id);
        
        my @plo_rows;
        while (my $plo = $sth->fetchrow_hashref) {
            push @plo_rows, $plo;
        }
        $sth->finish;
        
        # Only show PLO section if there are PLOs
        if (@plo_rows) {
            my $plo_heading = qq{<h3 class="w3-text-black" style="margin: 24px auto; padding: 16px; font-weight: bold; border-bottom: 2px solid #ccc;">Program Learning Outcomes (PLOs)</h3>};
            my $table_plo_start = qq{<div class="w3-container" style="display: flex; justify-content: center; align-items: center; gap: 10px;"><table class="w3-table w3-striped" style="width:50%; margin-bottom: 20px;">};
            my $table_plo_end = qq{</table></div>};
            my $table_plo_header = qq{
                <thead>
                    <tr class="w3-light-grey">
                        <th style="width:5%;">Code</th>
                        <th style="width:5%;">Tag</th>
                        <th style="width:60%;">Description</th>
                    </tr>
                </thead>
                <tbody>
            };
            
            $this->add_Content($plo_heading);
            $this->add_Content($table_plo_start);
            $this->add_Content($table_plo_header);
            
            foreach my $plo (@plo_rows) {
                my $plo_row = qq{
                    <tr>
                        <td>$plo->{plo_code}</td>
                        <td>$plo->{plo_tag}</td>
                        <td>$plo->{plo_description}</td>
                    </tr>
                };
                $this->add_Content($plo_row);
            }
            
            $this->add_Content("</tbody>");
            $this->add_Content($table_plo_end);
            
            # Add some spacing after PLO section
            $this->add_Content(qq{<div style="margin-bottom: 40px;"></div>});
        }
    }

    # Return early if there's no course data to process.
    return if !$num_row || !$num_col;

    # --- 1. Data Preparation ---
    # Create data structures for 8 semesters (4 years, 2 semesters/year).
    my @tlds;
    my @total_credits = (0) x 9; # Use 1-based indexing (1-8), index 0 is unused.

    for my $i (1..8) {
        $tlds[$i] = new Table_List_Data;
        # Copy column definitions from the main TLD.
        for (my $j = 0; $j < $num_col; $j++) {
            $tlds[$i]->add_Column($tld->get_Column_Name($j));
        }
    }

    # Distribute rows from the main TLD into semester-specific TLDs.
    for (my $i = 0; $i < $num_row; $i++) {
        my $semester_no = $tld->get_Data($i, "semester_no");

        # Skip rows with invalid semester numbers.
        next unless ($semester_no && $semester_no >= 1 && $semester_no <= 8);

        $total_credits[$semester_no] += $tld->get_Data($i, "credit_hour") || 0;

        # Copy the entire row data.
        my @data_row;
        for (my $j = 0; $j < $num_col; $j++) {
            push @data_row, $tld->get_Data($i, $tld->get_Column_Name($j));
        }
        $tlds[$semester_no]->add_Row_Data(@data_row);
    }

    # --- 2. HTML Rendering ---
    my $cumulative_credit_total = 0;

    # Define reusable HTML templates for course tables
    my $table_start = qq{<div class="w3-container" style="display: flex; justify-content: center; align-items: center; gap: 10px;"><table class="w3-table" style="width:50%; margin-bottom: 20px;};
    my $table_end = qq{</table></div>};
    my $table_header_content = qq{
        <thead>
            <tr class="w3-light-grey">
                <th style="width:5%;">Code</th>
                <th style="width:35%;">Name</th>
                <th style="width:10%;">Credit</th>
                <th style="width:20%;">Prerequisite</th>
                <th style="width:10%;">Elective</th>
                <th style="width:10%;">Status</th>
            </tr>
        </thead>
    };
    my $colgroup_content = qq{
        <colgroup>
            <col style="width:5%;"> <!-- No -->
            <col style="width:5%;"> <!-- Code -->
            <col style="width:35%;"> <!-- Name -->
            <col style="width:10%;"> <!-- Credit Hour -->
            <col style="width:20%;"> <!-- Prerequisite -->
            <col style="width:10%;"> <!-- Elective -->
            <col style="width:10%;"> <!-- Status -->
            
        </colgroup>
    };
    # Loop through each semester and render its table if it has courses.
    for my $semester_no (1..8) {
        my $sem_tld = $tlds[$semester_no];
        next if $sem_tld->get_Row_Num == 0;

        my $year = int(($semester_no - 1) / 2) + 1;
        my $semester_in_year = ($semester_no % 2) == 0 ? 2 : 1;
        my $heading = qq{<h4 class="w3-text-black" style="margin: 24px auto; padding: 16px; font-weight: bold;width:50%;border-top: 1px solid #ccc;">YEAR $year SEMESTER $semester_in_year</h4>};

        $this->add_Content($heading);
        $this->add_Content($table_start);
        $this->add_Content($colgroup_content);
        $this->add_Content($table_header_content);
        $this->add_Content("<tbody>");

        # Set the current TLD for the parent class to process and render the rows.
        $this->{tld} = $sem_tld;
        $this->SUPER::process_LIST($te);

        # Add Total and Cumulative Credit rows.
        my $sem_total_credit = $total_credits[$semester_no];
        $cumulative_credit_total += $sem_total_credit;

        my $total_credit_row = qq{
            <tr class="w3-light-grey">
                <td colspan="2" style="text-align: right; font-weight: bold;">Total Credit:</td>
                <td style="font-weight: bold;">$sem_total_credit</td>
                <td colspan="3"></td>
            </tr>
        };
        my $cumulative_credit_row = qq{
            <tr class="w3-light-grey">
                <td colspan="2" style="text-align: right; font-weight: bold;">Cumulative Credit:</td>
                <td style="font-weight: bold;">$cumulative_credit_total</td>
                <td colspan="3"></td>
            </tr>
        };

        $this->add_Content($total_credit_row);
        $this->add_Content($cumulative_credit_row);
        $this->add_Content("</tbody>");
        $this->add_Content($table_end);
    }
}
1;