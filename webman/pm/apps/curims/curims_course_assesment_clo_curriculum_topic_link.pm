package curims_course_assesment_clo_curriculum_topic_link;

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
    my $admin_buttons_edit_delete = '';
    my $is_admin_flag = 0;
    my $is_course_owner_flag = 0;
    my $course_owner_col_style = '';
    my $course_owner_td_style = '';
    # Check if user is an admin
    # This @groups is retrieved from parent class webman_CGI_component
    # which is set by function get_User_Groups
    foreach my $group (@groups) {
        if (lc($group) eq 'admin') {
            $is_admin_flag = 1;

            
            $admin_buttons_edit_delete = qq|
  <tfoot id="admin-buttons-tfoot">
  <tr class="w3-light-grey">
    <td align="right"></td>

    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    
    <td class="w3-center">
      <!-- start_cgihtml_ //-->
      <button class="w3-button w3-blue w3-text-white w3-hover-blue w3-round-large" onclick="document.tld_view_dynamic.task.value='curims_course_multirows_update'; document.tld_view_dynamic.submit();">Edit</button> <button class="w3-button w3-red w3-text-white w3-hover-red w3-round-large" onclick="document.tld_view_dynamic.task.value='curims_course_multirows_delete'; document.tld_view_dynamic.submit();">Delete</button>
      <!-- end_cgihtml_ //-->
    </td>
  </tr>
  </tfoot>|;    
            last;
        }

        if (lc($group) eq 'course_owner') {
            $is_course_owner_flag = 1;
                       
            $course_owner_col_style = qq|
            <col style="width: 5%">
            <col style="width: 5%">
            <col style="width: 5%">|;

            $course_owner_td_style = qq|
            <td></td>
            <td></td>
            <td></td>
            |;
            last;
        }
    }
    
    $cgi->push_Param("admin_buttons_edit_delete", $admin_buttons_edit_delete);
    $cgi->push_Param("is_admin", $is_admin_flag); 
    $cgi->push_Param("course_owner_col_style", $course_owner_col_style); 
    $cgi->push_Param("is_course_owner", $is_course_owner_flag); 
    $cgi->push_Param("course_owner_td_style", $course_owner_td_style); 
    my $match_group = $this->match_Group($group_name_, @groups);

    # Fetch Total course for the current session
    my $total_course_count = 0;
    if ($db_conn) {
        my $sql_total_course = "SELECT COUNT(*) FROM curims_course"; # Count all curricula
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
    
    ### DB item dynamic list with multi row insert/update/delete  
    ### operations support need this to behave correctly 
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
    my $sql_filter = undef;
    
    
    if (!$cgi->param_Exist("filter_course_code") || $cgi->param("filter_course_code") eq "") {
        $cgi->push_Param("filter_course_code", "\%");
    }
    my $filter_course_code = $cgi->param("filter_course_code");
    $sql_filter .= "course_code like '$filter_course_code' and ";
    
    
    if (!$cgi->param_Exist("filter_course_name") || $cgi->param("filter_course_name") eq "") {
        $cgi->push_Param("filter_course_name", "\%");
    }
    my $filter_course_name = $cgi->param("filter_course_name");
    $sql_filter .= "course_name like '$filter_course_name' and ";
    
    
    $sql_filter =~ s/ and $//;
    
    my @sql_part = split(/ order by /, $sql);
    
    #$cgi->add_Debug_Text($sql, __FILE__, __LINE__, "DATABASE");
    
    if ($sql_part[0] =~ / where /) {
        $sql = "$sql_part[0] and $sql_filter order by $sql_part[1]";
         
    } else {
        $sql = "$sql_part[0] where $sql_filter order by $sql_part[1]";
    }
    
    #$cgi->add_Debug_Text($sql, __FILE__, __LINE__, "DATABASE");

    my $total_items = "Select count(*) from curims_course";
    my $sth_course = $db_conn->prepare($total_items);
    $sth_course->execute();
    my ($total_course) = $sth_course->fetchrow_array();
    $this->set_DB_Items_View_Num($total_course);
    
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

1;