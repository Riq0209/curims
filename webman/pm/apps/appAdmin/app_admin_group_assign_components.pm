package app_admin_group_assign_components;

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
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $task = $cgi->param("task");
    
    my $dyna_mod_table_name = "webman_" . $cgi->param("app_name_in_control") . "_dyna_mod";
    my $comp_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_comp_auth";
    
    my $dbu = new DB_Utilities;
            
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_group");
    
    my $group_name = $cgi->param("group_name");
    
    if ($task eq "group_add_component") { ### POST method
        my $submit = $cgi->param("button_submit");
        
        $cgi->add_Param("\$db_group_name", $group_name);
        
        my @comp_name_list = ();
        
        if ($submit eq "Add") {
            push(@comp_name_list, $cgi->param("\$db_comp_name"));
            
        } elsif ($submit eq "Add Selected") {
            
            ### push selected components inside @comp_name_list while at the 
            ### same time remove it from CGI variables list and DB cache
            
            my %map_var_val = $cgi->get_Param_Val_Hash;

            foreach my $cgi_var (keys(%map_var_val)) {
                if ($cgi_var =~ /^comp_name_[1-9]/) {
                    push(@comp_name_list, $cgi->param_Shift($cgi_var));
                    
                    #$cgi->add_Debug_Text("\@comp_name_list - \$cgi_var = " . @comp_name_list . " - " . $cgi_var, __FILE__, __LINE__);
                }
            }
        }
        
        foreach my $comp_name (@comp_name_list) {
        
            $dbu->set_Table($dyna_mod_table_name);
            my $found_component = $dbu->find_Item("dyna_mod_name", $comp_name);
        
            $dbu->set_Table($comp_auth_table_name);
            my $found_component_group = $dbu->find_Item("comp_name group_name", "$comp_name $group_name");
        
            if ($found_component && !$found_component_group) { ### this is not required if $submit eq "Add Selected" but 
                                                               ### included here since the logic also used for if $submit eq "Add"
                
                if (!$cgi->set_Param_Val("\$db_comp_name", $comp_name)) { ### this is not required if $submit eq "Add" but included
                    $cgi->add_Param("\$db_comp_name", $comp_name)         ### here since the logic also deal for if $submit eq "Add Selected"
                }
                
                my $htmldb = new HTML_DB_Map;

                $htmldb->set_CGI($cgi);
                $htmldb->set_DBI_Conn($db_conn);
                $htmldb->set_Table("webman_" . $cgi->param("app_name_in_control") . "_comp_auth");
                                
                $htmldb->insert_Table; ### method 1
            }
        }
        
        $cgi->param_Shift("\$db_group_name");
        $cgi->param_Shift("\$db_comp_name");
        $cgi->param_Shift("button_submit");
        
        $cgi->set_Param_Val("task", "group_assign_component"); ### reset task CGI variable    
    }
    
    if ($task eq "group_remove_component") { ### GET method
        #print "try remove component from group <br>";
        
        my $comp_name = $cgi->param_Shift("comp_name");
        
        $dbu->set_Table($comp_auth_table_name);
        $dbu->delete_Item("comp_name group_name", "$comp_name $group_name");
        
        $cgi->set_Param_Val("task", "group_assign_component"); ### reset task CGI variable
    }
    
    $this->SUPER::run_Task();
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);
    
    if ($te_type_name eq "form_hidden_field") {    
    
        my $hpd = $cgi->generate_Hidden_POST_Data("session_id link_id");
    
        $this->add_Content($hpd);
        
    } elsif ($te_type_name eq "comp_multi_selection" && $cgi->param("open_list")) {
        my $group_name = $cgi->param("group_name");
        my $comp_table_name = "webman_" . $cgi->param("app_name_in_control") . "_dyna_mod";
        my $comp_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_comp_auth";
        
        my $component = new webman_db_item_view_dynamic;
        
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn);
        
        $component->set_Template_Default("template_app_admin_multi_select_components.html");
        
        $dbu->set_Table("$comp_auth_table_name");
        
        if ($dbu->count_Item("group_name", "$group_name") == 0) {
            $component->set_SQL("select * from $comp_table_name order by dyna_mod_name");
            
        } else {
            my @ahr = $dbu->get_Items("comp_name", "group_name", "$group_name");
            my $not_in = undef;
            
            foreach my $item (@ahr) {
                $not_in .= "'$item->{comp_name}', ";
            }
            
            $not_in .= "''";
            
            $component->set_SQL("select * from $comp_table_name where dyna_mod_name not in ($not_in) order by dyna_mod_name");
        }
        
        #$component->set_List_Selection_Num(2);
                             
        $component->set_INL_Var_Name("inl_multi_select"); ### Items Num./List, default is "inl"
        $component->set_LSN_Var_Name("lsn_multi_select"); ### List Set Num., default is "lsn"

        $component->set_DB_Items_Set_Num_Var("dbisn_multi_select");
        $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_multi_select");
        
        $component->run_Task;
        $component->process_Content;
        
        $this->add_Content($component->get_Content);
    }
}

sub customize_TLD {
    my $this = shift @_;
    
    my $tld = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $i = 0;
    my $tld_data = undef;
    
    my $caller_get_data = $this->generate_GET_Data("link_name link_id dmisn app_name ...");
    my $get_data = undef;
    
    $tld->add_Column("row_color");
    
    my $row_color = "#FFFFFF";
    
    for ($i < 0; $i < $tld->get_Row_Num; $i++) { 
        #$tld_data = $tld->get_Data($i, "nama");
        
        #$get_data = $caller_get_data . "&" . "nama=" . $tld_data;
        #$get_data =~ s/ /+/g;
        
        #$tld_data = "<font color=\"#0099FF\">$tld_data</font>";
            
        #$tld->set_Data($i, "nama", $tld_data);
        #$tld->set_Data_Get_Link($i, "nama", "index.cgi?$get_data");
        
        $tld->set_Data($i, "row_color", "$row_color");
        
        if ($row_color eq "#FFFFFF") {
            $row_color = "#F2F3FD"
        } else {
            $row_color = "#FFFFFF"
        }
    }
    
    return $tld;
}

1;