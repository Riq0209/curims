package app_admin_db_item_auth;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use app_admin_db_item_auth_list;

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
    
    my $login_name = $this->get_User_Login;
    
    my $task = $cgi->param("task");
    
    my $dbu = new DB_Utilities;
        
    $dbu->set_DBI_Conn($db_conn);
    
    if ($task eq "db_item_auth_add" && $this->valid_Form_Data) {
        #print "try to add db item auth <br>";
        
        my $htmldb = new HTML_DB_Map;
                    
        $htmldb->set_CGI($cgi);
        $htmldb->set_DBI_Conn($db_conn);
        $htmldb->set_Table("webman_" . $cgi->param("app_name_in_control") . "_db_item_auth");
                    
        $htmldb->insert_Table; ### method 1
    }
    
    
    if ($task eq "db_item_auth_set_insert") {
        my $id_dbia = $cgi->param("id_dbia");
        my $mode_value = $cgi->param("mode_value");
        
        $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_db_item_auth");
            
        $dbu->update_Item("mode_insert", "$mode_value", "id_dbia", "$id_dbia");
    }
    
    
    if ($task eq "db_item_auth_set_update") {
        my $id_dbia = $cgi->param("id_dbia");
        my $mode_value = $cgi->param("mode_value");

        $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_db_item_auth");

        $dbu->update_Item("mode_update", "$mode_value", "id_dbia", "$id_dbia");
    }
    
    
    if ($task eq "db_item_auth_set_delete") {
        my $id_dbia = $cgi->param("id_dbia");
        my $mode_value = $cgi->param("mode_value");

        $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_db_item_auth");

        $dbu->update_Item("mode_delete", "$mode_value", "id_dbia", "$id_dbia");
    }
    
    
    if ($task eq "db_item_auth_remove") {
        #print "try to remove db item auth <br>";
        
        my $id_dbia = $cgi->param("id_dbia");
        
        $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_db_item_auth");
        
        $dbu->delete_Item("id_dbia", "$id_dbia");
    }
    
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

sub process_MENU { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $app_name_in_control = $cgi->param("app_name_in_control");
    my $app_name_db_auth = $cgi->param("app_name_db_auth");
    
    if ($app_name_db_auth eq "") {
        $app_name_db_auth = "appAdmin";
        $cgi->set_Param_Val("app_name_db_auth", $app_name_db_auth);
    }
    
    my @menu_items = ("appAdmin", $app_name_in_control);

    my @menu_links = ("index.cgi?app_name_db_auth=appAdmin", "index.cgi?app_name_db_auth=$app_name_in_control");

    my $html_menu = new HTML_Link_Menu;

    $html_menu->set_Menu_Template_Content($te_content);
    $html_menu->set_Menu_Items(@menu_items);
    $html_menu->set_Menu_Links(@menu_links);
    $html_menu->add_GET_Data_Links_Source($cgi->generate_GET_Data("session_id link_id"));
    $html_menu->set_Active_Menu_Item($app_name_db_auth);

    my $content = $html_menu->get_Menu;
    
    $this->add_Content($content);
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    if ($te_type_num == 0) {
    
    } else {
        $te_content = $this->get_DB_Item_Auth_List;
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

sub get_DB_Item_Auth_List {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $app_name_db_auth = $cgi->param("app_name_db_auth");
    my $db_item_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_db_item_auth";
    
    if ($app_name_db_auth eq "") {
        $app_name_db_auth = "appAdmin";
        $cgi->set_Param_Val("app_name_db_auth", $app_name_db_auth);
    }
    
    if ($app_name_db_auth eq "appAdmin") {
        $set_by_app_name = "is null";
    } else {
        $set_by_app_name = "is not null";
    }
    
    my $component = new app_admin_db_item_auth_list; 

    $component->set_Template_Default("template_app_admin_db_item_auth_list.html");
    $component->set_SQL("select * from $db_item_auth_table_name where set_by_app_name $set_by_app_name order by \$cgi_order_by_db_item_auth_list_");

    $component->set_Order_Field_Caption("Table Name:Login Name:Group Name");
    $component->set_Order_Field_Name("table_name, key_field_name, key_field_value, login_name, group_name:login_name, table_name, key_field_name, key_field_value, group_name:group_name, table_name, key_field_name, key_field_value, login_name");
    $component->set_Order_Field_CGI_Var("order_by_db_item_auth_list");


    $component->set_DB_Items_View_Num(20);
    $component->set_DB_Items_Set_Num(1);

    $component->set_DB_Items_Set_Num_Var("dbisn_db_item_auth_list");
    $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_db_item_auth_list");
    
    $component->set_Additional_GET_Data($cgi->generate_GET_Data("app_name_in_control app_name_db_auth"));

    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);
    $component->run_Task;
    $component->process_Content;
    
    my $caller_get_data = $cgi->generate_GET_Data("link_name link_id dmisn app_name app_name_in_control app_name_db_auth
                               order_by_db_item_auth_list dbisn_db_item_auth_list dmisn_db_item_auth_list");

    my $content = $component->get_Content;

    $content =~ s/\$caller_get_data_/$caller_get_data/g;
    
    return $content;
}

sub valid_Form_Data {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $table_name = $cgi->param("\$db_table_name");
    my $key_field_name = $cgi->param("\$db_key_field_name");
    my $key_field_value = $cgi->param("\$db_key_field_value");
    
    my $login_name = $cgi->param("\$db_login_name");
    my $group_name = $cgi->param("\$db_group_name");
    
    my $user_table_name = "webman_" . $cgi->param("app_name_in_control") . "_user";
    my $group_table_name = "webman_" . $cgi->param("app_name_in_control") . "_group";
    my $db_item_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_db_item_auth";
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);
    
    
    if (($login_name ne "" && $group_name ne "") || 
        ($login_name eq "" && $group_name eq "")) {
            #print "debug 1";
        return 0;
    }
    
    if ($login_name ne "") {
        $dbu->set_Table($user_table_name);
        
        if (!$dbu->find_Item("login_name", $login_name)) {
            #print "debug 2";
            return 0;
        }
        
        $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_db_item_auth");
        
        if ($dbu->find_Item("table_name key_field_name key_field_value login_name", 
                    "$table_name $key_field_name $key_field_value $login_name")) {
            #print "debug 3";
            return 0;
        }
        
    }
    
    if ($group_name ne "") {
        $dbu->set_Table($group_table_name);
        
        if (!$dbu->find_Item("group_name", $group_name)) {
            #print "debug 4";
            return 0;
        }
        
        $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_db_item_auth");
        
        if ($dbu->find_Item("table_name key_field_name key_field_value group_name", 
                     "$table_name $key_field_name $key_field_value $group_name")) {
            #print "debug 5";
            return 0;
        }
    }
    
    
    $dbu->set_Table($table_name);
    
    if (!$dbu->table_Exist) {
        #print "debug 6";
        return 0;
    }
    
    return 1;

}

1;