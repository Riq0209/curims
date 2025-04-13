package app_admin_login_info_all_hits_content;

use webman_CGI_component;

@ISA=("webman_CGI_component");

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
    
    if ($te_type_num == 0) {
        $this->add_Content("user info");
        
    } elsif ($te_type_num == 1) {
        $this->add_Content("hits list");
    }
}

sub process_DBHTML { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
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
    
    my $hits_session_id = $cgi->param("hits_session_id");
    my $app_name_in_control = $cgi->param("app_name_in_control");
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);   ### option 1
    
    $dbu->set_Table("webman_" . $app_name_in_control . "_session");
    
    my $login_name = $dbu->get_Item("login_name", "session_id", "$hits_session_id");
    
    #print "\$login_name = $login_name<br>\n";
    
    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL("select * from webman_" . $app_name_in_control . "_user where login_name='$login_name'");
    $dbihtml->set_HTML_Code($te_content);
    #$dbihtml->set_Items_View_Num($...); ### option 1
    #$dbihtml->set_Items_Set_Num($...);  ### option 2

    my $content = $dbihtml->get_HTML_Code;
    
    $this->add_Content($content);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
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
    
    my $hits_session_id = $cgi->param("hits_session_id");
    my $app_name_in_control = $cgi->param("app_name_in_control");
    my $link_id = $cgi->param("link_id");
    my $session_id = $cgi->param("session_id");
    
    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL("select * from webman_" . $app_name_in_control . "_hit_info where session_id='$hits_session_id' order by date, time");
    
    my $tld = $dbihtml->get_Table_List_Data;
    
    #print $tld->get_Table_List;
    
    for ($i = 0; $i < $tld->get_Row_Num; $i++) {
        my $hit_id = $tld->get_Data($i, "hit_id");
        
        $tld->set_Data_Get_Link($i, "hit_id", "../$app_name_in_control/index_view_hits_content.cgi?hit_id=$hit_id&app_name_in_control=$app_name_in_control&link_id=$link_id&session_id=$session_id");
    }
    
    my $tldhtml = new TLD_HTML_Map;

    $tldhtml->set_Table_List_Data($tld);
    $tldhtml->set_HTML_Code($te_content);

    $tldhtml->set_Items_View_Num(items_view_num_); ### option 1
    $tldhtml->set_Items_Set_Num(items_set_num_);   ### option 2

    my $content = $tldhtml->get_HTML_Code;    
    
    $this->add_Content($content);
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

1;