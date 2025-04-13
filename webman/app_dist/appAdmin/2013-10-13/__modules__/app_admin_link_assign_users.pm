package app_admin_link_assign_users;

use webman_db_item_view_dynamic;

@ISA=("webman_db_item_view_dynamic");

sub new {
    my $type = shift;
    
    my $this = webman_db_item_view_dynamic->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{staff_id};
    
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
        
    } elsif ($te_type_name eq "user_multi_selection" && $cgi->param("open_list")) {
        my $link_id_auth = $cgi->param("link_id_auth");
        my $user_table_name = "webman_" . $cgi->param("app_name_in_control") . "_user";
        my $link_auth_table_name = "webman_" . $cgi->param("app_name_in_control") . "_link_auth";
        
        
        my $component = new webman_db_item_view_dynamic;
        
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn);
        
        $component->set_Template_Default("template_app_admin_multi_select_users.html");
        
        $component->set_SQL_Debug(1);
        
        $component->set_Table_Name($user_table_name);

        $component->set_Order_Field_Caption("Login Name:Full Name:Unique Description");
        $component->set_Order_Field_Name("login_name:full_name:description, full_name");
        $component->set_Order_Field_CGI_Var("order_by_multi_select"); 
        
        $component->set_Map_Caption_Field("Login Name => login_name, Full Name => full_name, Unique Description => description");
    
        $component->set_List_Selection_Num(2);
                 
        $component->set_INL_Var_Name("inl_multi_select"); ### Items Num./List, default is "inl"
        $component->set_LSN_Var_Name("lsn_multi_select"); ### List Set Num., default is "lsn"
        
        $component->set_Filter_Field_Name("description");
        
        $dbu->set_Table($link_auth_table_name);
        
        my @ahr = $dbu->get_Items("login_name", "link_id", "$link_id_auth");
        my $not_in = undef;

        foreach my $item (@ahr) {
            $not_in .= "'$item->{login_name}', ";
        }

        $not_in .= "''";
        
        $component->set_Filter_Field_Additional_Keystr("login_name not in ($not_in)");

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