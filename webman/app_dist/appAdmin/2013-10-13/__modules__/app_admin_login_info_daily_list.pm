package app_admin_login_info_daily_list;

use webman_TLD_item_view_dynamic;

@ISA=("webman_TLD_item_view_dynamic");

sub new {
    my $type = shift;
    
    my $this = webman_TLD_item_view_dynamic->new();
    
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

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
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

sub process_VIEW { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
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
    
    my $caller_get_data = $cgi->generate_GET_Data("link_name dmisn link_id app_name session_id  " . $this->{inl_var_name} . " ...");
    
    $te_content =~ s/\$caller_get_data_/$caller_get_data/;
        
    $te->set_Content($te_content);
        
    $this->SUPER::process_VIEW($te);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    if ($te_type_name eq "main") {
        $this->SUPER::process_LIST($te);
        
    } else {
        $this->add_Content($te_content);
    }
}

sub process_SELECT { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
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
    my $te_type_name = $te->get_Name;
    
    if ($te_type_name eq $this->{lsn_var_name}) {
        $this->SUPER::process_SELECT($te);
            
    } else {
        $this->add_Content($te_content);
    }
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
    my $te_type_name = $te->get_Name;
    
    if ($te_type_name eq "form_hidden_field") {
        $this->SUPER::process_DYNAMIC($te);
        
    } else {
        $this->add_Content($te_content);
    }
    
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
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
    
    $this->add_Content($te_content);
}

sub customize_TLD {
    my $this = shift @_;
    
    my $tld = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $i = 0;
    my $tld_data = undef;
    
    my $app_name_in_control = $cgi->param("app_name_in_control");
    
    my $session_table = "webman_" . $app_name_in_control . "_session";
    
    my $caller_get_data = $cgi->generate_GET_Data("link_name link_id dmisn app_name session_id " . $this->{inl_var_name} . " ...");
    my $get_data = undef;
    
    $tld->add_Column("row_color");
    $tld->add_Column("caller_get_data");
    
    my $row_color = "#FFFFFF";
        
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);   ### option 1
    
    for ($i = 0; $i < $tld->get_Row_Num; $i++) { 
        $tld->set_Data($i, "row_color", "$row_color");

        if ($row_color eq "#FFFFFF") {
            $row_color = "#EEEEFF";
        } else {
            $row_color = "#FFFFFF";
        }
        
        $tld->set_Data($i, "caller_get_data", $caller_get_data);
        
        ### example for setting link for table list data item
        
        #$tld_data = $tld->get_Data($i, "column_name_");
        
        #$get_data = $caller_get_data . "&" . "column_name_=" . $tld_data;
        #$get_data =~ s/ /+/g;
        
        #$tld_data = "<font color=\"#0099FF\">$tld_data</font>";
            
        #$tld->set_Data($i, "column_name_", $tld_data);
        #$tld->set_Data_Get_Link($i, "column_name_", "index.cgi?$get_data");
        
        my $day_abbr = $tld->get_Data($i, "day_abbr");
        
        if ($day_abbr eq "Sat" || $day_abbr eq "Sun") {
            $tld->set_Data($i, "day_abbr", "<font color=\"#FF9900\">$day_abbr</font>");
        }
    }
    
    return $tld;
}

1;