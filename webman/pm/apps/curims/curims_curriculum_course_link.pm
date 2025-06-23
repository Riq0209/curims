package curims_curriculum_course_link;

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

    # Define admin buttons HTML
    my $admin_buttons_add = '';
    my $admin_buttons_edit_delete = '';
    my $admin_header_action = '';   
    my $admin_body_action = '';
    my $admin_footer_action = '';
    my $is_admin_flag = 0;
    # Check if user is an admin
    foreach my $group (@groups) {
        if (lc($group) eq 'admin') {
            $is_admin_flag = 1;
            $admin_buttons_add = qq|<button class="w3-button w3-green w3-text-white w3-hover-green w3-round-large" onclick="document.tld_view_dynamic.task.value='curims_curriculum_multirows_insert'; document.tld_view_dynamic.submit();">Add</button>|;
            
            $admin_buttons_edit_delete = qq|
  <tfoot>
  <tr class="w3-light-grey">
    <td align="right"></td>

    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>

    <td class="w3-center">
      <!-- start_cgihtml_ //-->
      <button class="w3-button w3-blue w3-text-white w3-hover-blue w3-round-large" onclick="document.tld_view_dynamic.task.value='curims_curriculum_multirows_update'; document.tld_view_dynamic.submit();">Edit</button> <button class="w3-button w3-red w3-text-white w3-hover-red w3-round-large" onclick="document.tld_view_dynamic.task.value='curims_curriculum_multirows_delete'; document.tld_view_dynamic.submit();">Delete</button>
      <!-- end_cgihtml_ //-->
    </td>
  </tr>
  </tfoot>|;
            last;
        }
    }
    $cgi->push_Param("admin_buttons_add", $admin_buttons_add);
    $cgi->push_Param("admin_buttons_edit_delete", $admin_buttons_edit_delete);   
    $cgi->push_Param("is_admin_flag", $is_admin_flag); 
    my $match_group = $this->match_Group($group_name_, @groups);
    
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


    ### DB item dynamic list with multi row insert/update/delete  
    ### operations support need this to behave correctly 
    
    # 🟢 Get curriculum ID from query param
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

    # fetch total curriculum count after insertion
    my $total_items = "Select count(*) from curims_curriculum";
    my $sth_curriculum = $db_conn->prepare($total_items);
    $sth_curriculum->execute();
    my ($total_curriculum) = $sth_curriculum->fetchrow_array();
    $this->set_DB_Items_View_Num($total_curriculum);
    
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
    $tld->add_Column("curims_plo");
    
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

        # Determine course count for the current curriculum
        $dbu->set_Table("curims_currcourse");
        my $course_count = $dbu->count_Item("id_curriculum_62base", $id_curr);
        $tld->set_Data($i, "curims_course", $course_count); # Set data for 'Course' column (count)

        # Conditionally create link for curriculum name
        my $curriculum_name_display;
        if ($course_count > 0) {
            $curriculum_name_display = qq{<a href="index.cgi?link_id=7&task=curims_curriculum_course_list_bysem&id_curriculum_62base=$id_curr">$curriculum_name_string</a>};
        } else {
            $curriculum_name_display = $curriculum_name_string; # Plain text if no courses
        }
        $tld->set_Data($i, "curriculum_name", $curriculum_name_display); # Update 'curriculum_name' field with HTML or plain text

        # Determine PLO count for the current curriculum
        $dbu->set_Table("curims_plo");
        my $plo_count = $dbu->count_Item("id_curriculum_62base", $id_curr);
        $tld->set_Data($i, "curims_plo", $plo_count); # Set data for 'PLO' column (count)
    }
    
    return $tld;
}

1;