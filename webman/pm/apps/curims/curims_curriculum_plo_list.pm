package curims_curriculum_plo_list;

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
    my $admin_col_style = '';
    my $is_admin_flag = 0;
    # Check if user is an admin
    foreach my $group (@groups) {
        if (lc($group) eq 'admin') {
            $is_admin_flag = 1;
            
            $admin_buttons_edit_delete = qq|
            <tfoot>
  <tr bgcolor="#EEEEEE">
    <td align="right"></td>
    <td></td>
    <td></td>
    <td></td>

    <td class="w3-center">
      <button type="button" 
        class="w3-button w3-blue w3-text-white w3-hover-blue w3-round-large" 
        onclick="document.tld_view_dynamic.task.value='curims_curriculum_plo_multirows_update'; document.tld_view_dynamic.submit();">
    Edit
</button>
      <button type="button" 
        class="w3-button w3-red w3-text-white w3-hover-red w3-round-large" 
        onclick="document.tld_view_dynamic.task.value='curims_curriculum_plo_multirows_delete'; document.tld_view_dynamic.submit();">
    Delete
</button>
    </td>
  </tr>
  </tfoot>|;
            $admin_col_style = qq|<col style="width: 10%">|;
            last;
        }
    }
    $cgi->push_Param("admin_buttons_edit_delete", $admin_buttons_edit_delete);   
    $cgi->push_Param("is_admin_flag", $is_admin_flag); 
    $cgi->push_Param("admin_col_style", $admin_col_style); 

    my $match_group = $this->match_Group($group_name_, @groups);

        my $curriculum_id = $cgi->param("id_curriculum_62base");
    # Lookup curriculum_name and intake_session and push combined label to CGI
    if ($curriculum_id) {
        $dbu->set_Table("curims_curriculum");
        my $curriculum_name   = $dbu->get_Item("curriculum_name",   "id_curriculum_62base", $curriculum_id);
        my $intake_session    = $dbu->get_Item("intake_session",    "id_curriculum_62base", $curriculum_id);


        my $label = "$curriculum_name - $intake_session";


        # Set into CGI so that $cgi_cgi_curriculum_name_ works in template
        $cgi->push_Param("curriculum_name_label", $label);
    }
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

    # fetch total plo count after insertion
    my $total_items = "Select count(*) from curims_plo";
    my $sth_plo = $db_conn->prepare($total_items);
    $sth_plo->execute();
    my ($total_plo) = $sth_plo->fetchrow_array();
    $this->set_DB_Items_View_Num($total_plo);

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
        
    }
    
    return $tld;
}

1;