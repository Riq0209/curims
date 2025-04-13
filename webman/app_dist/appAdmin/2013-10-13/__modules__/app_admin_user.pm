package app_admin_user;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use webman_db_item_insert;
use webman_db_item_update;
use webman_db_item_delete;

use webman_text2db_map;

use app_admin_user_list;
use app_admin_user_assign_groups;
use app_admin_user_assign_components;

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
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
    
    $this->SUPER::run_Task();
    
    #$cgi->add_Debug_Text("run_Task: ". $this->get_Component_Name_Full, __FILE__, __LINE__);
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
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
        
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $task = $cgi->param("task");
    my $button_submit = $cgi->param("button_submit");
    my $login_name_selected = $cgi->param("login_name");
    
    my $user_table_name = "webman_" . $cgi->param("app_name_in_control") . "_user";
    my $group_table_name = "webman_" . $cgi->param("app_name_in_control") . "_group";
    my $user_group_table_name = "webman_" . $cgi->param("app_name_in_control") . "_user_group";
    my $comp_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_comp_auth";
    my $db_item_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_db_item_auth";
    
    
    my $dbu = new DB_Utilities;
       $dbu->set_DBI_Conn($db_conn);   ### option 1        
    
    my $component = undef;
    
    if ($te_type_num == 0) {
        if ($task ne "" && 
            $task ne "user_add" && $task ne "user_add_text2db" && 
            $task ne "user_update" && $task ne "user_update_text2db" && 
            $task ne "user_delete" && $task ne "user_delete_text2db") {    
            
            my $wmlpg = new webman_link_path_generator;
            
            $wmlpg->set_Template_Default("template_link_path.html");
            $wmlpg->set_Carried_GET_Data("session_id"); ### all possible get data except link_name & link_id
            $wmlpg->set_Additional_GET_Data("task=&login_name=&group_name=&comp_name=&button_submit="); ### overwrite task from DB cache CGI variable
            $wmlpg->set_Level_Start("0");
            $wmlpg->set_Level_Deep("1");
            
            
            $wmlpg->set_CGI($cgi);
            $wmlpg->set_DBI_Conn($db_conn);
            
            $wmlpg->construct_Link_Path;
            
            $wmlpg->run_Task;
            $wmlpg->process_Content;
            
            my $lpath_content = $wmlpg->get_Content;
            
            my $current_task = undef;
            
            if ($task eq "user_assign_group" || $task eq "user_add_group" || $task eq "user_remove_group") { 
                $current_task = "$login_name_selected &gt; Groups"; 
            }
            
            if ($task eq "user_assign_component" || $task eq "user_add_component" || $task eq "user_remove_component") { 
                $current_task = "$login_name_selected &gt; Components"; 
            }
            
            $te_content = "$lpath_content $current_task<br>\n";
        }
            
    } else {
        if ($task eq "") {
            $te_content = $this->get_User_List;
            
        } elsif ($task eq "user_add" || $task eq "user_add_text2db") {
            if ($task eq "user_add") {
                if ($cgi->param("\$db_id_user") eq "") {
                    $dbu->set_Table($user_table_name);
                    $cgi->push_Param("\$db_id_user", $dbu->get_Unique_Random_62Base("id_user"));
                }

                $component = new webman_db_item_insert;

                $component->set_CGI($cgi);
                $component->set_DBI_Conn($db_conn);

                $component->set_Template_Default("template_app_admin_user_add.html");
                #$component->set_Template_Default_Confirm("template_app_admin_user_add_confirm.html");

                $component->set_Table_Name("$user_table_name");
                $component->set_Check_On_CGI_Data("\$db_login_name \$db_full_name \$db_description");
                $component->set_Check_On_Fields_Duplication("login_name full_name");

                $component->set_Last_Phase_CGI_Data_Reset("task='' button_submit='' \$db_login_name='' \$db_password='' \$db_full_name='' \$db_description=''");

                my $status = 0; 

                if ($component->authenticate($login_name, \@groups, "webman_". $cgi->param("app_name") . "_comp_auth")) {
                    $status = $component->run_Task; ### $status == 1 if insert operation is proceeded/success
                    $component->process_Content;

                    #$cgi->add_Debug_Text("SQL = " . $component->get_SQL, __FILE__, __LINE__);
                }

                if ($component->last_Phase) {
                    $component->end_Task;
                    $te_content = $this->get_User_List;

                } else {
                    my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");
                    
                    $te_content = $component->get_Content;
                    
                    $te_content =~ s/\$caller_get_data_/$caller_get_data/g;
                }
                
            } else {
                $component = new webman_text2db_map;

                $component->set_CGI($cgi);
                $component->set_DBI_Conn($db_conn);

                $component->set_Template_Default("template_app_admin_user_add_text2db.html");
                $component->set_Template_Default_Confirm("template_app_admin_user_add_text2db_confirm.html");
                
                $component->set_Task("insert");
                
                #$component->set_Spliter_Column("spliter_col_");
                $component->set_Table_Name($user_table_name);
                $component->set_Field_List("login_name password full_name description");
                $component->set_Key_Field_Name("id_user");
                $component->set_Key_Field_Type("62Base");
                #$component->set_Key_Field_Length("length_");
                
                if ($component->authenticate($login_name, \@groups, "webman_". $cgi->param("app_name") . "_comp_auth")) {
                    $status = $component->run_Task; ### $status == 1 if insert operation is proceeded/success
                    $component->process_Content;

                    #$cgi->add_Debug_Text("SQL = " . $component->get_SQL, __FILE__, __LINE__);
                }
                
                if ($component->last_Phase) {
                    $component->end_Task;
                    $te_content = $this->get_User_List;

                } else {                
                    my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");
                
                    $te_content = $component->get_Content;
                
                    $te_content =~ s/\$caller_get_data_/$caller_get_data/g;
                }
            }
            
        } elsif ($task eq "user_update" || $task eq "user_update_text2db") {
            if ($task eq "user_update") {
                $component = new webman_db_item_update;

                $component->set_CGI($cgi);
                $component->set_DBI_Conn($db_conn);

                $component->set_Template_Default("template_app_admin_user_update.html");
                $component->set_Template_Default_Confirm("template_app_admin_user_update_confirm.html");

                $component->set_Table_Name($user_table_name);
                $component->set_SQL_View("select * from $user_table_name where login_name ='\$cgi_login_name_'");
                $component->set_Update_Keys_Str("login_name='\$cgi_login_name_'");

                $component->set_Check_On_CGI_Data("\$db_full_name \$db_description");
                $component->set_Check_On_Fields_Duplication("full_name");

                $component->set_Last_Phase_CGI_Data_Reset("login_name='' task='' button_submit='' \$db_login_name='' \$db_password='' \$db_full_name='' \$db_description=''");

                my $status = 0; 

                if ($component->authenticate($login_name, \@groups, "webman_". $cgi->param("app_name") . "_comp_auth")) {
                    $status = $component->run_Task; ### $status == 1 if insert operation is proceeded
                    $component->process_Content;
                }

                if ($component->last_Phase) {
                    $component->end_Task;
                    $te_content = $this->get_User_List;

                } else {                    
                    my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");
                    
                    $te_content = $component->get_Content;
                    
                    $te_content =~ s/\$caller_get_data_/$caller_get_data/g;                    
                }
                
            } else {
                $component = new webman_text2db_map;

                $component->set_CGI($cgi);
                $component->set_DBI_Conn($db_conn);

                $component->set_Template_Default("template_app_admin_user_update_text2db.html");
                $component->set_Template_Default_Confirm("template_app_admin_user_update_text2db_confirm.html");
                
                #$component->set_Task("task_");
                
                #$component->set_Spliter_Column("spliter_col_");
                $component->set_Table_Name($user_table_name);
                $component->set_Field_List("id_user login_name password full_name description");
                $component->set_Key_Field_Name("login_name");
                #$component->set_Key_Field_Type("62Base");
                #$component->set_Key_Field_Length("length_");
                
                if ($component->authenticate($login_name, \@groups, "webman_". $cgi->param("app_name") . "_comp_auth")) {
                    $status = $component->run_Task; ### $status == 1 if insert operation is proceeded/success
                    $component->process_Content;

                    #$cgi->add_Debug_Text("SQL = " . $component->get_SQL, __FILE__, __LINE__);
                }
                
                if ($component->last_Phase) {
                    $component->end_Task;
                    $te_content = $this->get_User_List;

                } else {                
                    my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");
                
                    $te_content = $component->get_Content;
                
                    $te_content =~ s/\$caller_get_data_/$caller_get_data/g;
                }            
            }
            
        } elsif ($task eq "user_delete" || $task eq "user_delete_text2db") {
            if ($task eq "user_delete") {
                $component = new webman_db_item_delete;

                $component->set_CGI($cgi);
                $component->set_DBI_Conn($db_conn); ### option 2

                $component->set_Template_Default("template_app_admin_user_delete_confirm.html");

                $component->set_Table_Name($user_table_name);
                $component->set_SQL_View("select * from $user_table_name where login_name='\$cgi_login_name_'");
                $component->set_Delete_Keys_Str("login_name ='\$cgi_login_name_'");

                $component->set_Last_Phase_CGI_Data_Reset("login_name='' task='' button_submit='' \$db_login_name='' \$db_password='' \$db_full_name='' \$db_description=''");

                my $status = 0; 

                if ($component->authenticate($login_name, \@groups, "webman_". $cgi->param("app_name") . "_comp_auth")) {
                    $status = $component->run_Task; ### $status == 1 if insert operation is proceeded
                    $component->process_Content;
                }

                if ($component->last_Phase) {
                    $component->end_Task;

                    $te_content = $this->get_User_List;

                    #$cgi->add_Debug_Text("\$button_submit = $button_submit", __FILE__, __LINE__);

                    if ($button_submit eq "Proceed") {
                        $dbu->set_Table($user_group_table_name);
                        $dbu->delete_Item("login_name", $login_name_selected);

                        $dbu->set_Table($comp_auth_table_name);
                        $dbu->delete_Item("login_name", $login_name_selected);

                        $dbu->set_Table($db_item_auth_table_name);
                        $dbu->delete_Item("login_name", $login_name_selected);
                    }

                } else {
                    my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");
                    
                    $te_content = $component->get_Content;
                    
                    $te_content =~ s/\$caller_get_data_/$caller_get_data/g;
                }
                
            } else {
                $component = new webman_text2db_map;

                $component->set_CGI($cgi);
                $component->set_DBI_Conn($db_conn);

                $component->set_Template_Default("template_app_admin_user_delete_text2db.html");
                $component->set_Template_Default_Confirm("template_app_admin_user_delete_text2db_confirm.html");
                
                #$component->set_Task("task_");
                
                #$component->set_Spliter_Column("spliter_col_");
                $component->set_Table_Name($user_table_name);
                $component->set_Field_List("login_name");
                $component->set_Key_Field_Name("login_name");
                #$component->set_Key_Field_Type("62Base");
                #$component->set_Key_Field_Length("length_");
                
                if ($component->authenticate($login_name, \@groups, "webman_". $cgi->param("app_name") . "_comp_auth")) {
                    $status = $component->run_Task; ### $status == 1 if insert operation is proceeded/success
                    $component->process_Content;

                    #$cgi->add_Debug_Text("SQL = " . $component->get_SQL, __FILE__, __LINE__);
                }
                
                if ($component->last_Phase) {
                    $component->end_Task;
                    $te_content = $this->get_User_List;

                } else {                
                    my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");
                
                    $te_content = $component->get_Content;
                
                    $te_content =~ s/\$caller_get_data_/$caller_get_data/g;
                }            
            }
            
        } elsif ($task eq "user_assign_group" || $task eq "user_add_group" || $task eq "user_remove_group") {
            #print "try add groups to user <br>";
            
            $component = new app_admin_user_assign_groups;
            
            $component->set_Template_Default("template_app_admin_user_assign_groups.html");
            $component->set_SQL("select g.* from $user_group_table_name ug, $group_table_name g 
                                 where ug.login_name='$login_name_selected' and ug.group_name=g.group_name order by g.group_name");

            #$component->set_Order_Field_Caption("");
            #$component->set_Order_Field_Name("");
            #$component->set_Order_Field_CGI_Var("");


            $component->set_DB_Items_View_Num(15);
            $component->set_DB_Items_Set_Num(1);

            $component->set_DB_Items_Set_Num_Var("dbisn_user_group_list");
            $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_user_group_list");

            #$component->set_Additional_GET_Data("app_name_in_control=" . $cgi->param("app_name_in_control"));

            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn);
            $component->run_Task;
            $component->process_Content;

            my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");

            $te_content = $component->get_Content;

            $te_content =~ s/\$caller_get_data_/$caller_get_data/g;
            
        } elsif ($task eq "user_assign_component" || $task eq "user_add_component" || $task eq "user_remove_component") {           
            my $comp_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_comp_auth";
        
            $component = new app_admin_user_assign_components; 

            $component->set_Template_Default("template_app_admin_user_assign_components.html");
            $component->set_SQL("select * from $comp_auth_table_name where login_name='$login_name_selected' order by comp_name");

            #$component->set_Order_Field_Caption("");
            #$component->set_Order_Field_Name("");
            #$component->set_Order_Field_CGI_Var("");


            $component->set_DB_Items_View_Num(15);
            $component->set_DB_Items_Set_Num(1);

            $component->set_DB_Items_Set_Num_Var("dbisn_user_component_list");
            $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_user_component_list");

            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn);
            $component->run_Task;
            $component->process_Content;

            my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");

            $te_content = $component->get_Content;

            $te_content =~ s/\$caller_get_data_/$caller_get_data/g;
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

sub get_User_List {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $limit_description = $cgi->param("limit_description");
    my $user_table_name = "webman_" . $cgi->param("app_name_in_control") . "_user";
    
    my $sql = undef;
    
    if ($limit_description eq "") {
        $sql = "select * from $user_table_name order by \$cgi_order_by_user_list_";
        
    } else {
        $sql = "select * from $user_table_name where description='$limit_description' order by \$cgi_order_by_user_list_";
    }
    
    my $component = new app_admin_user_list; 
    
    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);    

    $component->set_Template_Default("template_app_admin_user_list.html");
    $component->set_SQL($sql);
    $component->set_SQL_Debug(1);

    $component->set_Order_Field_Caption("Login Name:Full Name:Unique Description");
    $component->set_Order_Field_Name("login_name:full_name:description, full_name");
    $component->set_Order_Field_CGI_Var("order_by_user_list");

    $component->set_DB_Items_View_Num(100);
    $component->set_DB_Items_Set_Num(1);

    $component->set_DB_Items_Set_Num_Var("dbisn_user_list");
    $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_user_list");
    
    #$component->set_Additional_GET_Data("get_data_1=get_value_1&...&get_data_n=get_value_n");#

    $component->run_Task;
    $component->process_Content;
    
    my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");

    my $content = $component->get_Content;

    $content =~ s/\$caller_get_data_/$caller_get_data/g;
    
    return $content;
}

1;
