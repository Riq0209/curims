package app_admin_group;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use app_admin_group_list;

use app_admin_group_assign_users;
use app_admin_group_assign_components;

use webman_db_item_insert;
use webman_db_item_update;
use webman_db_item_delete;

sub new {
    my $type = shift;
    
    my $this = webman_CGI_component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
    $this->{group_name} = undef;
    
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

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $dbu = new DB_Utilities;
            
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_group");
            
    my $group_name = $dbu->get_Item("group_name", "id_group", $cgi->param("id_group"));
            
    $this->{group_name} = $group_name;
    
    $this->SUPER::run_Task();
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
    my $submit = $cgi->param("button_submit");
    
    my $valid_update = undef;
    
    my $group_table_name = "webman_" . $cgi->param("app_name_in_control") . "_group";
    my $user_group_table_name = "webman_" . $cgi->param("app_name_in_control") . "_user_group";
    my $comp_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_comp_auth";
    my $db_item_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_db_item_auth";
    
    my $dbu = new DB_Utilities;
        
    $dbu->set_DBI_Conn($db_conn);   ### option 1
    
    my $component = undef;
    
    if ($te_type_num == 0) {
        if ($task ne "" && $task ne "group_add" && $task ne "group_update" && $task ne "group_delete") {
            my $wmlpg = new webman_link_path_generator;
            
            $wmlpg->set_Template_Default("template_link_path.html");
            $wmlpg->set_Carried_GET_Data("session_id");
            $wmlpg->set_Additional_GET_Data("task=&group_name=&comp_name=&login_name=&button_submit=");
            $wmlpg->set_Level_Start("0");
            $wmlpg->set_Level_Deep("1");
            
            
            $wmlpg->set_CGI($cgi);
            $wmlpg->set_DBI_Conn($db_conn);
            
            $wmlpg->construct_Link_Path;
            
            $wmlpg->run_Task;
            $wmlpg->process_Content;
            
            $te_content = $wmlpg->get_Content;
            
            my $current_task = undef;
            my $group_name = $cgi->param("group_name");
            
            if ($task eq "group_assign_user" || $task eq "group_add_user" || $task eq "group_remove_user") { 
                $current_task = "$group_name &gt; Users";
            }
            
            if ($task eq "group_assign_component" || $task eq "group_add_component" || $task eq "group_remove_component") {
                $current_task = "$group_name &gt; Components";
            }
            
            $te_content = "$te_content $current_task<br>\n";
        }
            
    } else {
        if ($task eq "") {
            $te_content = $this->get_Group_List;
            
        } elsif ($task eq "group_add") {
            my $group_name = $cgi->param("\$db_group_name");
            
            if ($group_name ne "") {
                $group_name = uc($group_name);
                $group_name =~ s/ /_/g;
                
                if (!$cgi->set_Param_Val("\$db_group_name", $group_name)) {
                    $cgi->add_Param("\$db_group_name", $group_name);
                }                
            }
            
            if ($cgi->param("\$db_id_group") eq "") {
                $dbu->set_Table($group_table_name);
                $cgi->push_Param("\$db_id_group", $dbu->get_Unique_Random_62Base("id_group"));
            }            
            
            $component = new webman_db_item_insert;

            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn);

            $component->set_Table_Name("$group_table_name");

            $component->set_Template_Default("template_app_admin_group_add.html");
            #$component->set_Template_Default_Confirm("template_app_admin_group_add_confirm.html");

            $component->set_Proceed_On_Submit("Add");
            $component->set_Cancel_On_Submit("Cancel");
            
            $component->set_Check_On_CGI_Data("\$db_group_name"); 
            $component->set_Check_On_Fields_Duplication("group_name");
            
            $component->run_Task;
            $component->process_Content;

            if ($component->last_Phase) {
                $component->end_Task;
                $te_content = $this->get_Group_List;

            } else {
                $te_content = $component->get_Content;
            }
            
        } elsif ($task eq "group_update") {
            my $group_name = $cgi->param("\$db_group_name");
            
            if ($group_name ne "") {
                $group_name = uc($group_name);
                $group_name =~ s/ /_/g;
                
                if (!$cgi->set_Param_Val("\$db_group_name", $group_name)) {
                    $cgi->add_Param("\$db_group_name", $group_name);
                }                
            }
            
            $dbu->set_Table($group_table_name);
            
            $component = new webman_db_item_update;

            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn);

            $component->set_Table_Name($group_table_name);
            $component->set_Update_Keys_Str("id_group='\$cgi_id_group_'");

            $component->set_Template_Default("template_app_admin_group_update.html");
            $component->set_Template_Default_Confirm("template_app_admin_group_update_confirm.html");

            $component->set_SQL_View("select * from $group_table_name where id_group ='\$cgi_id_group_'");

            $component->set_Proceed_On_Submit("Update");

            $component->set_Check_On_CGI_Data("\$db_group_name"); 
            $component->set_Check_On_Fields_Duplication("group_name");

            $status = $component->run_Task;
            
            $component->process_Content;

            if ($component->last_Phase) {
                $cgi->add_Debug_Text("\$status = $status", __FILE__, __LINE__, "TRACING");
                
                if ($status) {
                    my $app_name_in_control = $cgi->param("app_name_in_control");
                    my $group_name_old = $cgi->param("group_name");
                    my $group_name_new = $cgi->param("\$db_group_name");
                    
                    if ($group_name_new ne $group_name_old) {
                        ### also update if group_name exist as a foreign key inside other related table

                        #$cgi->add_Debug_Text("$group_name_old become $group_name_new" , __FILE__, __LINE__, "TRACING");
                        
                        $dbu->set_Keys_Str("group_name='$group_name_old'");
                        
                        $dbu->set_Table("webman_" . $app_name_in_control . "_user_group");
                        $dbu->update_Item("group_name", "$group_name_new");
                        
                        $dbu->set_Table("webman_" . $app_name_in_control . "_comp_auth");
                        $dbu->update_Item("group_name", "$group_name_new");
                        
                        $dbu->set_Keys_Str(undef);
                    }
                }
                
                $component->end_Task;
                
                $cgi->param_Shift("id_group");
                $cgi->param_Shift("group_name");
                
                $te_content = $this->get_Group_List;

            } else {
                $te_content = $component->get_Content;
            }
            
        } elsif ($task eq "group_delete") {
            $component = new webman_db_item_delete;

            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn); ### option 2

            $component->set_Table_Name($group_table_name);
            $component->set_Delete_Keys_Str("id_group ='\$cgi_id_group_'");

            $component->set_Template_Default("template_app_admin_group_delete_confirm.html");

            $component->set_SQL_View("select * from $group_table_name where id_group='\$cgi_id_group_'");
            
            $status = $component->run_Task;
            $component->process_Content; 
            
            if ($component->last_Phase) {
                if ($status) {
                    my $app_name_in_control = $cgi->param("app_name_in_control");
                    my $group_name = $cgi->param("group_name");
                    
                    $dbu->set_Table("webman_" . $app_name_in_control . "_user_group");
                    $dbu->delete_Item("group_name", "$group_name");
                    
                    $dbu->set_Table("webman_" . $app_name_in_control . "_comp_auth");
                    $dbu->delete_Item("group_name", "$group_name");
                }
                
                $component->end_Task;
                
                $cgi->param_Shift("id_group");
                $cgi->param_Shift("group_name");
                
                $te_content = $this->get_Group_List;

            } else {
                $te_content = $component->get_Content;
            }
            
        } elsif ($task eq "group_assign_user" || $task eq "group_add_user" || $task eq "group_remove_user") {
            my $group_name = $cgi->param("group_name");
            
            my $user_table_name = "webman_" . $cgi->param("app_name_in_control") . "_user";
            my $user_group_table_name = "webman_" . $cgi->param("app_name_in_control") . "_user_group";
        
            $component = new app_admin_group_assign_users; 

            $component->set_Template_Default("template_app_admin_group_assign_users.html");
            $component->set_SQL("select u.* from $user_table_name u, $user_group_table_name ug 
                                 where u.login_name=ug.login_name and ug.group_name='$group_name' order by u.login_name");

            #$component->set_Order_Field_Caption("");
            #$component->set_Order_Field_Name("");
            #$component->set_Order_Field_CGI_Var("");


            $component->set_DB_Items_View_Num(15);
            $component->set_DB_Items_Set_Num(1);

            $component->set_DB_Items_Set_Num_Var("dbisn_group_user_list");
            $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_group_user_list");
            
            $component->set_Additional_GET_Data($cgi->generate_GET_Data("app_name_in_control id_group order_by_group_list dbisn_group_list dmisn_group_list task"));

            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn);
            $component->run_Task;
            $component->process_Content;

            my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");

            $te_content = $component->get_Content;

            $te_content =~ s/\$caller_get_data_/$caller_get_data/g;
            
        } elsif ($task eq "group_assign_component" || $task eq "group_add_component" || $task eq "group_remove_component") {
            my $group_name = $cgi->param("group_name");
            
            my $comp_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_comp_auth";
        
            $component = new app_admin_group_assign_components; 

            $component->set_Template_Default("template_app_admin_group_assign_components.html");
            $component->set_SQL("select * from $comp_auth_table_name where group_name='$group_name' order by comp_name");

            #$component->set_Order_Field_Caption("");
            #$component->set_Order_Field_Name("");
            #$component->set_Order_Field_CGI_Var("");


            $component->set_DB_Items_View_Num(15);
            $component->set_DB_Items_Set_Num(1);

            $component->set_DB_Items_Set_Num_Var("dbisn_group_component_list");
            $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_group_component_list");

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

sub get_Group_List {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $group_table_name = "webman_" . $cgi->param("app_name_in_control") . "_group";
    
    my $component = new app_admin_group_list; 

    $component->set_Template_Default("template_app_admin_group_list.html");
    $component->set_SQL("select * from $group_table_name order by \$cgi_order_by_group_list_");

    $component->set_Order_Field_Caption("Group_name:Description");
    $component->set_Order_Field_Name("group_name:description, group_name");
    $component->set_Order_Field_CGI_Var("order_by_group_list");


    $component->set_DB_Items_View_Num(15);
    $component->set_DB_Items_Set_Num(1);

    $component->set_DB_Items_Set_Num_Var("dbisn_group_list");
    $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_group_list");

    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);
    $component->run_Task;
    $component->process_Content;
    
    my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");

    my $content = $component->get_Content;

    $content =~ s/\$caller_get_data_/$caller_get_data/g;
    
    return $content;
}

1;
