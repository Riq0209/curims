package app_admin_link;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use app_admin_link_list;
use app_admin_link_assign_users;
use app_admin_link_assign_groups;

sub new {
    my $type = shift;
    
    my $this = webman_CGI_component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
    bless $this, $type;
    
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

sub set_Template_Default {
    my $this = shift @_;
    
    my $template_file = shift @_;
    
    $this->{template_default} = $template_file;
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $task = $cgi->param("task");
    my $link_id_auth = $cgi->param("link_id_auth");
    
    my $dbu = new DB_Utilities;        
    $dbu->set_DBI_Conn($db_conn);
    
    ###########################################################################
    
    my $link_struct_table_name = "webman_" . $cgi->param("app_name_in_control") . "_link_structure";
    
    $dbu->set_Table($link_struct_table_name);
    
    my @ahr = $dbu->get_Items("link_id parent_id name sequence auto_selected target_window", "parent_id", "0", "sequence", undef);
    
    foreach my $item (@ahr) {
        $item->{link_id_path} = $item->{link_id};
    }
    
    my $tld = new Table_List_Data;
    
    $tld->add_Array_Hash_Reference(@ahr);
    $tld->add_Column("link_id_path");
    
    ### trace all other sub links
    my @col_names = ("link_id", "parent_id", "name", "sequence", "auto_selected", "target_window");

    for (my $row_idx = 0; $row_idx < $tld->get_Row_Num; $row_idx++) {
        $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_link_structure");
        my @ahr = $dbu->get_Items("link_id parent_id name sequence auto_selected target_window", "parent_id", $tld->get_Data($row_idx, "link_id"), "sequence", undef);
        
        #$cgi->add_Debug_Text($dbu->get_SQL . " - $step", __FILE__, __LINE__, "TRACING");
        #$cgi->add_Debug_Text("\@ahr = " . @ahr, __FILE__, __LINE__, "TRACING");
        
        if (@ahr > 0) {
            foreach my $item (@ahr) {
                #$item->{name} = $tld->get_Data($row_idx, "name") . " : " . $item->{name};
                
                $item->{link_id_path} =  $tld->get_Data($row_idx, "link_id_path") . " : " . $item->{link_id};
            }
            
            $tld->insert_Array_Hash_Reference($row_idx + 1, @ahr);
        }
    }
    
    $this->{tld} = $tld;
    
    ###########################################################################
    
    if ($task eq "link_add_user") {
        my $submit = $cgi->param("button_submit");
        
        $cgi->add_Param("\$db_link_id", $link_id_auth);
        
        my @login_name_list = ();
        
        if ($submit eq "Add") {
            push(@login_name_list, $cgi->param("\$db_login_name"));
            
        } elsif ($submit eq "Add Selected") {
            
            ### push selected users inside @comp_name_list while at the 
            ### same time remove it from CGI variables list and DB cache
            
            my %map_var_val = $cgi->get_Param_Val_Hash;

            foreach my $cgi_var (keys(%map_var_val)) {
                if ($cgi_var =~ /^login_name_[1-9]/) {
                    push(@login_name_list, $cgi->param_Shift($cgi_var));
                    
                    #$cgi->add_Debug_Text("\@login_name_list - \$cgi_var = " . @login_name_list . " - " . $cgi_var, __FILE__, __LINE__);
                }
            }
        }
        
        foreach my $login_name (@login_name_list) {
            $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_user");
            my $found_user = $dbu->find_Item("login_name", $login_name);

            $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_link_auth");
            my $found_link_user = $dbu->find_Item("link_id login_name", "$link_id_auth $login_name");

            if ($found_user && !$found_link_user) { ### this is not required if $submit eq "Add Selected" but 
                                                    ### included here since the logic also used for if $submit eq "Add"
            
                if (!$cgi->set_Param_Val("\$db_login_name", $login_name)) { ### this is not required if $submit eq "Add" but included
                    $cgi->add_Param("\$db_login_name", $login_name)         ### here since the logic also deal for if $submit eq "Add Selected"
                }
                
                my $htmldb = new HTML_DB_Map;

                $htmldb->set_CGI($cgi);
                $htmldb->set_DBI_Conn($db_conn);
                $htmldb->set_Table("webman_" . $cgi->param("app_name_in_control") . "_link_auth");

                $htmldb->insert_Table; ### method 1
            }
        }
        
        $cgi->param_Shift("\$db_link_id");
        $cgi->param_Shift("\$db_login_name");         
        $cgi->param_Shift("button_submit");
        
        $cgi->set_Param_Val("task", "link_assign_user"); ### reset task CGI variable
    }
    
    if ($task eq "link_remove_user") {
        $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_link_auth");
        $dbu->delete_Item("id_link_auth", $cgi->param("id_link_auth"));
        
        $cgi->set_Param_Val("task", "link_assign_user"); ### reset task CGI variable
    }    
    
    ###########################################################################
    
    if ($task eq "link_add_group") {
        my $submit = $cgi->param("button_submit");
        
        $cgi->add_Param("\$db_link_id", $link_id_auth);

        my @group_list = ();
        
        if ($submit eq "Add") {
            push(@group_list, $cgi->param("\$db_group_name"));
            
        } elsif ($submit eq "Add Selected") {
            
            ### push selected groups inside @grouplist while at the 
            ### same time remove it from CGI variables list and DB cache
            
            my %map_var_val = $cgi->get_Param_Val_Hash;

            foreach my $cgi_var (keys(%map_var_val)) {
                if ($cgi_var =~ /^group_name_[1-9]/) {
                    push(@group_list, $cgi->param_Shift($cgi_var));
                    
                    #$cgi->add_Debug_Text("\@group_list - \$cgi_var = " . @group_list . " - " . $cgi_var, __FILE__, __LINE__);
                }
            }
        }
        
        foreach my $group_name (@group_list) {       
            $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_group");
            my $found_group = $dbu->find_Item("group_name", $group_name);
            
            $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_link_auth");
            my $found_link_group = $dbu->find_Item("link_id group_name", "$link_id_auth $group_name");
            

            if ($found_group && !$found_link_group) { ### this is not required if $submit eq "Add Selected" but 
                                                      ### included here since the logic also used for if $submit eq "Add"
                
                if (!$cgi->set_Param_Val("\$db_group_name", $group_name)) { ### this is not required if $submit eq "Add" but included
                    $cgi->add_Param("\$db_group_name", $group_name)         ### here since the logic also deal for if $submit eq "Add Selected"
                }

                my $htmldb = new HTML_DB_Map;

                $htmldb->set_CGI($cgi);
                $htmldb->set_DBI_Conn($db_conn);
                $htmldb->set_Table("webman_" . $cgi->param("app_name_in_control") . "_link_auth");

                $htmldb->insert_Table; ### method 1
            }
        }
        
        ### need this due to the implementation of CGI variable database cache :-(
        $cgi->param_Shift("\$db_link_id");
        $cgi->param_Shift("\$db_group_name");
        $cgi->param_Shift("button_submit");
        
        $cgi->set_Param_Val("task", "link_assign_group"); ### reset task CGI variable
    }
    
    if ($task eq "link_remove_group") {
        $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_link_auth");
        $dbu->delete_Item("id_link_auth", $cgi->param("id_link_auth"));
        
        $cgi->set_Param_Val("task", "link_assign_group"); ### reset task CGI variable
    }    
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File($this->{template_default});
    
    #print "\$this->{template_default} = " . $this->{template_default} . "<br>";
    
    $this->SUPER::process_Content;  
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $task = $cgi->param("task");
    my $submit = $cgi->param("submit");
    
    my $link_id_auth = $cgi->param("link_id_auth");
    
    my $component = undef;
    
    if ($te_type_num == 0) {
        if ($task ne "" && $submit ne "Proceed" && $submit ne "Cancel") {
            my $link_name_path = $cgi->param("link_name_path");
            
            my $wmlpg = new webman_link_path_generator;

            $wmlpg->set_Template_Default("template_link_path.html");
            $wmlpg->set_Carried_GET_Data("session_id");
            $wmlpg->set_Additional_GET_Data("task=&link_id_auth=&id_group=&login_name=&button_submit=");
            $wmlpg->set_Level_Start("0");
            $wmlpg->set_Level_Deep("1");


            $wmlpg->set_CGI($cgi);
            $wmlpg->set_DBI_Conn($db_conn);

            $wmlpg->construct_Link_Path;

            $wmlpg->run_Task;
            $wmlpg->process_Content;

            $te_content = $wmlpg->get_Content;

            my $current_task = undef;

            if ($task eq "link_assign_user" || $task eq "link_remove_user") { 
                $current_task = "$link_name_path &gt; Users";
            }
            
            if ($task eq "link_assign_group" || $task eq "link_remove_group") {
                $current_task = "$link_name_path &gt; Groups";
            }

            $te_content = "<b>$te_content $current_task</b>\n";
        }        
    } else {
        if ($task eq "link_assign_user" || $task eq "link_add_user" || $task eq "link_remove_user") {
            my $user_table_name = "webman_" . $cgi->param("app_name_in_control") . "_user";
            my $link_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_link_auth";
            
            $component = new app_admin_link_assign_users; 

            $component->set_Template_Default("template_app_admin_link_assign_users.html");
            
            $component->set_SQL("select u.*, la.id_link_auth from $user_table_name u, $link_auth_table_name la 
                                 where u.login_name=la.login_name and la.link_id='$link_id_auth' order by u.login_name");

            #$component->set_Order_Field_Caption("");
            #$component->set_Order_Field_Name("");
            #$component->set_Order_Field_CGI_Var("");


            $component->set_DB_Items_View_Num(15);
            $component->set_DB_Items_Set_Num(1);

            $component->set_DB_Items_Set_Num_Var("dbisn_link_user_list");
            $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_link_user_list");

            $component->set_Additional_GET_Data("app_name_in_control=" . $cgi->param("app_name_in_control"));

            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn);
            $component->run_Task;
            $component->process_Content;

            #my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");

            $te_content = $component->get_Content;

            #$te_content =~ s/\$caller_get_data_/$caller_get_data/g;
            
        } elsif ($task eq "link_assign_group" || $task eq "link_add_group" || $task eq "link_remove_group") {
            my $group_table_name = "webman_" . $cgi->param("app_name_in_control") . "_group";
            my $link_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_link_auth";
            
            $component = new app_admin_link_assign_groups; 

            $component->set_Template_Default("template_app_admin_link_assign_groups.html");
            
            $component->set_SQL("select g.*, la.id_link_auth from $group_table_name g, $link_auth_table_name la 
                                 where g.group_name=la.group_name and la.link_id='$link_id_auth' order by g.group_name");

            #$component->set_Order_Field_Caption("");
            #$component->set_Order_Field_Name("");
            #$component->set_Order_Field_CGI_Var("");


            $component->set_DB_Items_View_Num(15);
            $component->set_DB_Items_Set_Num(1);

            $component->set_DB_Items_Set_Num_Var("dbisn_link_group_list");
            $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_link_group_list");

            #$component->set_Additional_GET_Data("app_name_in_control=" . $cgi->param("app_name_in_control"));

            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn);
            $component->run_Task;
            $component->process_Content;

            $te_content = $component->get_Content;      
            
        } else {
            $te_content = $this->get_Link_List;
        }
    }
    
    $this->add_Content($te_content);
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    $this->add_Content($te_content);
}

sub get_Link_List {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $link_struct_table_name = "webman_" . $cgi->param("app_name_in_control") . "_link_structure";
    
    my $component = new app_admin_link_list; 

    $component->set_Template_Default("template_app_admin_link_list.html");

    #$component->set_Order_Field_Caption("");
    #$component->set_Order_Field_Name("");
    #$component->set_Order_Field_CGI_Var("");

    $component->set_Items_View_Num(100);
    $component->set_Items_Set_Num(1);
    $component->set_Items_Set_Num_Var("dbisn_link_list");
    $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_link_list");
    
    $component->set_Additional_GET_Data("app_name_in_control=" . $cgi->param("app_name_in_control"));
    
    $component->set_TLD($this->{tld});

    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);
    $component->run_Task;
    $component->process_Content;
    
    my $caller_get_data = $cgi->generate_GET_Data("link_name link_id dmisn app_name app_name_in_control 
                                                   dbisn_link_list dmisn_link_list");

    my $content = $component->get_Content;

    $content =~ s/\$caller_get_data_/$caller_get_data/g;
    
    return $content;
}

1;