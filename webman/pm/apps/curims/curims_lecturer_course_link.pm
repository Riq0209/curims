package curims_lecturer_course_link;

use webman_db_item_view_dynamic;

@ISA=("webman_db_item_view_dynamic");

sub new {
    my $class = shift;
    
    my $this = $class->SUPER::new();
    
    $this->set_Debug_Mode(1, 1);  
    
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

        # Define admin buttons HTML
    my $admin_buttons_add = '';
    my $admin_buttons_edit_delete = '';
    my $admin_header_action = '';   
    my $admin_body_action = '';
    my $admin_footer_action = '';
    my $admin_header_col = '';
    my $is_admin_flag = 0;
    # Check if user is an admin
    foreach my $group (@groups) {
        if (lc($group) eq 'admin') {
            $is_admin_flag = 1;
            $admin_buttons_add = qq|<button type="button" 
        class="w3-button w3-green w3-round-large w3-hover-green" 
        onclick="document.tld_view_dynamic.task.value='curims_lecturer_multirows_insert'; document.tld_view_dynamic.link_id.value='$cgi_link_id_'; document.tld_view_dynamic.submit();">
        Add
        </button>|;
        $admin_buttons_edit_delete = qq|  <tfoot>
  <tr class="w3-light-grey">
    <td align="right"></td>

    <td></td>
    <td></td>
    <td></td>   
    <td></td>
    <td></td>
    <td class="w3-center">
            <!-- start_cgihtml_ //-->
            <button class="w3-button w3-blue w3-text-white w3-hover-blue w3-round-large" onclick="document.tld_view_dynamic.task.value='curims_lecturer_multirows_update'; document.tld_view_dynamic.submit();">Edit</button>
            <button class="w3-button w3-red w3-text-white w3-hover-red w3-round-large" onclick="document.tld_view_dynamic.task.value='curims_lecturer_multirows_delete'; document.tld_view_dynamic.submit();">Delete</button>
            <!-- end_cgihtml_ //-->
    </td>
  </tr>
  </tfoot>|;
        $admin_header_col = qq|<col style="width: 15%">|;
            last;
        }
    }
    $cgi->push_Param("is_admin", $is_admin_flag); 
    $cgi->push_Param("admin_buttons_add", $admin_buttons_add); 
    $cgi->push_Param("admin_buttons_edit_delete", $admin_buttons_edit_delete); 
    $cgi->push_Param("admin_header_col", $admin_header_col); 
    my $match_group = $this->match_Group($group_name_, @groups);
    
    # Fetch Total Lecturer for the current session
    my $total_lecturer_count = 0;
    if ($db_conn) {
        my $sql_total_lecturer = "SELECT COUNT(*) FROM curims_lecturer"; # Count all curricula
        my $sth_total_lecturer = $db_conn->prepare($sql_total_lecturer);
        if ($sth_total_lecturer) {
            eval {
                $sth_total_lecturer->execute(); 
                ($total_lecturer_count) = $sth_total_lecturer->fetchrow_array();
                $sth_total_lecturer->finish();
            };
            if ($@) {
                $cgi->add_Debug_Text("DBI error fetching total lecturer count: $@", __FILE__, __LINE__, "ERROR");
            }
        } else {
            $cgi->add_Debug_Text("DBI prepare error for total lecturer count: " . ($db_conn->errstr || 'Unknown error'), __FILE__, __LINE__, "ERROR");
        }
    }
    $cgi->push_Param("total_lecturer", $total_lecturer_count || 0);

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
    
    
    if (!$cgi->param_Exist("filter_email") || $cgi->param("filter_email") eq "") {
        $cgi->push_Param("filter_email", "\%");
    }
    my $filter_email = $cgi->param("filter_email");
    $sql_filter .= "email like '$filter_email' and ";
    
    
    $sql_filter =~ s/ and $//;
    
    my @sql_part = split(/ order by /, $sql);
    
    #$cgi->add_Debug_Text($sql, __FILE__, __LINE__, "DATABASE");
    
    if ($sql_part[0] =~ / where /) {
        $sql = "$sql_part[0] and $sql_filter order by $sql_part[1]";
         
    } else {
        $sql = "$sql_part[0] where $sql_filter order by $sql_part[1]";
    }
    
    #$cgi->add_Debug_Text($sql, __FILE__, __LINE__, "DATABASE");    

    # fetch total lecturer count after insertion
    my $total_items = "Select count(*) from curims_lecturer";
    my $sth_lecturer = $db_conn->prepare($total_items);
    $sth_lecturer->execute();
    my ($total_lecturer) = $sth_lecturer->fetchrow_array();
    $this->set_DB_Items_View_Num($total_lecturer);
    
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
    $tld->add_Column("admin_action_cell"); # New column for the checkbox cell

    # Check for admin privileges once
    my @groups = $this->get_User_Groups;
    my $is_admin = 0;
    foreach my $group (@groups) {
        if (lc($group) eq 'admin') {
            $is_admin = 1;
            last;
        }
    }
    
    my $row_class = "row_odd"; ### HTML CSS class
    
    for (my $i = 0; $i < $tld->get_Row_Num; $i++) { 
        my $action_cell_html = '<td></td>'; # Default to an empty cell for non-admins
        
        if ($is_admin) {
            # If user is admin, build the checkbox cell
            my $id_lecturer = $tld->get_Data($i, "id_lecturer_62base");
            my $idx = $tld->get_Data($i, "idx");
            $action_cell_html = qq|<td class="w3-center">
      <input class="w3-check" type="checkbox" style="width: 20px; height: 20px; margin-bottom: 10px;" name="id_lecturer_62base_$idx" id="id_lecturer_62base_$idx" value="$id_lecturer" />
    </td>|;
        }
        $tld->set_Data($i, "admin_action_cell", $action_cell_html);

        $tld->set_Data($i, "row_class", "$row_class");
        
        if ($row_class eq "row_odd") {
            $row_class = "row_even";
        } else {
            $row_class = "row_odd";
        }        
        
        $dbu->set_Table("curims_course_lecturer");
        my $count_item = $dbu->count_Item("id_lecturer_62base", $tld->get_Data($i, "id_lecturer_62base"));
        $tld->set_Data($i, "curims_course", $count_item);
    }
    
    return $tld;
}

1;